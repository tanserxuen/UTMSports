import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:utmsport/globalVariable.dart' as global;

import 'package:utmsport/view_model/adminPost/vm_eventCard.dart';
import 'package:utmsport/model/m_Event.dart';
import 'package:utmsport/view/authentication/v_homePage.dart';

import 'package:utmsport/utils.dart';

class LatestEventWall extends StatefulWidget {
  const LatestEventWall({Key? key}) : super(key: key);

  @override
  State<LatestEventWall> createState() => _LatestEventWallState();
}

class _LatestEventWallState extends State<LatestEventWall> {
  List events = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: global.FFdb.collection('events')
            // .where("date", isGreaterThanOrEqualTo: new DateTime.now())
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text("Something went wrong");
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          if (!snapshot.hasData)
            return MyHomePage();
          else
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var eventObj = snapshot.data!.docs[index];
                  Event event = Event(
                    id: eventObj['id'],
                    name: eventObj['name'],
                    description: eventObj['description'],
                    date: Utils.parseTimestampToDateTime(eventObj['date']),
                    image: eventObj['image'],
                    venue: eventObj['venue'],
                    platform: eventObj['platform'],
                  );
                  return EventCard(context, index, event);
                });
        });
  }
}
