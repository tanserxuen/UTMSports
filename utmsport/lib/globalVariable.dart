import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//views
import 'package:utmsport/view/adminPost/v_createEvent.dart';
import 'package:utmsport/view/advBooking/v_createAdvancedCalendar.dart';
import 'package:utmsport/view/appointment/listView_appointment.dart';
import 'package:utmsport/view/appointment/v_requestList.dart';
import 'package:utmsport/view/profile/v_profilePage.dart';
import 'package:utmsport/view/adminPost/v_eventList.dart';
import 'package:utmsport/view/sportTeam/v_displaySportTeamList.dart';
import 'package:utmsport/view/sportTeam/v_teamAthletePage.dart';
import 'package:utmsport/view/studentBooking/v_bookingCalendarView.dart';
import 'package:utmsport/view/adminPost/v_latestEventWall.dart';
import 'package:utmsport/view/studentBooking/v_feedbackForm.dart';
import 'package:utmsport/view/studentBooking/v_viewFeedbacks.dart';

// usage:
// import this file in files that you need these variables and add gloabl.

//==================Authentication
final FFdb = FirebaseFirestore.instance;
final FA = FirebaseAuth.instance;

final USERID = FA.currentUser!.uid;
final USER = () async => await FFdb.collection("users").doc(USERID).get();

var _userRole; //private
setUserRole(data) => _userRole = data['roles'];

getUserRole() => _userRole;

const sports = ['Badminton', 'Squash', 'PingPong'];

final int badmintonCourt = 11;
final int squashCourt = 3;
final int pingPongCourt = 4;

final colorCollection = () {
      List colors = [
            Colors.redAccent,
            Colors.amber,
            Colors.orangeAccent,
            Colors.blueAccent,
            Colors.greenAccent,
            Colors.pink,
            Colors.purpleAccent,
            Colors.yellowAccent,
            Colors.white54,
      ];
      return colors.map((e) => e.value.toRadixString(16));
};

//==================Routes
ADMIN_ROUTES(user) => [
      EventList(),
      ViewFeedback(),
      RequestListPage(),
      BookingCalendar(),
      ProfilePage()
    ];

STUDENT_ROUTES(user) =>
    [LatestEventWall(), BookingCalendar(), FeedbackForm(), ProfilePage()];

ATHLETE_ROUTES(user) =>
    [LatestEventWall(), BookingCalendar(), TeamAthletePage(), ProfilePage()];

MANAGER_ROUTES(user) =>
    [LatestEventWall(), BookingCalendar(), SportTeamPage(), ProfilePage()];

CLUB_ROUTES(user) => [
      LatestEventWall(),
      BookingCalendar(),
      listViewAppointment(),
      ProfilePage()
    ];

/*
* */
