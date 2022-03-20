
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//////////////////////////////////////////////////////////////////////////////
///////////////////////////// HomePageMenuItem ///////////////////////////////
//////////////////////////////////////////////////////////////////////////////
class HomePageMenuItem extends StatefulWidget {
  HomePageMenuItem({
    Key? key,
    required this.menuItemText,
    required this.onPressed
  }) : super(key: key);

  String menuItemText;
  void Function()? onPressed;
  @override
  HomePageMenuItemState createState() {
    return HomePageMenuItemState();
  }
}
class HomePageMenuItemState  extends State<HomePageMenuItem>{
  @override
  Widget build(BuildContext context) {
    return                               Container(
      //clipBehavior: Clip.hardEdge,
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        //  borderRadius: BorderRadius.circular(15),
      ),
      child: ElevatedButton(

          style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 15),
              primary: Colors.white,
              onPrimary: Colors.green,
              shadowColor: Colors.green
          ),
          onPressed: widget.onPressed,

          child:  Text(widget.menuItemText)
      ),
    );
  }
}
//////////////////////////////////////////////////////////////////////////////
///////////////////////////// HomePageMenuItem ///////////////////////////////
//////////////////////////////////////////////////////////////////////////////
