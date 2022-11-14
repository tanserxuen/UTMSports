import 'package:flutter/material.dart';
import 'package:utmsport/admin_post/view/create_post.dart';

import '../../eo_meetingbook/view/vm_MeetingBookForm .dart';

Widget BookingButton(BuildContext context) {
  return (FloatingActionButton(
    tooltip: "Booking",
    onPressed: () => {
      Navigator.pushNamed(context, '/student-booking'),
    },
    child: Icon(Icons.add, size: 32),
  ));
}

const fabLocation = FloatingActionButtonLocation.centerDocked;
const destinations = [
  NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
  NavigationDestination(
      icon: Icon(Icons.sports_basketball), label: 'Bookings'),
  NavigationDestination(icon: Icon(Icons.list), label: 'Requests'),
  NavigationDestination(icon: Icon(Icons.person), label: 'Profile')
];

Widget homeScreen(user, FA) => Padding(
    padding: EdgeInsets.all(32),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Signed In as',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 8),
        Text(user.email!,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 40),
        ElevatedButton.icon(
          onPressed: () => FA.instance.signOut(),
          style: ElevatedButton.styleFrom(
            minimumSize: Size.fromHeight(50),
          ),
          icon: Icon(Icons.arrow_back, size: 32),
          label: Text(
            'Sign Out',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ],
    ));

navScreen(user, FA) => <Widget>[
      homeScreen(user, FA),
      FormScreen(),
      MeetingForm(),
    ];
