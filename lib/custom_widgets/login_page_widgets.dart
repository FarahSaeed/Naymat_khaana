import 'package:flutter/material.dart';

//////////////////////////////////////////////////////////////////////////////
///////////////////////////// LoginInputTextField ////////////////////////////
//////////////////////////////////////////////////////////////////////////////
class LoginInputTextField extends StatefulWidget {
   LoginInputTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.errorText,
     required this.isPassword
  }) : super(key: key);

   TextEditingController? controller;
   String? hintText;
   String? errorText;
   bool isPassword;
   bool _isHidden = true;
  @override
  LoginInputTextFieldState createState() {
    return LoginInputTextFieldState();
  }
}

class LoginInputTextFieldState  extends State<LoginInputTextField>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return TextField(
      obscureText: (widget.isPassword)? widget._isHidden?true:false:false,
      enableSuggestions: (widget.isPassword)?false:true,
      autocorrect: (widget.isPassword)?false:true,
      textInputAction: (widget.isPassword)?TextInputAction.done: TextInputAction.next,
      controller: widget.controller,

      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        fillColor:  Color(0xFF3F9243),
        filled:true,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF5ABF63), width: 3),
        ),
        focusedBorder: UnderlineInputBorder(//0xFF52C45B
          borderSide: BorderSide(color: Colors.white, width: 3),
        ),
        hintText: widget.hintText,
        errorText: widget.errorText,
        suffix: (widget.isPassword)?InkWell(
          onTap: _togglePasswordView,
          child: Icon(
            widget._isHidden
                ? Icons.visibility_off
                : Icons.visibility,
            color: Color(0xFF2E6831),
          ),
        ):null,

      ),
    );
  }

  void _togglePasswordView() {
    setState(() {
      widget._isHidden = !widget._isHidden;
    });
  }
}
//////////////////////////////////////////////////////////////////////////////
///////////////////////////// LoginInputTextField ////////////////////////////
//////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
///////////////////////////// LoginMainButton ////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

class LoginButton extends StatefulWidget {
  LoginButton({
    Key? key,
    required this.buttonText,
    this.onPressed
  }) : super(key: key);

  String buttonText;
  void Function()? onPressed;

  @override
  LoginButtonState createState() {
    return LoginButtonState();
  }
}

class LoginButtonState  extends State<LoginButton>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return
      Container(
        height: 50,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.white60, offset: Offset(0, 1), blurRadius: 0.5)
          ],
          borderRadius: BorderRadius.circular(5),
          gradient: LinearGradient(
            stops: [0.1, 0.5, 1.0],
            colors: [
              Colors.white30,
              Colors.white,
              Colors.white30,
            ],
          ),

        ),
        margin: const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              textStyle: const TextStyle(fontSize: 20),
              primary: Colors.transparent,
              shadowColor: Colors.transparent,
              onPrimary: Colors.green
          ),
          onPressed: widget.onPressed,
          child: Text(widget.buttonText),
        ),
      );
  }
}
//////////////////////////////////////////////////////////////////////////////
///////////////////////////// LoginMainButton ////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
///////////////////////////// LoginTextButton ////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
class LoginTextButton extends StatefulWidget {
  LoginTextButton({
    Key? key,
    required this.buttonText,
    this.onPressed
  }) : super(key: key);

  String buttonText;
  void Function()? onPressed;

  @override
  LoginTextButtonState createState() {
    return LoginTextButtonState();
  }
}
class LoginTextButtonState  extends State<LoginTextButton>{
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 1.0),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      child: TextButton(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        ),
        onPressed: widget.onPressed, //() {navigateToSignupPage(context); },
        child: Text(widget.buttonText),
      ),
    );
  }
}
//////////////////////////////////////////////////////////////////////////////
///////////////////////////// LoginTextButton ////////////////////////////////
//////////////////////////////////////////////////////////////////////////////




//////////////////////////////////////////////////////////////////////////////
///////////////////////////// LoginGoogleTextButton ////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
class LoginGoogleTextButton extends StatefulWidget {
  LoginGoogleTextButton({
    Key? key,
    required this.buttonText,
    required this.googleEmailController,
    required this.onOKPressed,
    required this.onCancelPressed,
  }) : super(key: key);

  String buttonText;
  TextEditingController googleEmailController;
  void Function()? onOKPressed;
  void Function()? onCancelPressed;

  @override
  LoginGoogleTextButtonState createState() {
    return LoginGoogleTextButtonState();
  }
}
class LoginGoogleTextButtonState  extends State<LoginGoogleTextButton>{
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 1.0),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      child: TextButton(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        ),
        onPressed: (){
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Gmail address'),
                content: TextField(
                  controller: widget.googleEmailController,
                  decoration: InputDecoration(hintText: "Text Field in Dialog"),
                ),
                actions: <Widget>[
                  ElevatedButton(
                    child: Text('CANCEL'),
                    onPressed: widget.onCancelPressed,
                  ),
                  ElevatedButton(
                    child: Text('OK'),
                    onPressed: widget.onOKPressed,
                  ),
                ],
              );
            },
          );
        },
        child: Text(widget.buttonText),
      ),
    );
  }
}
//////////////////////////////////////////////////////////////////////////////
///////////////////////////// LoginTextButton ////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
