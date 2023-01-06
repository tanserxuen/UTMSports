import 'dart:convert';
import 'dart:math' as math;
import "package:collection/collection.dart";
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

Map sortSlots(slots) {
  //to order by courts
  slots.sort((a, b) {
    String aCourt = a.split(" ")[1];
    String bCourt = b.split(" ")[1];
    return int.parse(aCourt).compareTo(int.parse(bCourt));
  });

  List ids = slots.map((e) => e.split(' ')[1].toString()).toSet().toList();
  List sorted = [];
  ids.forEach((e) {
    sorted.add(slots
        .where((f) => f.split(" ")[1] == e)
        .toList());
  });
  print(sorted);
  return {'slotsSorted':slots, 'slotsInGroup':sorted};
}

Map getCourtTimeslotDisplay(booked, subject, color, id) {
  String date = booked.keys.toList()[0];
  List slots = booked.values.toList()[0], times = [];
  List resourceIds = slots
      .map((e) => e.split(' ')[1].toString().padLeft(4, '0'))
      .toSet()
      .toList();
  var a = sortSlots(slots);
  slots = a['slotsSorted'];
  List<DateTime> startTime = [], endTime = [];
  a['slotsInGroup'].forEach((slotGroup){
    String dateString = date.split(' ')[0];
    List<int> timeslots = slotGroup.map<int>((e)=>int.parse(e.split(' ')[0])).toList();
    int max = timeslots.reduce(math.max)-1;
    int min = timeslots.reduce(math.min)-1;
    print("$max $min");
    startTime.add(DateTime.parse("$dateString ${global.timeslot[min]}"));
    endTime.add(DateTime.parse("$dateString ${global.timeslot[max]}").add(Duration(minutes: 30)));
  });
  int iterate = 0;
  // print("---$resourceIds $slots");
  String tempTimeslot = "", tempCourt = "";
  // print("====================================== $subject $slots");
  // for (int j = 0; j < slots.length; j++) {
  //   var slot = slots[j];
  //   var slotValue = slot.split(' ');
  //   String dataTimeslot = slotValue[0], dataCourt = slotValue[1];
  //   String dateString = date.split(' ')[0];
  //   String timeString = global.timeslot[int.parse(slotValue[0]) - 1];
  //
  //   // print("+++$timeString");
  //   if (tempCourt == "") {
  //     // print(
  //     //     "dataCourt: $dataCourt    tempCourt: $tempCourt    resourceIds $resourceIds");
  //     tempCourt = dataCourt;
  //     tempTimeslot = dataTimeslot;
  //     iterate = 1;
  //     startTime.add(DateTime.parse("$dateString $timeString"));
  //     // print(
  //     //     "null Number of Iterate: $iterate    dataCourt: $dataCourt    tempCourt: $tempCourt    tempTimeslot: $tempTimeslot     datatimeslot: $dataTimeslot     timeString: $timeString");
  //   } else if (tempCourt == dataCourt) {
  //     // print("dataCourt: $dataCourt    tempCourt: $tempCourt");
  //     tempTimeslot = dataTimeslot;
  //     iterate += 1;
  //     // print(
  //     //     "remain ${dataCourt} iterate $iterate   dataCourt: $dataCourt    tempCourt: $tempCourt    tempTimeslot: $tempTimeslot     datatimeslot: $dataTimeslot     timeString: $timeString");
  //   } else if (tempCourt != dataCourt) {
  //     // print("dataCourt: $dataCourt    tempCourt: $tempCourt");
  //     tempCourt = dataCourt;
  //     if (int.parse(tempTimeslot) + 1 != int.parse(dataTimeslot)) {
  //       startTime.add(DateTime.parse("$dateString $timeString"));
  //       endTime.add(DateTime.parse("$dateString $timeString")
  //           .add(Duration(minutes: 30 * iterate)));
  //       iterate = 1;
  //     } else {
  //       iterate += 1;
  //     }
  //     tempTimeslot = dataTimeslot;
  //
  //     // print(
  //     //     "updated ${dataCourt} iterate $iterate   dataCourt: $dataCourt    tempCourt: $tempCourt    tempTimeslot: $tempTimeslot     datatimeslot: $dataTimeslot     endTime: $endTime");
  //   }
  //   if (j == slots.length - 1) {
  //     endTime.add(
  //         DateTime.parse("$dateString $timeString").add(Duration(minutes: 30)));
  //     // print("$endTime $timeString");
  //     // resourceIds.add("${dataCourt.toString().padLeft(4, '0')}" as Object);
  //   }
  // }

  // print({'subject': subject,
  //   'color': color,
  //   'startTime': startTime,
  //   'endTime': endTime,
  //   'resourceIds': resourceIds.cast<Object>(),});
  // print(resourceIds.cast<Object>());
  return {
    'id': id,
    'subject': subject,
    'color': color,
    'startTime': startTime,
    'endTime': endTime,
    'resourceIds': resourceIds.cast<Object>(),
  };
}

void getAppointments(appointments, appData) {
  if (appData.length == 0) return;
  // print(appData);

  var appointmentList = [], subject, color;
  appData.forEach((appDetails) {
    // subject = appDetails['subject'];
    // print(appDetails['subject']);
    // color = Color(int.parse(appDetails['color']));
    appointmentList.add(
      appDetails['startTime'].map(
        (booked) => getCourtTimeslotDisplay(
          booked,
          appDetails['subject'],
          Color(
            int.parse(appDetails['color']),
          ),
          appDetails["id"],
        ),
      ),
    );
  });
  // print(appointmentList);
  appointmentList.forEach((e) {
    e.forEach((element) {
      // print("");
      // print("");
      // print("");
      // print("");
      // print(" ===================================${element['subject']}");
      for (int i = 0; i < element['startTime'].length; i++) {
        // print(element['startTime'].length);
        // print({
        //   "endTime": element['endTime'],
        //   "endTimeLength": element['endTime'].length,
        //   "startTime": element['startTime'],
        //   "startTimeLength": element['startTime'].length,
        //   "resourceIds": element['resourceIds'],
        //   // "i": i,
        // });
        appointments.add(
          Appointment(
            // subject: subject,
            subject: "${element['subject']}",
            color: element['color'],
            endTime: element['endTime'][i],
            startTime: element['startTime'][i],
            resourceIds: element['resourceIds'],
            notes: element['id'],
            location: "Sports Hall 1",
          ),
        );
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
