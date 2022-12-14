import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:naymat_khaana/blocs/loginBloc/login_bloc.dart';
import 'package:naymat_khaana/blocs/loginBloc/login_event.dart';
import 'package:naymat_khaana/blocs/loginBloc/login_state.dart';
import 'package:naymat_khaana/custom_widgets/login_page_widgets.dart';
import 'package:naymat_khaana/repositories/user_repository.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naymat_khaana/utils/navigation.dart';
import 'package:naymat_khaana/utils/util_widgets.dart';
import 'package:naymat_khaana/utils/validation.dart';

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
    loginBloc = BlocProvider.of<LoginBloc>(context);
    loginBloc!.add(InitialGoogleSignOutEvent());
  super.initState();
  }


  @override
  Widget build(BuildContext context) {
    GoogleSignInAccount? user = _currentUser;
    // TODO: implement build
    return Scaffold(

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
                  ElevatedButton(onPressed: (){
                    loginBloc!.add(InitialGoogleSignOutEvent());

                  }, child: Text('Sign out'))
                ],
              ):Container(),
              Column (
                crossAxisAlignment: CrossAxisAlignment.stretch,
          children:[

              Container(
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

                child: Text(
                  "Naymat Khaana",
                  textAlign: TextAlign.center,
                    style: GoogleFonts.kalam(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold, ),
                ),
              ),
              BlocListener<LoginBloc,LoginState>(
                listener: (context,state){
                  if (state is LoginSuccessful){
                    navigateToHomePage(context, state.useraccount, "Home");
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
                      else if (state is InitialGoogleLogoutSuccessful) {
                        return Container();
                      }
                      else if (state is InitialGoogleLogoutFailed) {
                        return buildFailureUI(state.message);
                      }
                      else {return buildInitialUI();}
                    }
                ),
              ),
            Container(
              margin: const EdgeInsets.only(top: 80.0),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: LoginInputTextField(
                controller: emailController,
                hintText: "Email",
                errorText: valid_email,
                isPassword: false,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10.0),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child:
              LoginInputTextField(
                controller: passwordController,
                hintText: "Password",
                errorText: valid_pass,
                isPassword: true,
              ),
            ),
            LoginButton(
              buttonText: "Login",
              onPressed: () async {
                setState(() {
                  valid_email = validate_email(emailController!.text);
                  valid_pass = validate_password(passwordController!.text);
                  if (valid_email == null  && valid_pass == null ){
                    loginBloc!.add(LoginButtonPressedEvent(email: emailController!.text.trim(), password: passwordController!.text));
                  }
                });
              },
            ),
            LoginTextButton(
              buttonText: "Sign up",
              onPressed: () {navigateToSignupPage(context, "Sign up"); },
            ),
            LoginGoogleTextButton(
              buttonText: "Sign in through google",
              googleEmailController: googleemailController!,
                onCancelPressed: () {Navigator.pop(context);},
                onOKPressed: () async {
                bool userexists = await userRepository!.UserExist(googleemailController!.text);
                if (userexists == true)
                  loginBloc!.add(LoginGoogleSignInEvent(email: googleemailController!.text.trim()));
                else
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('problem while logging in')));
              Navigator.pop(context);
            },
            )
          ],),
            ],
          ),
      ),
    );
  }

}
