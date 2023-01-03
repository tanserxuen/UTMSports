// // To parse this JSON data, do
// //
// //     final appointment = appointmentFromJson(jsonString);
//
// import 'dart:convert';
//
// class MeetAppointment {
//   CMcourtBooking({
//     required this.date,
//     required this.description,
//     required this.email,
//     required this.title,
//     required this.file,
//     required this.staffno,
//     required this.name,
//     required this.phoneno,
//     required this.status,
//     required this.time,
//     required this.uid,
//   });
//
//   DateTime date;
//   String description;
//   String email;
//   String title;
//   String file;
//   String staffno;
//   String name;
//   String phoneno;
//   String status;
//   String time;
//   String uid;
//
//   factory CMcourtBooking.fromRawJson(String str) => CMcourtBooking.fromJson(json.decode(str));
//
//   String toRawJson() => json.encode(toJson());
//
//   factory CMcourtBooking.fromJson(Map<String, dynamic> json) => CMcourtBooking(
//     date: DateTime.parse(json["date"]),
//     description: json["description"],
//     email: json["email"],
//     title: json["title"],
//     file: json["file"],
//     staffno: json["staffno"],
//     name: json["name"],
//     phoneno: json["phoneno"],
//     status: json["status"],
//     time: json["time"],
//     uid: json["uid"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
//     "description": description,
//     "email": email,
//     "title": title,
//     "file": file,
//     "staffcno": staffno,
//     "name": name,
//     "phoneno": phoneno,
//     "status": status,
//     "time": time,
//     "uid": uid,
//   };
// }
