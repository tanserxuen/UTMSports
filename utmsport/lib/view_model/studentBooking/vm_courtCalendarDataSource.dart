import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:utmsport/globalVariable.dart' as global;

import '../../utils.dart';

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

  List bookedCourts =
      slots.map((e) => e.split(' ')[1].toString()).toSet().toList();
  List<List<String>> consecutiveTimeslotSort = [];
  bookedCourts.forEach((court) {
    //filter slots of the same court number
    List a = slots.where((f) => f.split(" ")[1] == court).toList();
    //make one group if the timeslot is consecutive
    List<List<String>> b = consecutive_groups(
      a.map<int>((e) => int.parse(e.split(" ")[0])).toList(),
      a[0].split(" ")[1],
    );
    consecutiveTimeslotSort = [...consecutiveTimeslotSort, ...b];
  });
  return {'slotsSorted': slots, 'slotsInGroup': consecutiveTimeslotSort};
}

List<List<String>> consecutive_groups(List<int> a, String court) {
  a.sort();
  List<List<String>> result = [];
  List<String> temp = [];
  temp.add("${a[0]} $court");

  for (int i = 0; i < a.length - 1; i++) {
    if (a[i + 1] == a[i] + 1) {
      temp.add("${a[i + 1]} $court");
    } else {
      result.add(temp);
      temp = [];
      temp.add("${a[i + 1]} $court");
    }
  }
  result.add(temp);
  return result;
}

void getCourtTimeslotDisplay(appointments, booked, subject, color, id, strt) {
  String date = booked.keys.toList()[0];
  List slots = booked.values.toList()[0];
  var data = sortSlots(slots);
  slots = data['slotsSorted'];
  // String courtsInSingleBooking =
  //     slots.map((e) => e.split(' ')[1].toString()).toSet().toList().join(", ");
  //
  // strt.map((e) => e.entries.toList());
  // String locationString = "";
  // var slotss = strt.map((e) => e.values.toList()[0]).toList();
  // var dates = strt.map((e) => e.keys.toList()[0]).toList();
  // // print(dates);
  // for (int i = 0; i < dates.length; i++) {
  //   var courtss= slotss[i].map((e) => e.split(" ")[1]).join(", ");
  //   var tss= slotss[i].map((e) => e.split(" ")[0]).join(", ");
  //   int tssMax = int.parse(tss.reduce(math.max) - 1);
  //   int tssMin = int.parse(tss.reduce(math.min) - 1);
  //   locationString =
  //       "$locationString ${Utils.parseDateTimeToFormatDate(DateTime.parse(dates[i]))}: ${global.timeslot[tssMin]}- ${global.timeslot[tssMax]} Court ${courtss}";
  // }
  // print("$subject $locationString");

  data['slotsInGroup'].forEach((slotGroup) {
    String dateString = date.split(' ')[0];
    String court = slotGroup[0].split(" ")[1].toString().padLeft(4, '0');
    List<int> timeslots =
        slotGroup.map<int>((e) => int.parse(e.split(' ')[0])).toList();
    int max = timeslots.reduce(math.max) - 1;
    int min = timeslots.reduce(math.min) - 1;
    appointments.add(
      Appointment(
        subject: "$subject",
        color: color,
        startTime: DateTime.parse("$dateString ${global.timeslot[min]}"),
        endTime: DateTime.parse("$dateString ${global.timeslot[max]}")
            .add(Duration(minutes: 30)),
        resourceIds: [court].cast<Object>(),
        notes: id,
        location: "Sports Hall 1: Court ${slotGroup[0].split(" ")[1]}",
      ),
    );
  });
}

void getAppointments(appointments, appData) {
  if (appData.length == 0) return;
  var appointmentList = [];
  appData.forEach((appDetails) {
    appointmentList.add(
      appDetails['startTime'].forEach(
        (booked) => getCourtTimeslotDisplay(
            appointments,
            booked,
            appDetails['subject'],
            Color(
              int.parse(appDetails['color']),
            ),
            appDetails["id"],
            appDetails['startTime']),
      ),
    );
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

Widget scheduleViewHeaderBuilder(
    BuildContext buildContext, ScheduleViewMonthHeaderDetails details) {
  final String monthName = _getMonthName(details.date.month);
  return Stack(
    children: [
      Image(
        image: ExactAssetImage('assets/images/' + monthName + '.png'),
        fit: BoxFit.contain,
        width: details.bounds.width,
        height: details.bounds.height,
      ),
    ],
  );
}

String _getMonthName(int month) {
  if (month == 01) {
    return 'jan';
  } else if (month == 02) {
    return 'feb';
  } else if (month == 03) {
    return 'mar';
  } else if (month == 04) {
    return 'apr';
  } else if (month == 05) {
    return 'may';
  } else if (month == 06) {
    return 'jun';
  } else if (month == 07) {
    return 'jul';
  } else if (month == 08) {
    return 'aug';
  } else if (month == 09) {
    return 'sept';
  } else if (month == 10) {
    return 'oct';
  } else if (month == 11) {
    return 'nov';
  } else {
    return 'dec';
  }
}
