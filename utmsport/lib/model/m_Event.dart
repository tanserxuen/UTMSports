import 'dart:convert';
import 'package:flutter/material.dart';
import "package:utmsport/globalVariable.dart" as global;
import 'package:utmsport/utils.dart';
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

void deleteEvents(context, id) async {
  var eventColl = global.FFdb.collection('events');
  eventColl.where("id", isEqualTo: id).get().then((value) {
    value.docs.forEach((element) {
      eventColl.doc(element.id).delete().then((value) {
        Utils.showSnackBar('deleted an event');
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
