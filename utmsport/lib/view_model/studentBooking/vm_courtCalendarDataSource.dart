import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:utmsport/globalVariable.dart' as global;

class DataSource extends CalendarDataSource {
  DataSource(List<Appointment> source, List<CalendarResource> resourceColl) {
    appointments = source;
    resources = resourceColl;
  }
}

DataSource getCalendarBookingData(List appData) {
  late List<Appointment> appointments = <Appointment>[];
  late List<CalendarResource> resources = <CalendarResource>[];
  getCourts(resources);
  // print(DateTime.now());
  // print(DateTime(2022, 11, 13, 12, 0, 0));
  getAppointments(appointments, appData);
  return DataSource(appointments, resources);
}

List<CalendarResource> getCourts(resources) {
  for (int index = 1; index < 9; index++) {
    resources.add(
      CalendarResource(
        // displayName: "Court $index",
        id: "${index.toString().padLeft(4, '0')}",
        displayName: "Court $index",
        color: (index) % 2 == 1 ? Colors.amber : Colors.orangeAccent,
      ),
    );
  }
  return resources;
}

void getAppointments(appointments, appData) {
  appData.forEach((appDetails) => {
        // if (appDetails['id'] == 'cuktubE2pvNRJbtLlSxD')
        if (appDetails['id'] == global.FA.currentUser!.uid)
          appointments.add(Appointment(
            startTime: _parseDateFormat(appDetails['startTime']),
            // startTime: DateTime.now(),
            // endTime: DateTime.now().add(Duration(hours: 2)),
            endTime: _parseDateFormat(appDetails['endTime']),
            subject: 'Your Booking',
            color: Color(int.parse(appDetails['color'])),
            resourceIds: List.from(appDetails['resourceIds']),
          ))
        else
          appointments.add(Appointment(
            startTime: _parseDateFormat(appDetails['startTime']),
            endTime: _parseDateFormat(appDetails['endTime']),
            subject: 'Anonymous Booked',
            color: Colors.grey,
            resourceIds: List.from(appDetails['resourceIds']),
          ))
      });
}

DateTime _parseDateFormat(timestamp) {
  var t = (timestamp as Timestamp).toDate();
  print(t);
  print(DateTime.now());
  return t;
}

final colorCollection = [
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

final resourceViewSettings = ResourceViewSettings(
  showAvatar: false,
  visibleResourceCount: 8,
  size: 60,
  displayNameTextStyle: TextStyle(
      fontStyle: FontStyle.italic, fontSize: 15, fontWeight: FontWeight.w700),
);

List<TimeRegion> getBreakTime() {
  final List<TimeRegion> regions = <TimeRegion>[];
  regions.add(
    TimeRegion(
      startTime: DateTime(2022, 11, 13, 12, 0, 0),
      endTime: DateTime(2022, 11, 13, 12, 0, 0).add(Duration(hours: 2)),
      enablePointerInteraction: false,
      color: Colors.grey.withOpacity(0.2),
      recurrenceRule: 'FREQ=DAILY;INTERVAL=1',
      // iconData: Icons.restaurant,
      textStyle: TextStyle(color: Colors.black45, fontSize: 25),
      // text: 'Break',
    ),
  );
  return regions;
}
