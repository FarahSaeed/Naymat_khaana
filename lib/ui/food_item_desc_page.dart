import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
import 'package:naymat_khaana/blocs/homePageBloc/home_page_bloc.dart';
import 'package:naymat_khaana/blocs/homePageBloc/home_page_event.dart';
import 'package:naymat_khaana/blocs/homePageBloc/home_page_state.dart';
import 'package:naymat_khaana/utils/cloud_storage.dart';
import 'package:naymat_khaana/utils/navigation.dart';
import 'package:naymat_khaana/utils/util_widgets.dart';
import 'home_page.dart';
import 'login_page.dart'; // new
// new
//import 'package:provider/provider.dart';           // new

class FoodItemsDescPageParent extends StatelessWidget {
  String title;
  FoodItem foodItem;
  UserAccount useraccount;
  FoodItemsDescPageParent({required this.title, required this.foodItem, required this.useraccount});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ExploreFoodItemsBloc>(
          create: (context) => ExploreFoodItemsBloc(),
        ),
        BlocProvider<HomePageBloc>(
          create: (context) => HomePageBloc(),
        ),
        BlocProvider<BasketBloc>(
          create: (context) => BasketBloc(),
        ),
      ], child: FoodItemsDescPage(title: this.title, foodItem: this.foodItem, useraccount: this.useraccount,),
    );
    // return BlocProvider(
    //   create: (context) => ExploreFoodItemsBloc(),
    //   child: FoodItemsDescPage(title: this.title, foodItem: this.foodItem, useraccount: this.useraccount,),
    // );
  }
}

// Define a custom Form widget.
class FoodItemsDescPage extends StatefulWidget {
  //User user;
  String title;
  FoodItem foodItem;
  UserAccount useraccount;
  CloudStorage cloudStorage = CloudStorage();
  ValueNotifier<int> basketItemsCountNotifier =ValueNotifier(0);

  FoodItemsDescPage({required this.title ,required this.foodItem,required this.useraccount});
  @override
  FoodItemsDescPageState createState() {
    return FoodItemsDescPageState(title: this.title, foodItem: this.foodItem);
  }
}

class FoodItemsDescPageState extends State<FoodItemsDescPage> {
  //User user;
  // Icon customIcon = const Icon(Icons.search);
  // Widget customSearchBar =  Text('Explore');
  String title;
  FoodItem foodItem;
  int activePage = 1;
  late PageController _pageController;

  FoodItemsDescPageState({required this.title, required this.foodItem}){
    // customSearchBar =  Text(this.title);
  }
  // FocusNode myFocusNode = FocusNode();
  // TextEditingController? inameController = TextEditingController();
  // DateTime selectedDate = DateTime.now();
  ExploreFoodItemsBloc? exploreFoodItemsBloc;
  HomePageBloc? homePageBloc;
  BasketBloc? basketBloc;

  // List<FoodItem> foodItemsList = [];

  Future<List<String>>? imageData;

  // Future<List<Future<String>>> getImageData() async{
  //   List<Future<String>> imgData = [];
  //   try{
  //     for(int i = 0; i <foodItem.imagename!.length; i++){
  //       imgData.add(widget.cloudStorage.downloadURL(imagename: foodItem.imagename![i]));
  //     }
  //     return imgData;
  //   } on FirebaseException catch (e) {
  //     print(e);
  //   }
  //   return imgData;
  // }

  @override
  void initState() {

    _pageController = PageController(viewportFraction: 0.8);

    imageData = widget.cloudStorage.downloadallURL(imagename: foodItem.imagename!);
    super.initState();
  }
  // Future<List<FoodItem>> initfoodItems() async{
  //   if (foodItemsList.isNotEmpty) {
  //     return foodItemsList;
  //   }
    //exploreFoodItemsBloc!.foodItemsListReference();
  //   final QuerySnapshot snapshot= await FirebaseFirestore.instance.collection('fooditems').get();
  //   List<DocumentSnapshot> docs = snapshot.docs;
  //   if (docs.length > 0) {
  //     foodItemsList = exploreFoodItemsBloc!.mapToList(docList: docs);
  //   }
  //   return foodItemsList;
  // }

  // Future<List<FoodItem>> searchfoodItems(String searchStr) async{
  //   List<FoodItem> searchItems = [];
  //   if (searchStr == null){searchStr = '';}
  //   else{searchStr = searchStr.trim().toLowerCase();}
  //   for( var i = 0 ; i < this.foodItemsList.length; i++ ) {
  //     if (this.foodItemsList[i].iname.toLowerCase().contains(searchStr)){
  //       searchItems.add(this.foodItemsList[i]);
  //     }
  //   }
  //   return searchItems;
  // }
  List<Widget> indicators(imagesLength,currentIndex) {
    return List<Widget>.generate(imagesLength, (index) {
      return Container(
        margin: EdgeInsets.all(3),
        width: 5,
        height: 5,
        decoration: BoxDecoration(
            color: currentIndex == index ? Colors.green : Color(0xFF97E269),
            shape: BoxShape.circle),
      );
    });
  }
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    exploreFoodItemsBloc = BlocProvider.of<ExploreFoodItemsBloc>(context);
    homePageBloc = BlocProvider.of<HomePageBloc>(context);
    basketBloc = BlocProvider.of<BasketBloc>(context);
    basketBloc!.add(HomePageStartedEvent(uname: widget.useraccount.uname));

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(this.title),
      // ),
      appBar: AppBar(
        title: Text(this.title),
        // title: customSearchBar,
        automaticallyImplyLeading: false,
        actions: [
          // IconButton(
          //   onPressed: () {
          //     setState(() {
          //       if (customIcon.icon == Icons.search) {
          //         customIcon =  Icon(Icons.cancel);
          //         customSearchBar =  Container(
          //           alignment: Alignment.centerLeft,
          //           child: TextField(
          //             controller: inameController,
          //             autofocus: true,
          //             focusNode: myFocusNode,
          //             cursorColor: Colors.black,
          //             // cursorHeight: 30,
          //
          //             decoration: InputDecoration(
          //               isDense: true,// this will remove the default content padding
          //               // now you can customize it here or add padding widget
          //               contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
          //               hintText: 'search',
          //               hintStyle: TextStyle(
          //                 color: Colors.white70,
          //                 fontSize: 20,
          //                 fontStyle: FontStyle.italic,
          //               ),
          //               border: InputBorder.none,
          //             ),
          //             style: TextStyle(
          //               color: Colors.white,
          //             ),
          //             // onChanged: searchOperation,
          //             onChanged: (String searchText) {
          //               setState(() {
          //               });
          //             },
          //           ),
          //         );
          //       }  else {
          //         inameController!.text = '';
          //         myFocusNode.requestFocus();
          //       }
          //     });
          //   },
          //   icon: customIcon,
          // )
          CartItemsIcon(
              basketItemsCountNotifier: widget.basketItemsCountNotifier,
              handleClick: (){
                navigateToBasketPage( context, 'Basket', widget.useraccount, HomePageStartedEvent(uname: widget.useraccount.uname), this.basketBloc!) ;
              }),
          UserSideMenu(handleClick: handleClick),

        ],
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
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


              foodItem.imagename==""?Container():
            Container(
              margin: const EdgeInsets.only(top: 0.0, bottom: 10.0, left: 20.0, right: 20.0),
              width: double.infinity,
              height: 300.0,
              child: PageView.builder(
                  itemCount: foodItem.imagename!.length,
                  pageSnapping: true,
                  controller: _pageController,
                  onPageChanged: (page) {
                    setState(() {
                      activePage = page;
                    });
                    },
                  itemBuilder: (context,pagePosition){
                    return Container(
                        margin: EdgeInsets.all(10),
                        child:

                    FutureBuilder(
                      future: imageData!,
                         // future: widget.cloudStorage.downloadURL(imagename: foodItem.imagename![pagePosition]), //'scaled_image_picker1176476598179497756.jpg'),
                          builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {

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
                                child: Image.network(snapshot.data![pagePosition], fit: BoxFit.cover )
                            );
                          }));
                    //Image.file(File(foodItem.imagename![pagePosition].path),fit: BoxFit.cover,));


                    //Image.network(images[pagePosition]));
                  }),
            ),
    Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: indicators(foodItem.imagename!.length,activePage)),
              // ConstrainedBox(constraints: BoxConstraints(
              //   minWidth: 44,
              //   minHeight: 44,
              //   maxWidth: 64,
              //   maxHeight: 500,
              // ),
              //   child: FutureBuilder(
              //       future: widget.cloudStorage.downloadURL(imagename: foodItem.imagename![0]), //'scaled_image_picker1176476598179497756.jpg'),
              //       builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              //         if (snapshot.hasError) {
              //           return Text('Something went wrong');
              //         }
              //         if (snapshot.connectionState == ConnectionState.waiting) {
              //           return Text("Loading");
              //         }
              //         //return Image.asset(snapshot.data!, fit: BoxFit.cover);
              //         return Container(
              //             width: 300,
              //             height: 250,
              //             child: Image.network(snapshot.data!, fit: BoxFit.cover )
              //         );
              //       }),
              // ),
          Text(
          this.foodItem.iname,
            style: TextStyle(
              fontWeight: FontWeight.bold,fontSize: 30,
            ),),
              Text(" Posted by: "+ foodItem.useremail
                  + "\n\n Actual price: " + foodItem.aprice
                  + "\n\n Discounted price: " + foodItem.dprice
                  + "\n\n Posting date: " + foodItem.sdate
                  + "\n\n Expiry date: " + foodItem.edate),
              // Text(
              //   this.foodItem.useremail,
              //   style: TextStyle(
              //    // fontWeight: FontWeight.bold,
              //   ),),
              // Container(
              //   alignment: Alignment(0.0, 0.0),
              //   child: (exploreFoodItemsBloc!.isFoodItemsListPopulated())?
              //   FutureBuilder<QuerySnapshot>(
              //     future: exploreFoodItemsBloc!.foodItemsListReference(),
              //     builder: (BuildContext context,
              //         AsyncSnapshot<QuerySnapshot> snapshot) {
              //       if (snapshot.hasData) {
              //         exploreFoodItemsBloc!.mapToList(docList: snapshot.data!.docs); // foodItemsList is also set here in food repo
              //         if (exploreFoodItemsBloc!.getFoodItems().isNotEmpty) {
              //           return buildList(exploreFoodItemsBloc!.getFoodItems());
              //         }
              //         return Text("No Food items in store");
              //       }
              //       return buildLoadingUI();
              //     },
              //   ):
              //   FutureBuilder<List<FoodItem>>(
              //     future: exploreFoodItemsBloc!.searchfoodItems(inameController!.text),
              //     builder: (BuildContext context,
              //         AsyncSnapshot<List<FoodItem>> snapshot) {
              //       if (snapshot.hasData) {
              //         if (snapshot.data!.length > 0) {
              //           return buildList(snapshot.data!);
              //         }
              //         return Text("No Food items in store");
              //       }
              //       return buildLoadingUI();
              //     },
              //   ),
              // ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20)),
                onPressed: () {
                  exploreFoodItemsBloc!.add(AddButtonPressedEvent(id: this.foodItem.id!, recieveruname: widget.useraccount.uname ));


                },
                child: const Text('Add'),
              ),

            ],
          ),
        ),
      ),
    );
  }

  ListView buildList(List<FoodItem> foodItemList) {
    return ListView.separated(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemCount: foodItemList.length,
        itemBuilder: (context, index) {
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
                + "\n Expiry date: " + foodItemList[index].edate),
            isThreeLine: true,
            onTap: () {
              String u = foodItemList[index].useremail;
              print('foodItemList[index] is $u');
            },
            trailing:
            IconButton(
              // icon: const Icon(Icons.add_shopping_cart_rounded),
              icon: const Icon(Icons.add_rounded),
              color: Colors.green,
              // iconSize: 25.0,
              onPressed: () {
                foodItemList[index].useremail;
                print('foodItemList[index] is $foodItemList[index]');
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
    // myFocusNode.dispose();

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
  void handleClick(String value) async {
    switch (value) {
      case 'Logout':
        homePageBloc!.add(LogoutButtonPressedEvent());
        break;
      case 'Settings':
        break;
    }
  }
}
