import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // new
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naymat_khaana/app_classes/food_item.dart';
import 'package:naymat_khaana/app_classes/user_account.dart';
import 'package:naymat_khaana/blocs/basketBloc/basket_bloc.dart';
import 'package:naymat_khaana/blocs/basketBloc/basket_event.dart';
import 'package:naymat_khaana/blocs/basketBloc/basket_state.dart';
import 'package:naymat_khaana/blocs/homePageBloc/home_page_bloc.dart';
import 'package:naymat_khaana/blocs/homePageBloc/home_page_event.dart';
import 'package:naymat_khaana/blocs/homePageBloc/home_page_state.dart';
import 'package:naymat_khaana/ui/food_item_desc_page.dart';
import 'checkout_page.dart';
import 'home_page.dart';
import 'login_page.dart'; // new
import 'package:intl/intl.dart';

// new
//import 'package:provider/provider.dart';           // new

class BasketPageParent extends StatelessWidget {
  String title;
  UserAccount useraccount;

  BasketPageParent({required this.title, required this.useraccount});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<BasketBloc>(
            create: (context) => BasketBloc(),
            //child: BasketPage(title: this.title, useraccount: this.useraccount),
          ),
          BlocProvider<HomePageBloc>(
            create: (context) => HomePageBloc(),
            //child: BasketPage(title: this.title, useraccount: this.useraccount),
          ),
        ], child: BasketPage(title: this.title, useraccount: this.useraccount),
    // child:       BlocProvider<BasketBloc>(
    // create: (context) => BasketBloc(),
    // child: BasketPage(title: this.title, useraccount: this.useraccount),
    // );
    );


  }
}

// Define a custom Form widget.
class BasketPage extends StatefulWidget {
  //User user;
  String title;
  UserAccount useraccount;
  BasketPage({required this.title, required this.useraccount});
  @override
  BasketPageState createState() {
    return BasketPageState(title: this.title, useraccount: this.useraccount);
  }

  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<String> downloadURL({required String imagename}) async{
    String durl = "";
    try{
      durl = await storage.ref('test/$imagename').getDownloadURL();
      return durl;
    } on FirebaseException catch (e) {print(e);}
    return durl;
  }

}

class BasketPageState extends State<BasketPage> {
  //User user;
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar =  Text('Explore');
  String title;
  int numitems = 0;
  Stream<QuerySnapshot>? fooditemsStream;
  CollectionReference? fooditems;
  ValueNotifier<int> basketItemsCountNotifier =ValueNotifier(0);

  UserAccount useraccount;
  BasketPageState({required this.title, required this.useraccount}){
    customSearchBar =  Text(this.title);
    this.fooditems = FirebaseFirestore.instance.collection('fooditems');
    this.fooditemsStream = this.fooditems!
            .where("receiever", isEqualTo: this.useraccount.uname)
            .where("taken", isNull: true)
            .snapshots();
  }



  FocusNode myFocusNode = FocusNode();
  TextEditingController? inameController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  BasketBloc? basketBloc;
  HomePageBloc? homePageBloc;
  List<FoodItem> foodItemsList = [];

  Future<List<FoodItem>> initfoodItems() async{
    if (foodItemsList.isNotEmpty) {
      return foodItemsList;
    }
    //exploreFoodItemsBloc!.foodItemsListReference();
    final QuerySnapshot snapshot= await FirebaseFirestore.instance.collection('fooditems').get();
    List<DocumentSnapshot> docs = snapshot.docs;
    if (docs.length > 0) {
      foodItemsList = basketBloc!.mapToList(docList: docs);
    }
    return foodItemsList;
  }

  Future<List<FoodItem>> searchfoodItems(String searchStr) async{
    List<FoodItem> searchItems = [];
    if (searchStr == null){searchStr = '';}
    else{searchStr = searchStr.trim().toLowerCase();}
    for( var i = 0 ; i < this.foodItemsList.length; i++ ) {
      if (this.foodItemsList[i].iname.toLowerCase().contains(searchStr)){
        searchItems.add(this.foodItemsList[i]);
      }
    }
    return searchItems;
  }
  void removeFromBasket(String id) async {
    await this.fooditems!.doc(id)
        .update({
      'receiever': null
    })
        .then((value) => print("Food item updated"))
        .catchError((error) => throw Exception(error.toString()));
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //numitems = 0;
    basketBloc = BlocProvider.of<BasketBloc>(context);
    homePageBloc = BlocProvider.of<HomePageBloc>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      // appBar: AppBar(
      //   title: Text(this.title),
      // ),
      appBar: AppBar(
        title: customSearchBar,
        automaticallyImplyLeading: false,
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.all(10.0),
        //     child: Container(
        //       width: 35.0,
        //       alignment: Alignment.center,
        //       child: GestureDetector(
        //         onTap: () {
        //           // Todo:navigate to cart screen
        //           // if (kDebugMode) {
        //           //   print("tapped on cart icon");
        //           // }
        //         },
        //         child: Stack(
        //           children: <Widget>[
        //             const IconButton(
        //               icon: Icon(
        //                 Icons.shopping_cart_sharp,
        //                 color: Colors.white60,
        //               ),
        //               onPressed: null,
        //             ),
        //             1 == 0
        //                 ? Container()
        //                 : Positioned(
        //               top: 0,
        //               right: 0,
        //               child: Stack(
        //                 children: <Widget>[
        //                   Container(
        //                     height: 20.0,
        //                     width: 20.0,
        //                     decoration: const BoxDecoration(
        //                       color: Colors.lime,
        //                       shape: BoxShape.circle,
        //                     ),
        //                     child: const Center(
        //                       child: Text(
        //                         "10",
        //                         style: TextStyle(
        //                           color: Colors.black54,
        //                           fontSize: 11.0,
        //                           fontWeight: FontWeight.bold,
        //                         ),
        //                       ),
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
        //     ),
        //   ),
        // ],
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                if (customIcon.icon == Icons.search) {
                  customIcon =  Icon(Icons.cancel);
                  customSearchBar =  Container(
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      controller: inameController,
                      autofocus: true,
                      focusNode: myFocusNode,
                      cursorColor: Colors.black,
                      // cursorHeight: 30,

                      decoration: InputDecoration(
                        isDense: true,// this will remove the default content padding
                        // now you can customize it here or add padding widget
                        contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                        hintText: 'search',
                        hintStyle: TextStyle(
                          color: Colors.white70,
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      // onChanged: searchOperation,
                      onChanged: (String searchText) {
                        setState(() {
                        });
                      },
                    ),
                  );
                }  else {
                  inameController!.text = '';
                  myFocusNode.requestFocus();
                }
              });
            },
            icon: customIcon,
          ),
          // IconButton(icon: Icon(Icons.shopping_cart), onPressed: () {}),
    Stack(
              children: <Widget>[
                 IconButton(
                  icon: Icon(
                    Icons.shopping_cart_sharp,
                    color: Colors.white,
                  ),
                  onPressed: (){
                    navigateToCheckoutPage(context);
                  },
                ),
                    Positioned(
                  top: 0,
                  right: 0,
                  child: Stack(
                    children: <Widget>[
                      GestureDetector(
                        // onTap: (){
                        // } ,
                        child: Container(
                          height: 20.0,
                          width: 20.0,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child:
                          Center(
                            child: ValueListenableBuilder(
                              valueListenable: basketItemsCountNotifier,
                              builder: (BuildContext context, int nitems, Widget? child)  {
                                return Text(nitems.toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 11.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        );
                              },
                              //child: Text('Hi')
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {'Logout', 'Settings'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
        centerTitle: true,
      ),
      body: SafeArea(
      //  child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // BlocListener<ExploreFoodItemsBloc,ExploreFoodItemsState>(
              //   listener: (context,state){
              //     if (state is AddingRecieverSuccessful){
              //       final snackBar = SnackBar(
              //         content: const Text('Item added to cart!'),
              //         // action: SnackBarAction(
              //         //   label: 'Undo',
              //         //   onPressed: () {
              //         //     // Some code to undo the change.
              //         //   },
              //         // ),
              //       );
              //       ScaffoldMessenger.of(context).showSnackBar(snackBar);
              //     }
              //   },),

              BlocListener<BasketBloc,BasketState>(
                listener: (context,state){
                  // if (state is AddingRecieverSuccessful){
                  //   // navigateToHomePage(context, state.useraccount);
                  //   final snackBar = SnackBar(
                  //     content: const Text('Item added to cart!'),
                  //     // action: SnackBarAction(
                  //     //   label: 'Undo',
                  //     //   onPressed: () {
                  //     //     // Some code to undo the change.
                  //     //   },
                  //     // ),
                  //   );
                  //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  // }
                },
                child: BlocBuilder<BasketBloc,BasketState>(
                    builder: (context,state) {
                      return Container();
                      // if (state is UserRegInitialState){
                      //   return buildInitialUI();
                      // }
                      // else if (state is UserRegLoading) {
                      //   return buildLoadingUI();
                      // }
                      // else if (state is UserRegSuccessful) {
                      //   return Container();
                      // }
                      // else if (state is UserRegFailed) {
                      //   return buildFailureUI(state.message);
                      // }
                      // else {return buildInitialUI();}
                    }
                ),
              ),
              BlocListener<HomePageBloc,HomePageState>(
                listener: (context,state){
                  if (state is LogoutSuccessful) {
                    navigateToLoginPage(context);
                  }
                },
                child: BlocBuilder<HomePageBloc,HomePageState>(
                    builder: (context,state) {
                      return Container();
                    }
                ),
              ),


              StreamBuilder<QuerySnapshot>(
                stream: fooditemsStream,
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
               if (snapshot.hasError) {
                 return Text('Something went wrong');
               }

               if (snapshot.connectionState == ConnectionState.waiting) {
                 return Text("Loading");
               }
               if (snapshot.data!.docs.length == 0){
                 return Text("Currently there are no food items in the list");
               }
               numitems=0;
               return Column(
                 //mainAxisSize: MainAxisSize.max,
                 children: [
                   Container(
                     height: 570,
                     child: ListView(
                       shrinkWrap: true,

                       children: snapshot.data!.docs.map((DocumentSnapshot document) {
                         Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                         FoodItem fooditem = FoodItem(iname: data['item_name'], uname: data['username'], aprice: data['actual_price'], dprice: data['discount_price'], sdate: data['submit_date'], edate: data['exp_date'], useremail: data['user_email'], imagename: data['imagename']==null? "":data['imagename']);
                         DateTime expirationDate = DateTime.parse(fooditem.edate);
                         final now = DateTime.now();
                         final bool isExpired = expirationDate.isBefore(now);
                         if (isExpired) return Container();
                         numitems= numitems+1; //return Text('An expired item has been removed from your basket');
                         WidgetsBinding.instance?.addPostFrameCallback((_){
                           basketItemsCountNotifier.value = numitems;
                         });
                         // setState(() {
                         // });
                         return Dismissible(
                           key: UniqueKey(),
                           onDismissed: (direction) {
                             numitems = numitems-1;
                             basketItemsCountNotifier.value = numitems;
                             var result = removeFromBasket(document.id);
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

                               //      String iname = data['item_name'];
                       //  String uname = data['username'];
                       //  String aprice = data['actual_price'];
                       //  String dprice = data['discount_price'];
                       //  String sdate = data['submit_date'];
                       //  String edate = data['exp_date'];
                               title: Padding(
                                 padding: const EdgeInsets.only(bottom:8.0),
                                 child: Text(capitalize(data['item_name']),
                                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                 ),
                               ),
                               // subtitle: Text(data['user_email']),
                               subtitle:
                               Text.rich(TextSpan(
                                 //text: 'This item costs ',
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
                                       // decoration: TextDecoration.lineThrough,
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
                               // subtitle: Text(
                               //    // " Posted by: "+ data['user_email']
                               //    // + "\n Actual price: " + data['actual_price']
                               //    // + "\n Discounted price: " + data['discount_price']
                               //    // + "\n Posting date: " + data['submit_date']
                               //    // + "\n Expiry date: " + data['exp_date']),
                               //   " Discounted price \$" + data['discount_price']
                               //       + "\n Original price: \$" + data['actual_price']
                               //       + "\n Expiring on " + DateFormat("yMMMMd").format(DateTime.parse(data['exp_date']))
                               //       + "\n Posted on  " + DateFormat("yMMMMd").format(DateTime.parse(data['submit_date']))
                               //       + "\n\n Posted by: "+ data['username']),
                                   //+ "\n " + (isExpired?"Expired":"") // isExpired?"":""
                                   // + "\n  Expired {$isExpired}" + (isExpired?"Expired":"") // isExpired?"":""
                                   //
                                 //  + "\n Id: " + document.id),
                               isThreeLine: true,
                               leading: fooditem.imagename==""?null:ConstrainedBox(
                                 constraints: BoxConstraints(
                                   minWidth: 44,
                                   minHeight: 44,
                                   maxWidth: 64,
                                   maxHeight: 64,
                                 ),
                                 // child: Image.asset(profileImage, fit: BoxFit.cover),
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

                                     numitems = numitems-1;
                                     basketItemsCountNotifier.value = numitems;
                                     var result = removeFromBasket(document.id);
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
                     ),
                   ),
               this.numitems>0?
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
               onPressed: () async {
               navigateToCheckoutPage(context);
               },
               child: const Text('Check out'),
               ),
               )
               :Container(),
                 ],
               );
                },
              ),




            ],

          ),
      //  ),
      ),
    );
  }
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);


  ListView buildList(List<FoodItem> foodItemList, List<QueryDocumentSnapshot> docs) {
    return ListView.separated(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemCount: foodItemList.length,
        itemBuilder: (context, index) {
          final now = DateTime.now();
          final expirationDate1 = DateTime(2021, 1, 10);
          DateTime expirationDate = DateTime.parse(foodItemList[index].edate);
          final bool isExpired = expirationDate.isBefore(now);
          final item_id = foodItemList[index].id!;
          return Dismissible(
            key: UniqueKey(), //Key(item_id),
            onDismissed: (direction) {
              // Remove the item from the data source.
              setState(() {
                docs.removeAt(index);
                basketBloc!.add(
                    RemoveButtonPressedEvent(id: foodItemList[index].id!, index: index));
                //foodItemList.removeAt(index);
              });
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('$foodItemList[index].iname dismissed')));
            },
             // Show a red background as the item is swiped away.
            background: Container(color: Colors.red),
            child: ListTile(
              title: Text(
                foodItemList[index].iname,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(" Posted by: "+ foodItemList[index].useremail
                  + "\n Actual price: " + foodItemList[index].aprice
                  + "\n Discounted price: " + foodItemList[index].dprice
                  + "\n Posting date: " + foodItemList[index].sdate
                  + "\n Expiry date: " + foodItemList[index].edate
                  + "\n " + (isExpired?"Expired":"") // isExpired?"":""
                  // + "\n  Expired {$isExpired}" + (isExpired?"Expired":"") // isExpired?"":""
                  //
                  + "\n Id: " + foodItemList[index].id!),
              isThreeLine: true,
              onTap: isExpired?null: () {
                String u = foodItemList[index].useremail;
                print('foodItemList[index] is $u');
                navigateToFoodItemPage( context,  foodItemList[index]);
              },
              trailing:
              IconButton(
                // icon: const Icon(Icons.add_shopping_cart_rounded),
                icon: const Icon(Icons.remove),
                //color: isExpired? Colors.grey: Colors.red,
                color: Colors.red,
                iconSize: 25.0,
                  onPressed: (){

            setState(() {
              basketBloc!.add(
                  RemoveButtonPressedEvent(id: foodItemList[index].id!, index: index));
              //foodItemList.removeAt(index);
            });

                  },
                // onPressed: isExpired?null: () {
                //   foodItemList[index].useremail;
                //   print('foodItemList[index] is $foodItemList[index]');
                  //RemoveButtonPressedEvent(id: foodItemList[index].id!);
              // basketBloc!.add();
                // },
              ),
              // Icon(
              //   Icons.favorite ,
              //   color:  Colors.red ,
              //  // semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
              // ),
            ),
          );
        });
  }
  void handleClick(String value) async {
    switch (value) {
      case 'Logout':
       homePageBloc!.add(LogoutButtonPressedEvent());
        break;
      case 'Settings':
        break;
    }
  }
  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();

    super.dispose();
  }

  Widget buildInitialUI() {
    return Text('Waiting for Submission');
  }

  Widget buildLoadingUI() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildFailureUI(String message) {
    return Text(message,
        style: TextStyle(
          color: Colors.red,
        ));
  }

  // void navigateToFoodItemPage(BuildContext context, FoodItem foodItem){
  //   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>
  //       FoodItemsDescPageParent(title: 'Detail', foodItem: foodItem)), (Route<dynamic> route) => false);
  //   return ExploreFoodItemsPageParent(title: "Explore Food Items");
  // }

  void navigateToFoodItemPage(BuildContext context, FoodItem foodItem) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return FoodItemsDescPageParent(title: 'Detail', foodItem: foodItem);
    }));
  }

  void navigateToCheckoutPage(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return CheckoutPageParent(title: "Checkout", useraccount: this.useraccount);
    }));
  }
  void navigateToLoginPage(BuildContext context) {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>
        LoginPageParent(title: 'Login')), (Route<dynamic> route) => false);
  }
}
