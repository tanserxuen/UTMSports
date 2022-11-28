import 'dart:convert';
import 'package:flutter/material.dart';
import "package:utmsport/globalVariable.dart" as global;
import 'package:utmsport/view/adminPost/v_createEvent.dart';

class Event {
  String id;
  String name;
  String description;
  String date;
  String image;
  String venue;
  String platform;

  Event({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
    this.image = "https://www.freeiconspng.com/img/23485",
    this.venue = "",
    this.platform = "",
  });

  factory Event.fromRawJson(String str) => Event.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        date: json["date"],
        image: json["image"],
        venue: json["venue"],
        platform: json["platform"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "date": date,
        "image": image,
        "venue": venue,
        "platform": platform,
      };
}

List<Event> getEmployeeData() {
  return [
    Event(
      id: '0001',
      name: "Joan",
      description: "simple event",
      date: "2022-11-12",
      image: "abc.png",
      venue: "L50 BK1",
      platform: "https://meet.google.com/yww-kpsv-zhr",
    ),
    Event(
      id: '0001',
      name: "Joan",
      description: "simple event",
      date: "2022-11-12",
      image: "abc.png",
      venue: "L50 BK1",
      platform: "https://meet.google.com/yww-kpsv-zhr",
    ),
    Event(
      id: '0001',
      name: "Joan",
      description: "simple event",
      date: "2022-11-12",
      image: "abc.png",
      venue: "L50 BK1",
      platform: "https://meet.google.com/yww-kpsv-zhr",
    ),
    Event(
      id: '0001',
      name: "Joan",
      description: "simple event",
      date: "2022-11-12",
      image: "abc.png",
      venue: "L50 BK1",
      platform: "https://meet.google.com/yww-kpsv-zhr",
    ),
    Event(
      id: '0001',
      name: "Joan",
      description: "simple event",
      date: "2022-11-12",
      image: "abc.png",
      venue: "L50 BK1",
      platform: "https://meet.google.com/yww-kpsv-zhr",
    ),
    Event(
      id: '0001',
      name: "Joan",
      description: "simple event",
      date: "2022-11-12",
      image: "abc.png",
      venue: "L50 BK1",
      platform: "https://meet.google.com/yww-kpsv-zhr",
    ),
  ];
}

void deleteEvents(id) async {
  var eventColl = global.FFdb.collection('events');
  eventColl.where("id", isEqualTo: id).get().then((value) {
    value.docs.forEach((element) {
      eventColl.doc(element.id).delete().then((value) {
        print("Success!");
      });
    });
  });
}

void editEvents(context, event) async {
  // print(event);
  Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => FormScreen(eventModel: event, formType: "edit")),
  );
}
