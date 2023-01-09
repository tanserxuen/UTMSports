
class Training {
  Training({
    required this.createdAt,
    required this.appointmentId,
    required this.subject,
    required this.sport,
    required this.startDate,
    required this.startTime,
    required this.description,
  });

  DateTime createdAt;
  String appointmentId;
  String subject;
  String sport;
  String startDate;
  String startTime;
  String description;

  factory Training.fromJson(Map<String, dynamic> json) => Training(
    createdAt: json["created_at"],
    appointmentId: json['appointmentId'],
    subject: json["subject"],
    sport: json["sport"],
    startDate: json["startDate"],
    startTime: json["startTime"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "created_at": createdAt,
    "appointmentId": appointmentId,
    "subject": subject,
    "sport": sport,
    "startDate": startDate,
    "startTime": startTime,
    "description": description,
  };
}
