import 'package:flutter/material.dart';

enum STATUS { rejected, approved, pending }

class CourtBooking {
  String id;
  String userId;
  String subject;
  bool isAllDay;
  String color;
  String status;
  dynamic createdAt;

  dynamic startTime; //List<DateTime> to tackle adv
  dynamic endTime; //List<DateTime> to tackle adv
  dynamic resourceIds = [];
  String name1;
  String matric1;
  String name2;
  String matric2;
  String name3;
  String matric3;
  String name4;
  String matric4;

  //sports training
  String remarks;
  String couch;
  dynamic athletes = [];

  //adv booking
  String attachment;
  String personInCharge;

  //adv&sports
  String phoneNo;

  CourtBooking({
    required this.id,
    required this.userId,
    required this.subject,
    this.isAllDay: false,
    required this.color,
    required this.status,
    required this.createdAt,
    required this.startTime,
    required this.endTime,

    //student booking
    this.resourceIds,
    this.name1: "",
    this.matric1: "",
    this.name2: "",
    this.matric2: "",
    this.name3: "",
    this.matric3: "",
    this.name4: "",
    this.matric4: "",

    //sports training
    this.remarks = "",
    this.couch = "",
    this.athletes = "", //list of matrics or user id

    //adv booking
    this.attachment = "",
    this.personInCharge = "",

    //adv&sports
    this.phoneNo = "",
  });

  final colorCollection = () {
    List colors = [
      Colors.redAccent,
      Colors.amber,
      Colors.orangeAccent,
      Colors.blueAccent,
      Colors.greenAccent,
      Colors.pink,
      Colors.purpleAccent,
      Colors.yellowAccent,
      Colors.white54,
    ];
    return colors.map((e) => e.value.toRadixString(16));
  };

  Map<String, dynamic> advToJson() => {
        "id": id,
        "userId": userId,
        "subject": subject,
        "color": color,
        "status": status,
        "createdAt": createdAt,
        "personInCharge": personInCharge,
        "attachment": attachment,
        "startTime": startTime,
        "endTime": endTime,
      };

  Map<String, dynamic> stuToJson() => {
        "id": id,
        "userId": userId,
        "startTime": startTime,
        "endTime": endTime,
        "subject": subject,
        "status": status,
        "createdAt": createdAt,
        "resourceIds": resourceIds,
        "isAllDay": isAllDay,
        "color": color,
        "name1": name1,
        "matric1": matric1,
        "name2": name2,
        "matric2": matric2,
        "name3": name3,
        "matric3": matric3,
        "name4": name4,
        "matric4": matric4,
      };
}
