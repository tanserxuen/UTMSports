import 'package:flutter/material.dart';

Widget BottomBar(BuildContext context) {
  const _iconSize = 28.0;
  const _iconColor = Colors.white;

  return (BottomAppBar(
    shape: CircularNotchedRectangle(),
    color: Colors.blue,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        IconButton(
          tooltip: "Home",
          icon: const Icon(Icons.home, size: _iconSize),
          color: _iconColor,
          onPressed: () => {print(0)},
        ),
        IconButton(
          tooltip: "Appointment",
          icon: const Icon(Icons.sports_basketball, size: _iconSize),
          color: _iconColor,
          onPressed: () => {print(1)},
        ),
        SizedBox(
          width: 70,
        ),
        IconButton(
          tooltip: "Requests",
          icon: const Icon(Icons.list, size: _iconSize),
          color: _iconColor,
          onPressed: () => {print(2)},
        ),
        IconButton(
          tooltip: "Profile",
          icon: const Icon(Icons.person, size: _iconSize),
          color: _iconColor,
          onPressed: () => {print(3)},
        ),
      ],
    ),
  ));
}

Widget BookingButton(BuildContext context) {
  return (FloatingActionButton(
    onPressed: () => {print("book")},
    child: Icon(Icons.add, size: 32),
  ));
}

const fabLocation = FloatingActionButtonLocation.centerDocked;