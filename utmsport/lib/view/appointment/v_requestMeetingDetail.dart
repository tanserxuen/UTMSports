import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:utmsport/model/m_MeetAppointment.dart';

class RequestMeetingDetail extends StatelessWidget {
  final document;

  const RequestMeetingDetail({Key? key, required this.document})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        document["eventtitle"],
      )),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Date: ' + document['date']),
              SizedBox(height: 20,),
              Text('Timeslot: ' + document['time']),
              SizedBox(height: 20,),
              Text('Name Event Organizer: ' + document['name']),
              SizedBox(height: 20,),
              Text('Matric No: ' + document['matricno']),
              SizedBox(height: 20,),
              Text('Person In Charged: ' + document['pic']),
              SizedBox(height: 20,),
              Text('Phone Number: ' + document['phoneno']),
              SizedBox(height: 20,),

              Text('Email: ' + document['email']),
              SizedBox(height: 20,),

              Text('Description: ' + document['description']),
              SizedBox(height: 20,),

              Text(document['file']),
              SizedBox(height: 20,),

              Text('Status: ' + document['status']),
              SizedBox(height: 20,),
              Text('_____________________________________',  textAlign: TextAlign.center, ),
            ]),

      )
      ,
    );
  }
}
