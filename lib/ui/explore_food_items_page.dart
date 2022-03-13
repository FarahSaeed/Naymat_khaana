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
import 'package:naymat_khaana/blocs/exploreFoodItemsBloc/explore_food_items_bloc.dart';
import 'package:naymat_khaana/blocs/exploreFoodItemsBloc/explore_food_items_event.dart';
import 'package:naymat_khaana/blocs/exploreFoodItemsBloc/explore_food_items_state.dart';
import 'package:naymat_khaana/blocs/homePageBloc/home_page_bloc.dart';
import 'package:naymat_khaana/blocs/homePageBloc/home_page_event.dart';
import 'package:naymat_khaana/blocs/homePageBloc/home_page_state.dart';
import 'package:naymat_khaana/ui/food_item_desc_page.dart';
import 'basket_page.dart';
import 'home_page.dart';
import 'login_page.dart'; // new
import 'package:intl/intl.dart';
// new
//import 'package:provider/provider.dart';           // new

class ExploreFoodItemsPageParent extends StatelessWidget {
  String title;
  UserAccount useraccount;

  ExploreFoodItemsPageParent({required this.title, required this.useraccount});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ExploreFoodItemsBloc>(
          create: (context) => ExploreFoodItemsBloc(),
          //child: BasketPage(title: this.title, useraccount: this.useraccount),
        ),
        BlocProvider<HomePageBloc>(
          create: (context) => HomePageBloc(),
          //child: BasketPage(title: this.title, useraccount: this.useraccount),
        ),
        BlocProvider<BasketBloc>(
          create: (context) => BasketBloc(),
          //child: BasketPage(title: this.title, useraccount: this.useraccount),
        ),
      ], child: ExploreFoodItemsPage(title: this.title, useraccount: this.useraccount),
    );
    // return BlocProvider(
    //   create: (context) => ExploreFoodItemsBloc(),
    //   child: ExploreFoodItemsPage(title: this.title, useraccount: this.useraccount),
    // );
  }
}

// Define a custom Form widget.
class ExploreFoodItemsPage extends StatefulWidget {
  //User user;
  String title;
  UserAccount useraccount;
  ExploreFoodItemsPage({required this.title, required this.useraccount});
  ValueNotifier<int> basketItemsCountNotifier =ValueNotifier(0);
  final FirebaseStorage storage = FirebaseStorage.instance;

  @override
  ExploreFoodItemsPageState createState() {
    return ExploreFoodItemsPageState(title: this.title, useraccount: this.useraccount);
  }

  Future<String> downloadURL({required String imagename}) async{
    String durl = "";
    try{
      durl = await storage.ref('test/$imagename').getDownloadURL();
      return durl;
    } on FirebaseException catch (e) {print(e);}
    return durl;
  }

}

class ExploreFoodItemsPageState extends State<ExploreFoodItemsPage> {
  //User user;
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar =  Text('Explore');
  String title;
  Stream<QuerySnapshot>? fooditemsStream;
  UserAccount useraccount;
  CollectionReference? fooditems;
  String searchField = "";
  HomePageBloc? homePageBloc;




  ExploreFoodItemsPageState({required this.title, required this.useraccount}){
    customSearchBar =  Text(this.title);

    this.fooditems = FirebaseFirestore.instance.collection('fooditems');
    this.fooditemsStream = this.fooditems!
        .where("receiever", isNull: true)
        .where("taken", isNull: true)//.orderBy('actual_price', descending: true)
        .snapshots();
  }
  FocusNode myFocusNode = FocusNode();
  TextEditingController? inameController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  ExploreFoodItemsBloc? exploreFoodItemsBloc;
  BasketBloc? basketBloc;

  List<FoodItem> foodItemsList = [];

  Future<List<FoodItem>> initfoodItems() async{
    if (foodItemsList.isNotEmpty) {
      return foodItemsList;
    }
    //exploreFoodItemsBloc!.foodItemsListReference();
    final QuerySnapshot snapshot= await FirebaseFirestore.instance.collection('fooditems').get();
    List<DocumentSnapshot> docs = snapshot.docs;
    if (docs.length > 0) {
      foodItemsList = exploreFoodItemsBloc!.mapToList(docList: docs);
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    exploreFoodItemsBloc = BlocProvider.of<ExploreFoodItemsBloc>(context);
    homePageBloc = BlocProvider.of<HomePageBloc>(context);
    basketBloc = BlocProvider.of<BasketBloc>(context);
    basketBloc!.add(HomePageStartedEvent(uname: useraccount.uname));

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(this.title),
      // ),
      appBar: AppBar(
        title: customSearchBar,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              myFocusNode.requestFocus();
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
                          this.searchField = searchText;
                        });
                      },
                    ),
                  );
                }  else {
                  inameController!.text = '';
                  this.searchField = "";
                  customIcon =  Icon(Icons.search);
                  customSearchBar =  Text(this.title);
                  //myFocusNode.requestFocus();
                  myFocusNode.nextFocus();
                }
              });
            },
            icon: customIcon,
          ),
          Stack(
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.shopping_cart_sharp,
                  color: Colors.white,
                ),
                onPressed: (){
                  navigateToBasketPage(context);
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
                            valueListenable: widget.basketItemsCountNotifier,
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
          )

        ],
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
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

            BlocListener<ExploreFoodItemsBloc,ExploreFoodItemsState>(
              listener: (context,state){
                if (state is AddingRecieverSuccessful){
                  // navigateToHomePage(context, state.useraccount);
                  final snackBar = SnackBar(
                    content: const Text('Item is added to basket.'),
                    // action: SnackBarAction(
                    //   label: 'Undo',
                    //   onPressed: () {
                    //     // Some code to undo the change.
                    //   },
                    // ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              child: BlocBuilder<ExploreFoodItemsBloc,ExploreFoodItemsState>(
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
            BlocListener<ExploreFoodItemsBloc,ExploreFoodItemsState>(
              listener: (context,state){
                if (state is AddingRecieverSuccessful) {
                  //navigateToLoginPage(context);
                  //fdfd
                  basketBloc!.add(HomePageStartedEvent(uname: useraccount.uname));

                }
              },
              child: BlocBuilder<ExploreFoodItemsBloc,ExploreFoodItemsState>(
                  builder: (context,state) {
                    return Container();
                  }
              ),
            ),

            BlocListener<BasketBloc, BasketState>(
              listener: (context, state) {
                if (state is BasketCountLoaded) {
                  widget.basketItemsCountNotifier.value = state.count;
                }
              },
              child: BlocBuilder<BasketBloc, BasketState>(
                builder: (context, state) {
                  if (state is BasketCountLoaded) {
                    return Container();
                  }
                  else {
                    return Container();
                  }
                },
              ),
            ),

            Expanded(
                child:

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

                    // create a list of food items to display
                    foodItemsList = [];
                    snapshot.data!.docs.forEach((document) {

                      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                      String iname = data['item_name'];
                      String uname = data['username'];
                      String aprice = data['actual_price'];
                      String dprice = data['discount_price'];
                      String sdate = data['submit_date'];
                      String edate = data['exp_date'];
                      String useremail = data['user_email']==null?'na':data['user_email'];
                      String imagename = data['imagename']==null? "":data['imagename'];

                      if (this.searchField == "" || iname.contains(this.searchField)) {
                        foodItemsList.add(FoodItem(iname: iname,
                            uname: uname,
                            aprice: aprice,
                            dprice: dprice,
                            sdate: sdate,
                            edate: edate,
                            useremail: useremail,
                            id: document.id,
                            imagename: imagename));
                      }
                    });
                    foodItemsList.sort((a, b) => DateTime.parse(b.edate).compareTo(DateTime.parse(a.edate)) );
                    return buildNewList(foodItemsList);
                  },
                )
              //alignment: Alignment(0.0, 0.0),
              // child: (exploreFoodItemsBloc!.isFoodItemsListPopulated())?
              // FutureBuilder<QuerySnapshot>(
              //   future: exploreFoodItemsBloc!.foodItemsListReference(),
              //   builder: (BuildContext context,
              //       AsyncSnapshot<QuerySnapshot> snapshot) {
              //         if (snapshot.hasData) {
              //           exploreFoodItemsBloc!.mapToList(docList: snapshot.data!.docs); // foodItemsList is also set here in food repo
              //           if (exploreFoodItemsBloc!.getFoodItems().isNotEmpty) {
              //             return buildList(exploreFoodItemsBloc!.getFoodItems());
              //           }
              //           return Text("No Food items in store");
              //         }
              //         return buildLoadingUI();
              //         },
              // ):
              // FutureBuilder<List<FoodItem>>(
              //   future: exploreFoodItemsBloc!.searchfoodItems(inameController!.text),
              //   builder: (BuildContext context,
              //       AsyncSnapshot<List<FoodItem>> snapshot) {
              //     if (snapshot.hasData) {
              //       if (snapshot.data!.length > 0) {
              //         return buildList(snapshot.data!);
              //       }
              //       return Text("No Food items in store");
              //     }
              //     return buildLoadingUI();
              //   },
              // ),
            ),

          ],
        ),
      ),
    );
  }
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  ListView buildNewList(List<FoodItem> foodItemList){
    return ListView(

      children: foodItemList.map((FoodItem fooditem) {
        //Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        DateTime expirationDate = DateTime.parse(fooditem.edate); //yMMMMd
        final now = DateTime.now();
        final bool isExpired =expirationDate.isBefore(now);
        return Card(
          margin: const EdgeInsets.only( top: 10, left: 25.0, right: 25.0),
          child: ListTile(
            // leading:
            // Container(
            //   // height: 45,
            //   // width: double.infinity,
            //   // margin: const EdgeInsets.only(top: 15.0, bottom: 10.0, left: 20.0, right: 20.0),
            //   // child: FutureBuilder(
            //   //     future: widget.downloadURL(imagename: 'scaled_image_picker1176476598179497756.jpg'),
            //   //     builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            //   //       if (snapshot.hasError) {
            //   //         return Text('Something went wrong');
            //   //       }
            //   //       if (snapshot.connectionState == ConnectionState.waiting) {
            //   //         return Text("Loading");
            //   //       }
            //   //       return Container(
            //   //           width: 300,
            //   //           height: 250,
            //   //           child: Image.network(snapshot.data!, fit: BoxFit.cover )
            //   //
            //   //       );
            //   //     }),
            // ),
            //



            // ConstrainedBox(
            //   constraints: BoxConstraints(
            //     minWidth: 44,
            //     minHeight: 44,
            //     maxWidth: 64,
            //     maxHeight: 64,
            //   ),
            //   child: Image.asset(profileImage, fit: BoxFit.cover),
            // ),
            contentPadding:const EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0, bottom:5.0),
            // minVerticalPadding: 10,
            //  String iname = data['item_name'];
            //  String uname = data['username'];
            //  String aprice = data['actual_price'];
            //  String dprice = data['discount_price'];
            //  String sdate = data['submit_date'];
            //  String edate = data['exp_date'];
            title: Padding(
              padding: const EdgeInsets.only(bottom:8.0),
              child: Text(capitalize(fooditem.iname),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            // subtitle: Text(data['user_email']),
            subtitle:
            Container(
              child: Stack(
                children: [Text.rich(TextSpan(
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
                      text: "\n Expiring " + DateFormat("MMMd").format(DateTime.parse(fooditem.edate)),
                      style:  TextStyle(
                          color: Colors.green, fontSize: 15.0, height: 2.0
                        // decoration: TextDecoration.lineThrough,
                      ),
                    )
                    ,
                  ],
                ),
                ),],
              ),
            ),
            // Text(
            //     "\$"+ fooditem.dprice + "\n\n Expiring on " + DateFormat("yMMMd").format(DateTime.parse(fooditem.edate)),
            //     // " Discounted price \$" + fooditem.dprice
            //     // + "\n Original price: \$" + fooditem.aprice
            //     // + "\n Expiring on " + DateFormat("yMMMMd").format(DateTime.parse(fooditem.edate))
            //     // + "\n Posted on  " + DateFormat("yMMMMd").format(DateTime.parse(fooditem.sdate))
            //     // + "\n\n Posted by: "+ fooditem.uname,
            //   style: TextStyle(fontSize: 15),
            //
            // ),
            // + "\n " + (isExpired?"Expired":"") // isExpired?"":""
            // + "\n  Expired {$isExpired}" + (isExpired?"Expired":"") // isExpired?"":""
            //
            //  + "\n Id: " + fooditem.id!),
            isThreeLine: true,

            trailing:isExpired?null://Text("not available"):
            IconButton(
              // icon: const Icon(Icons.add_shopping_cart_rounded),
              icon: const Icon(Icons.add_rounded),
              color: isExpired? Colors.grey: Colors.green,
              // iconSize: 25.0,
              onPressed: isExpired?null: () {
                // foodItemList[index].useremail;
                // print('foodItemList[index] is $data['user_email']');
                exploreFoodItemsBloc!.add(AddButtonPressedEvent(id: fooditem.id!, recieveruname: this.useraccount.uname ));

              },
            ),
            // IconButton(
            //   // icon: const Icon(Icons.add_shopping_cart_rounded),
            //   icon: const Icon(Icons.remove),
            //   //color: isExpired? Colors.grey: Colors.red,
            //   color: Colors.red,
            //   iconSize: 25.0,
            //   onPressed: (){
            //     var result = removeFromBasket(document.id);
            //     final snackBar = SnackBar(
            //       content: const Text('Item added to cart!'),
            //       // action: SnackBarAction(
            //       //   label: 'Undo',
            //       //   onPressed: () {
            //       //     // Some code to undo the change.
            //       //   },
            //       // ),
            //     );
            //     ScaffoldMessenger.of(context)
            //         .showSnackBar(SnackBar(content: Text('$data["item_name"] dismissed')));
            //   },
            // ),

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
          ),
        );
      }).toList(),
    );
  }

  ListView buildList(List<FoodItem> foodItemList) {
    // return ListView.separated(
    //   itemCount: 25,
    //   //shrinkWrap: true,
    //   separatorBuilder: (BuildContext context, int index) => Divider(),
    //   itemBuilder: (BuildContext context, int index) {
    //     return ListTile(
    //       title: Text('item $index'),
    //     );
    //   },
    // );
    return ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemCount: foodItemList.length,
        itemBuilder: (context, index) {
          final now = DateTime.now();
          final expirationDate1 = DateTime(2021, 1, 10);

          DateTime expirationDate = DateTime.parse(foodItemList[index].edate);
          final bool isExpired = expirationDate.isBefore(now);
          return ListTile(
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
              icon: const Icon(Icons.add_rounded),
              color: isExpired? Colors.grey: Colors.green,
              // iconSize: 25.0,
              onPressed: isExpired?null: () {
                foodItemList[index].useremail;
                print('foodItemList[index] is $foodItemList[index]');
                exploreFoodItemsBloc!.add(AddButtonPressedEvent(id: foodItemList[index].id!, recieveruname: this.useraccount.uname ));
              },
            ),
            // Icon(
            //   Icons.favorite ,
            //   color:  Colors.red ,
            //  // semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
            // ),
          );
        });
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
    })).then(
            (context) {
          basketBloc!.add(HomePageStartedEvent(uname: useraccount.uname));
        });
  }

  void navigateToLoginPage(BuildContext context) {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>
        LoginPageParent(title: 'Login')), (Route<dynamic> route) => false);
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
  void navigateToBasketPage(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return BasketPageParent(title: "Basket Items", useraccount: this.useraccount);
    })).then(
            (context) {
          basketBloc!.add(HomePageStartedEvent(uname: useraccount.uname));
        });

  }
}
