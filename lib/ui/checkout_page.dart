import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naymat_khaana/app_classes/user_account.dart';
import 'package:naymat_khaana/blocs/checkoutBloc/checkout_bloc.dart';
import 'package:naymat_khaana/blocs/checkoutBloc/checkout_event.dart';
import 'package:naymat_khaana/blocs/checkoutBloc/checkout_state.dart';
import 'package:naymat_khaana/custom_widgets/checkout_page_widgets.dart';
import 'package:naymat_khaana/utils/util_widgets.dart';
import 'package:naymat_khaana/utils/validation.dart';
import 'package:naymat_khaana/utils/navigation.dart';

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

class CheckoutPage extends StatefulWidget {
  String title;
  UserAccount useraccount;
  CheckoutPage({required this.title, required this.useraccount});
  @override
  CheckoutPageState createState() {
    return CheckoutPageState(title: this.title, useraccount: this.useraccount);
  }
}

class CheckoutPageState extends State<CheckoutPage>  {
  String title;
  UserAccount useraccount;
  CheckoutPageState({required this.title, required this.useraccount});

  TextEditingController? address1Controller = TextEditingController();
  TextEditingController? address2Controller = TextEditingController();
  TextEditingController? cityController = TextEditingController();
  TextEditingController? zipcodeController = TextEditingController();
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
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);

                    navigateToHomePage(context, this.useraccount,"Home");

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

              Container(
                alignment: AlignmentDirectional.center,
                margin: const EdgeInsets.only(top: 5.0, bottom: 6.0, left: 20.0, right: 20.0),
                child: CheckoutInputTextField
                  (
                  labelText: 'Address Line 1',
                  errorText: valid_address1,
                  inputTextController: address1Controller,
                ),
              ),



              Container(
                alignment: AlignmentDirectional.center,
                margin: const EdgeInsets.only(top: 10.0, bottom: 6.0, left: 20.0, right: 20.0),
                child: CheckoutInputTextField
                  (
                  labelText: 'Address Line 2',
                  errorText: valid_address2,
                  inputTextController: address2Controller,
                ),
              ),

              Container(
                alignment: AlignmentDirectional.center,
                margin: const EdgeInsets.only(top: 10.0, bottom: 6.0, left: 20.0, right: 20.0),
                child: CheckoutInputTextField
                  (
                  labelText: 'City',
                  errorText: valid_city,
                  inputTextController: cityController,
                ),
              ),

              Container(
                alignment: AlignmentDirectional.center,
                margin: const EdgeInsets.only(top: 10.0, bottom: 6.0, left: 20.0, right: 20.0),
                child: CheckoutInputTextField
                  (
                  labelText: 'Zipcode',
                  errorText: valid_zipcode,
                  inputTextController: zipcodeController,
                ),
              ),

              CheckoutDropDownMenu(
                  valueText: stateValue!,
                  hintText: 'State',
                  menuItems: <String>['AL' ,'AK' ,'AZ' ,'AR' ,'CA' ,'CZ' ,'CO' ,'CT' ,'DE' ,'DC' ,'FL' ,'GA' ,'GU' ,'HI' ,'ID' ,'IL' ,'IN' ,'IA' ,'KS' ,'KY' ,'LA' ,'ME' ,'MD' ,'MA' ,'MI' ,'MN' ,'MS' ,'MO' ,'MT' ,'NE' ,'NV' ,'NH' ,'NJ' ,'NM' ,'NY' ,'NC' ,'ND' ,'OH' ,'OK' ,'OR' ,'PA' ,'PR' ,'RI' ,'SC' ,'SD' ,'TN' ,'TX' ,'UT' ,'VT' ,'VI' ,'VA' ,'WA' ,'WV' ,'WI' ,'WY' ,'null'],
                  onChanged: (String? newValue) {
                              setState(() {
                                stateValue = newValue!;
                              });
                            }
              ),

              CheckoutDropDownMenu(
                  valueText: countryValue!,
                  hintText: 'Country',
                  menuItems: <String>['us'],
                  onChanged: (String? newValue) {
                      setState(() {
                        countryValue = newValue!;
                      });
                  }
              ),

              Container(
                alignment: AlignmentDirectional.center,
                margin: const EdgeInsets.only(top: 10.0, bottom: 6.0, left: 20.0, right: 20.0),
                child: CheckoutInputTextField
                  (
                  labelText: 'Phone',
                  errorText: valid_phone,
                  inputTextController: phoneController,
                ),
              ),

              Container(
                alignment: AlignmentDirectional.center,
                margin: const EdgeInsets.only(top: 10.0, bottom: 6.0, left: 20.0, right: 20.0),
                child: CheckoutInputTextField
                  (
                  labelText: 'Email',
                  errorText: valid_email,
                  inputTextController: emailController,
                ),
              ),
              CheckoutButton(
                buttonText: "Submit",
                    onPressed: ()  {
                      setState(() {

                        valid_address1 = validate_address1(address1Controller!.text);
                        valid_address2 = validate_address2(address2Controller!.text);
                        valid_city = validate_city(cityController!.text);
                        valid_zipcode = validate_zipcode(zipcodeController!.text);
                        valid_phone = validate_phone(phoneController!.text);
                        valid_email = validate_email(emailController!.text);

                        if (valid_address1 == null && valid_address2 == null && valid_city == null && valid_zipcode == null && valid_phone == null && valid_email == null){
                          String addressvalue = address1Controller!.text + "::"+address2Controller!.text + "::"+cityController!.text + "::"+stateValue! + "::"+zipcodeController!.text + "::"+countryValue! + "::"+phoneController!.text + "::"+emailController!.text;
                          checkoutBloc!.add(CheckoutButtonPressedEvent(address: addressvalue, uname: (this.useraccount.uname) ));
                        }
                      });},
              ),
            ],
          ),
        ),
      ),
    );
  }

}
