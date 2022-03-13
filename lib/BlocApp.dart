import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naymat_khaana/blocs/authBloc/auth_bloc.dart';
import 'package:naymat_khaana/blocs/authBloc/auth_event.dart';
import 'package:naymat_khaana/blocs/authBloc/auth_state.dart';
import 'package:naymat_khaana/ui/signup_page.dart';
import 'package:naymat_khaana/ui/home_page.dart';
import 'package:naymat_khaana/ui/login_page.dart';

import 'app_classes/user_account.dart';

class BlocApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: BlocProvider(
        create: (context) => AuthBloc()..add(AppStartedEvent()),
        child: App(),
      ),
      // SignupPage(title: 'Signup Page'), //LoginPage(title: 'Login Page'), //HomePage(title: 'Home Page'),
    );
  }
}


class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc,AuthState>(
        builder: (context, state){
          // if (state is AuthIntialState){
          //   return HomePageParent(title: 'Auth_initial_state');
          // }
           if (state is AuthSuccessfulState){
            return HomePageParent(title: 'Auth_successful_state', useraccount: state.useraccount!, );
          }
          else {
            return LoginPageParent(title: 'Login');
          }
          // else {
          //   return SignupPageParent();
          // }
    },
    );
  }

  void navigateToHomePage(BuildContext context, UserAccount userAccount){
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>
        HomePageParent(title: 'Home page', useraccount: userAccount)), (Route<dynamic> route) => false);
  }

}