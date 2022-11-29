import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:utmsport/view_model/adminPost/vm_eventCard.dart';

class LatestEventWall extends StatefulWidget {
  const LatestEventWall({Key? key}) : super(key: key);

  @override
  State<LatestEventWall> createState() => _LatestEventWallState();
}

class _LatestEventWallState extends State<LatestEventWall> {
  final CollectionReference productList =
      FirebaseFirestore.instance.collection("events");
  List events = [];

  Future<List?> getEvents() async {
    List _events = [];

    try {
      await productList.get().then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          print(element.data());
          _events.add(element.data());
        });
      });

      return _events; // This is missing
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    getEvents().then((data) {
      setState(() {
        this.events = data!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    getEvents();
    //TODO: loading vs no events added
    if (this.events.length == 0) {
      return Center(child: CircularProgressIndicator());
    }
    if (this.events.length == 0) {
      return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text("No events added"),
      );
    }
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('events')
          // .where("date", isGreaterThanOrEqualTo: new DateTime.now())
          .snapshots(),
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot doc = snapshot.data!.docs[index];
                // if(index == 0){
                //   return Text("${snapshot.data!.docs.length}");
                // }else
                return EventCard(context, index, doc);
              });
        }
        if(snapshot.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator());
        return Text('Somethings Error');
      },
    );
  }
}
