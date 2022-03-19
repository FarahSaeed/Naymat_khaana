
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//////////////////////////////////////////////////////////////////////////////
///////////////////////////// signupInputTextField ////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
class SignupInputTextField extends StatefulWidget {
  SignupInputTextField({
    Key? key,
    required this.labelText,
     this.errorText,
     this.inputTextController,
    this.focusNode

  }) : super(key: key);

  String labelText;
  String? errorText;
  FocusNode? focusNode;
  TextEditingController? inputTextController;
  @override
  SignupInputTextFieldState createState() {
    return SignupInputTextFieldState();
  }
}
class SignupInputTextFieldState  extends State<SignupInputTextField>{
  @override
  Widget build(BuildContext context) {
    return TextField(
      textInputAction: TextInputAction.next,
      controller: widget.inputTextController,
      focusNode: widget.focusNode,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFC5C9C7), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF4EB65C), width: 1),
        ),
        labelStyle:   TextStyle( color: Color(0xFFCFE0BC)),
        labelText: widget.labelText,
        errorText:  widget.errorText,
        floatingLabelBehavior:
        FloatingLabelBehavior.auto,
        //floatingLabelStyle: TextStyle(color: Colors.blue),
      ),
    );
  }
}
//////////////////////////////////////////////////////////////////////////////
///////////////////////////// signupInputTextField ////////////////////////////////
//////////////////////////////////////////////////////////////////////////////




//////////////////////////////////////////////////////////////////////////////
///////////////////////////// SignupButtonField ////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
class SignupButtonField extends StatefulWidget {
  SignupButtonField({
    Key? key,
    required this.buttonText,
    this.onPressed
  }) : super(key: key);

  String buttonText;
  void Function()? onPressed;

  @override
  SignupButtonFieldState createState() {
    return SignupButtonFieldState();
  }
}
class SignupButtonFieldState  extends State<SignupButtonField>{
  @override
  Widget build(BuildContext context) {
    return Container(
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
        onPressed: widget.onPressed,
        child:  Text(widget.buttonText),
      ),
    );


  }
}
//////////////////////////////////////////////////////////////////////////////
///////////////////////////// SignupButtonField //////////////////////////////
//////////////////////////////////////////////////////////////////////////////

