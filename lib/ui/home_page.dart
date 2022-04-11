import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        ),
        BlocProvider<HomePageBloc>(
          create: (context) => HomePageBloc(),
        ),
      ], child: HomePage(title: this.title, useraccount: this.useraccount),
    );
  }
}

class HomePage extends StatelessWidget {
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
    // TODO: implement build
    int count =2 ;
    return Scaffold(

      resizeToAvoidBottomInset: true,

      appBar: AppBar(
        title: Text("Welcome "+this.useraccount.fname,),
        actions: <Widget>[
          CartItemsIcon(
              basketItemsCountNotifier: this.basketItemsCountNotifier,
              handleClick: (){
                navigateToBasketPage( context, 'Basket', this.useraccount, HomePageStartedEvent(uname: useraccount.uname), this.basketBloc!) ;
              }),
          UserSideMenu(handleClick: handleClick),
        ],
      ),
          body: SafeArea(

            child: SingleChildScrollView(
              child: Column(
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
                    height: 600,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          color:Colors.green,
                          height: 200,
                        ),
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
                              HomePageMenuItem(
                                  menuItemText: 'Explore Food Items',
                                  onPressed:  ()  async {
                                    navigateToExploreFoodItemsPage( context, 'Explore', this.useraccount, HomePageStartedEvent(uname: useraccount.uname), this.basketBloc!) ;
                                  }
                              ),
                              HomePageMenuItem(
                                  menuItemText: 'My basket',
                                  onPressed:  ()  async {
                                    navigateToBasketPage( context, 'Basket', this.useraccount, HomePageStartedEvent(uname: useraccount.uname), this.basketBloc!) ;
                                  }
                              ),
                          ]),
                        ),
                      ],
                    ),

                  ),
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

}
