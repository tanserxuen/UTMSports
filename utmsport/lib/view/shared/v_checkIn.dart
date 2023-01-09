import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:utmsport/athlete/qr_scan.dart';
import 'package:utmsport/utils.dart';

import '../../cm_booking/qr_generator.dart';
import '../training/v_trainingDetail.dart';
import 'package:utmsport/globalVariable.dart' as global;

class CheckIn extends StatelessWidget {
  const CheckIn({
    Key? key,
    this.id,
  }) : super(key: key);
  final id;

  Widget studentView(String appDocId, BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SportEvents'),
        actions: [qrCodeOption(appDocId, context)],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Attendance Student'),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('attendance')
                        .where('bookingId', isEqualTo: appDocId)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting)
                        return Center(child: CircularProgressIndicator());
                      if (snapshot.hasData) {
                        final DocumentSnapshot documentSnapshot =
                            snapshot.data!.docs.first;
                        print(snapshot.data!.docs.first['matrics']);
                        return ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: documentSnapshot['matrics'].length,
                            itemBuilder: (BuildContext context, int index) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(documentSnapshot['matrics'][index]),
                                  Text(documentSnapshot['status'][index] == true
                                      ? 'checked'
                                      : 'unchecked')
                                ],
                              );
                            });
                      }
                      if (snapshot.hasError)
                        return Text('Soemthing error in v_checkin.dart');
                      return Text('null');
                    })
              ],
            ),
          )
          //  Display attendance Student
        ],
      ),
    );
  }

  Widget trainingView(String appDocId, BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Training'),
          actions: [qrCodeOption(appDocId, context)],
        ),
        body: TrainingDetailPage(
          trainingId: appDocId,
        ));
    return TrainingDetailPage(
      trainingId: appDocId,
    );
  }

  Widget clubView(String appDocId, BuildContext context) {
    return Text('club content');
  }

  Widget otherView(String appDocId, BuildContext context) {
    return Text('other content');
  }

  Widget qrCodeOption(String appDocId, BuildContext context) {
    //Do Switch function
    var _roles = global.getUserRole();
    switch (_roles) {
      case 'athlete':
        return IconButton(
            icon: Icon(Icons.qr_code_scanner_rounded),
            color: Colors.yellow,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          QRScan(callback: (qrcodeId, matricNo) {
                            FirebaseFirestore.instance
                                .collection('training')
                                .where('appointmentId', isEqualTo: qrcodeId)
                                .get()
                                .then((training) {
                              var sportId = training.docs.first['sportId'];
                              FirebaseFirestore.instance
                                  .collection('sportTeam')
                                  .doc(sportId)
                                  .get()
                                  .then((sportTeam) {
                                if (!sportTeam
                                    .data()!['athletes']
                                    .contains(matricNo))
                                  return Utils.showSnackBar(
                                      "Data Not Recorded Because You are Not Belongs to this",
                                      'red');
                                if (training.docs.first['athlete']
                                    .contains(matricNo))
                                  return Utils.showSnackBar(
                                      "Data Already Scanned", "red");

                                var athleteList =
                                    training.docs.first['athlete'];
                                var athleteTimeList =
                                    training.docs.first['athletetime'];
                                var currentTime = DateTime.now();
                                athleteList.add(matricNo);
                                athleteTimeList.add(currentTime);
                                var data = {
                                  'athlete': athleteList,
                                  'athletetime': athleteTimeList
                                };
                                FirebaseFirestore.instance
                                    .collection('training')
                                    .doc(training.docs.first.id)
                                    .update(data)
                                    .then((_) {
                                  Utils.showSnackBar(
                                      "Attendance Recorded", "green");
                                  print('updated successsfully');
                                });
                              });
                            });
                          })));
            });
        break;
      case 'student':
        return IconButton(
            icon: Icon(Icons.qr_code_scanner_rounded),
            color: Colors.yellow,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          QRScan(callback: (qrcodeId, matricNo) {
                            print('Perform Student Scanning');
                            FirebaseFirestore.instance
                                .collection('attendance')
                                .where('bookingId', isEqualTo: qrcodeId)
                                .get()
                                .then((attendance) {
                              if (!attendance.docs.first['matrics']
                                  .contains(matricNo))
                                return Utils.showSnackBar(
                                    "Matric Number Not Found", "red");

                              int index = attendance.docs.first['matrics']
                                  .indexOf(matricNo);
                              var array = attendance.docs.first['status'];
                              array[index] = true;
                              FirebaseFirestore.instance
                                  .collection('attendance')
                                  .doc(attendance.docs.first.id)
                                  .update({'status': array}).then((value) {
                                Utils.showSnackBar(
                                    'Attendance Recorded', "green");
                              });
                            });
                          })));
            });
        break;
      case 'staff':
        break;
      case 'admin':
      case 'manager':
        return IconButton(
            icon: Icon(Icons.qr_code),
            color: Colors.black,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => QRGenerate(
                            qrId: appDocId,
                          )));
            });
      default:
        return IconButton(onPressed: (){}, icon: Icon(Icons.error_outline));
    }
    return Icon(Icons.error_outline_rounded);

  }

  @override
  Widget build(BuildContext context) {
    print(id);
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('student_appointments')
            .where('id', isEqualTo: id)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return Text('Something Error');
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );
          if (snapshot.hasData) {
            //  Define the sportType of bookingType
            var bookType = snapshot.data!.docs.first['bookingType'];
            //  Define the DocumentID of appointment by using the
            var appDocId = snapshot.data!.docs.first.id;
            print(appDocId);
            if (bookType == 'Sport Events')
              return studentView(appDocId, context);
            if (bookType == 'Training') return trainingView(appDocId, context);
            if (bookType == 'Club Event') return clubView(appDocId, context);
            return Text('Cannot find specific view');
          }
          return Text('Stuck at checkin.dart');
        });
  }
}
