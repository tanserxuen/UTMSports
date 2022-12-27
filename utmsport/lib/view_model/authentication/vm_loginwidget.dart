import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:utmsport/main.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../utils.dart';
import '../../view/authentication/v_forgetPassword.dart';

class LoginWidget extends StatefulWidget {
  final Function() onClickedSignUp;

  const LoginWidget({
    Key? key,
    required this.onClickedSignUp,
  }) : super(key:key);

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: EdgeInsets.all(16),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 40),
        TextField(
          controller: emailController,
          cursorColor: Colors.white,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(labelText: 'Email'),
        ),
        SizedBox(height: 4),
        TextField(
          controller: passwordController,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(labelText: 'Password'),
          obscureText: true,
        ),
        SizedBox(height: 4),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            minimumSize: Size.fromHeight(50),
          ),
          icon: Icon(Icons.lock_open, size: 32),
          label: Text(
              'Sign In',
              style: TextStyle(fontSize: 24)
          ),
          onPressed: signIn,
        ),
        SizedBox(height: 24),
        GestureDetector(
          child: Text(
            'Forget Password?',
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 20
            ),
          ),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ForgetPasswordPage()
          )),
        ),
        SizedBox(height: 24),
        RichText(
            text: TextSpan(
                style: TextStyle(color: Colors.black, fontSize: 20),
                text: 'No account? ',
                children: [
                  TextSpan(
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Theme.of(context).colorScheme.secondary
                      ),
                      text: 'Sign Up',
                      recognizer: TapGestureRecognizer()
                        ..onTap = widget.onClickedSignUp
                  )
                ]

            )
        )
      ],
    ),
  );

  Future signIn() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (content) => Center(child: CircularProgressIndicator()),
    );

    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim()
      );
    } on FirebaseAuthException catch (e){
      print(e);

      Utils.showSnackBar(e.message, "red");
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);

  }
}
