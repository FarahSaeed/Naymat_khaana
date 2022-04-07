import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // new
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naymat_khaana/app_classes/user_account.dart';
import 'package:naymat_khaana/blocs/basketBloc/basket_bloc.dart';
import 'package:naymat_khaana/blocs/basketBloc/basket_event.dart';
import 'package:naymat_khaana/blocs/basketBloc/basket_state.dart';
import 'package:naymat_khaana/blocs/homePageBloc/home_page_bloc.dart';
import 'package:naymat_khaana/blocs/homePageBloc/home_page_event.dart';
import 'package:naymat_khaana/blocs/homePageBloc/home_page_state.dart';
import 'package:naymat_khaana/custom_widgets/home_page_widgets.dart';
import 'package:naymat_khaana/repositories/user_repository.dart';
import 'package:naymat_khaana/utils/navigation.dart';
import 'package:naymat_khaana/utils/util_widgets.dart';

import 'basket_page.dart';
import 'checkout_page.dart';
import 'explore_food_items_page.dart';
import 'login_page.dart'; // new
        // new
//import 'package:provider/provider.dart';           // new


class HomePageParent extends StatelessWidget {
  String title;
  UserAccount useraccount;
  HomePageParent({required this.title, required this.useraccount});

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
      ], child: HomePage(title: this.title, useraccount: this.useraccount),
      // child:       BlocProvider<BasketBloc>(
      // create: (context) => BasketBloc(),
      // child: BasketPage(title: this.title, useraccount: this.useraccount),
      // );
    );
    // return BlocProvider(
    //   create: (context) => HomePageBloc(),
    //   child: HomePage(title: this.title, useraccount: this.useraccount),
    // );
  }
}

class HomePage extends StatelessWidget {
  //User user;
  String title;
  UserAccount useraccount;
  HomePageBloc? homePageBloc;
  BasketBloc? basketBloc;
  UserRepository? userRepository;
  ValueNotifier<int> basketItemsCountNotifier =ValueNotifier(0);
  HomePage({required this.title, required this.useraccount});

  @override
  Widget build(BuildContext context) {

    basketBloc = BlocProvider.of<BasketBloc>(context);
    homePageBloc = BlocProvider.of<HomePageBloc>(context);

    basketBloc!.add(HomePageStartedEvent(uname: useraccount.uname));
    //final ButtonStyle style =
    //ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
    // TODO: implement build
    int count =2 ;
    return Scaffold(

      resizeToAvoidBottomInset: true,

      appBar: AppBar(
        title: Text("Welcome "+this.useraccount.fname,),
        actions: <Widget>[
          //IconButton(icon: Icon(Icons.shopping_cart), onPressed: () {}),
          Stack(
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.shopping_cart_sharp,
                  color: Colors.white,
                ),
                onPressed: (){
                  navigateToBasketPage( context, 'Basket', this.useraccount, HomePageStartedEvent(uname: useraccount.uname), this.basketBloc!) ;
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

          UserSideMenu(handleClick: handleClick),
          // PopupMenuButton<String>(
          //   onSelected: handleClick,
          //   itemBuilder: (BuildContext context) {
          //     return {'Logout', 'Settings'}.map((String choice) {
          //       return PopupMenuItem<String>(
          //         value: choice,
          //         child: Text(choice),
          //       );
          //     }).toList();
          //   },
          // ),
        ],
      ),

      // appBar: AppBar(
        // title: Text(this.title),
        // ),
          body: SafeArea(

            child: SingleChildScrollView(
              child: Column(

              // child: Wrap(
                // spacing: 8.0, // gap between adjacent chips
                // runSpacing: 4.0, // gap between lines
                // direction: Axis.horizontal, // main axis (rows or columns)
                //crossAxisCount: count,
                //mainAxisSize: MainAxisSize.max,
               crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[

                  BlocListener<HomePageBloc, HomePageState>(
                    listener: (context, state) {
                      if (state is LogoutSuccessful) {
                        navigateToLoginPage(context);
                      }
                    },
                    child: BlocBuilder<HomePageBloc, HomePageState>(
                      builder: (context, state) {
                        if (state is LogoutInitialState) {
                          return SizedBox.shrink();
                        } //else if (state is UserRegLoading) {
                        //return buildLoadingUi();
                        //} //else if (state is UserRegFailed) {
                        //return buildFailureUi(state.message);
                        //}
                        else if (state is LogoutSuccessful) {

                          return SizedBox.shrink();}
                        else {
                          return SizedBox.shrink();
                        }
                      },
                    ),
                  ),

                  BlocListener<BasketBloc, BasketState>(
                    listener: (context, state) {
                      if (state is BasketCountLoaded) {
                        basketItemsCountNotifier.value = state.count;
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

                  Container(
                    //color:Colors.green,
                    //margin: EdgeInsets.symmetric(horizontal: 4, vertical: 200),
                   // margin: const EdgeInsets.only(top: 200.0),
                    height: 600,
                  //  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 0),

                    // padding: EdgeInsets.all(50),
                    // alignment: Alignment.center,
                    child: Stack(
                      clipBehavior: Clip.none,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          color:Colors.green,
                          height: 200,
                      //    margin: const EdgeInsets.only(top: 250.0, left:15),

                         // padding: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                        ),
                        /// welcome home text
                        // Container(
                        //      margin: const EdgeInsets.only(top: 50.0, left:100),
                        // child: Text(
                        //     "Home", //"Welcome "+this.useraccount.fname,
                        //     textAlign: TextAlign.center,
                        //     // kalam sriracha italianno
                        //     // style: TextStyle(fontSize: 20, color: Colors.green, fontWeight: FontWeight.bold, fontFamily: 'Road Rage')
                        //     style: GoogleFonts.kalam(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold, ),
                        //   ),
                        // ),

                        ///// search bar
                        // Container(
                        //   margin: const EdgeInsets.only(top: 150.0),
                        //   child: TextField(
                        //   //  "Welcome "+this.useraccount.uname,
                        //
                        //     textAlign: TextAlign.center,
                        //     decoration: InputDecoration( //0xFF47A54B FF449E48 0xFF3E8E42
                        //       suffixIcon: Icon(Icons.search),
                        //       fillColor:  Colors.white24,//Color(0xFF3F9243), //Color(0xFF47A54B),//Colors.green,//Color(0xFF16B617), //Color(0xFF16B617), //0xFFC8ECC9
                        //       filled:true,
                        //       border: OutlineInputBorder(
                        //         borderRadius: BorderRadius.circular(29),
                        //
                        //       ),
                        //       enabledBorder: UnderlineInputBorder(
                        //         borderSide: BorderSide(color: Color(0xFF5ABF63), width: 3),
                        //       ),
                        //       focusedBorder: UnderlineInputBorder(//0xFF52C45B
                        //         borderSide: BorderSide(color: Colors.white, width: 3),
                        //       ),
                        //       hintText: 'Search Food items',
                        //     ),
                        //     // kalam sriracha italianno
                        //     // style: TextStyle(fontSize: 20, color: Colors.green, fontWeight: FontWeight.bold, fontFamily: 'Road Rage')
                        //     //style: GoogleFonts.kalam(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold, ),
                        //   ),
                        // ),
                        Container(
                          margin: const EdgeInsets.only(top: 150.0, left:20),
                          child: Wrap(
                            runSpacing: 10,
                            spacing: 10,
                            children: [
                              HomePageMenuItem(
                                  menuItemText: 'Submit a Food Item',
                                  onPressed:  ()  async {
                                    navigateToSubmitFoodItemPage( context, 'Submit a food item', this.useraccount, HomePageStartedEvent(uname: useraccount.uname), this.basketBloc!) ;
                                  }
                                  ),
                            //   Container(
                            //   //clipBehavior: Clip.hardEdge,
                            //   height: 100,
                            //   width: 100,
                            //   decoration: BoxDecoration(
                            //     //  borderRadius: BorderRadius.circular(15),
                            //   ),
                            //   child: ElevatedButton(
                            //
                            //       style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 15),
                            //           primary: Colors.white,
                            //         onPrimary: Colors.green,
                            //         shadowColor: Colors.green
                            //       ),
                            //       onPressed: ()  async { navigateToSubmitFoodItemPage(context);
                            //       },
                            //
                            //       child: const  Text('Submit a Food Item')
                            //   ),
                            // ),
                              HomePageMenuItem(
                                  menuItemText: 'Explore Food Items',
                                  onPressed:  ()  async {
                                    navigateToExploreFoodItemsPage( context, 'Explore', this.useraccount, HomePageStartedEvent(uname: useraccount.uname), this.basketBloc!) ;
                                  }
                              ),
                              // Container(
                              //   height: 100,
                              //   width: 100,
                              //   decoration: BoxDecoration(
                              //     borderRadius: BorderRadius.circular(40),
                              //   ),
                              //   child: ElevatedButton(
                              //     style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 15),
                              //         primary: Colors.white,
                              //         onPrimary: Colors.green,
                              //         shadowColor: Colors.green),
                              //     onPressed: ()  async { navigateToExploreFoodItemsPage(context);
                              //     },
                              //     child: const Text('Explore Food Items'),
                              //   ),
                              // ),
                              HomePageMenuItem(
                                  menuItemText: 'My basket',
                                  onPressed:  ()  async {
                                    navigateToBasketPage( context, 'Basket', this.useraccount, HomePageStartedEvent(uname: useraccount.uname), this.basketBloc!) ;
                                  }
                              ),
                              // Container(
                              //   height: 100,
                              //   width: 100,
                              //   decoration: BoxDecoration(
                              //     borderRadius: BorderRadius.circular(40),
                              //   ),
                              //   child: ElevatedButton(
                              //     style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 15),
                              //         primary: Colors.white,
                              //         onPrimary: Colors.green,
                              //         shadowColor: Colors.green),
                              //     onPressed: ()  async { navigateToBasketPage(context);
                              //     },
                              //     child: const Text('My basket'),
                              //   ),
                              // ),
                          ]),
                        ),

                      ],
                    ),

                  ),
                // Text(
                // "Welcome "+this.useraccount.uname,
                // textAlign: TextAlign.center,
                // ),
              // Container(
              //   margin: const EdgeInsets.only(top: 100.0, left:10.0, right: 10.0),
              //   child: Positioned(
              //     //margin: const EdgeInsets.only(top: -10.0, left:10.0, right: 10.0),
              //     top: -50.0,
              //     child: Wrap(
              //         runSpacing: 10.0,
              //         spacing: 10.0,
              //       // crossAxisAlignment: CrossAxisAlignment.center,
              //       // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //       children: [
              //
              //         Container(
              //           //clipBehavior: Clip.hardEdge,
              //           height: 100,
              //           width: 100,
              //           decoration: BoxDecoration(
              //           //  borderRadius: BorderRadius.circular(15),
              //           ),
              //           child: ElevatedButton(
              //
              //               style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 15)),
              //               onPressed: ()  async { navigateToSubmitFoodItemPage(context);
              //               },
              //               child: const  Text('Submit a Food Item')
              //           ),
              //         ),
              //         Container(
              //           height: 100,
              //           width: 100,
              //           decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(40),
              //           ),
              //           child: ElevatedButton(
              //             style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 15)),
              //             onPressed: ()  async { navigateToExploreFoodItemsPage(context);
              //             },
              //             child: const Text('Explore Food Items'),
              //           ),
              //         ),
              //         Container(
              //           height: 100,
              //           width: 100,
              //           decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(40),
              //           ),
              //           child: ElevatedButton(
              //             style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 15)),
              //             onPressed: ()  async { navigateToBasketPage(context);
              //             },
              //             child: const Text('My basket'),
              //           ),
              //         ),
              //         Container(
              //           height: 100, width: 100,
              //           child: ElevatedButton(
              //             style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 15)),
              //             onPressed: ()  async {
              //               //User user = (await this.userRepository!.getCurrentUser())!;
              //               homePageBloc!.add(LogoutButtonPressedEvent());
              //             },
              //             child: const Text('Log out'),
              //           ),
              //         ),
              //
              //       ]),
              //   ),
              // ),
                ],
              ),
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

  // void navigateToSubmitFoodItemPage(BuildContext context, String title, UserAccount userAccount, HomePageStartedEvent homePageStartedEvent) {
  //   Navigator.push(context, MaterialPageRoute(builder: (context) {
  //     return SubmitFoodItemPageParent(title: "Submit Food Item", useraccount: this.useraccount);
  //   })).then(
  //           (context) {
  //         basketBloc!.add(HomePageStartedEvent(uname: useraccount.uname));
  //       });
  // }

  // void navigateToExploreFoodItemsPage(BuildContext context) {
  //   Navigator.push(context, MaterialPageRoute(builder: (context) {
  //     return ExploreFoodItemsPageParent(title: "Explore Food Items", useraccount: this.useraccount);
  //   })).then(
  //           (context) {
  //         basketBloc!.add(HomePageStartedEvent(uname: useraccount.uname));
  //       });
  // }


  // void navigateToCheckoutPage(BuildContext context) {
  //   Navigator.push(context, MaterialPageRoute(builder: (context) {
  //     return CheckoutPageParent(
  //         title: "Checkout", useraccount: this.useraccount);
  //   })).then(
  //           (context) {
  //         basketBloc!.add(HomePageStartedEvent(uname: useraccount.uname));
  //       });
  // }
  // void navigateToBasketPage(BuildContext context) {
  //   Navigator.push(context, MaterialPageRoute(builder: (context) {
  //     return BasketPageParent(title: "Basket Items", useraccount: this.useraccount);
  //   })).then(
  //           (context) {
  //         basketBloc!.add(HomePageStartedEvent(uname: useraccount.uname));
  //       });
  // }

}
