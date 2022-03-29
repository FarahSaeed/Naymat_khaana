import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:naymat_khaana/app_classes/food_item.dart';
import 'package:intl/intl.dart';
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
    required this.removeFromBasket
  }) : super(key: key);

  AsyncSnapshot<QuerySnapshot> snapshot;
  ValueNotifier<int> basketItemsCountNotifier;
  int numitems = 0;
  String useraccountname;
  final FirebaseStorage storage = FirebaseStorage.instance;
 // void Function(String) removeFromBaset;

  void Function(String) removeFromBasket;


  Future<String> downloadURL({required String imagename}) async{
    String durl = "";
    try{
      durl = await storage.ref('test/$imagename').getDownloadURL();
      return durl;
    } on FirebaseException catch (e) {print(e);}
    return durl;
  }
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
        FoodItem fooditem = FoodItem(iname: data['item_name'], uname: data['username'], aprice: data['actual_price'], dprice: data['discount_price'], sdate: data['submit_date'], edate: data['exp_date'], useremail: data['user_email'], imagename: data['imagename']==null? "":data['imagename']);
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
              Text.rich(TextSpan(
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
              isThreeLine: true,
              leading: fooditem.imagename==""?null:ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 44,
                  minHeight: 44,
                  maxWidth: 64,
                  maxHeight: 64,
                ),
                child: FutureBuilder(
                    future: widget.downloadURL(imagename: fooditem.imagename!), //'scaled_image_picker1176476598179497756.jpg'),
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
