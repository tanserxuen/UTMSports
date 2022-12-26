class AppointmentDetail{

  DateTime dateTime;
  String eventDescp;
  String eventTitle;
  String email;
  String file;
  String matricno;
  String name;
  String phoneno;
  String pic;
  String status;
  String uid;
  String docid;

  AppointmentDetail({
    required this.dateTime,
    required this.eventDescp,
    required this.eventTitle,
    required this.email,
    required this.file,
    required this.matricno,
    required this.name,
    required this.phoneno,
    required this.pic,
    required this.status,
    required this.uid,
    required this.docid
  });

  Map<String, dynamic> toJson() => {
    "dateTime": dateTime,
    "eventDescp": eventDescp,
    "eventTitle": eventTitle,
    "email": email,
    "file": file,
    "matricno": matricno,
    "name": name,
    "phoneno": phoneno,
    "pic": pic,
    "status": status,
    "uid": uid,
    "docid": docid,
  };

}