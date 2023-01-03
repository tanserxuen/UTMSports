// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:utmsport/cm_booking/viewCalendar_cm_courtbooking.dart';
// import 'package:utmsport/view/view_calendarPage.dart';
//
// class menuCMBookingForm extends StatefulWidget {
//   @override
//   State<menuCMBookingForm> createState() => _menuCMBookingFormState();
// }
//
// class _menuCMBookingFormState extends State<menuCMBookingForm> {
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           // Text('Request List',
//           //   textAlign: TextAlign.left,
//           //     style: TextStyle(
//           //       fontWeight: FontWeight.bold,
//           //       fontSize: 24,
//           //     ),
//           // ),
//           Padding(
//             padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
//             child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   GestureDetector(
//                     onTap: () => Navigator.push(
//                         context, MaterialPageRoute(builder: (context) => cmCourtBookCalendar())),
//                     child: Container(
//                       width: 500,
//                       height: 150,
//                       padding: EdgeInsets.all(10),
//                       margin: EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         color: Colors.red,
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Container(
//                             padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Court Booking (Athlete)',
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold, fontSize: 18),
//                                 ),
//                                 Text('Click to book now')
//                               ],
//                             ),
//                           ),
//                           Container(
//                             height: 120,
//                             width: 140,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10),
//                               color: Colors.blue,
//                             ),
//                             transform: Matrix4.rotationZ(-0.05),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () => Navigator.push(
//                         context, MaterialPageRoute(builder: (context) => Calendar())),
//                     child: Container(
//                       width: 500,
//                       height: 150,
//                       padding: EdgeInsets.all(10),
//                       margin: EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         color: Colors.red,
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Container(
//                             padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Advance Booking',
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold, fontSize: 18),
//                                 ),
//                                 Text('Click to book now')
//                               ],
//                             ),
//                           ),
//                           Container(
//                             height: 120,
//                             width: 140,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10),
//                               color: Colors.blue,
//                             ),
//                             transform: Matrix4.rotationZ(-0.05),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () => Navigator.push(
//                         context, MaterialPageRoute(builder: (context) => cmCourtBookCalendar())),
//                     child: Container(
//                       width: 500,
//                       height: 150,
//                       padding: EdgeInsets.all(10),
//                       margin: EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         color: Colors.red,
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Container(
//                             padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Register Athlete',
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold, fontSize: 18),
//                                 ),
//                                 Text('Click to register')
//                               ],
//                             ),
//                           ),
//                           Container(
//                             height: 120,
//                             width: 140,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10),
//                               color: Colors.blue,
//                             ),
//                             transform: Matrix4.rotationZ(-0.05),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                   // GestureDetector(
//                   //   onTap: () => Navigator.push(
//                   //       context, MaterialPageRoute(builder: (context) => Calendar())),
//                   //   child: Container(
//                   //     width: 500,
//                   //     height: 150,
//                   //     padding: EdgeInsets.all(10),
//                   //     margin: EdgeInsets.all(10),
//                   //     decoration: BoxDecoration(
//                   //       borderRadius: BorderRadius.circular(10),
//                   //       color: Colors.red,
//                   //     ),
//                   //     child: Row(
//                   //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   //       children: [
//                   //         Container(
//                   //           padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
//                   //           child: Column(
//                   //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   //             crossAxisAlignment: CrossAxisAlignment.start,
//                   //             children: [
//                   //               Text(
//                   //                 'Squash',
//                   //                 style: TextStyle(
//                   //                     fontWeight: FontWeight.bold, fontSize: 18),
//                   //               ),
//                   //               Text('Click to view list')
//                   //             ],
//                   //           ),
//                   //         ),
//                   //         Container(
//                   //           height: 120,
//                   //           width: 150,
//                   //           decoration: BoxDecoration(
//                   //             borderRadius: BorderRadius.circular(10),
//                   //             color: Colors.blue,
//                   //           ),
//                   //           transform: Matrix4.rotationZ(-0.05),
//                   //         )
//                   //       ],
//                   //     ),
//                   //   ),
//                   // ),
//                 ]),
//           ),
//         ],
//       ),
//     );
//   }
// }
