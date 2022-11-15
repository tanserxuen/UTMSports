import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:utmsport/view/shared/v_bottom_layout.dart' as bottomBar;
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:utmsport/view_model/vm_ courtViewData.dart' as scv;

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  late List<scv.Employee> _employees;

  @override
  void initState() {
    _employees = scv.getEmployeeData();
    super.initState();
  }


  late scv.EmployeeDataSource? _employeeDataSource;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final screens=bottomBar.navScreen(user);
    return Scaffold(
        appBar: AppBar(
          title: Text('UTM Sports'),
        ),
        body: screens[_currentIndex],
        // body: SfDataGrid(
        //     source: _employeeDataSource,
        //     columns: [
        //       GridColumn(
        //           columnName: 'id',
        //           label: Container(
        //               padding: EdgeInsets.symmetric(horizontal: 16.0),
        //               alignment: Alignment.centerRight,
        //               child: Text(
        //                 'ID',
        //                 overflow: TextOverflow.ellipsis,
        //               ))),
        //       GridColumn(
        //           columnName: 'name',
        //           label: Container(
        //               padding: EdgeInsets.symmetric(horizontal: 16.0),
        //               alignment: Alignment.centerLeft,
        //               child: Text(
        //                 'Name',
        //                 overflow: TextOverflow.ellipsis,
        //               ))),
        //       GridColumn(
        //           columnName: 'designation',
        //           label: Container(
        //               padding: EdgeInsets.symmetric(horizontal: 16.0),
        //               alignment: Alignment.centerLeft,
        //               child: Text(
        //                 'Designation',
        //                 overflow: TextOverflow.ellipsis,
        //               ))),
        //       GridColumn(
        //           columnName: 'salary',
        //           label: Container(
        //               padding: EdgeInsets.symmetric(horizontal: 16.0),
        //               alignment: Alignment.centerRight,
        //               child: Text(
        //                 'Salary',
        //                 overflow: TextOverflow.ellipsis,
        //               )))
        //     ]),
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
        floatingActionButton: bottomBar.BookingButton(context),
        floatingActionButtonLocation: bottomBar.fabLocation);
  }
}
