import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:utmsport/view/view_calendarPage.dart';

import '../eo_appointment/listView_appointment.dart';
import '../view/appointment/listView_appointment.dart';
import 'listviewNcrud_cm_advbooking.dart';
import 'listviewNcrud_cm_courtbooking.dart';

class menuListViewBooking extends StatefulWidget {
  @override
  State<menuListViewBooking > createState() => _menuListViewBookingState();
}

class _menuListViewBookingState extends State<menuListViewBooking > {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Text('Request List',
          //   textAlign: TextAlign.left,
          //     style: TextStyle(
          //       fontWeight: FontWeight.bold,
          //       fontSize: 24,
          //     ),
          // ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context, MaterialPageRoute(builder: (context) => CMlistviewNcrudCourtBook())),
                    child: Container(
                      width: 500,
                      height: 150,
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.red,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Court Booking (Athlete)',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                                Text('Click to view list')
                              ],
                            ),
                          ),
                          Container(
                            height: 120,
                            width: 140,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blue,
                            ),
                            transform: Matrix4.rotationZ(-0.05),
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context, MaterialPageRoute(builder: (context) => CMlistviewNcrudAdvBook())),
                    child: Container(
                      width: 500,
                      height: 150,
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.red,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Advance Booking',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                                Text('Click to view list')
                              ],
                            ),
                          ),
                          Container(
                            height: 120,
                            width: 140,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blue,
                            ),
                            transform: Matrix4.rotationZ(-0.05),
                          )
                        ],
                      ),
                    ),
                  ),
                  // GestureDetector(
                  //   onTap: () => Navigator.push(
                  //       context, MaterialPageRoute(builder: (context) => Calendar())),
                  //   child: Container(
                  //     width: 500,
                  //     height: 150,
                  //     padding: EdgeInsets.all(10),
                  //     margin: EdgeInsets.all(10),
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(10),
                  //       color: Colors.red,
                  //     ),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         Container(
                  //           padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                  //           child: Column(
                  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             children: [
                  //               Text(
                  //                 'Squash',
                  //                 style: TextStyle(
                  //                     fontWeight: FontWeight.bold, fontSize: 18),
                  //               ),
                  //               Text('Click to view list')
                  //             ],
                  //           ),
                  //         ),
                  //         Container(
                  //           height: 120,
                  //           width: 150,
                  //           decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(10),
                  //             color: Colors.blue,
                  //           ),
                  //           transform: Matrix4.rotationZ(-0.05),
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ]),
          ),
        ],
      ),
    );
  }
}
