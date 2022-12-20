import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//views
import 'package:utmsport/view/adminPost/v_createEvent.dart';
import 'package:utmsport/view/advBooking/v_createAdvancedCalendar.dart';
import 'package:utmsport/view/appointment/listView_appointment.dart';
import 'package:utmsport/view/profile/v_profilePage.dart';
import 'package:utmsport/view/adminPost/v_eventList.dart';
import 'package:utmsport/view/shared/v_bottom_layout.dart';
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
getUserRole()=>_userRole;

//==================Routes
ADMIN_ROUTES(user) =>
    [EventList(), ViewFeedback(), CreateAdvBookingCalendar(), ProfilePage()];

STUDENT_ROUTES(user) =>
    [LatestEventWall(), BookingCalendar(), homeScreen(user), ProfilePage()];

ATHLETE_ROUTES(user) =>
    [LatestEventWall(), BookingCalendar(), TeamAthletePage(), ProfilePage()];

MANAGER_ROUTES(user) =>
    [LatestEventWall(), BookingCalendar(), SportTeamPage(), ProfilePage()];

CLUB_ROUTES(user) =>
    [LatestEventWall(), BookingCalendar(), listViewAppointment(), ProfilePage()];

/*
* */