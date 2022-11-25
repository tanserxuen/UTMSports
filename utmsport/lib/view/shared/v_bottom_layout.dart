import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:utmsport/admin_post/view/create_post.dart';
import '../../crud/crud_appointment.dart';
import '../../crud/listView_appointment.dart';
import '../../crud/timeslot.dart';
import '../view_calendarPage.dart';
import 'calendar.dart';


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

Widget homeScreen(user) => Padding(
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
          onPressed: () => FirebaseAuth.instance.signOut(),
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

navScreen(user) => <Widget>[
      homeScreen(user),
      FormScreen (),   // JOAN TAN
      // TODO: Add new page below here
      Calendar(),   // AIDAH WONG
      listViewAppointment(),    // CM TAN
    ];
