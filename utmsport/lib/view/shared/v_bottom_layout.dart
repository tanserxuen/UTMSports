import 'package:flutter/material.dart';
import 'package:utmsport/admin_post/view/create_post.dart';
import 'package:utmsport/athlete/qr_scan.dart';
import 'package:utmsport/view/profile/v_profilePage.dart';

import '../../athlete/scanQR.dart';
import '../../cm_booking/qr_generator.dart';
import '../../eo_appointment/listView_appointment.dart';
import '../view_calendarPage.dart';

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
    child: Scaffold(
      body: Text('HomePage'),
    ),
);

navScreen(user) => <Widget>[
      homeScreen(user),
      QRGenerate (),   // JOAN TAN
      // TODO: Add new page below here
      //scanQR(),   // AIDAH WONG
      QRScan(),
      ProfilePage()    // CM TAN
    ];
