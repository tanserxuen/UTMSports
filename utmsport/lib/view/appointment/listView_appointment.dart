import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:utmsport/view/appointment/v_requestMeetingDetail.dart';
import 'package:utmsport/view/view_calendarPage.dart';
import 'package:utmsport/globalVariable.dart' as global;
import '../../cm_booking/qr_generator.dart';
import '../../utils.dart';

class   listViewAppointment extends StatefulWidget {
  @override
  State<listViewAppointment> createState() => _listViewAppointmentState();
}

class _listViewAppointmentState extends State<listViewAppointment> {
  final TextEditingController _eventTitleController = TextEditingController();
  final TextEditingController _TimeController = TextEditingController();
  final TextEditingController _DateController = TextEditingController();
  final TextEditingController _PicController = TextEditingController();
  final TextEditingController _matricNoController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final CollectionReference _appointments = global.FFdb.collection('appointments');

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _eventTitleController.text = documentSnapshot['eventtitle'];
      _PicController.text = documentSnapshot['pic'];
      _matricNoController.text = documentSnapshot['matricno'];
      _phoneNoController.text = documentSnapshot['phoneno'].toString();
      _descriptionController.text = documentSnapshot['description'];
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  top: 20,
                  left: 20,
                  right: 20,
                  bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _eventTitleController,
                    decoration: const InputDecoration(labelText: 'Event Title'),
                  ),
                  TextField(
                    controller: _PicController,
                    decoration:
                        const InputDecoration(labelText: 'Person in charge'),
                  ),
                  TextField(
                    controller: _matricNoController,
                    decoration:
                        const InputDecoration(labelText: 'Matric Number'),
                  ),
                  TextField(
                    controller: _phoneNoController,
                    decoration:
                        const InputDecoration(labelText: 'Phone Number'),
                  ),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    child: const Text('Update'),
                    onPressed: () async {
                      final String eventtitle = _eventTitleController.text;
                      final String pic = _PicController.text;
                      final String matricno = _matricNoController.text;
                      final String phoneno = _phoneNoController.text;
                      final String description = _descriptionController.text;

                      await _appointments.doc(documentSnapshot!.id).update({
                        "eventtitle": eventtitle,
                        "date": documentSnapshot['date'],
                        "pic": pic,
                        "matricno": matricno,
                        "phoneno": phoneno,
                        "description": description,
                        "email": FirebaseAuth.instance.currentUser!.email,
                        "file": documentSnapshot['file'],
                        "name": documentSnapshot['name'],
                        "status": documentSnapshot['status'],
                        "uid": FirebaseAuth.instance.currentUser!.uid
                      });

                      _eventTitleController.text = '';
                      _TimeController.text = '';
                      _DateController.text = '';
                      _PicController.text = '';
                      _matricNoController.text = '';
                      _phoneNoController.text = '';
                      _descriptionController.text = '';
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                              'You have successfully updated your appointment')));
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  Future<void> _delete(String appointmentId) async {
    await _appointments.doc(appointmentId).delete();
    Utils.showSnackBar('You have successfully deleted an appointment', "red");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
        GestureDetector(
          onTap: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => Calendar())),
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
                        'Meeting Appointment',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text('Click to Book Now')
                    ],
                  ),
                ),
                Container(
                  height: 120,
                  width: 150,
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
                    isEqualTo: global.FA.currentUser!.uid)
            .orderBy('created_at', descending: true)
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
                              width: 145,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                      icon: Icon(Icons.edit,
                                          color:
                                            documentSnapshot['status'] == 'pending'
                                            ? Colors.green
                                            : Colors.grey
                                      ),
                                      onPressed:
                                          documentSnapshot['status'] == 'pending'
                                            ? () => _update(documentSnapshot)
                                            : null
                                  ),
                                  IconButton(
                                      icon: Icon(Icons.delete,
                                          color:
                                            documentSnapshot['status'] == 'pending'
                                          ? Colors.red
                                          : Colors.grey
                                      ),
                                      onPressed:
                                        documentSnapshot['status'] == 'pending'
                                          ? ()=>  _delete(documentSnapshot.id)
                                          : null
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
