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
import 'package:naymat_khaana/blocs/exploreFoodItemsBloc/explore_food_items_state.dart';
import 'package:naymat_khaana/blocs/homePageBloc/home_page_bloc.dart';
import 'package:naymat_khaana/blocs/homePageBloc/home_page_event.dart';
import 'package:naymat_khaana/blocs/homePageBloc/home_page_state.dart';
import 'package:naymat_khaana/custom_widgets/explore_food_items_page_widgets.dart';
import 'package:naymat_khaana/ui/food_item_desc_page.dart';
import 'package:naymat_khaana/utils/navigation.dart';
import 'package:naymat_khaana/utils/util_widgets.dart';

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
        ),
        BlocProvider<HomePageBloc>(
          create: (context) => HomePageBloc(),
        ),
        BlocProvider<BasketBloc>(
          create: (context) => BasketBloc(),
        ),
      ], child: ExploreFoodItemsPage(title: this.title, useraccount: this.useraccount),
    );
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

                      decoration: InputDecoration(
                        isDense: true,// this will remove the default content padding
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
                  myFocusNode.nextFocus();
                }
              });
            },
            icon: customIcon,
          ),
          CartItemsIcon(
              basketItemsCountNotifier: widget.basketItemsCountNotifier,
              handleClick: (){
                navigateToBasketPage( context, 'Basket', this.useraccount, HomePageStartedEvent(uname: useraccount.uname), this.basketBloc!) ;
              }),

          UserSideMenu(handleClick: handleClick),

        ],
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[

            BlocListener<ExploreFoodItemsBloc,ExploreFoodItemsState>(
              listener: (context,state){
                if (state is AddingRecieverSuccessful){
                  // navigateToHomePage(context, state.useraccount);
                  final snackBar = SnackBar(
                    content: const Text('Item is added to basket.'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              child: BlocBuilder<ExploreFoodItemsBloc,ExploreFoodItemsState>(
                  builder: (context,state) {
                    return Container();
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
                    return
                      ExploreListView(
                      useraccountname: this.useraccount.uname,
                      exploreFoodItemsBloc: exploreFoodItemsBloc!,
                      foodItemList: foodItemsList,
                    );
                  },
                )
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  void navigateToFoodItemPage(BuildContext context, FoodItem foodItem) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return FoodItemsDescPageParent(title: 'Detail', foodItem: foodItem);
    })).then(
            (context) {
          basketBloc!.add(HomePageStartedEvent(uname: useraccount.uname));
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

}
