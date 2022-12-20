import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:utmsport/model/m_MeetAppointment.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:utmsport/view/appointment/v_readerScreen.dart';


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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Date: ' + document['date']),
                  Text('Timeslot: ' + document['time']),
                ],
              ),
              Row(
                children: [
                  Expanded(child: Text('Name Event Organizer: ')),
                  Container(
                      color: Colors.red,
                      child: Text(document['name']))
                ],
              ),
              Row(
                children: [
                  Expanded(child: Text('Matric No: ')),
                  Container(
                      color: Colors.orange,
                      child: Text(document['matricno']))
                ],
              ),
              Row(
                children: [
                  Expanded(child: Text('Phone Number: ')),
                  Container(
                      color: Colors.red,
                      child: Text(document['phoneno']))
                ],
              ),
              Row(
                children: [
                  Expanded(child: Text('Email Address: ')),
                  Container(
                      color: Colors.red,
                      child: Text(document['email']))
                ],
              ),
              SizedBox(height: 20,),
              Row(
                children: [
                  Expanded(child: Text('Person in Charge: ')),
                  Container(
                      color: Colors.red,
                      child: Text(document['pic']))
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
                              document['description'],
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
                  color: document['status'] == "pending" ? Colors.yellow : Colors.transparent,
                  border: Border.all(
                    color: document['status'] == 'approved'
                      ? Colors.green : document['status'] == 'rejected'
                      ? Colors.red  : Colors.yellow,
                    width: 1,
                  )
                ),
                child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          document['status'],
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
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => ReaderScreen(document['file'])));
                  } ,
                title: Text(document['file'], overflow: TextOverflow.ellipsis,),
                leading: Icon(Icons.picture_as_pdf, color: Colors.red, size: 32,),
              ),

            ]),
      ),
    );
  }
}
