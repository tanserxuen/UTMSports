import 'package:collection/collection.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:utmsport/globalVariable.dart'as global;
import 'package:utmsport/view/studentBooking/v_createStuBooking.dart';

class StuBookingChooseSports extends StatefulWidget {
  const StuBookingChooseSports({Key? key}) : super(key: key);

  @override
  State<StuBookingChooseSports> createState() => _StuBookingChooseSportsState();
}

class _StuBookingChooseSportsState extends State<StuBookingChooseSports> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Book Court",
                    style:
                        TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                SizedBox(height: 24),
                ..._buildSportsOptionButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

List<Widget> _buildSportsOptionButton(context) {
  List<Widget> buttons = [];
  global.sports.forEachIndexed((index, sport) {
    buttons.add(
      SizedBox(
        width: 200,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateStuBooking(sportsType: sport),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              sport,
              style: TextStyle(fontSize: 22),
            ),
          ),
          // style: ,
        ),
      ),
    );
    if (index != global.sports.length - 1 || index != 0)
      buttons.add(
        SizedBox(height: 18),
      );
  });
  return buttons;
}
