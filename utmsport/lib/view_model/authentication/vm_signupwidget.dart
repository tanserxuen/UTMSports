import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../../utils.dart';

class SignUpWidget extends StatefulWidget {
  final Function() onClickedSignIn;

  const SignUpWidget({
    Key? key,
    required this.onClickedSignIn,
  }) : super(key: key);

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final formKey = GlobalKey<FormState>();
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
    child: Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 40),
          TextFormField(
            controller: emailController,
            cursorColor: Colors.white,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(labelText: 'Email'),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (email) =>
              email != null && !EmailValidator.validate(email)
                  ? 'Enter a valid email'
                  : null,
          ),
          SizedBox(height: 4),
          TextFormField(
            controller: passwordController,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) =>
            value != null && value.length < 6
                ? 'Enter min 6 charactor'
                : null,
          ),
          SizedBox(height: 4),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              minimumSize: Size.fromHeight(50),
            ),
            icon: Icon(Icons.arrow_forward, size: 32),
            label: Text(
              'Sign Up',
              style: TextStyle(fontSize: 24)
            ),
            onPressed: signUp,
          ),
          SizedBox(height: 24),
          RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.black, fontSize: 20),
                text: 'Already have an account? ',
              children: [
                TextSpan(
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Theme.of(context).colorScheme.secondary
                  ),
                  text: 'Log In',
                  recognizer: TapGestureRecognizer()
                  ..onTap = widget.onClickedSignIn
                )
              ]
            )
          )
        ],
      ),
    ),
  );

  Future signUp() async{

    final isValid = formKey.currentState!.validate();
    if (emailController.text != '')
    if (!isValid) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (content) => Center(child: CircularProgressIndicator()),
    );

    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim()
      );
    } on FirebaseAuthException catch (e) {
      print(e);

      Utils.showSnackBar(e.message);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}