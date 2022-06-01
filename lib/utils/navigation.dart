import 'package:flutter/material.dart';
import 'package:naymat_khaana/app_classes/food_item.dart';
import 'package:naymat_khaana/app_classes/user_account.dart';
import 'package:naymat_khaana/blocs/basketBloc/basket_bloc.dart';
import 'package:naymat_khaana/blocs/basketBloc/basket_event.dart';
import 'package:naymat_khaana/ui/basket_page.dart';
import 'package:naymat_khaana/ui/checkout_page.dart';
import 'package:naymat_khaana/ui/explore_food_items_page.dart';
import 'package:naymat_khaana/ui/food_item_desc_page.dart';
import 'package:naymat_khaana/ui/home_page.dart';
import 'package:naymat_khaana/ui/signup_page.dart';
import 'package:naymat_khaana/ui/login_page.dart';
import 'package:naymat_khaana/ui/submit_food_item_page.dart';

void navigateToHomePage(BuildContext context, UserAccount useraccount, String title){
  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>
      HomePageParent(title: title, useraccount: useraccount)), (Route<dynamic> route) => false);
}

void navigateToSignupPage(BuildContext context, String title){
  Navigator.of(context).push(MaterialPageRoute(builder:
      (context){ return SignupPageParent(title: title);}));
}

void navigateToLoginPage(BuildContext context){
  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>
      LoginPageParent(title: 'Login')), (Route<dynamic> route) => false);
}


void navigateToSubmitFoodItemPage(BuildContext context, String title, UserAccount userAccount, HomePageStartedEvent homePageStartedEvent, BasketBloc basketBloc) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return SubmitFoodItemPageParent(title: title, useraccount: userAccount);
  })).then(
          (context) {
        basketBloc.add(HomePageStartedEvent(uname: userAccount.uname));
      });
}


void navigateToExploreFoodItemsPage(BuildContext context, String title, UserAccount userAccount, HomePageStartedEvent homePageStartedEvent, BasketBloc basketBloc) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return ExploreFoodItemsPageParent(title: title, useraccount: userAccount);
  })).then(
          (context) {
        basketBloc.add(HomePageStartedEvent(uname: userAccount.uname));
      });
}

void navigateToCheckoutPage(BuildContext context, String title, UserAccount userAccount, HomePageStartedEvent homePageStartedEvent, BasketBloc basketBloc) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return CheckoutPageParent(title: title, useraccount: userAccount);
  })).then(
          (context) {
        basketBloc.add(HomePageStartedEvent(uname: userAccount.uname));
      });
}

void navigateToBasketPage(BuildContext context, String title, UserAccount userAccount, HomePageStartedEvent homePageStartedEvent, BasketBloc basketBloc) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return BasketPageParent(title: title, useraccount: userAccount);
  })).then(
          (context) {
        basketBloc.add(HomePageStartedEvent(uname: userAccount.uname));
      });
}

// void navigateToFoodItemPage(BuildContext context, FoodItem foodItem) {
//   Navigator.push(context, MaterialPageRoute(builder: (context) {
//     return FoodItemsDescPageParent(title: 'Detail', foodItem: foodItem);
//   }));
// }

void navigateToFoodItemPage(BuildContext context, FoodItem foodItem, BasketBloc basketBloc, String useraccountname) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return FoodItemsDescPageParent(title: 'Detail', foodItem: foodItem);
  })).then(
          (context) {
        basketBloc.add(HomePageStartedEvent(uname: useraccountname));
      });
}