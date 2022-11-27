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
    if (this.events == []) {
      return CircularProgressIndicator();
    }
    return ListView.builder(
      padding: const EdgeInsets.all(5.5),
      itemCount: this.events.length,
      itemBuilder: (ctxt, index) => EventCard(ctxt, index, this.events),
    );
  }

}
