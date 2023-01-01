import 'package:cloud_firestore/cloud_firestore.dart';
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
enum RoleUser { student, manager }

class _SignUpWidgetState extends State<SignUpWidget> {
  final formKey = GlobalKey<FormState>();
  final fullnameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final coachController = TextEditingController();
  final matricController = TextEditingController();
  final phonenoController = TextEditingController();

  FirebaseFirestore db = FirebaseFirestore.instance;
  RoleUser _role = RoleUser.student;
  String roleData = "student";

  @override
  void dispose() {
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
          SizedBox(height: 20),
          Text('Register Page', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
          SizedBox(height: 10),
          Container(
            margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.redAccent,
                boxShadow:[ BoxShadow(
                  color: Colors.grey,
                  offset: const Offset(0.0, 5.0),
                  blurRadius: 2.0,
                  spreadRadius: 0.0,
                ), ]
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:<Widget> [
                Text('Register Account as', style: TextStyle(fontWeight: FontWeight.bold),),
                Row(
                  children: [
                    Radio<RoleUser>(
                      activeColor: Colors.white,
                      groupValue: _role,
                      value: RoleUser.student,
                      onChanged: (RoleUser? value){
                        setState(() {
                          _role = value!;
                          roleData = "student";
                        });
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _role = RoleUser.student;
                        });},
                      child: Container( child: Text('Student'),),)
                  ],
                ),
                Row(
                  children: [
                    Radio<RoleUser>(
                      activeColor: Colors.white,
                      groupValue: _role,
                      value: RoleUser.manager,
                      onChanged: (RoleUser? value){
                        setState(() {
                          _role = value!;
                        });
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _role = RoleUser.manager;
                          roleData = "manager";
                        });},
                      child: Container( child: Text('Coach'),),
                    )
                  ],
                ),
              ],
            ),
          ),
          TextFormField(
            controller: fullnameController,
            cursorColor: Colors.white,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(labelText: 'Full Name'),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (fullname) =>
            fullname != null && !fullname.isNotEmpty
                ? 'Enter your name'
                : null,
          ),
          TextFormField(
            controller: emailController,
            cursorColor: Colors.white,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(labelText: 'Email'),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (email) =>
            email != null && !EmailValidator.validate(email)
                ? 'Enter a valid email'
                : null,
          ),
          TextFormField(
            controller: matricController,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(labelText: 'Matric Number', hintText: 'BxxECxxxx'),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) => value != null && value.length < 9
                ? 'Enter min 9 charactor'
                : null,
          ),
          TextFormField(
            controller: phonenoController,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(labelText: 'Phone Number', hintText: '601xxxxxxxxx'),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) => value != null && value.length < 11
                ? 'Enter min 11 charactor'
                : null,
          ),
          TextFormField(
            controller: passwordController,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) => value != null && value.length < 6
                ? 'Enter min 6 charactor'
                : null,
          ),
          _displayAdditionalInfo(),
          SizedBox(height: 12),

          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              minimumSize: Size.fromHeight(50),
            ),
            icon: Icon(Icons.arrow_forward, size: 32),
            label: Text('Sign Up', style: TextStyle(fontSize: 24)),
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
                            color: Theme.of(context).colorScheme.secondary),
                        text: 'Log In',
                        recognizer: TapGestureRecognizer()
                          ..onTap = widget.onClickedSignIn)
                  ]))
        ],
      ),
    ),
  );

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (emailController.text != '') if (!isValid) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (content) => Center(child: CircularProgressIndicator()),
    );

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());

      var data = {
        'name': fullnameController.text.trim(),
        'matric': matricController.text.trim().toUpperCase(),
        'phoneno': phonenoController.text.trim(),
        'roles': roleData,
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'image': ''
      };

      db
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(data)
          .then((value) => 'The data inserted successfully')
          .onError((error, _) => "Somethings Error on inserting");

      // db
      //     .collection("users")
      //     .add(data)
      //     .then((value) => 'The data inserted successfully')
      //     .onError((error, _) => "Somethings Error on inserting");

    } on FirebaseAuthException catch (e) {
      print(e);

      Utils.showSnackBar(e.message, "red");
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  Widget StudentRegister() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 40),
        TextFormField(
          controller: fullnameController,
          cursorColor: Colors.white,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(labelText: 'Full Name'),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (fullname) =>
          fullname != null && !fullname.isNotEmpty
              ? 'Enter your name'
              : null,
        ),
        SizedBox(height: 4),
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
          validator: (value) => value != null && value.length < 6
              ? 'Enter min 6 charactor'
              : null,
        ),
        SizedBox(height: 4),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            minimumSize: Size.fromHeight(50),
          ),
          icon: Icon(Icons.arrow_forward, size: 32),
          label: Text('Sign Up', style: TextStyle(fontSize: 24)),
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
                          color: Theme.of(context).colorScheme.secondary),
                      text: 'Log In',
                      recognizer: TapGestureRecognizer()
                        ..onTap = widget.onClickedSignIn)
                ]))
      ],
    );
  }

  Widget _displayAdditionalInfo() {
    return _role == RoleUser.student ? Text('') : Column(
      children: [
        TextFormField(
          controller: coachController,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(labelText: 'Coach ID'),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          maxLength: 15,
          validator: (value) => value != null && value.length < 15
              ? 'Enter min 15 charactor'
              : null,
        ),
      ],
    );
  }
}


