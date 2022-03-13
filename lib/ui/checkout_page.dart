import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // new
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naymat_khaana/app_classes/food_item.dart';
import 'package:naymat_khaana/app_classes/user_account.dart';
import 'package:naymat_khaana/blocs/checkoutBloc/checkout_bloc.dart';
import 'package:naymat_khaana/blocs/checkoutBloc/checkout_event.dart';
import 'package:naymat_khaana/blocs/checkoutBloc/checkout_state.dart';


import 'home_page.dart';
import 'login_page.dart'; // new
// new
//import 'package:provider/provider.dart';           // new


class CheckoutPageParent extends StatelessWidget {
  String title;
  UserAccount useraccount;
  CheckoutPageParent({required this.title, required this.useraccount});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CheckoutBloc(),
      child: CheckoutPage(title: this.title, useraccount: this.useraccount),
    );
  }
}

// Define a custom Form widget.
class CheckoutPage extends StatefulWidget {
  //User user;
  String title;
  UserAccount useraccount;
  CheckoutPage({required this.title, required this.useraccount});
  @override
  CheckoutPageState createState() {
    return CheckoutPageState(title: this.title, useraccount: this.useraccount);
  }
}

class CheckoutPageState extends State<CheckoutPage>  {
  //User user;
  String title;
  UserAccount useraccount;
  CheckoutPageState({required this.title, required this.useraccount});

  TextEditingController? address1Controller = TextEditingController();
  TextEditingController? address2Controller = TextEditingController();
  TextEditingController? cityController = TextEditingController();
  // state
  TextEditingController? zipcodeController = TextEditingController();
  // country
  TextEditingController? phoneController = TextEditingController();
  TextEditingController? emailController = TextEditingController();

  String? valid_address1 = null;
  String? valid_address2 = null;
  String? valid_city = null;
  String? valid_zipcode = null;
  String? valid_phone = null;
  String? valid_email = null;
  String? stateValue = "null";
  String? countryValue = "us";

  DateTime selectedDate = DateTime.now();
  CheckoutBloc? checkoutBloc;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    checkoutBloc = BlocProvider.of<CheckoutBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(this.title),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              BlocListener<CheckoutBloc,CheckoutState>(
                listener: (context,state){
                  if (state is CheckoutSuccessful){
                    final snackBar = SnackBar(
                      content: const Text('Check out successful!'),
                      // action: SnackBarAction(
                      //   label: 'Undo',
                      //   onPressed: () {
                      //     // Some code to undo the change.
                      //   },
                      // ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);

                    navigateToHomePage(context, this.useraccount);
                    // navigateToHomePage(context, state.useraccount);

                  }
                },
                child: BlocBuilder<CheckoutBloc,CheckoutState>(
                    builder: (context,state) {
                      if (state is CheckoutInitialState){
                        return buildInitialUI();
                      }
                      else if (state is CheckoutLoading) {
                        return buildLoadingUI();
                      }
                      else if (state is CheckoutSuccessful) {
                        return Container();
                      }
                      else if (state is CheckoutFailed) {
                        return buildFailureUI(state.message);
                      }
                      else {return buildInitialUI();}
                    }
                ),
              ),
              Text(
                "",
                textAlign: TextAlign.center,
              ),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              //   child: TextField(
              //     controller: address1Controller,
              //     decoration: InputDecoration(
              //       border: OutlineInputBorder(),
              //       hintText: 'Address Line 1',
              //       errorText: valid_address1,
              //     ),
              //   ),
              // ),


              Container(
                alignment: AlignmentDirectional.center,
                margin: const EdgeInsets.only(top: 5.0, bottom: 6.0, left: 20.0, right: 20.0),
                child: TextField(
                  textInputAction: TextInputAction.next,
                  controller: address1Controller,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFC5C9C7), width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF4EB65C), width: 1),
                    ),
                    labelStyle:   TextStyle( color: Color(0xFFCFE0BC)),
                    alignLabelWithHint: true,
                    //border: OutlineInputBorder(),
                    labelText: 'Address Line 1',
                    errorText: valid_address1,
                  ),
                ),
              ),



              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              //   child: TextField(
              //     controller: address2Controller,
              //     decoration: InputDecoration(
              //       border: OutlineInputBorder(),
              //       hintText: 'Address Line 2',
              //       errorText: valid_address2,
              //     ),
              //   ),
              // ),

              Container(
                alignment: AlignmentDirectional.center,
                margin: const EdgeInsets.only(top: 10.0, bottom: 6.0, left: 20.0, right: 20.0),
                child: TextField(
                  textInputAction: TextInputAction.next,
                  controller: address2Controller,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFC5C9C7), width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF4EB65C), width: 1),
                    ),
                    labelStyle:   TextStyle( color: Color(0xFFCFE0BC)),
                    alignLabelWithHint: true,
                    //border: OutlineInputBorder(),
                    labelText: 'Address Line 2',
                    errorText: valid_address2,
                  ),
                ),
              ),



              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              //   child: TextField(
              //     controller: cityController,
              //     decoration: InputDecoration(
              //       border: OutlineInputBorder(),
              //       hintText: 'City',
              //       errorText: valid_city,
              //     ),
              //   ),
              // ),

              Container(
                alignment: AlignmentDirectional.center,
                margin: const EdgeInsets.only(top: 10.0, bottom: 6.0, left: 20.0, right: 20.0),
                child: TextField(
                  textInputAction: TextInputAction.next,
                  controller: cityController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFC5C9C7), width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF4EB65C), width: 1),
                    ),
                    labelStyle:   TextStyle( color: Color(0xFFCFE0BC)),
                    alignLabelWithHint: true,
                    //border: OutlineInputBorder(),
                    labelText: 'City',
                    errorText: valid_city,
                  ),
                ),
              ),

              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              //   child: TextField(
              //     controller: zipcodeController,
              //     decoration: InputDecoration(
              //       border: OutlineInputBorder(),
              //       hintText: 'Zipcode',
              //       errorText: valid_zipcode,
              //     ),
              //   ),
              // ),


              Container(
                alignment: AlignmentDirectional.center,
                margin: const EdgeInsets.only(top: 10.0, bottom: 6.0, left: 20.0, right: 20.0),
                child: TextField(
                  textInputAction: TextInputAction.next,
                  controller: zipcodeController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFC5C9C7), width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF4EB65C), width: 1),
                    ),
                    labelStyle:   TextStyle( color: Color(0xFFCFE0BC)),
                    alignLabelWithHint: true,
                    //border: OutlineInputBorder(),
                    labelText: 'Zipcode',
                    errorText: valid_zipcode,
                  ),
                ),
              ),

              Container(
                width:100,
                alignment: AlignmentDirectional.topStart,
                padding: const EdgeInsets.only(left: 12, right: 17),
                margin: const EdgeInsets.only(top: 10.0, bottom: 6.0, left: 20.0, right: 20.0),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xFFC5C9C7), // Colors.blue,
                      width: 1,
                    ),
                    //color: Colors.white,
                    borderRadius: BorderRadius.circular(5)),
                child:
                Theme(
                  data: Theme.of(context).copyWith(
                      canvasColor: Colors.greenAccent, // background color for the dropdown items
                      buttonTheme: ButtonTheme.of(context).copyWith(
                        //alignedDropdown: true,  //If false (the default), then the dropdown's menu will be wider than its button.
                      )
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      menuMaxHeight: 300,
                      //isDense: true,
                      hint: Text("State",style: TextStyle(color: Color(0xFF8B8B8B),fontSize: 15),),
                     // hint: Text("State"),
                      //alignment: Alignment.bottomLeft,
                      value: stateValue,
                      //icon: const Icon(Icons.arrow_downward),
                     // elevation: 2,
                     //underline: null,
                     isExpanded: true,
                     style: const TextStyle(color: Colors.black),
                      // underline: Container(
                      //   height: 2,
                      //   color: Colors.green,
                      // ),
                      onChanged: (String? newValue) {
                        setState(() {
                          stateValue = newValue!;
                        });
                      },
                      items: <String>['AL' ,'AK' ,'AZ' ,'AR' ,'CA' ,'CZ' ,'CO' ,'CT' ,'DE' ,'DC' ,'FL' ,'GA' ,'GU' ,'HI' ,'ID' ,'IL' ,'IN' ,'IA' ,'KS' ,'KY' ,'LA' ,'ME' ,'MD' ,'MA' ,'MI' ,'MN' ,'MS' ,'MO' ,'MT' ,'NE' ,'NV' ,'NH' ,'NJ' ,'NM' ,'NY' ,'NC' ,'ND' ,'OH' ,'OK' ,'OR' ,'PA' ,'PR' ,'RI' ,'SC' ,'SD' ,'TN' ,'TX' ,'UT' ,'VT' ,'VI' ,'VA' ,'WA' ,'WV' ,'WI' ,'WY' ,'null']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),


          Container(
            width:100,
            alignment: AlignmentDirectional.topStart,
            padding: const EdgeInsets.only(left: 12, right: 17),
            margin: const EdgeInsets.only(top: 10.0, bottom: 6.0, left: 20.0, right: 20.0),
            decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xFFC5C9C7), // Colors.blue,
                  width: 1,
                ),
                //color: Colors.white,
                borderRadius: BorderRadius.circular(5)),
            child:
            Theme(
              data: Theme.of(context).copyWith(
                //canvasColor: Colors.yellowAccent, // background color for the dropdown items
                  buttonTheme: ButtonTheme.of(context).copyWith(
                    //alignedDropdown: true,  //If false (the default), then the dropdown's menu will be wider than its button.
                  )
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                    value: countryValue,
                    //icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    isExpanded: true,
                    hint: Text("Country"),
                    style: const TextStyle(color: Colors.black),
                    // underline: Container(
                    //   height: 2,
                    //   color: Colors.green,
                    // ),
                    onChanged: (String? newValue) {
                      setState(() {
                        countryValue = newValue!;
                      });
                    },
//                items: <String>['Saudi Arabia','UAE', 'Palestine', 'Pakistan', 'Africa', 'China', 'us']
                  items: <String>['us']

                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
              ),
            ),
          ),


              Container(
                alignment: AlignmentDirectional.center,
                margin: const EdgeInsets.only(top: 10.0, bottom: 6.0, left: 20.0, right: 20.0),
                child: TextField(
                  textInputAction: TextInputAction.next,
                  controller: phoneController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFC5C9C7), width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF4EB65C), width: 1),
                    ),
                    labelStyle:   TextStyle( color: Color(0xFFCFE0BC)),
                    alignLabelWithHint: true,
                    //border: OutlineInputBorder(),
                    labelText: 'Phone',
                    errorText: valid_phone,
                  ),
                ),
              ),

              Container(
                alignment: AlignmentDirectional.center,
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
                    labelStyle:   TextStyle( color: Color(0xFFCFE0BC)),
                    alignLabelWithHint: true,
                    //border: OutlineInputBorder(),
                    labelText: 'Email',
                    errorText: valid_email,
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
                  //style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20)),
                  style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20),
                    primary: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  onPressed: ()  {
                    setState(() {

                      valid_address1 = validate_address1(address1Controller!.text);
                      valid_address2 = validate_address2(address2Controller!.text);
                      valid_city = validate_city(cityController!.text);
                      valid_zipcode = validate_zipcode(zipcodeController!.text);
                      valid_phone = validate_phone(phoneController!.text);
                      valid_email = validate_email(phoneController!.text);

                      if (valid_address1 == null && valid_address2 == null && valid_city == null && valid_zipcode == null && valid_phone == null && valid_email == null){
                        String addressvalue = address1Controller!.text + "::"+address2Controller!.text + "::"+cityController!.text + "::"+stateValue! + "::"+zipcodeController!.text + "::"+countryValue! + "::"+phoneController!.text + "::"+emailController!.text;
                        checkoutBloc!.add(CheckoutButtonPressedEvent(address: addressvalue, uname: (this.useraccount.uname) ));
                      }
                    });},
                  child: const Text('Submit'),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  String? validate_address1(String value) {
    value = value == null? '':value;
    if (value == '') {return 'Value Can\'t Be Empty'; }
    else {  return null;}
  }

  String? validate_address2(String value) {
    value = value == null? '':value;
    if (value == '') {return 'Value Can\'t Be Empty'; }
    else {  return null;}
  }

  String? validate_city(String value) {
    value = value == null? '':value;
    if (value == '') {return 'Value Can\'t Be Empty'; }
    else {  return null;}
  }

  String? validate_zipcode(String value) {
    value = value == null? '':value;
    if (value == '') {return 'Value Can\'t Be Empty'; }
    else {  return null;}
  }

  String? validate_phone(String value) {
    value = value == null? '':value;
    if (value == '') {return 'Value Can\'t Be Empty'; }
    else {  return null;}
  }

  String? validate_email(String value) {
    value = value == null? '':value;
    if (value == '') {return 'Value Can\'t Be Empty'; }
    else {  return null;}
  }

  Widget buildInitialUI(){
    return Container(); //Text('Waiting for Submission');
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

}
