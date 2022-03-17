
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

  }) : super(key: key);

  String labelText;
  String? errorText;
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
