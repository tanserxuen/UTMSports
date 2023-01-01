// To parse this JSON data, do
//
//     final appointment = appointmentFromJson(jsonString);

import 'dart:convert';

class MeetAppointment {
  MeetAppointment({
    required this.date,
    required this.description,
    required this.email,
    required this.eventtitle,
    required this.file,
    required this.matricno,
    required this.name,
    required this.phoneno,
    required this.pic,
    required this.status,
    required this.time,
    required this.uid,
  });

  DateTime date;
  String description;
  String email;
  String eventtitle;
  String file;
  String matricno;
  String name;
  String phoneno;
  String pic;
  String status;
  String time;
  String uid;

  factory MeetAppointment.fromRawJson(String str) => MeetAppointment.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MeetAppointment.fromJson(Map<String, dynamic> json) => MeetAppointment(
    date: DateTime.parse(json["date"]),
    description: json["description"],
    email: json["email"],
    eventtitle: json["eventtitle"],
    file: json["file"],
    matricno: json["matricno"],
    name: json["name"],
    phoneno: json["phoneno"],
    pic: json["pic"],
    status: json["status"],
    time: json["time"],
    uid: json["uid"],
  );

  Map<String, dynamic> toJson() => {
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "description": description,
    "email": email,
    "eventtitle": eventtitle,
    "file": file,
    "matricno": matricno,
    "name": name,
    "phoneno": phoneno,
    "pic": pic,
    "status": status,
    "time": time,
    "uid": uid,
  };
}
