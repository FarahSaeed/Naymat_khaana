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