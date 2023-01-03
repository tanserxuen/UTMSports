import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:utmsport/athlete/qr_scan.dart';
import 'package:utmsport/globalVariable.dart' as global;

import '../../cm_booking/qr_generator.dart';

class TrainingDetailPage extends StatelessWidget {
  const TrainingDetailPage({Key? key, this.trainingId, this.trainingTitle})
      : super(key: key);
  final trainingId;
  final trainingTitle;

  Widget qrCodeOption(BuildContext context) {
    return global.getUserRole() == "coach"
        ? IconButton(
            icon: Icon(Icons.qr_code),
            color: Colors.black,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => QRGenerate(
                            trainingId: trainingId,
                          )));
            })
        : IconButton(
            icon: Icon(Icons.qr_code_scanner_rounded),
            color: Colors.yellow,
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => QRScan()));
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Session ${trainingTitle}'),
          actions: [
            qrCodeOption(context),
          ],
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("training")
              .doc(trainingId)
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());
            if (snapshot.hasData) {
              // print(snapshot.data?.data()!['sportId']);
              var documentSnapshot = snapshot.data?.data();
              String date = DateFormat.yMMMMd('en_US')
                  .format(documentSnapshot!['start_at'].toDate());
              String time = DateFormat.jm()
                  .format(documentSnapshot!['start_at'].toDate());
              // return Text("Data Found");
              return Container(
                padding: EdgeInsets.all(10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Subject: '),
                          Text(documentSnapshot['subject'])
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Sport Type: '),
                          Text(documentSnapshot['sportType'])
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Coach: '),
                          Text(documentSnapshot['coach'])
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Training Time: '),
                          Text(time)
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10,),
                          Text('Description: '),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.lightBlue.shade50,
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  padding: EdgeInsets.all(5),
                                  child: SizedBox(
                                      height: 100,
                                      child: Text(documentSnapshot!['description'])),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text('List Attendance Athlete: '),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.lightGreen.shade50,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          padding: EdgeInsets.all(5),
                          child: ListView.builder(
                              itemCount: snapshot.data!['athlete'].length,
                              itemBuilder: (BuildContext context, int index) {
                                final documentSnapshot =
                                    snapshot.data!['athlete'][index];
                                // print(documentSnapshot['startTime'][0]);
                                return ListTile(title: Text(documentSnapshot));
                              }),
                        ),
                      ),
                    ]),
              );
            }
            return Text('Something Error in TrainingDetail.dart');
          },
        ));
  }
}
