import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:utmsport/admin_post/view/create_post.dart';
import 'package:utmsport/view/profile/profilePage.dart';
import 'package:utmsport/view_model/vm_ courtViewData.dart';

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
      FormScreen(),
      GridDataTable(), // JOAN TAN
      // TODO: Add new page below here
      FormScreen(), // AIDAH WONG
      ProfilePage() // CM TAN
    ];
