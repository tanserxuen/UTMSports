class StuAppointment {
  dynamic startTime = "";
  dynamic endTime = "";
  List resourceIds = [];
  String subject = "";
  bool isAllDay = false;
  String color = "";
  String id = "";

  String name1 = "";
  String matric1 = "";
  String name2 = "";
  String matric2 = "";
  String name3 = "";
  String matric3 = "";
  String name4 = "";
  String matric4 = "";

  StuAppointment({
    required this.startTime,
    required this.endTime,
    required this.resourceIds,
    required this.subject,
    required this.isAllDay,
    required this.color,
    required this.id,
    required this.name1,
    required this.matric1,
    required this.name2,
    required this.matric2,
    required this.name3,
    required this.matric3,
    required this.name4,
    required this.matric4,
  });

  Map<String, dynamic> toJson() => {
    "startTime": startTime,
    "endTime": endTime,
    "resourceIds": resourceIds,
    "subject": subject,
    "isAllDay": isAllDay,
    "color": color,
    "id": id,
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
