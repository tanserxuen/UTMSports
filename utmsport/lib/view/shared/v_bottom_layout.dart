import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:utmsport/view/adminPost/v_createEvent.dart';
import 'package:utmsport/view/profile/v_profilePage.dart';
import 'package:utmsport/view/studentBooking/v_createBooking.dart';
import 'package:utmsport/view/adminPost/v_eventList.dart';
import 'package:utmsport/view/studentBooking/v_bookingCalendarView.dart';
import 'package:utmsport/view/adminPost/v_latestEventWall.dart';

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
  LatestEventWall(),
      BookingCalendar(),
      FormScreen(),
      EventList(), // JOAN TAN
      // TODO: Add new page below here
      FormScreen(), // AIDAH WONG
      ProfilePage() // CM TAN
    ];
