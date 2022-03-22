import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:naymat_khaana/app_classes/food_item.dart';
import 'package:intl/intl.dart';
import 'package:naymat_khaana/blocs/exploreFoodItemsBloc/explore_food_items_bloc.dart';
import 'package:naymat_khaana/blocs/exploreFoodItemsBloc/explore_food_items_event.dart';

//////////////////////////////////////////////////////////////////////////////
///////////////////////////// ExploreListView ////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
class ExploreListView extends StatefulWidget {
  ExploreListView({
    Key? key,
    required this.foodItemList,
    required this.exploreFoodItemsBloc,
    required this.useraccountname
  }) : super(key: key);
  List<FoodItem> foodItemList;
  ExploreFoodItemsBloc exploreFoodItemsBloc;
  String useraccountname;
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<String> downloadURL({required String imagename}) async{
    String durl = "";
    try{
      durl = await storage.ref('test/$imagename').getDownloadURL();
      return durl;
    } on FirebaseException catch (e) {print(e);}
    return durl;
  }
  @override
  ExploreListViewState createState() {
    return ExploreListViewState();
  }
}
String capitalize(String s) => s[0].toUpperCase() + s.substring(1);



class ExploreListViewState  extends State<ExploreListView>{
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: widget.foodItemList.map((FoodItem fooditem) {
        //Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        DateTime expirationDate = DateTime.parse(fooditem.edate); //yMMMMd
        final now = DateTime.now();
        final bool isExpired =expirationDate.isBefore(now);
        return Card(
          margin: const EdgeInsets.only( top: 10, left: 25.0, right: 25.0),
          child: ListTile(
            contentPadding:const EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0, bottom:5.0),
            title: Padding(
              padding: const EdgeInsets.only(bottom:8.0),
              child: Text(capitalize(fooditem.iname),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            subtitle:
            Container(
              child: Stack(
                children: [Text.rich(TextSpan(
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
                      text: "\n Expiring " + DateFormat("MMMd").format(DateTime.parse(fooditem.edate)),
                      style:  TextStyle(
                          color: Colors.green, fontSize: 15.0, height: 2.0
                      ),
                    ),
                  ],
                ),
                ),],
              ),
            ),
            isThreeLine: true,
            trailing:isExpired?null://Text("not available"):
            IconButton(
              icon: const Icon(Icons.add_rounded),
              color: isExpired? Colors.grey: Colors.green,
              onPressed: isExpired?null: () {
                widget.exploreFoodItemsBloc!.add(AddButtonPressedEvent(id: fooditem.id!, recieveruname: widget.useraccountname ));
              },
            ),
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
          ),
        );
      }).toList(),
    );
  }
}
//////////////////////////////////////////////////////////////////////////////
///////////////////////////// ExploreListView ////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
