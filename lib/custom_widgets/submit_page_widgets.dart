
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//////////////////////////////////////////////////////////////////////////////
///////////////////////////// SubmitInputTextField ////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
class SubmitInputTextField extends StatefulWidget {
  SubmitInputTextField({
    Key? key,
    required this.labelText,
    required this.errorText,
    required this.inputTextController,
    this.focusNode,
    this.onSubmitted,
    this.onTap,
    this.suffixIcon,
    this.hintText
  }) : super(key: key);

  String labelText;
  String? errorText;
  FocusNode? focusNode;
  Widget? suffixIcon;
  String? hintText;
  TextEditingController? inputTextController;
  void Function(String)? onSubmitted;
  void Function()? onTap;
  @override
  SubmitInputTextFieldState createState() {
    return SubmitInputTextFieldState();
  }
}
class SubmitInputTextFieldState  extends State<SubmitInputTextField>{
  @override
  Widget build(BuildContext context) {
    return TextField(

      textInputAction: TextInputAction.next,
      controller: widget.inputTextController,
      decoration: InputDecoration(
        suffixIcon: widget.suffixIcon == null? null:widget.suffixIcon,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFC5C9C7), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF4EB65C), width: 1),
        ),
        labelStyle:   TextStyle( color: Color(0xFFCFE0BC)),
        alignLabelWithHint: true,
        //border: OutlineInputBorder(),
        //border: OutlineInputBorder(),
        labelText: widget.labelText,
        errorText: widget.errorText,
        hintText: widget.hintText,
      ),

      onSubmitted: widget.onSubmitted,
      onTap: widget.onTap
    );
  }
}
//////////////////////////////////////////////////////////////////////////////
///////////////////////////// SubmitInputTextField ////////////////////////////////
//////////////////////////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////////////////////
///////////////////////////// SubmitButtonField ////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
class SubmitButtonField extends StatefulWidget {
  SubmitButtonField({
    Key? key,
    required this.buttonText,
    this.onPressed
  }) : super(key: key);

  String buttonText;
  void Function()? onPressed;

  @override
  SubmitButtonFieldState createState() {
    return SubmitButtonFieldState();
  }
}
class SubmitButtonFieldState  extends State<SubmitButtonField>{
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
          child: Text(widget.buttonText),
        ),
      );
  }
}
//////////////////////////////////////////////////////////////////////////////
///////////////////////////// SubmitButtonField //////////////////////////////
//////////////////////////////////////////////////////////////////////////////



