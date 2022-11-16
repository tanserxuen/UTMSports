import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utmsport/view/authentication/v_adminPage.dart';
import 'package:utmsport/view/authentication/v_homePage.dart';

import '../../utils.dart';


class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({Key? key}) : super(key: key);

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {

  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState(){
    super.initState();

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if(!isEmailVerified){
      sendVerificationEmail();

      timer = Timer.periodic(
        Duration(seconds: 3),
          (_) => checkEmailVerified()
      );
    }
  }

  @override
  void dispose(){
    timer?.cancel();

    super.dispose();
  }

  Future checkEmailVerified() async {
    // call after email verification
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if(isEmailVerified) timer?.cancel();
  }

  Future sendVerificationEmail() async {
    try{
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() => canResendEmail = false);
      await Future.delayed(Duration(seconds: 5));
      setState(() => canResendEmail = true);
    } catch (e) {
      Utils.showSnackBar(e.toString());
    }

  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      // ? MyHomePage()
      ? authorization()
      : Scaffold(
        appBar: AppBar(
          title: Text('Verify Email')
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  'A Verification email has been sent to your email.',
                style: TextStyle(
                  fontSize: 20
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              ElevatedButton.icon(
                icon: Icon(Icons.email, size: 32),
                onPressed: canResendEmail ? sendVerificationEmail : null ,
                label: Text(
                  'Resend Email',
                  style: TextStyle(fontSize: 24),
                ),
              ),
              SizedBox(height: 8),
              TextButton(onPressed: ()=>FirebaseAuth.instance.signOut(), child: Text('Cancel', style: TextStyle(fontSize: 24),))
            ],
          ),
        ),
  );
}

Widget authorization() => FutureBuilder(
  future: FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get(),
  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
    if(snapshot.hasError) return Text("Something went wrong");
    if(snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
    if(snapshot.connectionState == ConnectionState.done){
      Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
      if(data['roles'] == "admin") {
        return AdminPage();
      }
      if(data['roles'] == "student") {
        // return Text('Push ${data['roles']} to Student Page');
        return MyHomePage();
      }
    }

    return Text("loading NOTHING");
  },


);

Future isLogged(roles) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('roles', roles);
  String? role = prefs.getString('roles');
  if(role == 'admin'){ return Text("Push ${roles}to Admin Page"); }
  if(role == 'student'){ return Text("Push ${roles}to Student Page"); }
  
}

