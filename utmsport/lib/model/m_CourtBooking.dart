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
  dynamic dateList; //List<DateTime> to tackle adv
  dynamic resourceIds = [];
  String matric1;
  String matric2;
  String matric3;
  String matric4;
  String sportType;

  //sports training
  String remarks;
  String couch;
  dynamic athletes = [];

  //adv booking
  String attachment;
  String personInCharge;

  //adv&sports
  String phoneNo;

  //all
  String bookingType;

  CourtBooking({
    required this.id,
    required this.userId,
    required this.subject,
    this.isAllDay: false,
    required this.color,
    required this.status,
    required this.createdAt,
    required this.startTime,
    this.endTime,
    this.dateList,

    //student booking
    this.resourceIds,
    this.matric1: "",
    this.matric2: "",
    this.matric3: "",
    this.matric4: "",
    this.sportType: "",

    //sports training
    this.remarks = "",
    this.couch = "",
    this.athletes = "", //list of matrics or user id

    //adv booking
    this.attachment = "",
    this.personInCharge = "",

    //adv&sports
    this.phoneNo = "",

    //all
    // Training, Sport Events, Club Events
    this.bookingType = "",
  });

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
        "phoneNo": phoneNo,
        "bookingType": bookingType,
      };

  Map<String, dynamic> stuToJson() => {
        "id": id,
        "userId": userId,
        "startTime": startTime,
        "endTime": endTime,
        "subject": subject,
        "status": status,
        "createdAt": createdAt,
        // "resourceIds": resourceIds,
        "isAllDay": isAllDay,
        "color": color,
        "matric1": matric1,
        "matric2": matric2,
        "matric3": matric3,
        "matric4": matric4,
        "sportType": sportType,
        "bookingType": bookingType
      };
}
