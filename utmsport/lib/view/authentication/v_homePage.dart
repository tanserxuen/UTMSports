import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:utmsport/view/shared/v_bottom_layout.dart' as bottomBar;

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final screens = bottomBar.navScreen(user);
    return Scaffold(
      appBar: AppBar(
        title: Text('UTM Sports'),
      ),
      body: LazyLoadScrollView(
        onEndOfPage: () {},
        child: screens[_currentIndex],
      ),
      // body: screens[]
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.blue.shade100,
          labelTextStyle: MaterialStateProperty.all(
            TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) =>
              setState(() => this._currentIndex = index),
          destinations: bottomBar.destinations,
        ),
      ),
      // floatingActionButton: bottomBar.BookingButton(context),
      // floatingActionButtonLocation: bottomBar.fabLocation,
    );
  }
}
