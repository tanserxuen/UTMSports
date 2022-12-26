import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:utmsport/view/appointment/v_requestMeetingDetail.dart';

import '../../main.dart';
import '../../model/m_AppointmentDetail.dart';

class RequestMeetingList extends StatefulWidget {
  const RequestMeetingList({Key? key}) : super(key: key);

  @override
  State<RequestMeetingList> createState() => _RequestMeetingListState();
}

class _RequestMeetingListState extends State<RequestMeetingList> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  final CollectionReference _appointments =
      FirebaseFirestore.instance.collection('appointments');
  var listAppointment;

  getAppointments() async {
    List<AppointmentDetail> _listappointmentDetails = [];
    listAppointment = {};
    try {
      await _appointments
          .where('status', isNotEqualTo: "rejected")
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
        String date = DateFormat('yyyy-MM-dd')
            .format(_listappointmentDetails[i].dateTime);
        String time =
            DateFormat.jm().format(_listappointmentDetails[i].dateTime);
        if (listAppointment.containsKey(date)) {
          print("THIS WONNT REPLACE");
        } else {
          print("REPLACED OR INSERTED");
          listAppointment[date] = [];
        }
        var eventDetail = {
          "eventDescp": _listappointmentDetails[i].eventDescp,
          "eventTitle": _listappointmentDetails[i].eventTitle,
          "name": _listappointmentDetails[i].name,
          "time": time,
          "status": _listappointmentDetails[i].status,
          "docid": _listappointmentDetails[i].docid
        };
        listAppointment[date].add(eventDetail);
      }
      setState(() {
        print(listAppointment);
      });
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
  void initState() {
    // TODO: implement initState
    getAppointments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Meeting Request',
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
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
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            ..._listOfDayEvents(_selectedDay!).map(
              (myEvents) => ListTile(
                onLongPress: myEvents['status'] == 'pending'
                    ? () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: const Text('Confirmation'),
                              content: const Text('Do you want to approve?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'Cancel'),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                    onPressed: () => _reject(myEvents['docid'])
                                            .then((value) {
                                          navigatorKey.currentState!.popUntil(
                                              (route) => route.isFirst);
                                        }),
                                    child: const Text('Reject')),
                                TextButton(
                                  onPressed: () =>
                                      _approve(myEvents['docid']).then((value) {
                                    navigatorKey.currentState!
                                        .popUntil((route) => route.isFirst);
                                  }),
                                  child: const Text('Ok'),
                                )
                              ],
                            ))
                    : null,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              RequestMeetingDetail(docid: myEvents['docid'])));
                },
                leading: myEvents['status'] == 'approved'
                    ? Icon(
                        Icons.done,
                        color: Colors.teal,
                        size: 32,
                      )
                    : Icon(
                        Icons.pending,
                        color: Colors.amberAccent,
                        size: 32,
                      ),
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(' ${myEvents['eventTitle']}'),
                ),
                subtitle: Text('${myEvents['time']}: ${myEvents['name']}'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _reject(String docid) async {
  //Todo: Send Notification upon rejected
  return update(docid, 'rejected').then((_) => print('rejected Successfully'));
}

Future<void> _approve(String docid) async {
  return update(docid, 'approved').then((_) => print('approved successfully'));
}

update(String docid, String status) async {
  return await FirebaseFirestore.instance
      .collection('appointments')
      .doc(docid)
      .update({
    'status': status,
  });
}
