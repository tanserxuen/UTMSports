import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:utmsport/view_model/appointment/vm_appmntwidget.dart';
import 'package:utmsport/model/m_AppointmentDetail.dart';
import '../eo_appointment/add_appointment.dart';
import 'package:utmsport/globalVariable.dart' as globaldart;

import 'appointment/v_requestMeetingDetail.dart';

class Calendar extends StatefulWidget {
  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late final ValueNotifier<List<dynamic>> _selectedEvents;
  late CalendarController _controller;
  late Map<DateTime, List<dynamic>> _appts;

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  final CollectionReference _appointments =
      FirebaseFirestore.instance.collection('appointments');
  var listAppointment = {};

  @override
  void initState() {
    // TODO: implement initState
    getEvents();
    super.initState();
    //  Todo: Fetch eventdate and title from db in this form
  }

  getEvents() async {
    List<AppointmentDetail> _listappointmentDetails = [];

    try {
      await _appointments
          .where('status', isEqualTo: "approved")
          .get()
          .then((querySnapshot) {
        setState(() {
          _listappointmentDetails = querySnapshot.docs
              .map((appt) => AppointmentDetail(
                  dateTime: appt['date'].toDate(),
                  eventDescp: appt['description'],
                  eventTitle: appt['eventtitle'],
                  email: appt['email'],
                  file: appt['file'],
                  matricno: appt['matricno'],
                  name: appt['name'],
                  phoneno: appt['phoneno'],
                  pic: appt['pic'],
                  status: appt['status'],
                  uid: appt['uid'],
                  docid: appt.id))
              .toList();
        });
      });

      for (int i = 0; i < _listappointmentDetails.length; i++) {
        String time =
            DateFormat.jm().format(_listappointmentDetails[i].dateTime);
        String date = DateFormat('yyyy-MM-dd')
            .format(_listappointmentDetails[i].dateTime);

        if (listAppointment.containsKey(date)) {
          // print("THIS WONNT REPLACE");
        } else {
          // print("REPLACED OR INSERTED");
          listAppointment[date] = [];
        }
        var eventDetail = {
          "eventDescp": _listappointmentDetails[i].eventDescp,
          "eventTitle": _listappointmentDetails[i].eventTitle,
          "time": time,
          "uid": _listappointmentDetails[i].uid,
          "docid": _listappointmentDetails[i].docid
        };
        listAppointment[date].add(eventDetail);
      }
      setState(() {});
    } catch (e) {
      print(e.toString());
    }
  }

  List _listOfDayEvents(DateTime dateTime) {
    if (listAppointment[DateFormat('yyyy-MM-dd').format(dateTime)] != null) {
      return listAppointment[DateFormat('yyyy-MM-dd').format(dateTime)]!;
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CALENDAR"),
        centerTitle: true,
      ),
      body: StreamBuilder(
          stream: globaldart.FFdb.collection("appointments").snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  TableCalendar(
                    eventLoader: _listOfDayEvents,
                    firstDay: DateTime(1980),
                    lastDay: DateTime(2050),
                    focusedDay: _focusedDay,
                    calendarFormat: _calendarFormat,
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      if (!isSameDay(_selectedDay, selectedDay)) {
                        // Call `setState()` when updating the selected day
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                      }
                    },
                    onFormatChanged: (format) {
                      if (_calendarFormat != format) {
                        // Call `setState()` when updating calendar format
                        setState(() {
                          _calendarFormat = format;
                        });
                      }
                    },
                    onPageChanged: (focusedDay) {
                      // No need to call `setState()` here
                      print(focusedDay);
                      _focusedDay = focusedDay;
                    },

                    //Style:-
                    //Header Style:-
                    headerStyle: HeaderStyle(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                      headerMargin: const EdgeInsets.only(bottom: 10.0),
                      formatButtonVisible: true,
                      titleCentered: true,
                      formatButtonShowsNext: false,
                      formatButtonDecoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: Colors.orange, width: 2),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      formatButtonTextStyle: TextStyle(
                        color: Colors.orange,
                      ),
                    ),

                    //Calendar Style:-
                    calendarStyle: CalendarStyle(
                      isTodayHighlighted: true,
                      selectedDecoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      selectedTextStyle: TextStyle(color: Colors.white),
                      todayDecoration: BoxDecoration(
                        color: Colors.pink,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  ..._listOfDayEvents(_selectedDay!).map(
                    (myEvents) => GestureDetector(
                      onTap: myEvents['uid'] ==
                              FirebaseAuth.instance.currentUser?.uid
                          ? () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          RequestMeetingDetail(
                                              docid: myEvents['docid'])));
                            }
                          : null,
                      child: Card(
                        child: ListTile(
                          leading: myEvents['uid'] ==
                                  FirebaseAuth.instance.currentUser?.uid
                              ? Icon(
                                  Icons.account_circle,
                                  color: Colors.teal,
                                )
                              : Icon(
                                  Icons.people_alt_rounded,
                                  color: Colors.grey,
                                ),
                          title: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: myEvents['uid'] ==
                                    FirebaseAuth.instance.currentUser?.uid
                                ? Text('${myEvents['eventTitle']}')
                                : Text('Anonymous'),
                          ),
                          subtitle: myEvents['uid'] ==
                                  FirebaseAuth.instance.currentUser?.uid
                              ? Text('${myEvents['eventDescp']}')
                              : Text('Anonymous'),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return CircularProgressIndicator();
            }
          }),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AppointmentWidget(
                        selectedDay: _selectedDay,
                      )));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
