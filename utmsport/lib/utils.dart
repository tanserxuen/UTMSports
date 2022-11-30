import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utils {
  static GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static showSnackBar(String? text) {
    if (text == null) return;

    final snackBar = SnackBar(content: Text("You have successfully $text!"));

    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static parsetoStringDateOnly(timestamp, {format = null}) {
    DateTime newDT = timestamp.toDate();
    DateTime dateOnly = new DateTime(newDT.year, newDT.month, newDT.day);
    if (format != null) return DateFormat(format).format(dateOnly);
    return DateFormat('dd ${DateFormat.MONTH} yyyy').format(dateOnly);
  }
}
