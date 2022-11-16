import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naymat_khaana/app_classes/food_item.dart';
import 'package:naymat_khaana/app_classes/user_account.dart';
import 'package:naymat_khaana/blocs/basketBloc/basket_bloc.dart';
import 'package:naymat_khaana/blocs/basketBloc/basket_event.dart';
import 'package:naymat_khaana/blocs/basketBloc/basket_state.dart';
import 'package:naymat_khaana/blocs/homePageBloc/home_page_bloc.dart';
import 'package:naymat_khaana/blocs/homePageBloc/home_page_event.dart';
import 'package:naymat_khaana/blocs/homePageBloc/home_page_state.dart';
import 'package:naymat_khaana/custom_widgets/basket_page_widgets.dart';
import 'package:naymat_khaana/utils/navigation.dart';
import 'package:naymat_khaana/utils/util_widgets.dart';

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
          ),
          BlocProvider<HomePageBloc>(
            create: (context) => HomePageBloc(),
          ),
        ], child: BasketPage(title: this.title, useraccount: this.useraccount),
    );
  }
}

class BasketPage extends StatefulWidget {
  String title;
  UserAccount useraccount;
  BasketPage({required this.title, required this.useraccount});
  @override
  BasketPageState createState() {
    return BasketPageState(title: this.title, useraccount: this.useraccount);
  }
}

class BasketPageState extends State<BasketPage> {
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
    basketBloc = BlocProvider.of<BasketBloc>(context);
    homePageBloc = BlocProvider.of<HomePageBloc>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: customSearchBar,
        //automaticallyImplyLeading: false,
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

          CartItemsIcon(
              basketItemsCountNotifier: this.basketItemsCountNotifier,
              handleClick: (){
                navigateToBasketPage( context, 'Basket', this.useraccount, HomePageStartedEvent(uname: useraccount.uname), this.basketBloc!) ;
              }),
          UserSideMenu(handleClick: handleClick)
        ],
        centerTitle: true,
      ),
      body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              BlocListener<BasketBloc,BasketState>(
                listener: (context,state){
                },
                child: BlocBuilder<BasketBloc,BasketState>(
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
                 children: [
                   Container(
                     height: 570,
                     child:
                     BasketListView(
                       snapshot: snapshot,
                       basketItemsCountNotifier: basketItemsCountNotifier,
                       removeFromBasket: removeFromBasket,
                       useraccountname: useraccount.uname,
                       basketBloc: this.basketBloc!,
                       useraccount: useraccount,
                     )
                   ),

                   ValueListenableBuilder(
                     valueListenable: basketItemsCountNotifier,
                     builder: (BuildContext context, int nitems, Widget? child)  {
                       return nitems==0?Container():
                       BasketCheckoutButton(buttonText: 'Check out',
                       onPressed: () async {
                         navigateToCheckoutPage( context, 'Checkout', this.useraccount, HomePageStartedEvent(uname: useraccount.uname), this.basketBloc!) ;
                       });
                     },
                   ),

                 ],
               );
                },
              ),
            ],
          ),
      ),
    );
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
}
