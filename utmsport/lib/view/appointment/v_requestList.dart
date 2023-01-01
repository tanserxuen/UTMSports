import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:utmsport/view/appointment/v_requestMeetingList.dart';
import 'package:utmsport/view/appointment/v_timeAvailableMeet.dart';

class RequestListPage extends StatefulWidget {
  const RequestListPage({Key? key}) : super(key: key);

  @override
  State<RequestListPage> createState() => _RequestListPageState();
}

class _RequestListPageState extends State<RequestListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => RequestMeetingList()));
            },
            child: Container(
              width: 500,
              height: 120,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.red,
              ),
              child: Stack(
                  textDirection: TextDirection.ltr, // Clip the Content
                  children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Meeting Request',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text('Click to Book Now')
                      ],
                    ),
                  ),
                  Positioned(
                    right: -10,
                    top: 50,
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue,
                      ),
                      transform: Matrix4.rotationZ(-0.3),
                    ),
                  ),
                ]
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 500,
              height: 120,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.red,
              ),
              child: Stack(
                  textDirection: TextDirection.ltr, // Clip the Content
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Training Court Booked',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Text('Click to Book Now')
                        ],
                      ),
                    ),
                    Positioned(
                      right: -10,
                      top: 50,
                      child: Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blue,
                        ),
                        transform: Matrix4.rotationZ(-0.3),
                      ),
                    ),
                  ]
              ),
            ),
          ),
          Text("Update Meeting Timeslot"),
          ElevatedButton.icon(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => TimesAvailableMeet()));
            },
            icon: Icon(Icons.access_time), label: Text("Update Meet Available"),)
        ],
      ),
    );
  }
}
