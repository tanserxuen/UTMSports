import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:utmsport/model/m_MasterBooking.dart';
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
  getAppointments(appointments, appData);
  return DataSource(appointments, resources);
}

List<CalendarResource> getCourts(resources) {
  for (int index = 1; index <= global.badmintonCourt; index++) {
    resources.add(
      CalendarResource(
        id: "${index.toString().padLeft(4, '0')}",
        displayName: "Court $index",
        color: (index) % 2 == 1 ? Colors.amber : Colors.orangeAccent,
      ),
    );
  }
  return resources;
}

Map getCourtTimeslotDisplay(booked, subject, color) {
  String date = booked.keys.toList()[0];
  List slots = booked.values.toList()[0], times = [];
  int timeslot = 0;
  var resourceIds = [], startTime = [], endTime = [];
  var court, iterate = 0;
  print(booked);
  for (int j = 0; j < slots.length; j++) {
    var slot = slots[j];
    var slotValue = slot.split(' ');
    String dateToParse = date.split(' ')[0];
    String timeToParse = global.timeslot[int.parse(slotValue[1])];
    // print(slotValue[1]);
    if (court == null) {
      court = slotValue[0];
      iterate = 1;
      startTime.add(DateTime.parse("$dateToParse $timeToParse"));
      resourceIds.add("${court.toString().padLeft(4, '0')}" as Object);
      // print("null ${slotValue[0]} iterate $iterate");

    } else if (slotValue[0] == court) {
      timeslot = int.parse(slotValue[1]);
      endTime.add(DateTime.parse("$dateToParse $timeToParse")
          .add(Duration(minutes: 30 * iterate)));
      iterate = 0;
      // print("remain ${slotValue[0]} iterate $iterate");

    } else if (slotValue[0] != court) {
      court = slotValue[0];
      iterate += 1;
      startTime.add(DateTime.parse("$dateToParse $timeToParse"));
      resourceIds.add("${court.toString().padLeft(4, '0')}" as Object);
      // print("updated ${slotValue[0]} iterate $iterate");
    }
    if (j == slots.length - 1 && startTime.length != endTime.length) {
      endTime.add(DateTime.parse("$dateToParse $timeToParse")
          .add(Duration(minutes: 30)));
    }
  }
  // print("startTimeeeeeee ${startTime}");
  // print("endTimeeeeeee ${endTime}");
  return {
    'subject': subject,
    'color': color,
    'startTime': startTime,
    'endTime': endTime,
    'resourceIds': resourceIds.toList().cast<Object>(),
  };
}

void getAppointments(appointments, appData) {
  if (appData.length == 0) return;

  var appointmentList = [], subject, color;
  appData.forEach((appDetails) {
    // subject = appDetails['subject'];
    print(appDetails['subject']);
    // color = Color(int.parse(appDetails['color']));
    appointmentList.add(
      appDetails['startTime'].map((booked) => getCourtTimeslotDisplay(booked,
          appDetails['subject'], Color(int.parse(appDetails['color'])))),
    );
  });
  appointmentList.forEach((e) {
    e.forEach((element) {
      for (int i = 0; i < element['startTime'].length; i++) {
        print(" ===================================");
        // print({
        //   "endTime": element['endTime'].length,
        //   "startTime": element['startTime'].length,
        //   "resourceIds": element['resourceIds'],
        //   "i":i,
        // });
        appointments.add(Appointment(
          // subject: subject,
          subject: element['subject'],
          color: element['color'],
          endTime: element['endTime'][i],
          startTime: element['startTime'][i],
          resourceIds: element['resourceIds'],
          notes: element['resourceIds'].toString(),
          location: "Sports Hall 1"
        ));
      }
    });
  });
}

final timeSlotViewSettings = TimeSlotViewSettings(
  minimumAppointmentDuration: Duration(minutes: 30),
  timelineAppointmentHeight: 100,
  startHour: 10,
  endHour: 20,
  nonWorkingDays: <int>[DateTime.friday, DateTime.saturday],
);

final resourceViewSettings = ResourceViewSettings(
  size: 60,
  showAvatar: false,
  visibleResourceCount: 8,
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
      iconData: Icons.restaurant,
      textStyle: TextStyle(color: Colors.black45, fontSize: 25),
      text: 'Break',
    ),
  );
  return regions;
}

List<CalendarView> getAllowedViews(bool isAdmin) => isAdmin
    ? <CalendarView>[
        CalendarView.schedule,
        CalendarView.timelineDay,
        CalendarView.timelineMonth,
        CalendarView.month
      ]
    : <CalendarView>[CalendarView.schedule, CalendarView.timelineDay];

getCalendarView(isAdmin, stuView) =>
    isAdmin || stuView ? CalendarView.month : CalendarView.timelineDay;
