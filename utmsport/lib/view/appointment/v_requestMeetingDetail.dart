import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:utmsport/model/m_MeetAppointment.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:utmsport/view/appointment/v_readerScreen.dart';

import '../../model/m_AppointmentDetail.dart';


class RequestMeetingDetail extends StatefulWidget {
  final docid;

  const RequestMeetingDetail({Key? key, this.docid})
      : super(key: key);

  @override
  State<RequestMeetingDetail> createState() => _RequestMeetingDetailState();
}

class _RequestMeetingDetailState extends State<RequestMeetingDetail> {

  final CollectionReference _appointments =
  FirebaseFirestore.instance.collection('appointments');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'test'
      )),
      body: FutureBuilder<DocumentSnapshot>(
          future: _appointments.doc(widget.docid).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.hasData && !snapshot.data!.exists) {
              return Text("Document does not exist");
            }

            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
              return Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text('Event Title: ')),
                        Container(
                            color: Colors.red,
                            child: Text(data['eventtitle']))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Date: ' + DateFormat('yyyy-MM-dd')
                            .format(data['date'].toDate())),
                        Text('Timeslot: ' + DateFormat.jm()
                            .format(data['date'].toDate())),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: Text('Name Event Organizer: ')),
                        Container(
                            color: Colors.red,
                            child: Text(data['name']))
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: Text('Matric No: ')),
                        Container(
                            color: Colors.orange,
                            child: Text(data['matricno']))
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: Text('Phone Number: ')),
                        Container(
                            color: Colors.red,
                            child: Text(data['phoneno']))
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: Text('Email Address: ')),
                        Container(
                            color: Colors.red,
                            child: Text(data['email']))
                      ],
                    ),
                    SizedBox(height: 20,),
                    Row(
                      children: [
                        Expanded(child: Text('Person in Charge: ')),
                        Container(
                            color: Colors.red,
                            child: Text(data['pic']))
                      ],
                    ),

                    Text('Description: '),
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      color: Colors.green,
                      child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                data['description'],
                                textAlign: TextAlign.justify,
                              ),
                            )
                          ]),
                    ),
                    SizedBox(height: 20,),

                    Container(
                      margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: data['status'] == "pending" ? Colors.yellow : Colors.transparent,
                          border: Border.all(
                            color: data['status'] == 'approved'
                                ? Colors.green : data['status'] == 'rejected'
                                ? Colors.red  : Colors.yellow,
                            width: 1,
                          )
                      ),
                      child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                data['status'],
                                textAlign: TextAlign.center,
                              ),
                            )
                          ]),
                    ),
                    SizedBox(height: 25,),
                    Text('Open To Review', style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                    ),),
                    ListTile(
                      //TODO: Solve the CORS security to display the file
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ReaderScreen(data['file'])));
                      } ,
                      title: Text(data['file'], overflow: TextOverflow.ellipsis,),
                      leading: Icon(Icons.picture_as_pdf, color: Colors.red, size: 32,),
                    ),

                    SizedBox(height: 25,),
                    Text('Attendence Report', style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                    ),),
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      color: Colors.blueGrey[100],
                      child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                data['description'],
                                textAlign: TextAlign.justify,
                              ),
                            )
                          ]),
                    ),
                    SizedBox(height: 20,),

                  ]));
            }
            return Text("loading");
          },
        ),
    );
  }
}
