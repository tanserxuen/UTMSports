import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//views
import 'package:utmsport/view/adminPost/v_createEvent.dart';
import 'package:utmsport/view/appointment/listView_appointment.dart';
import 'package:utmsport/view/appointment/v_requestList.dart';
import 'package:utmsport/view/profile/v_profilePage.dart';
import 'package:utmsport/view/adminPost/v_eventList.dart';
import 'package:utmsport/view/shared/v_bottom_layout.dart';
import 'package:utmsport/view/studentBooking/v_bookingCalendarView.dart';
import 'package:utmsport/view/adminPost/v_latestEventWall.dart';
import 'package:utmsport/view/view_calendarPage.dart';

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
ADMIN_ROUTES(user) => [LatestEventWall(), EventList(), RequestListPage(), ProfilePage()];
STUDENT_ROUTES(user) => [BookingCalendar(), homeScreen(user), listViewAppointment(), ProfilePage()];
ATHLETE_ROUTES(user) => [homeScreen(user), homeScreen(user), FormScreen(), ProfilePage()];
MANAGER_ROUTES(user) => [homeScreen(user), homeScreen(user), FormScreen(), ProfilePage()];
CLUB_ROUTES(user) => [LatestEventWall(), homeScreen(user), listViewAppointment(), ProfilePage()];

/*
* */