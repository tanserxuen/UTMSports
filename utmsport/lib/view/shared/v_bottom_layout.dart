import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:utmsport/globalVariable.dart' as global;
// import 'package:utmsport/view/appointment/listView_appointment.dart';
// import 'package:utmsport/view/profile/v_profilePage.dart';
//
// import '../view_calendarPage.dart';

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
var destinations;

Widget homeScreen(user) => Padding(
      padding: EdgeInsets.all(32),
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('HomePage'),
          ],
        ),
      ),
    );

navScreen(user) {
  List routes = [];
  switch (global.getUserRole()) {
    case 'admin':
      routes = global.ADMIN_ROUTES(user);
      destinations = [
        NavigationDestination(icon: Icon(Icons.calendar_today), label: 'Events'),
        NavigationDestination(icon: Icon(Icons.question_answer), label: 'Feedback'),
        NavigationDestination(
            icon: Icon(Icons.add_alarm), label: 'Appts'),
        NavigationDestination(icon: Icon(Icons.edit_calendar), label: 'Advance'),
        NavigationDestination(icon: Icon(Icons.person), label: 'Profile')
      ];
      break;
    case 'athlete':
    case 'coach':
      routes = global.ATHLETE_ROUTES(user);
      destinations = [
        NavigationDestination(icon: Icon(Icons.calendar_today), label: 'Events'),
        NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined), label: 'Bookings'),
        NavigationDestination(icon: Icon(Icons.groups), label: 'Trainings'),
        NavigationDestination(icon: Icon(Icons.person), label: 'Profile')
      ];
      break;
    case 'manager':
      routes = global.MANAGER_ROUTES(user);
      destinations = [
        NavigationDestination(icon: Icon(Icons.calendar_today), label: 'Events'),
        NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined), label: 'Bookings'),
        NavigationDestination(icon: Icon(Icons.group), label: 'SportTeam'),
        NavigationDestination(icon: Icon(Icons.person), label: 'Profile')
      ];
      break;
    case 'club':
    case 'organizer':
      routes = global.CLUB_ROUTES(user);
      destinations = [
        NavigationDestination(icon: Icon(Icons.calendar_today), label: 'Events'),
        NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined), label: 'Bookings'),
        NavigationDestination(icon: Icon(Icons.list), label: 'Appointments'),
        NavigationDestination(icon: Icon(Icons.person), label: 'Profile')
      ];
      break;
    default: //student
      routes = global.STUDENT_ROUTES(user);
      destinations = [
        NavigationDestination(icon: Icon(Icons.calendar_today), label: 'Events'),
        NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined), label: 'Bookings'),
        NavigationDestination(icon: Icon(Icons.chat_bubble_rounded), label: 'Feedback'),
        NavigationDestination(icon: Icon(Icons.person), label: 'Profile')
      ];
  }
  return routes;
}
