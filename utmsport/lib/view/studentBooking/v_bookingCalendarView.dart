import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:utmsport/view_model/studentBooking/vm_courtCalendarDataSource.dart';

class BookingCalendar extends StatefulWidget {
  const BookingCalendar({Key? key}) : super(key: key);

  @override
  State<BookingCalendar> createState() => _BookingCalendarState();
}

class _BookingCalendarState extends State<BookingCalendar> {
  CalendarController _calendarController = CalendarController();
  late Appointment _selectedAppointment;
  late int _selectedResourceIndex;

  final CollectionReference appointmentList =
      FirebaseFirestore.instance.collection("student_appointments");

  late List appData = [];

  Future<List?> getAppointmentsFromDB() async {
    List _appData = [];

    try {
      await appointmentList.get().then((querySnapshot) {
        querySnapshot.docs.forEach((element) => _appData.add(element.data()));
      });

      return _appData; // This is missing
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  @override
  void initState() {
    super.initState();

    getAppointmentsFromDB().then((data) {
      setState(() {
        this.appData = data!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    late dynamic appointment;
    late DateTime date;
    late CalendarElement element;
    late bool canBook = false;
    late Color bookBtnColor = canBook ? Colors.blue : Colors.grey;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

    var courtsToBook;

    return Column(
      children: [
        Text("$courtsToBook"),
        Expanded(
          child: SfCalendar(
            controller: _calendarController,
            onViewChanged: (ViewChangedDetails details) {
              List<DateTime> dates = details.visibleDates;
              print(dates);
            },
            onLongPress: (CalendarLongPressDetails  details) {
              appointment = details.appointments;
              date = details.date!;
              element = details.targetElement;
              // if (appointment == null && ) {
              //   courtsToBook
              // } else
              //   canBook = false;
              // canBook = appointment ?? true;
              print("appointment ${appointment}");
              print("date ${date}");
              print("element ${element.index}");
            },
            view: CalendarView.timelineDay,
            minDate: today,
            maxDate: tomorrow,
            dataSource: getCalendarBookingData(this.appData),
            // showDatePickerButton: true,
            allowViewNavigation: true,
            allowedViews: <CalendarView>[
              CalendarView.schedule,
              CalendarView.timelineDay
            ],
            timeSlotViewSettings: timeSlotViewSettings,
            specialRegions: getBreakTime(),
            resourceViewSettings: resourceViewSettings,
          ),
        ),
      ],
    );
  }
}
