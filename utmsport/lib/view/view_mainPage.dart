import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:utmsport/view/view_authPage.dart';
import 'package:utmsport/view/view_homePage.dart';
import 'package:utmsport/view/view_verifyemailPage.dart';

import '../view_model/viewmodel_loginwidget.dart';

class MainPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) => Scaffold(
    body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }else if(snapshot.hasError){
            return Center(child: Text('Something went wrong!'));
          }else if (snapshot.hasData){
            return VerifyEmailPage();
          }else{
            return AuthPage();
          }
        }
    ),
  );
}

