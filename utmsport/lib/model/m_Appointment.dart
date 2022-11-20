class Appointment {
  String from = "";
  String to = "";
  String background = "";
  String startTimeZone = "";
  String endTimeZone = "";
  String description = "";
  bool isAllDay = false;
  String eventName = "";
  String ids = "";

  Appointment({
    required this.from,
    required this.to,
    required this.background,
    required this.startTimeZone,
    required this.endTimeZone,
    required this.description,
    required this.isAllDay,
    required this.eventName,
    required this.ids,
  });
}
