import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:utmsport/shared/bottom_layout.dart' as bottomBar;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("UTMSports"),
        ),
        body: Text("insert your content here"),
        bottomNavigationBar: bottomBar.BottomBar(context),
        floatingActionButton: bottomBar.BookingButton(context),
        floatingActionButtonLocation: bottomBar.fabLocation);
  }
}
