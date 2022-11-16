import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class BookingCalendar extends StatefulWidget {
  // const BookingCalendar({Key? key}) : super(key: key);

  @override
  State<BookingCalendar> createState() => _BookingCalendarState();
}

class _BookingCalendarState extends State<BookingCalendar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SfCalendar(
        view: CalendarView.timelineDay,
        dataSource: _getCalendarDataSource(),
        resourceViewSettings: ResourceViewSettings(
          showAvatar: false,
          visibleResourceCount: 4,
          size: 60,
          displayNameTextStyle: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 15,
              fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class DataSource extends CalendarDataSource {
  DataSource(List<Appointment> source, List<CalendarResource> resourceColl) {
    appointments = source;
    resources = resourceColl;
  }
}

DataSource _getCalendarDataSource() {
  List<Appointment> appointments = <Appointment>[];
  List<CalendarResource> resources = <CalendarResource>[];

  appointments.add(
    Appointment(
      startTime: DateTime.now(),
      endTime: DateTime.now().add(Duration(hours: 2)),
      isAllDay: true,
      subject: 'Meeting',
      color: Colors.blue,
      resourceIds: ['0001'],
    ),
  );

  appointments.add(Appointment(
    startTime: DateTime(2022, 11, 15, 08, 0, 0),
    endTime: DateTime(2022, 11, 15, 12, 0, 0),
    subject: 'General Meeting',
    color: Colors.red,
    resourceIds: ['0002', '0003'],
  ));

  appointments.add(Appointment(
    startTime: DateTime(2022, 11, 15, 08, 0, 0),
    endTime: DateTime(2022, 11, 15, 12, 0, 0),
    subject: 'Demo App',
    color: Colors.redAccent,
    resourceIds: ['0002', '0003'],
  ));

  resources.add(CalendarResource(
      displayName: 'Court 1', id: '0001', color: Colors.orangeAccent));
  resources.add(CalendarResource(
      displayName: 'Court 2', id: '0002', color: Colors.amber));
  resources.add(CalendarResource(
      displayName: 'Court 3', id: '0003', color: Colors.orangeAccent));

  return DataSource(appointments, resources);
}
