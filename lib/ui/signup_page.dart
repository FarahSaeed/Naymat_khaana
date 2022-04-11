import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naymat_khaana/blocs/regBloc/user_reg_bloc.dart';
import 'package:naymat_khaana/blocs/regBloc/user_reg_event.dart';
import 'package:naymat_khaana/blocs/regBloc/user_reg_state.dart';
import 'package:naymat_khaana/custom_widgets/signup_page_widgets.dart';
import 'package:naymat_khaana/utils/navigation.dart';
import 'package:naymat_khaana/utils/util_widgets.dart';
import 'package:naymat_khaana/utils/validation.dart';

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
  String title;

  SignupPageState({required this.title});
  TextEditingController? fnameController = TextEditingController();
  TextEditingController? lnameController = TextEditingController();
  TextEditingController? dobController = TextEditingController();
  TextEditingController? emailController = TextEditingController();
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
  String? valid_pass = null;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    userRegBloc = BlocProvider.of<UserRegBloc>(context);

    return Scaffold(

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(

            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              BlocListener<UserRegBloc,UserRegState>(
                listener: (context,state){
                  if (state is UserRegSuccessful){
                  navigateToHomePage(context, state.useraccount, "Home");
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
                child: SignupInputTextField(
                  labelText: 'First name',
                  errorText:  valid_fname,
                  inputTextController: fnameController!
                )
              ),
              Container(
                margin: const EdgeInsets.only(top: 10.0, bottom: 6.0, left: 20.0, right: 20.0),
                child: SignupInputTextField(
                  labelText: 'Last name',
                  errorText:  valid_lname,
                  inputTextController: lnameController!
              ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10.0, bottom: 6.0, left: 20.0, right: 20.0),
                child: SignupInputTextField(
                    labelText: 'Date of birth',
                    errorText:  valid_dob,
                    inputTextController: dobController!,
                    focusNode: _focusNode,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10.0, bottom: 6.0, left: 20.0, right: 20.0),
                child:
                SignupInputTextField(
                    labelText: 'Email',
                    errorText:  valid_email,
                    inputTextController: emailController!
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 20.0, right: 20.0),
                child:
                SignupInputTextField(
                    labelText: 'Password',
                    errorText:  valid_pass,
                    inputTextController: passwordController!
                ),
              ),
              SignupButtonField(
                buttonText: 'Sign up',
                onPressed: () async {
                        setState(() {
                          valid_fname = validate_fname(fnameController!.text);
                          valid_lname = validate_lname(lnameController!.text);
                          valid_dob = validate_dob(dobController!.text);
                          valid_email = validate_email(emailController!.text);
                          valid_pass = validate_password(passwordController!.text);

                          if (valid_fname == null && valid_lname == null && valid_dob == null && valid_email == null  && valid_pass == null ){
                            userRegBloc!.add(SignupButtonPressedEvent(fname: fnameController!.text, lname: lnameController!.text, dob: dobController!.text, email: emailController!.text, uname: 'na', password: passwordController!.text));
                          }
                        });
                        },
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
            ],
          ),
        ),
      ),
    );

  }

}
