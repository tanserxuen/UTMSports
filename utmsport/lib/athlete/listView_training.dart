import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:utmsport/athlete/qr_scan.dart';
import 'package:utmsport/view/appointment/v_requestMeetingDetail.dart';
import 'package:utmsport/view/view_calendarPage.dart';
import 'package:utmsport/globalVariable.dart' as global;
import '../../cm_booking/qr_generator.dart';
import '../../utils.dart';

class   listviewTraining extends StatefulWidget {
  @override
  State<listviewTraining> createState() => _listviewTrainingState();
}

class _listviewTrainingState extends State<listviewTraining> {
  final TextEditingController _eventTitleController = TextEditingController();
  final TextEditingController _TimeController = TextEditingController();
  final TextEditingController _DateController = TextEditingController();
  final TextEditingController _PicController = TextEditingController();
  final TextEditingController _matricNoController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final CollectionReference _appointments = global.FFdb.collection('appointments');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Text(
                  'Your Request List',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
              Container(
                // color: Colors.green,
                width: 500,
                height: 360,
                child: StreamBuilder(
                  stream: _appointments
                      .where('uid',
                      isEqualTo: global.FA.currentUser!.uid).where('status', isEqualTo: 'approved')
                      //.orderBy('created_at', descending: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                    if (streamSnapshot.connectionState == ConnectionState.waiting)
                      return Center(child: CircularProgressIndicator());
                    if (streamSnapshot.hasData) {
                      //TODO: filter the users data
                      return ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: streamSnapshot.data!.docs.length,
                          itemBuilder: (context, int) {
                            final DocumentSnapshot documentSnapshot =
                            streamSnapshot.data!.docs[int];
                            return Card(
                              margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                              child: GestureDetector(
                                onTap: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => RequestMeetingDetail(
                                              docid: documentSnapshot.id)));
                                },
                                child: ListTile(
                                  title: Text(documentSnapshot['eventtitle']),
                                  // subtitle: Text(documentSnapshot['time']),
                                  subtitle: Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(DateFormat.yMd().format(documentSnapshot['date'].toDate()).toString()),
                                            Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.horizontal(
                                                      left: Radius.circular(10),
                                                      right:
                                                      Radius.circular(10)),
                                                  color:
                                                  documentSnapshot['status'] ==
                                                      'rejected'
                                                      ? Colors.red
                                                      : documentSnapshot[
                                                  'status'] ==
                                                      'approved'
                                                      ? Colors.green
                                                      : Colors.yellow,
                                                ),
                                                width: 85,
                                                margin: EdgeInsets.fromLTRB(
                                                    10, 0, 0, 0),
                                                padding: EdgeInsets.fromLTRB(
                                                    10, 2, 10, 2),
                                                child: Text(
                                                  documentSnapshot['status'],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w900),
                                                )),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  trailing: SizedBox(
                                    width: 50,
                                    child: Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.qr_code_scanner_outlined,
                                              color:
                                              documentSnapshot['status'] == 'approved'
                                                  ? Colors.orange
                                                  : Colors.grey
                                          ),
                                          // onPressed:
                                          // documentSnapshot['status'] == 'approved'
                                          //     ? () => QRGenerate()
                                          //     : null
                                          onPressed:(){
                                            Navigator.push(context,
                                                MaterialPageRoute(builder: (context) => QRScan())
                                            );} ,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                    }
                    if (streamSnapshot.hasError)
                      return Text('Something went wrong');
                    return Text('No Recorded founded');
                  },
                ),
              )
            ]),
      ),
    );
  }
}
