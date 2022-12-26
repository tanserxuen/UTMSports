import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'package:utmsport/globalVariable.dart' as global;
import 'package:utmsport/view_model/studentBooking/vm_courtCalendarDataSource.dart';

class BookingCalendar extends StatefulWidget {
  const BookingCalendar({Key? key}) : super(key: key);

  @override
  State<BookingCalendar> createState() => _BookingCalendarState();
}

class _BookingCalendarState extends State<BookingCalendar> {
  late List appData = [];
  final timeNow = DateTime.now();
  bool stuView = false;
  final isAdmin = global.getUserRole() == 'stud';

  CalendarController _calendarController = CalendarController();
  final CollectionReference appointmentList =
      FirebaseFirestore.instance.collection("student_appointments");

  @override
  void initState() {
    super.initState();
    fetchAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildStudentViewButton(isAdmin, stuView),
          _buildAdvancedCalendarView(),
        ],
      ),
    ));
  }

  fetchAppointments() async {
    List _appData = [];
    try {
      await appointmentList.get().then((querySnapshot) {
        querySnapshot.docs.forEach((element) => _appData.add(element.data()));
      });
      setState(() => this.appData = _appData);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Widget _buildStudentViewButton(isAdmin, stuView) {
    return Visibility(
      visible: isAdmin,
      child: ElevatedButton(
        onPressed: () => stuView = true,
        child: Text("Student View"),
      ),
    );
  }

  Widget _buildAdvancedCalendarView() {
    bool canShowStudentView = isAdmin || stuView;
    final today = canShowStudentView
        ? null
        : DateTime(timeNow.year, timeNow.month, timeNow.day);
    final tomorrow = canShowStudentView
        ? null
        : DateTime(timeNow.year, timeNow.month, timeNow.day, 23, 59, 59);
    //TODO: think adv can book multiple date, so how to store data to display in calendar view
    return Expanded(
      child: SfCalendar(
        controller: _calendarController,
        view: getCalendarView(isAdmin, stuView),
        minDate: today,
        maxDate: tomorrow,
        dataSource: getCalendarBookingData(this.appData),
        showDatePickerButton: canShowStudentView ? true : false,
        allowViewNavigation: canShowStudentView ? true : false,
        allowedViews: getAllowedViews(isAdmin),
        timeSlotViewSettings: timeSlotViewSettings,
        specialRegions: canShowStudentView ? null : getBreakTime(),
        resourceViewSettings: resourceViewSettings,
      ),
    );
  }
}
