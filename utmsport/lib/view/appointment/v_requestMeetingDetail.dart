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
      body: Center(
        child: Container(
          child: Column(
              children: [
                Text(document['date']),
                Text(document['time']),
                Text(document['name']),
                Text(document['pic']),
                Text(document['matricno']),
                Text(document['phoneno']),
                Text(document['email']),
                Text(document['description']),
                Text(document['file']),
                Text(document['uid']),
                Text(document['status']),
              ]),
        ),
      ),
    );
  }
}
