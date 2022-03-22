import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//////////////////////////////////////////////////////////////////////////////
///////////////////////////// CheckoutInputTextField ////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
class CheckoutInputTextField extends StatefulWidget {
  CheckoutInputTextField({
    Key? key,
    required this.labelText,
    required this.errorText,
    required this.inputTextController,
    this.focusNode,
    this.onTap
  }) : super(key: key);

  String labelText;
  String? errorText;
  FocusNode? focusNode;
  TextEditingController? inputTextController;
  void Function(String)? onSubmitted;
  void Function()? onTap;
  @override
  CheckoutInputTextFieldState createState() {
    return CheckoutInputTextFieldState();
  }
}
class CheckoutInputTextFieldState  extends State<CheckoutInputTextField>{
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
        labelText: widget.labelText, //'Address Line 1',
        errorText: widget.errorText,
      ),
    );
  }
}
//////////////////////////////////////////////////////////////////////////////
///////////////////////////// CheckoutInputTextField ////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
///////////////////////////// CheckoutButton ////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
class CheckoutButton extends StatefulWidget {
  CheckoutButton({
    Key? key,
    required this.buttonText,
    required this.onPressed,

  }) : super(key: key);

  String buttonText;
  void Function()? onPressed;
  @override
  CheckoutButtonState createState() {
    return CheckoutButtonState();
  }
}
class CheckoutButtonState  extends State<CheckoutButton>{
  @override
  Widget build(BuildContext context) {
    return
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
          onPressed: widget.onPressed,
          child: Text(widget.buttonText),
        ),
      );
  }
}
//////////////////////////////////////////////////////////////////////////////
///////////////////////////// CheckoutButton ////////////////////////////////
//////////////////////////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////////////////////
///////////////////////////// CheckoutDropDownMenu ////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
class CheckoutDropDownMenu extends StatefulWidget {
  CheckoutDropDownMenu({
    Key? key,
    required this.valueText,
    required this.hintText,
    required this.menuItems,
    required this.onChanged,
  }) : super(key: key);

  String valueText;
  String hintText;
  List<String> menuItems;
  void Function(String?)? onChanged;
  @override
  CheckoutDropDownMenuState createState() {
    return CheckoutDropDownMenuState();
  }
}
class CheckoutDropDownMenuState  extends State<CheckoutDropDownMenu>{
  @override
  Widget build(BuildContext context) {
    return
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
              hint: Text(widget.hintText,style: TextStyle(color: Color(0xFF8B8B8B),fontSize: 15),),
              // hint: Text("State"),
              //alignment: Alignment.bottomLeft,
              value: widget.valueText,
              //icon: const Icon(Icons.arrow_downward),
              // elevation: 2,
              //underline: null,
              isExpanded: true,
              style: const TextStyle(color: Colors.black),
              // underline: Container(
              //   height: 2,
              //   color: Colors.green,
              // ),
              onChanged: widget.onChanged,
              items: widget.menuItems//<String>['AL' ,'AK' ,'AZ' ,'AR' ,'CA' ,'CZ' ,'CO' ,'CT' ,'DE' ,'DC' ,'FL' ,'GA' ,'GU' ,'HI' ,'ID' ,'IL' ,'IN' ,'IA' ,'KS' ,'KY' ,'LA' ,'ME' ,'MD' ,'MA' ,'MI' ,'MN' ,'MS' ,'MO' ,'MT' ,'NE' ,'NV' ,'NH' ,'NJ' ,'NM' ,'NY' ,'NC' ,'ND' ,'OH' ,'OK' ,'OR' ,'PA' ,'PR' ,'RI' ,'SC' ,'SD' ,'TN' ,'TX' ,'UT' ,'VT' ,'VI' ,'VA' ,'WA' ,'WV' ,'WI' ,'WY' ,'null']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
      );
  }
}
//////////////////////////////////////////////////////////////////////////////
///////////////////////////// CheckoutDropDownMenu ////////////////////////////////
//////////////////////////////////////////////////////////////////////////////


