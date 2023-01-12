import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:utmsport/view_model/PDF/PDFServices.dart';
import 'package:utmsport/utils.dart';

class AdminReports extends StatefulWidget {
  const AdminReports({Key? key}) : super(key: key);

  @override
  State<AdminReports> createState() => _AdminReportsState();
}

class _AdminReportsState extends State<AdminReports> {
  List trainingColNames = [
    {'label': "Subject", 'varName': "subject", 'type': "String"},
    {'label': "Sports Type", 'varName': "sportType", "type": "String"},
    {'label': "Trainer", 'varName': "coach", "type": "String"},
    {'label': "Training Starts At", 'varName': "start_at", "type": "Timestamp"},
    {'label': "Trainee", 'varName': "athlete", "type": "Array"},
    {'label': "Time Recorded", 'varName': "athletetime", "type": "Array"},
  ];

  List advColNames = [
    {'label': "Subject", 'varName': "subject", 'type': "String"},
    {'label': "Booking Type", 'varName': "bookingType", "type": "String"},
    {
      'label': "Person In Charge",
      'varName': "personInCharge",
      "type": "String"
    },
    {'label': "Phone Number", 'varName': "phoneNo", "type": "String"},
    {'label': "Booking Time", 'varName': "createdAt", "type": "Timestamp"},
  ];

  List studentAttendanceColNames = [
    {'label': "Matric No.", 'varName': "matrics", 'type': "Array"},
    {'label': "Attendance", 'varName': "status", "type": "Array"},
    {'label': "Time Recorded", 'varName': "created_at", "type": "Timestamp"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      margin: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Text("Reports",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700)),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 3 / 5,
              children: _buildReportButtons(),
            ),
          ),
        ],
      ),
    ));
  }

  List<Widget> _buildReportButtons() {
    return [
      ElevatedButton(
        style: ElevatedButton.styleFrom(primary: Colors.blue[300]),
        child: Text(
          "Advanced Booking Report",
          style: TextStyle(fontSize: 18),
        ),
        onPressed: () async {
          final permission = await PDFService().requestPermission();
          if (permission) {
            await FirebaseFirestore.instance
                .collection('student_appointments')
                .get()
                .then((value) async {
              var logo =
                  await rootBundle.load('assets/images/utmsports_logo.jpeg');

              /*var pdf = PDFService().generatePDF(
                value.docs,
                logo,
                'Advanced Booking',
                advColNames,
              );
              PDFService().saveAndOpenPDF(pdf);*/
            });
          } else {
            Utils.showSnackBar("Have no permission to file system", "cyan");
          }
        },
      ),
      ElevatedButton(
        style: ElevatedButton.styleFrom(primary: Colors.blue[300]),
        child: Text(
          "Training Attendance Report",
          style: TextStyle(fontSize: 18),
        ),
        onPressed: () async {
          final permission = await PDFService().requestPermission();
          if (permission) {
            await FirebaseFirestore.instance
                .collection('training')
                .get()
                .then((value) async {
              var logo =
                  await rootBundle.load('assets/images/utmsports_logo.jpeg');

              /*var pdf = PDFService().generatePDF(
                value.docs,
                logo,
                'Training Attendance',
                trainingColNames,
              );
              PDFService().saveAndOpenPDF(pdf);*/
            });
          } else {
            Utils.showSnackBar("Have no permission to file system", "cyan");
          }
        },
      ),
      ElevatedButton(
        style: ElevatedButton.styleFrom(primary: Colors.blue[300]),
        child: Text(
          "Student Booking Attendance Report",
          style: TextStyle(fontSize: 18),
        ),
        onPressed: () async {
          final permission = await PDFService().requestPermission();
          if (permission) {
            await FirebaseFirestore.instance
                .collection('attendance')
                .get()
                .then((value) async {
              var logo =
                  await rootBundle.load('assets/images/utmsports_logo.jpeg');
              /*var pdf = PDFService().generatePDF(
                value.docs,
                logo,
                'Student Booking Attendance',
                studentAttendanceColNames,
              );
              PDFService().saveAndOpenPDF(pdf);*/
            });
          } else {
            Utils.showSnackBar("Have no permission to file system", "cyan");
          }
        },
      ),
    ];
  }
}
