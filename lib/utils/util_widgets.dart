import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'navigation.dart';

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



//////////////////////////////////////////////////////////////////////////////
///////////////////////////// CartItemsIcon ///////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
class CartItemsIcon extends StatefulWidget {
  CartItemsIcon({
    Key? key,
    required this.basketItemsCountNotifier,
    required this.handleClick
  }) : super(key: key);

  void Function()? handleClick;
  ValueNotifier<int> basketItemsCountNotifier;

  @override
  CartItemsIconState createState() {
    return CartItemsIconState();
  }
}
class CartItemsIconState extends State<CartItemsIcon>{
  @override
  Widget build(BuildContext context) {
    return
      Stack(
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.shopping_cart_sharp,
              color: Colors.white,
            ),
            onPressed: widget.handleClick,
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Stack(
              children: <Widget>[
                GestureDetector(
                  // onTap: (){
                  // } ,
                  child: Container(
                    height: 20.0,
                    width: 20.0,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child:
                    Center(
                      child: ValueListenableBuilder(
                        valueListenable: widget.basketItemsCountNotifier,
                        builder: (BuildContext context, int nitems, Widget? child)  {
                          return Text(nitems.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11.0,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                        //child: Text('Hi')
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
  }
}
//////////////////////////////////////////////////////////////////////////////
///////////////////////////// CartItemsIcon ///////////////////////////////////
//////////////////////////////////////////////////////////////////////////////


