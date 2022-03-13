import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // new
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:naymat_khaana/app_classes/user_account.dart';
import 'package:naymat_khaana/blocs/loginBloc/login_bloc.dart';
import 'package:naymat_khaana/blocs/loginBloc/login_event.dart';
import 'package:naymat_khaana/blocs/loginBloc/login_state.dart';
import 'package:naymat_khaana/repositories/user_repository.dart';
import 'package:naymat_khaana/ui/signup_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_page.dart'; // new
// new
//import 'package:provider/provider.dart';           // new


class LoginPageParent extends StatelessWidget {
  String title;
  LoginPageParent({required this.title});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: LoginPage(title: this.title),
    );
  }
}

final _googleSignIn = GoogleSignIn(
    scopes: ['email']
);
// Define a custom Form widget.
class LoginPage extends StatefulWidget {
  String title;




  LoginPage({required this.title});

  @override
  LoginPageState createState() {
    return LoginPageState();
  }
}

class LoginPageState  extends State<LoginPage>{
  int _counter = 5;
  LoginBloc? loginBloc;
  TextEditingController? emailController = TextEditingController();
  TextEditingController? googleemailController = TextEditingController();
  TextEditingController? passwordController = TextEditingController();
  String? valid_email = null;
  String? valid_pass = null;
  bool _isHidden = false;
  GoogleSignInAccount? _currentUser;
  UserRepository? userRepository = UserRepository();

  @override
  void initState(){

    _googleSignIn.onCurrentUserChanged.listen((account) {

      setState(() {
        _currentUser = account;
      });

    });
    //_googleSignIn.signInSilently();
signOut();
    super.initState();
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {

    GoogleSignInAccount? user = _currentUser;

    loginBloc = BlocProvider.of<LoginBloc>(context);
    // TODO: implement build
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      //
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.green,
      body: SingleChildScrollView(
          child:

          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              (_currentUser!=null)?
              Column(
                children: [
                  Text('Google user is signed in!'),
                  ElevatedButton(onPressed: signOut, child: Text('Sign out'))
                ],
              ):Container(),
              Column (
                //  mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
          children:[

            /////////////////////////////////////////////////////////////////////////////////////////


            ElevatedButton(onPressed: (){

              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('TextField in Dialog'),
                    content: TextField(
                     controller: googleemailController,
                      decoration: InputDecoration(hintText: "Text Field in Dialog"),
                    ),
                    actions: <Widget>[
                      ElevatedButton(
                        child: Text('CANCEL'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      ElevatedButton(
                        child: Text('OK'),
                        onPressed: () async {
                         // print(_textFieldController.text);
                          bool ue = await userRepository!.UserExist(googleemailController!.text);
                          if (ue == true)
                          {
                            SignIn();
                          }
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                },
              );


            }, child: Text('Sign in through Google')),
              ///////////////////////////////////////////////////////////////////////////////////////

              Container(
                //margin: EdgeInsets.symmetric(horizontal: 4, vertical: 200),
                margin: const EdgeInsets.only(top: 200.0),
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.green.withOpacity(0.7),
                      Colors.green,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),),
                // padding: EdgeInsets.all(50),
                // alignment: Alignment.center,
                child: Text(
                  "Naymat Khaana",
                  textAlign: TextAlign.center,
                    // kalam sriracha italianno
                    // style: TextStyle(fontSize: 20, color: Colors.green, fontWeight: FontWeight.bold, fontFamily: 'Road Rage')
                    style: GoogleFonts.kalam(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold, ),
                ),
              ),
              BlocListener<LoginBloc,LoginState>(
                listener: (context,state){
                  if (state is LoginSuccessful){
                    navigateToHomePage(context, state.useraccount);
                  }
                },
                child: BlocBuilder<LoginBloc,LoginState>(
                    builder: (context,state) {
                      if (state is LoginInitialState){
                        return buildInitialUI();
                      }
                      else if (state is LoginLoading) {
                        return buildLoadingUI();
                      }
                      else if (state is LoginSuccessful) {
                        return Container();
                      }
                      else if (state is LoginFailed) {
                        return buildFailureUI(state.message);
                      }
                      else {return buildInitialUI();}
                    }
                ),
              ),
            Container(
              margin: const EdgeInsets.only(top: 80.0),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: TextField(
                style: TextStyle(color: Colors.white),
                textInputAction: TextInputAction.next,
              controller: emailController,
              decoration: InputDecoration( //0xFF47A54B FF449E48 0xFF3E8E42
                fillColor:  Color(0xFF3F9243), //Color(0xFF47A54B),//Colors.green,//Color(0xFF16B617), //Color(0xFF16B617), //0xFFC8ECC9
                filled:true,
                //border: OutlineInputBorder(),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF5ABF63), width: 3),
                ),
                focusedBorder: UnderlineInputBorder(//0xFF52C45B
                  borderSide: BorderSide(color: Colors.white, width: 3),
                ),
                hintText: 'Email',
                errorText: valid_email,//validate_email(emailController!.text),
              ),

              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10.0),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: TextField(
                style: TextStyle(color: Colors.white),
                textInputAction: TextInputAction.done,
              obscureText: true,

              enableSuggestions: false,
              autocorrect: false,
              controller: passwordController,
              decoration: InputDecoration(
                suffix: InkWell(
                  onTap: _togglePasswordView,
                  child: Icon(
                    _isHidden
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Color(0xFF2E6831),

                  ),
                ),
              //  decoration: InputDecoration( //0xFF47A54B FF449E48 0xFF3E8E42
                  fillColor:  Color(0xFF3F9243), //Color(0xFF47A54B),//Colors.green,//Color(0xFF16B617), //Color(0xFF16B617), //0xFFC8ECC9
                  filled:true,
                  //border: OutlineInputBorder(),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF5ABF63), width: 3),
                  ),
                  focusedBorder: UnderlineInputBorder(//0xFF52C45B
                    borderSide: BorderSide(color: Colors.white, width: 3),
                  ),

                  //border: OutlineInputBorder(),
                hintText: 'Password',
                errorText: valid_pass, //validate_password(passwordController!.text),
              ),
                onSubmitted: (term){
                  login();
                },
              ),
            ),

            Container(
              height: 50,
              decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.white60, offset: Offset(0, 1), blurRadius: 0.5)
              ],
              // boxShadow: [
              //   BoxShadow(
              //       color: Colors.black26, offset: Offset(0, 4), blurRadius: 5.0)
              // ],
              borderRadius: BorderRadius.circular(5),
              gradient: LinearGradient(
               // begin: Alignment.topLeft,
                //end: Alignment.bottomRight,
                stops: [0.1, 0.5, 1.0],
               // stops: [0.1, 0.5, 1.0],
                colors: [
                  Colors.white30,
                 Colors.white,
                  Colors.white30,
                  //Colors.white10,
                 // Colors.white30,
                ],
              ),
              //   color: Colors.deepPurple.shade300,
              //   borderRadius: BorderRadius.circular(20),
              ),
              // decoration: BoxDecoration(
              //   borderRadius:BorderRadius.circular(100),
              // ),
             // crossAxisAlignment: CrossAxisAlignment.stretch
              //alignment: Alignment.centerRight,
              margin: const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),


              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20),
                  primary: Colors.transparent,
                  shadowColor: Colors.transparent,
                  onPrimary: Colors.green
              ),
              //
              onPressed: () async {
                setState(() {
                  valid_email = validate_email(emailController!.text);
                  valid_pass = validate_password(passwordController!.text);
                  if (valid_email == null  && valid_pass == null ){
                    loginBloc!.add(LoginButtonPressedEvent(email: emailController!.text.trim(), password: passwordController!.text));
                  }
                });
              },
              child: const Text('Log in'),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 1.0),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
              child: TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              onPressed: () {navigateToSignupPage(context); },
              child: Text('Sign up'),
              ),
            )
          ],),

            ],
          ),
      ),
    );
  }

  void signOut(){
    _googleSignIn.disconnect();
  }

  Future<void> SignIn() async{
    try{
      await _googleSignIn.signIn();
      setState(() {
        loginBloc!.add(LoginGoogleSignInEvent(email: googleemailController!.text.trim()));
      });

    }
    catch(e){
      print('error signing in due to: $e');
    }
  }

  String? validate_email(String value) {
    _counter++;
    if (_counter >4) {
      value = value == null? '':value;
      bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
    if (value == '') {return 'Value Can\'t Be Empty'; }
    else if (emailValid == false ) { return 'Invalid email address';}
    else {  return null;}
    }
    else {

      return null;
    }
  }
  String? validate_password(String value) {
    _counter++;
    if (_counter >4) {
      value = value == null? '':value;
      if (value == '') {   return 'Value Can\'t Be Empty'; }
      else {return null;}
    }
    else {

      return null;
    }
  }


  Widget buildInitialUI(){
    return Container(); //Text('Waiting for User login');
  }
  Widget buildLoadingUI(){
    return Center(
      // child: CircularProgressIndicator(),
      child:             LinearProgressIndicator(
        // value: controller.value,
        semanticsLabel: 'Linear progress indicator',
      ),
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

  void navigateToSignupPage(BuildContext context){
    Navigator.of(context).push(MaterialPageRoute(builder:
        (context){ return SignupPageParent(title: 'Sign up');}));
  }

  void login() async {
  setState(() {
  valid_email = validate_email(emailController!.text);
  valid_pass = validate_password(passwordController!.text);
  if (valid_email == null  && valid_pass == null ){
  loginBloc!.add(LoginButtonPressedEvent(email: emailController!.text.trim(), password: passwordController!.text));
  }
  });
}
}
