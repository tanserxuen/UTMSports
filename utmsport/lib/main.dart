import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:utmsport/utils.dart';
import 'package:utmsport/view/authentication/v_mainPage.dart';
import 'package:utmsport/view/adminPost/v_createEvent.dart';
import 'package:utmsport/view/studentBooking/v_createStuBooking.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/student-booking': (context) => CreateStuBooking(sportsType: '',),
      },
      scaffoldMessengerKey: Utils.messengerKey,
      navigatorKey: navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(),
      // onGenerateRoute: (settings) {
      //   print("initialize");
      //   return MaterialPageRoute(builder: (_) => FormScreen());
      // },

      scrollBehavior: MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown
        },
      ),
    );
  }
}
