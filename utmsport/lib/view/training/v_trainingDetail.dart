import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:utmsport/athlete/qr_scan.dart';
import 'package:utmsport/globalVariable.dart' as global;

import '../../cm_booking/qr_generator.dart';
import '../../utils.dart';

class TrainingDetailPage extends StatelessWidget {
  const TrainingDetailPage(
      {Key? key, required this.trainingId, this.trainingTitle})
      : super(key: key);
  final trainingId;
  final trainingTitle;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("training")
              .where('appointmentId', isEqualTo: trainingId)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());
            if (snapshot.hasData) {
              var documentSnapshot = snapshot.data!.docs.first;

              /*String date = DateFormat.yMMMMd('en_US')
                  .format(documentSnapshot!['start_at'].toDate());
              String time = DateFormat.jm()
                  .format(documentSnapshot!['start_at'].toDate())*/;
              print(documentSnapshot['athletes']);
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
                          Text('Coaches: '),
                          Column(
                            children: List.generate(documentSnapshot['coaches'].length, (index) {
                              return Text(documentSnapshot['coaches'][index]);
                            }),
                          )
                          // Text(documentSnapshot['coach'])
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text('Training Time: '), Text(/*time*/'')],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text('Description: '),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.lightBlue.shade50,
                                      borderRadius: BorderRadius.circular(10)),
                                  padding: EdgeInsets.all(5),
                                  child: SizedBox(
                                      height: 100,
                                      child: Text(
                                          documentSnapshot!['description'])),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text('List Attendance Athletes: '),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.lightGreen.shade50,
                              borderRadius: BorderRadius.circular(10)),
                          child: ListView.builder(
                              itemCount: documentSnapshot['athletes'].length,
                              itemBuilder: (BuildContext context, int index) {
                                final athletes = documentSnapshot['athletes'];
                                final timeAttend =
                                    documentSnapshot['athletetime'];
                                if (athletes.length == 0)
                                  return Text('Empty Data');
                                return StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection('users')
                                        .where('matric',
                                            isEqualTo: athletes[index])
                                        .snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting)
                                        return Center(
                                            child: CircularProgressIndicator());
                                      if (snapshot.hasError)
                                        return Text(
                                            'SomethingError occured in trainingDetail.dart');
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(athletes[index]),
                                          Text(DateFormat.Hm().format(
                                              timeAttend[index].toDate())),
                                          Text(
                                              snapshot.data?.docs.first['name'])
                                        ],
                                      );
                                    });
                              }),
                        ),
                      ),
                    ]),
              );
            }
            return Text('Something Error in TrainingDetail.dart');
          },
    );
  }
}
