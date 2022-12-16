import 'package:flutter/material.dart';

class Utils{
  static GlobalKey<ScaffoldMessengerState> messengerKey = GlobalKey<ScaffoldMessengerState>();

  static showSnackBar(String? text, String? color) {
    var colorchild ;
    if (text == null) return;
    if (color == "green") colorchild = Colors.green;
    if (color == "red") colorchild = Colors.red;

    final snackBar = SnackBar(content: Text(text), backgroundColor: colorchild );

    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);


  }
}