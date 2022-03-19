
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//////////////////////////////////////////////////////////////////////////////
///////////////////////////// SubmitInputTextField ////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
class SubmitInputTextField extends StatefulWidget {
  SubmitInputTextField({
    Key? key,
    required this.labelText,
    this.errorText,
    this.inputTextController,
    this.focusNode,
    this.onSubmitted
  }) : super(key: key);

  String labelText;
  String? errorText;
  FocusNode? focusNode;
  TextEditingController? inputTextController;
  void Function(String)? onSubmitted;
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
      ),
      onSubmitted: widget.onSubmitted,
    );
  }
}
//////////////////////////////////////////////////////////////////////////////
///////////////////////////// SubmitInputTextField ////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
