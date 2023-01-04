import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'package:utmsport/globalVariable.dart' as global;
import 'package:utmsport/view/advBooking/v_createAdvancedCalendar.dart';
import 'package:utmsport/view/advBooking/v_createAdvancedForm.dart';
import 'package:utmsport/view/shared/v_checkIn.dart';
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
  final isAdmin = global.getUserRole() == 'admin';

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
      await appointmentList
          // .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((querySnapshot) {
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
        showNavigationArrow: isAdmin || stuView ? true : false,
        monthViewSettings: MonthViewSettings(
            appointmentDisplayCount: 4,
            navigationDirection: MonthNavigationDirection.horizontal),
        dataSource: getCalendarBookingData(this.appData),
        showDatePickerButton: canShowStudentView ? true : false,
        allowViewNavigation: canShowStudentView ? true : false,
        allowedViews: getAllowedViews(isAdmin),
        timeSlotViewSettings: timeSlotViewSettings,
        specialRegions: canShowStudentView ? null : getBreakTime(),
        resourceViewSettings: resourceViewSettings,
        onTap: (CalendarTapDetails details) {
          // print(details);
          showModalBottomSheet(
              context: context,
              builder: (context) =>
                  _buildBottomModal(details.appointments, context));
        },
      ),
    );
  }

  Widget _buildBottomModal(appointment, context) {
    if (appointment == null)
      return Wrap(
        children: [
          Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("No appointments booked"),
                ElevatedButton(
                    onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateAdvBookingCalendar(),
                          ),
                        ),
                    child: Text("Book now!"))
              ],
            ),
          ),
        ],
      );
    var app = appointment![0];
    var courts = app!.resourceIds
        .map((id) => id.replaceAll(new RegExp(r'^0+(?=.)'), "Court "))
        .join(', ');
    var dayFormat = DateFormat("dd MMM yyy");
    var hourFormat = DateFormat("HH:mm a");
    return Wrap(
      children: [
        Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                children: [
                  Text(
                    "${app.subject}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                            "${dayFormat.format(app!.startTime).toString()}   ${hourFormat.format(app!.startTime).toString()} - ${hourFormat.format(app!.endTime).toString()}"),
                        Text("${app!.location}: $courts"),
                      ]),
                  if (global.getUserRole() == 'admin')
                    ElevatedButton(
                      onPressed: () => editAdv(app),
                      child: Text(
                        "Edit",
                      ),
                    )
                  else
                    ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckIn(),
                        ),
                      ),
                      child: Text(
                        "Check In",
                      ),
                    )
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  editAdv(appointment) async {
      List<DateTime> dateLists = [];
      List<List<String>> slotLists = [[]];
      await FirebaseFirestore.instance
          .collection('student_appointments')
          .where('id', isEqualTo: appointment.notes)
          .get()
          .then((val) {
        var ct = val.docs[0]['startTime'];
        dateLists = ct
            .map<DateTime>((e) => e.keys
            .map((f) => DateTime.parse(f))
            .toList()[0] as DateTime)
            .toList();
        slotLists=ct.map<List<String>>((e){
          var a= e.values.toList()[0];
          List<String> d =[];
          a.forEach((f){
            return d.add(f.toString());
          });
          return d;
        }).toList();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreateAdvBooking(
              dateList: dateLists,
              formType: "Edit",
              slotLists: slotLists,
              stuAppModel: val.docs[0],
            ),
          ),
        );
      });
    }
}
