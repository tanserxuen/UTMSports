import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

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
        appointments.add(Appointment(
          startTime: _parseDateFormat(appDetails['startTime']),
          endTime: _parseDateFormat(appDetails['endTime']),
          subject: appDetails['subject'],
          color: Color(int.parse(appDetails['color'])),
          resourceIds: List.from(appDetails['resourceIds']),
        ))
      });
}

DateTime _parseDateFormat(timestamp) =>
    DateFormat("yyyy-MM-dd hh:mm:ss").parse(timestamp.toDate().toString());

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

final timeSlotViewSettings = TimeSlotViewSettings(
  // timeIntervalHeight: 50,
  minimumAppointmentDuration: Duration(minutes: 30),
  timelineAppointmentHeight: 100,
  startHour: 10,
  endHour: 20,
  nonWorkingDays: <int>[DateTime.friday, DateTime.saturday],
);

final resourceViewSettings = ResourceViewSettings(
  showAvatar: false,
  visibleResourceCount: 8,
  size: 60,
  displayNameTextStyle: TextStyle(
      fontStyle: FontStyle.italic, fontSize: 15, fontWeight: FontWeight.w700),
);

final appointmentDetails = [
  Appointment(
    startTime: DateTime(2022, 11, 20, 10, 0, 0),
    endTime: DateTime(2022, 11, 20, 11, 0, 0).add(Duration(hours: 2)),
    isAllDay: true,
    subject: 'Meeting',
    color: Colors.blue,
    resourceIds: ['0001'],
  ),
  Appointment(
    startTime: DateTime(2022, 11, 21, 14, 0, 0),
    endTime: DateTime(2022, 11, 21, 16, 0, 0),
    subject: 'Demo App',
    color: Colors.redAccent,
    resourceIds: ['0004', '0007'],
  ),
  Appointment(
    startTime: DateTime(2022, 11, 20, 10, 0, 0),
    endTime: DateTime(2022, 11, 20, 12, 0, 0),
    subject: 'Rest',
    color: Colors.yellow,
    resourceIds: ['0002', '0003'],
  )
];

List<TimeRegion> getBreakTime() {
  final List<TimeRegion> regions = <TimeRegion>[];
  regions.add(
    TimeRegion(
      startTime: DateTime(2022, 11, 13, 12, 0, 0),
      endTime: DateTime(2022, 11, 13, 12, 0, 0).add(Duration(hours: 2)),
      enablePointerInteraction: false,
      color: Colors.grey.withOpacity(0.2),
      recurrenceRule: 'FREQ=DAILY;INTERVAL=1',
      iconData: Icons.restaurant,
      textStyle: TextStyle(color: Colors.black45, fontSize: 25),
      text: 'Break',
    ),
  );
  return regions;
}
