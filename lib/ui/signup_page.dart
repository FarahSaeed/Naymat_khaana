import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // new
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naymat_khaana/app_classes/user_account.dart';
import 'package:naymat_khaana/blocs/regBloc/user_reg_bloc.dart';
import 'package:naymat_khaana/blocs/regBloc/user_reg_event.dart';
import 'package:naymat_khaana/blocs/regBloc/user_reg_state.dart';

import 'home_page.dart';
import 'login_page.dart'; // new
// new
//import 'package:provider/provider.dart';           // new


class SignupPageParent extends StatelessWidget {
  String title;
  SignupPageParent({required this.title});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserRegBloc(),
      child: SignupPage(title: this.title),
    );
  }
}


// Define a custom Form widget.
class SignupPage extends StatefulWidget {
  //User user;
  String title;
  SignupPage({required this.title});
  @override
  SignupPageState createState() {
    return SignupPageState(title: this.title);
  }
}


class SignupPageState extends State<SignupPage> {
  //User user;
  String title;

  SignupPageState({required this.title});
  TextEditingController? fnameController = TextEditingController();
  TextEditingController? lnameController = TextEditingController();
  TextEditingController? dobController = TextEditingController();
  TextEditingController? emailController = TextEditingController();
  //TextEditingController? unameController = TextEditingController();
  TextEditingController? passwordController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  UserRegBloc? userRegBloc;
  FocusNode? _focusNode; // focus management dob
  int focus_counter = 0;
  @override
  void dispose() {
    super.dispose();
    _focusNode!.dispose();
  }

  @override
  void initState() {
    super.initState();
    _focusNode = new FocusNode();
    _focusNode!.addListener(_onOnFocusNodeEvent);
  }

  _onOnFocusNodeEvent() async {
    if (_focusNode!.hasFocus){
      focus_counter = focus_counter+1;
        final DateTime? picked = (await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900, 8),
            lastDate: DateTime(2101)));
      dobController!.text = (picked==null)?"":"${picked.toLocal()}".split(' ')[0];
      FocusScope.of(context).nextFocus();
    }
  }

  String? valid_fname = null;
  String? valid_lname = null;
  String? valid_dob = null;
  String? valid_email = null;
  //String? valid_uname = null;
  String? valid_pass = null;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    userRegBloc = BlocProvider.of<UserRegBloc>(context);

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(this.title),
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            //margin: const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),

            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              BlocListener<UserRegBloc,UserRegState>(
                listener: (context,state){
                  if (state is UserRegSuccessful){
                  navigateToHomePage(context, state.useraccount);
                  }
                },
                child: BlocBuilder<UserRegBloc,UserRegState>(
                    builder: (context,state) {
                      if (state is UserRegInitialState){
                        return buildInitialUI();
                      }
                      else if (state is UserRegLoading) {
                        return buildLoadingUI();
                      }
                      else if (state is UserRegSuccessful) {
                        return Container();
                      }
                      else if (state is UserRegFailed) {
                        return buildFailureUI(state.message);
                      }
                      else {return buildInitialUI();}
                    }
                ),
              ),
             // SizedBox(height: 50),
              Container(
                margin: const EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,

                  children: [
                    Text(

                      "Create Account",
                      style: TextStyle(fontSize: 27, color: Colors.green, fontWeight: FontWeight.bold, fontFamily: 'Road Rage'),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Sign up to get started",
                      style: TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.normal, fontFamily: 'Road Rage'),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),

              Container(
                alignment: AlignmentDirectional.center,
                margin: const EdgeInsets.only(top: 30.0, bottom: 6.0, left: 20.0, right: 20.0),
                child: TextField(
                  textInputAction: TextInputAction.next,
                  controller: fnameController,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFC5C9C7), width: 1),
                  ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF4EB65C), width: 1),
                      ),
                      labelStyle:   TextStyle( color: Color(0xFFCFE0BC)),
                    labelText: 'First name',
                    errorText:  valid_fname,

                   floatingLabelBehavior:
                      FloatingLabelBehavior.auto,
                    //floatingLabelStyle: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10.0, bottom: 6.0, left: 20.0, right: 20.0),
                child: TextField(
                  textInputAction: TextInputAction.next,
                  controller: lnameController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFC5C9C7), width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF4EB65C), width: 1),
                    ),
                    labelStyle: TextStyle( color: Color(0xFFCFE0BC)),
                   // border: OutlineInputBorder(),
                    labelText: 'Last name',
                    errorText: valid_lname,
                  ),
                 // textInputAction: TextInputAction.next,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10.0, bottom: 6.0, left: 20.0, right: 20.0),
                child: TextField(
                  textInputAction: TextInputAction.next,

                  controller: dobController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFC5C9C7), width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF4EB65C), width: 1),
                    ),
                    labelStyle: TextStyle( color: Color(0xFFCFE0BC)),
                    labelText: 'Date of birth',
                    errorText: valid_dob,
                  ),
                focusNode: _focusNode,

                // onTap: () async {
                //     final DateTime picked = (await showDatePicker(
                //     context: context,
                //     initialDate: selectedDate,
                //     firstDate: DateTime(1900, 8),
                //     lastDate: DateTime(2101)))!;
                //     dobController!.text = "${picked.toLocal()}".split(' ')[0];
                //     FocusScope.of(context).nextFocus();
                // },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10.0, bottom: 6.0, left: 20.0, right: 20.0),
                child: TextField(
                  textInputAction: TextInputAction.next,
                  controller: emailController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFC5C9C7), width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF4EB65C), width: 1),
                    ),
                    labelStyle: TextStyle( color: Color(0xFFCFE0BC)),                    labelText: 'Email',
                    errorText: valid_email,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 20.0, right: 20.0),
                child: TextField(
                  textInputAction: TextInputAction.next,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  controller: passwordController,
                  decoration: InputDecoration(                    enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFC5C9C7), width: 1),
                  ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF4EB65C), width: 1),
                    ),
                    labelStyle: TextStyle( color: Color(0xFFCFE0BC)),
                    labelText: 'Password',
                    errorText: valid_pass,
                  ),
                ),
              ),
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

                  onPressed: () async {
                    setState(() {
                      valid_fname = validate_fname(fnameController!.text);
                      valid_lname = validate_lname(lnameController!.text);
                      valid_dob = validate_dob(dobController!.text);
                      valid_email = validate_email(emailController!.text);
                      //valid_uname = validate_uname(unameController!.text);
                      valid_pass = validate_pass(passwordController!.text);

                      if (valid_fname == null && valid_lname == null && valid_dob == null && valid_email == null  && valid_pass == null ){
                        userRegBloc!.add(SignupButtonPressedEvent(fname: fnameController!.text, lname: lnameController!.text, dob: dobController!.text, email: emailController!.text, uname: 'na', password: passwordController!.text));
                      }
                    });
                    },
                  // onPressed: () async {
                  //   userRegBloc!.add(SignupButtonPressedEvent(fname: fnameController!.text, lname: lnameController!.text, dob: dobController!.text, email: emailController!.text, uname: unameController!.text, password: passwordController!.text));
                  // },
                  child: const Text('Sign up'),
                ),
              ),
              Container(
                alignment: AlignmentDirectional.center,
                margin: const EdgeInsets.only(top: 20.0, bottom: 10.0, left: 20.0, right: 20.0),

                child: TextButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.green),
                  ),
                  onPressed: () {navigateToLoginPage(context); },
                  child: Text('Already have an account? Login'),
                ),
              ),
              // ElevatedButton(
              //   style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20)),
              //   onPressed: ()  {navigateToLoginPage(context);},
              //   child: const Text('Login noww'),),
            ],
          ),
        ),
      ),
    );

  }

  String? validate_fname(String value) {
    value = value == null? '':value;
    bool valid = RegExp(r"^[a-zA-Z*]+").hasMatch(value);
    if (value == '') {return 'Value Can\'t Be Empty'; }
    else if (valid == false ) { return 'Invalid value';}
    else {  return null;}
  }

  String? validate_lname(String value) {
    value = value == null? '':value;
    bool valid = RegExp(r"^[a-zA-Z*]+").hasMatch(value);
    if (value == '') {return 'Value Can\'t Be Empty'; }
    else if (valid == false ) { return 'Invalid value';}
    else {  return null;}
  }

  String? validate_dob(String value) {
    value = value == null? '':value;
    if (value == '') {return 'Value Can\'t Be Empty'; }
    else {  return null;}
  }


  String? validate_email(String value) {
      value = value == null? '':value;
      bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
      if (value == '') {return 'Value Can\'t Be Empty'; }
      else if (emailValid == false ) { return 'Invalid email address';}
      else {  return null;}
  }

  // String? validate_uname(String value) {
  //   value = value == null? '':value;
  //   bool valid = RegExp(r"^[a-zA-Z*]+").hasMatch(value);
  //   if (value == '') {return 'Value Can\'t Be Empty'; }
  //   else if (valid == false ) { return 'Invalid value';}
  //   else {  return null;}
  // }

  String? validate_pass(String value) {
    value = value == null? '':value;
    if (value == '') {return 'Value Can\'t Be Empty'; }
    else {  return null;}
  }

  Widget buildInitialUI(){
    return Container(); //Text('Waiting for User registration');
  }
  Widget buildLoadingUI(){
    return Center(
      child: CircularProgressIndicator(),
    );
  }
  Widget buildFailureUI(String message){
    return Text(
        message,
        style: TextStyle(
          color: Colors.red,
        )
    );
  }

  void navigateToHomePage(BuildContext context, UserAccount useraccount){
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>
        HomePageParent(title: 'Home', useraccount: useraccount)), (Route<dynamic> route) => false);
  }

  void navigateToLoginPage(BuildContext context){
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>
        LoginPageParent(title: 'Login')), (Route<dynamic> route) => false);
  }
}
