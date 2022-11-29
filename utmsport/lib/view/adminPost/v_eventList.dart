import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:utmsport/model/m_Event.dart';
import 'package:utmsport/view/adminPost/v_createEvent.dart';
import 'package:utmsport/view_model/adminPost/vm_eventDatatableWidget.dart';
import 'package:utmsport/view_model/adminPost/vm_eventDataSource.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

class EventList extends StatefulWidget {
  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  late EventDataSource _eventDataSource;

  final CollectionReference eventLists =
      FirebaseFirestore.instance.collection("events");
  List<Event> events = [];

  void getEvents() async {
    try {
      await eventLists.get().then((querySnapshot) {
        setState(() {
          this.events = querySnapshot.docs
              .map((event) => Event(
                    id: event['id'] ?? '',
                    name: event['name'] ?? '',
                    description: event['description'] ?? '',
                    date: event['date'] ?? '',
                    image: event['image'] ?? '',
                    venue: event['venue'] ?? '',
                    platform: event['platform'] ?? '',
                  ))
              .toList();
        });
        _eventDataSource = EventDataSource(events: this.events);
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    getEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8,16,8,16),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("List of Events",style: TextStyle(fontSize: 30,fontWeight: FontWeight.w700)),
                    ElevatedButton(
                      child: Text("Add Event"),
                      onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) => FormScreen())),
                    ),
                  ]),
            )),
        Expanded(flex: 6, child: EventDatatableWidget(_eventDataSource)),
      ],
    );
  }
}
