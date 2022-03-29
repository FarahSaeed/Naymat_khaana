

import 'package:flutter/material.dart';
import 'package:naymat_khaana/app_classes/user_account.dart';
import 'package:naymat_khaana/ui/home_page.dart';
import 'package:naymat_khaana/ui/signup_page.dart';

void navigateToHomePage(BuildContext context, UserAccount useraccount, String title){
  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>
      HomePageParent(title: title, useraccount: useraccount)), (Route<dynamic> route) => false);
}

void navigateToSignupPage(BuildContext context, String title){
  Navigator.of(context).push(MaterialPageRoute(builder:
      (context){ return SignupPageParent(title: title);}));
}