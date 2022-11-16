import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
const ADMIN_ROUTES = [];
const STUDENT_ROUTES = [];
const ATHLETE_ROUTES = [];
const MANAGER_ROUTES = [];
const CLUB_ROUTES = [];
