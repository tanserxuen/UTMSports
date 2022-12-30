import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utils {
  static GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

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

  static parseTimestampToFormatDate(timestamp, {format = null}) {
    DateTime newDT = timestamp.toDate();
    DateTime dateOnly = new DateTime(newDT.year, newDT.month, newDT.day);
    if (format != null) return DateFormat(format).format(dateOnly);
    return DateFormat('dd ${DateFormat.MONTH} yyyy').format(dateOnly);
  }

  static parseDateTimeToFormatDate(DateTime dt, {format = null}){
    if (format != null) return DateFormat(format).format(dt);
    return DateFormat('dd ${DateFormat.MONTH} yyyy').format(dt);
  }

  static parseTimestampToDateTime(Timestamp timestamp){
    return timestamp.toDate();
  }

  static getCurrentDateOnly() {
    DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  static getCurrentTimeOnly(String timeString) {
    DateTime now = DateTime.now();
    String dateString = now.toString().split(' ')[0];
    print(DateFormat("HH:mm a").parse("$dateString $timeString"));
    return DateFormat("HH:mm a").parse("$dateString $timeString");
  }
}