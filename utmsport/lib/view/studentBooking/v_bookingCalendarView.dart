import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'package:utmsport/globalVariable.dart' as global;
import 'package:utmsport/view/shared/v_checkIn.dart';
import 'package:utmsport/view/studentBooking/v_createStuBooking_SportType.dart';
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildLegend(),
          _buildAdvancedCalendarView(),
        ],
      ),
    ));
  }

  fetchAppointments() async {
    List _appData = [];
    try {
      await appointmentList
          .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((element) => _appData.add(element.data()));
      });
      setState(() {
        this.appData = _appData;
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Widget _buildLegend() {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: Wrap(spacing: 6, runSpacing: 9, children: [
        Wrap(
          spacing: 3,
          children: [
            SizedBox(
              width: 13,
              height: 13,
              child: const DecoratedBox(
                decoration: const BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
              ),
            ),
            Text("Training"),
          ],
        ),
        Wrap(
          spacing: 3,
          children: [
            SizedBox(
              width: 13,
              height: 13,
              child: const DecoratedBox(
                decoration: const BoxDecoration(
                  color: Colors.deepOrangeAccent,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
              ),
            ),
            Text("Student Booking"),
          ],
        ),
        Wrap(
          spacing: 3,
          children: [
            SizedBox(
              width: 13,
              height: 13,
              child: const DecoratedBox(
                decoration: const BoxDecoration(
                  color: Colors.purpleAccent,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
              ),
            ),
            Text("Sport Events"),
          ],
        ),
        Wrap(
          spacing: 3,
          children: [
            SizedBox(
              width: 13,
              height: 13,
              child: const DecoratedBox(
                decoration: const BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
              ),
            ),
            Text("Club Events"),
          ],
        ),
        Wrap(
          spacing: 3,
          children: [
            SizedBox(
              width: 13,
              height: 13,
              child: const DecoratedBox(
                decoration: const BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
              ),
            ),
            Text("Others"),
          ],
        ),
      ]),
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
    return Expanded(
      child: SfCalendar(
        controller: _calendarController,
        view: getCalendarView(isAdmin, stuView),
        // minDate: today,
        // maxDate: tomorrow,
        showNavigationArrow: isAdmin || stuView ? true : false,
        monthViewSettings: MonthViewSettings(
          appointmentDisplayCount: 4,
          navigationDirection: MonthNavigationDirection.horizontal,
          dayFormat: 'EEE',
        ),
        scheduleViewSettings: ScheduleViewSettings(
          hideEmptyScheduleWeek: true,
        ),
        scheduleViewMonthHeaderBuilder: scheduleViewHeaderBuilder,
        dataSource: getCalendarBookingData(this.appData),
        showDatePickerButton: canShowStudentView ? true : false,
        allowViewNavigation: canShowStudentView ? true : false,
        allowedViews: getAllowedViews(isAdmin),
        timeSlotViewSettings: timeSlotViewSettings,
        specialRegions: canShowStudentView ? null : getBreakTime(),
        resourceViewSettings: resourceViewSettings,
        onTap: (CalendarTapDetails details) {
          showModalBottomSheet(
            context: context,
            builder: (context) =>
                _buildBottomModal(details.appointments, context, CalendarView),
          );
        },
      ),
    );
  }

  Widget _buildBottomModal(appointment, context, CalendarView) {
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
                      builder: (context) => StuBookingChooseSports(),
                    ),
                  ),
                  child: Text("Book now!"),
                )
              ],
            ),
          ),
        ],
      );
    var app = appointment![0];
    // var additionalData =
    //     appData.where((data) => data['id'] == app!.notes).toList()[0];
    // var courts = app!.resourceIds
    //     .map((id) => id.replaceAll(new RegExp(r'^0+(?=.)'), ""))
    //     .join(', ');
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Wrap(
                        direction: Axis.vertical,
                        spacing: 5,
                        children: [
                          Text(
                              "${dayFormat.format(app!.startTime).toString()}   ${hourFormat.format(app!.startTime).toString()} - ${hourFormat.format(app!.endTime).toString()}"),
                          Text("${app!.location}"),
                        ],
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (global.getUserRole() == 'admin')
                        ElevatedButton(
                          onPressed: () => editAdvBooking(app),
                          child: Text(
                            "Edit",
                          ),
                        )
                      else ...[
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CheckIn(),
                            ),
                          ),
                          child: Text(
                            "Check In",
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () => editStuBooking(context, app),
                          child: Text(
                            "Edit",
                          ),
                        )
                      ]
                    ],
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  editStuBooking(context, appointment) async {
    await FirebaseFirestore.instance
        .collection('student_appointments')
        .where('id', isEqualTo: appointment.notes)
        .get()
        .then((val) {
      List<List<String>> slotLists = [[]];
      var ct = val.docs[0]['startTime'];

      String dateString = ct
          .map<DateTime>((e) =>
              e.keys.map((f) => DateTime.parse(f)).toList()[0] as DateTime)
          .toList()[0]
          .toString();
      DateTime date = DateTime.parse(dateString);

      slotLists = ct.map<List<String>>((e) {
        var a = e.values.toList()[0];
        List<String> d = [];
        a.forEach((f) {
          return d.add(f.toString());
        });
        return d;
      }).toList();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StuBookingChooseSports(
            formType: "Edit",
            params: {
              'sportType': val.docs[0]['sportType'],
              'formType': "Edit",
              'stuAppModel': val.docs[0],
              'slotLists': slotLists,
              'date': date,
            },
          ),
        ),
      );
    });
  }

  editAdvBooking(appointment) async {
    List<DateTime> dateLists = [];
    List<List<String>> slotLists = [[]];
    await FirebaseFirestore.instance
        .collection('student_appointments')
        .where('id', isEqualTo: appointment.notes)
        .get()
        .then((val) {
      var ct = val.docs[0]['startTime'];

      dateLists = ct
          .map<DateTime>((e) =>
              e.keys.map((f) => DateTime.parse(f)).toList()[0] as DateTime)
          .toList();

      slotLists = ct.map<List<String>>((e) {
        var a = e.values.toList()[0];
        List<String> d = [];
        a.forEach((f) {
          return d.add(f.toString());
        });
        return d;
      }).toList();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StuBookingChooseSports(
            formType: "Edit",
            params: {
              'sportType': val.docs[0]['sportType'],
              'dateList': dateLists,
              'formType': "Edit",
              'slotLists': slotLists,
              'stuAppModel': val.docs[0],
            },
          ),
        ),
      );
    });
  }
}
