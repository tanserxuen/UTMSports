//
// class Appointment{
//   final String title;
//   final String time;
//   final String date;
//   final String pic;
//   final String matricNo;
//   final String phoneNo;
//   final String description;
//
//   Appointment({
//     required this.title,
//     required this.time,
//     required this.date,
//     required this.pic,
//     required this.matricNo,
//     required this.phoneNo,
//     required this.description,
//
//   });
//   Map<String, dynamic> toJson() => {
//     'title': title,
//     'time': time,
//     'date': date,
//     'pic': pic,
//     'matricNo': matricNo,
//     'phoneNo': phoneNo,
//     'description': description,
//   };
//
//   static Appointment fromJson(Map<String, dynamic> json) => Appointment(
//     title: json['title'],
//     time: json['time'],
//     date: json['date'],
//     pic: json['pic'],
//     matricNo: json['matricNo'],
//     phoneNo: json['phoneNo'],
//     description: json['description'],
//   );
// }