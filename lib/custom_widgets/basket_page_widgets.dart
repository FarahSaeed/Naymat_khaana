import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:naymat_khaana/app_classes/food_item.dart';
import 'package:intl/intl.dart';
import 'package:naymat_khaana/app_classes/user_account.dart';
import 'package:naymat_khaana/blocs/basketBloc/basket_bloc.dart';
import 'package:naymat_khaana/utils/cloud_storage.dart';
import 'package:naymat_khaana/utils/navigation.dart';
// import 'package:naymat_khaana/blocs/exploreFoodItemsBloc/explore_food_items_bloc.dart';
// import 'package:naymat_khaana/blocs/exploreFoodItemsBloc/explore_food_items_event.dart';

//////////////////////////////////////////////////////////////////////////////
///////////////////////////// BasketListView ////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
class BasketListView extends StatefulWidget {
  BasketListView({
    Key? key,
    required this.useraccountname,
    required this.snapshot,
    required this.basketItemsCountNotifier,
    required this.removeFromBasket,
    required this.basketBloc,
    required this.useraccount
  }) : super(key: key);


  BasketBloc basketBloc;
  UserAccount useraccount;
  AsyncSnapshot<QuerySnapshot> snapshot;
  ValueNotifier<int> basketItemsCountNotifier;
  int numitems = 0;
  String useraccountname;
  //final FirebaseStorage storage = FirebaseStorage.instance;
  CloudStorage cloudStorage = CloudStorage();
 // void Function(String) removeFromBaset;

  void Function(String) removeFromBasket;


  @override
  BasketListViewState createState() {
    return BasketListViewState();
  }
}
String capitalize(String s) => s[0].toUpperCase() + s.substring(1);



class BasketListViewState  extends State<BasketListView>{
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: widget.snapshot.data!.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

        String iname = data['item_name'];
        String uname = data['username'];
        String aprice = data['actual_price'];
        String dprice = data['discount_price'];
        String sdate = data['submit_date'];
        String edate = data['exp_date'];
        String useremail = data['user_email']==null?'na':data['user_email'];
        List<String> imagename = data['imagename']==null? [""]:data['imagename'] is String? [data['imagename']] :List<String>.from(data['imagename']) ;

        FoodItem fooditem = FoodItem(iname: iname,
        uname: uname,
        aprice: aprice,
        dprice: dprice,
        sdate: sdate,
        edate: edate,
        useremail: useremail,
        id: document.id,
        imagename: imagename);



        // FoodItem fooditem = FoodItem(iname: data['item_name'], uname: data['username'], aprice: data['actual_price'], dprice: data['discount_price'], sdate: data['submit_date'], edate: data['exp_date'], useremail: data['user_email'], imagename: data['imagename']==null? "":data['imagename']);
        DateTime expirationDate = DateTime.parse(fooditem.edate);
        final now = DateTime.now();
        final bool isExpired = expirationDate.isBefore(now);
        if (isExpired) return Container();
        widget.numitems= widget.numitems+1; //return Text('An expired item has been removed from your basket');
        WidgetsBinding.instance?.addPostFrameCallback((_){
          widget.basketItemsCountNotifier.value = widget.numitems;
        });
        return Dismissible(
          key: UniqueKey(),
          onDismissed: (direction) {
            widget.numitems = widget.numitems-1;
            widget.basketItemsCountNotifier.value = widget.numitems;
            var result = widget.removeFromBasket(document.id);
            final snackBar = SnackBar(
              content: const Text('Item is removed from basket.'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
          background: Container(color: Colors.green),
          child: Card(
            margin: const EdgeInsets.only( top: 10, left: 25.0, right: 25.0),
            child: ListTile(
              contentPadding:const EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0, bottom:5.0),
              title: Padding(
                padding: const EdgeInsets.only(bottom:8.0),
                child: Text(capitalize(data['item_name']),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              subtitle:
              GestureDetector(
        onTap: ()
        {
        navigateToFoodItemPage(context, fooditem, widget.basketBloc, widget.useraccountname, widget.useraccount);
        },
                child: Text.rich(TextSpan(
                  children: <TextSpan>[
                    new TextSpan(
                      text: ' \$'+ fooditem.dprice +' ',
                      style: new TextStyle(
                        color: Colors.green, fontSize: 20.0,
                      ),
                    ),
                    new TextSpan(
                      text: '\$'+ fooditem.aprice,
                      style: new TextStyle(
                        color: Color(0xFF90D493),
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    isExpired? TextSpan(
                      text: "\n Not available " ,
                      style:  TextStyle(
                          color: Colors.grey,fontSize: 15.0, height: 2.0
                      ),
                    ):
                    TextSpan(
                      text: "\n Expiring " + DateFormat("yMMMd").format(DateTime.parse(fooditem.edate)),
                      style:  TextStyle(
                          color: Colors.green, fontSize: 15.0, height: 2.0
                        // decoration: TextDecoration.lineThrough,
                      ),
                    )
                    ,
                  ],
                ),
                ),
              ),
              isThreeLine: true,
              leading: fooditem.imagename==""?null:ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 44,
                  minHeight: 44,
                  maxWidth: 64,
                  maxHeight: 64,
                ),
                child: FutureBuilder(
                    future: widget.cloudStorage.downloadURL(imagename: fooditem.imagename![0]), //'scaled_image_picker1176476598179497756.jpg'),
                    builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text("Loading");
                      }
                      //return Image.asset(snapshot.data!, fit: BoxFit.cover);
                      return Container(
                          width: 300,
                          height: 250,
                          child: Image.network(snapshot.data!, fit: BoxFit.cover )

                      );
                    }),
              ),
              trailing:
              IconButton(
                // icon: const Icon(Icons.add_shopping_cart_rounded),
                icon: const Icon(Icons.remove),
                //color: isExpired? Colors.grey: Colors.red,
                color: Colors.red,
                iconSize: 25.0,
                onPressed: (){

                  widget.numitems = widget.numitems-1;
                  widget.basketItemsCountNotifier.value = widget.numitems;
                  var result = widget.removeFromBasket(document.id);
                  final snackBar = SnackBar(
                    content: const Text('Item is removed from basket.'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);


                },
              ),

            ),
          ),
        );
      }).toList(),
    );
  }
}
//////////////////////////////////////////////////////////////////////////////
///////////////////////////// ExploreListView ////////////////////////////////
//////////////////////////////////////////////////////////////////////////////




//////////////////////////////////////////////////////////////////////////////
///////////////////////////// BasketCheckoutButton ///////////////////////////
//////////////////////////////////////////////////////////////////////////////

class BasketCheckoutButton extends StatefulWidget {
  BasketCheckoutButton({
    Key? key,
    required this.buttonText,
    required this.onPressed,

  }) : super(key: key);

  String buttonText;
  void Function()? onPressed;
  @override
  BasketCheckoutButtonState createState() {
    return BasketCheckoutButtonState();
  }
}
class BasketCheckoutButtonState  extends State<BasketCheckoutButton>{
  @override
  Widget build(BuildContext context) {
    return
      Container(
        height: 45,
        width: double.infinity,
        margin: const EdgeInsets.only(top: 15.0, bottom: 10.0, left: 20.0, right: 20.0),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.white60, offset: Offset(0, 1), blurRadius: 0.5)
          ],
          borderRadius: BorderRadius.circular(5),
          gradient: LinearGradient(
            stops: [0.1, 0.5, 1.0],
            colors: [
              Colors.green,
              Colors.lightGreen,
              Colors.green,
            ],
          ),
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20),
            primary: Colors.transparent,
            shadowColor: Colors.transparent,
          ),
          // style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20)),
          onPressed: widget.onPressed,
          child: const Text('Check out'),
        ),
      );
  }
}
//////////////////////////////////////////////////////////////////////////////
///////////////////////////// BasketCheckoutButton ///////////////////////////
//////////////////////////////////////////////////////////////////////////////

