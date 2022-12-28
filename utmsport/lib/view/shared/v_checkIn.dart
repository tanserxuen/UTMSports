import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CheckIn extends StatefulWidget {
  const CheckIn({Key? key}) : super(key: key);

  @override
  State<CheckIn> createState() => _CheckInState();
}

class _CheckInState extends State<CheckIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("Check In QR")),);
  }
}
