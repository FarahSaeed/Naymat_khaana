import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildLoadingUI(){
  return Center(
    child: LinearProgressIndicator(
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
Widget buildInitialUI(){
  return Container();
}


//////////////////////////////////////////////////////////////////////////////
///////////////////////////// UserSideMenu ///////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
class UserSideMenu extends StatefulWidget {
  UserSideMenu({
    Key? key,
    required this.handleClick
  }) : super(key: key);

  void Function(String)? handleClick;

  @override
  UserSideMenuState createState() {
    return UserSideMenuState();
  }
}
class UserSideMenuState extends State<UserSideMenu>{
  @override
  Widget build(BuildContext context) {
    return
      PopupMenuButton<String>(
      onSelected: widget.handleClick,
      itemBuilder: (BuildContext context) {
        return {'Logout', 'Settings'}.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice),
          );
        }).toList();
      },
    );
  }
}
//////////////////////////////////////////////////////////////////////////////
///////////////////////////// UserSideMenu ///////////////////////////////////
//////////////////////////////////////////////////////////////////////////////


