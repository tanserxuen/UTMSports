import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:utmsport/globalVariable.dart' as global;

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
  NavigationDestination(icon: Icon(Icons.sports_basketball), label: 'Bookings'),
  NavigationDestination(icon: Icon(Icons.list), label: 'Requests'),
  NavigationDestination(icon: Icon(Icons.person), label: 'Profile')
];

Widget homeScreen(user) => Padding(
      padding: EdgeInsets.all(32),
      child: Scaffold(
        body: Text('HomePage'),
      ),
    );

// navScreen(user) => <Widget>[
//       // homeScreen(user),
//       LatestEventWall(),
//       ProfilePage(), // CM TAN
//       BookingCalendar(),
//       EventList(), // JOAN TAN
//       FormScreen(),
//       // TODO: Add new page below here
//       FormScreen(), // AIDAH WONG
//     ];

navScreen(user) {
  List routes = [];
  print('btm layout ${global.getUserRole()}');
  switch (global.getUserRole()) {
    case 'admin':
      routes = global.ADMIN_ROUTES(user);
      break;
    case 'athlete':
    case 'couch':
      routes = global.ATHLETE_ROUTES(user);
      break;
    case 'manager':
      routes = global.MANAGER_ROUTES(user);
      break;
    case 'club':
    case 'organizer':
      routes = global.CLUB_ROUTES(user);
      break;
    default:
      routes = global.STUDENT_ROUTES(user);
  };
  return routes;
}
