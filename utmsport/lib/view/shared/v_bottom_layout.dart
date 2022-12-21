import 'package:flutter/material.dart';

import 'package:utmsport/globalVariable.dart' as global;
import 'package:utmsport/view/advBooking/v_createAdvancedCalendar.dart';

Widget BookingButton(BuildContext context) {
  return (FloatingActionButton(
    tooltip: "Booking",
    onPressed: () => {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Container(
              margin: EdgeInsets.all(12),
              child: Column(
                children: [
                  SizedBox(height: 50),
                  Text(
                    "Advanced Booking",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: CreateAdvBookingCalendar(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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
        NavigationDestination(
            icon: Icon(Icons.calendar_today), label: 'Events'),
        NavigationDestination(
            icon: Icon(Icons.question_answer), label: 'Feedback'),
        NavigationDestination(icon: Icon(Icons.add_alarm), label: 'Appts'),
        NavigationDestination(
            icon: Icon(Icons.edit_calendar), label: 'Advance'),
        NavigationDestination(icon: Icon(Icons.person), label: 'Profile')
      ];
      break;
    case 'athlete':
    case 'coach':
      routes = global.ATHLETE_ROUTES(user);
      destinations = [
        NavigationDestination(
            icon: Icon(Icons.calendar_today), label: 'Events'),
        NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined), label: 'Bookings'),
        NavigationDestination(icon: Icon(Icons.groups), label: 'Trainings'),
        NavigationDestination(icon: Icon(Icons.person), label: 'Profile')
      ];
      break;
    case 'manager':
      routes = global.MANAGER_ROUTES(user);
      destinations = [
        NavigationDestination(
            icon: Icon(Icons.calendar_today), label: 'Events'),
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
        NavigationDestination(
            icon: Icon(Icons.calendar_today), label: 'Events'),
        NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined), label: 'Bookings'),
        NavigationDestination(icon: Icon(Icons.list), label: 'Appointments'),
        NavigationDestination(icon: Icon(Icons.person), label: 'Profile')
      ];
      break;
    default: //student
      routes = global.STUDENT_ROUTES(user);
      destinations = [
        NavigationDestination(
            icon: Icon(Icons.calendar_today), label: 'Events'),
        NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined), label: 'Bookings'),
        NavigationDestination(
            icon: Icon(Icons.chat_bubble_rounded), label: 'Feedback'),
        NavigationDestination(icon: Icon(Icons.person), label: 'Profile')
      ];
  }
  return routes;
}
