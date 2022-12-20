import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:utmsport/view_model/appointment/vm_appmntwidget.dart';
import '../crud/add_appointment.dart';
import 'appointment/listView_appointment.dart';
import 'package:utmsport/globalVariable.dart' as globaldart;


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

  final TextEditingController _eventTitleController = TextEditingController();
  final TextEditingController _TimeController = TextEditingController();
  final TextEditingController _DateController = TextEditingController();
  final TextEditingController _PicController = TextEditingController();
  final TextEditingController _matricNoController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final CollectionReference _appointments =
  FirebaseFirestore.instance.collection('appointments');

  int counter = 0;
  get getHashCode => null;
  
  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _eventTitleController,
                  decoration: const InputDecoration(labelText: 'Event Title'),
                ),
                TextField(
                  controller: _TimeController,
                  decoration: const InputDecoration(labelText: 'Time'),
                ),
                TextField(
                    controller: _DateController,
                    decoration: InputDecoration(
                        labelText: "Date",
                        suffixIcon: Icon(Icons.calendar_today)),
                    readOnly: true,
                    onTap: () async {

                      DateTime? value = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100));

                      if (value == null) return null;
                      String date;
                      setState(() => {
                        date = DateFormat('yyyy-MM-dd').format(value),
                        _DateController.text = date,
                        print(date),
                      });
                    }
                ),
                TextField(
                  controller: _PicController,
                  decoration: const InputDecoration(labelText: 'Person in charge'),
                ),
                TextField(
                  controller: _matricNoController,
                  decoration: const InputDecoration(labelText: 'Matric Number'),
                ),
                TextField(
                  controller: _phoneNoController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Create'),
                  onPressed: () async {
                    // final String name = _nameController.text;
                    final String eventtitle = _eventTitleController.text;
                    final String time = _TimeController.text;
                    final String date = _DateController.text;
                    final String pic = _PicController.text;
                    final String matricno = _matricNoController.text;
                    final String phoneno = _phoneNoController.text;
                    final String description = _descriptionController.text;

                    if (eventtitle != null) {
                      await _appointments.add({
                        "eventtitle": eventtitle,
                        "time": time,
                        "date": date,
                        "pic": pic,
                        "matricno": matricno,
                        "phoneno": phoneno,
                        "description": description

                      });

                      _eventTitleController.text = '';
                      _TimeController.text = '';
                      _DateController.text = '';
                      _PicController.text = '';
                      _matricNoController.text = '';
                      _phoneNoController.text = '';
                      _descriptionController.text = '';
                      Navigator.of(context).pop();
                      showDialog(context: context, builder: (BuildContext context){
                        return AlertDialog(
                            title: Text("Success"),
                            titleTextStyle:
                            TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,fontSize: 20),
                            actionsOverflowButtonSpacing: 20,
                            actions: [
                              // ElevatedButton(
                              //  child: const Text("Back"),
                              //     onPressed:(){
                              //       Navigator.push(context,
                              //           MaterialPageRoute(builder: (context) => MeetingForm(),)
                              //       );},
                              //   ),
                              ElevatedButton(
                                child: const Text("ok"),
                                onPressed: (){
                                  // _navigateToNextScreen(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => listViewAppointment()),
                                  );
                                  //Navigator.of(context).pop();
                                },
                              ),
                            ],
                            content: Text("Booked successfully"));
                      });
                    }
                  },
                )
              ],
            ),
          );

        });
  }

  // Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
  //
  //   if (documentSnapshot != null) {
  //
  //     _eventTitleController.text = documentSnapshot['eventtitle'];
  //     _TimeController.text = documentSnapshot['time'].toString();
  //     _DateController.text = documentSnapshot['date'];
  //     _PicController.text = documentSnapshot['pic'].toString();
  //     _matricNoController.text = documentSnapshot['matricno'];
  //     _phoneNoController.text = documentSnapshot['phoneno'].toString();
  //     _descriptionController.text = documentSnapshot['description'];
  //
  //   }
  //
  //   await showModalBottomSheet(
  //       isScrollControlled: true,
  //       context: context,
  //       builder: (BuildContext ctx) {
  //         return Padding(
  //           padding: EdgeInsets.only(
  //               top: 20,
  //               left: 20,
  //               right: 20,
  //               bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               TextField(
  //                 controller: _eventTitleController,
  //                 decoration: const InputDecoration(labelText: 'Event Title'),
  //               ),
  //               TextField(
  //                 controller: _TimeController,
  //                 decoration: const InputDecoration(labelText: 'Time'),
  //               ),
  //               TextField(
  //                   controller: _DateController,
  //                   decoration: InputDecoration(
  //                       labelText: "Date",
  //                       suffixIcon: Icon(Icons.calendar_today)),
  //                   readOnly: true,
  //                   onTap: () async {
  //
  //                     DateTime? value = await showDatePicker(
  //                         context: context,
  //                         initialDate: DateTime.now(),
  //                         firstDate: DateTime(1900),
  //                         lastDate: DateTime(2100));
  //
  //                     if (value == null) return null;
  //                     String date;
  //                     setState(() => {
  //                       date = DateFormat('yyyy-MM-dd').format(value),
  //                       _DateController.text = date,
  //                       print(date),
  //                     });
  //                   }
  //               ),
  //               TextField(
  //                 controller: _PicController,
  //                 decoration: const InputDecoration(labelText: 'Person in charge'),
  //               ),
  //               TextField(
  //                 controller: _matricNoController,
  //                 decoration: const InputDecoration(labelText: 'Matric Number'),
  //               ),
  //               TextField(
  //                 controller: _phoneNoController,
  //                 decoration: const InputDecoration(labelText: 'Phone Number'),
  //               ),
  //               TextField(
  //                 controller: _descriptionController,
  //                 decoration: const InputDecoration(labelText: 'Description'),
  //               ),
  //               const SizedBox(
  //                 height: 20,
  //               ),
  //               ElevatedButton(
  //                 child: const Text( 'Update'),
  //                 onPressed: () async {
  //                   final String eventtitle = _eventTitleController.text;
  //                   final String time = _TimeController.text;
  //                   final String date = _DateController.text;
  //                   final String pic = _PicController.text;
  //                   final String matricno = _matricNoController.text;
  //                   final String phoneno = _phoneNoController.text;
  //                   final String description = _descriptionController.text;
  //
  //                   if (eventtitle != null) {
  //                     await _appointments
  //                         .doc(documentSnapshot!.id)
  //                         .update({
  //                       "eventtitle": eventtitle,
  //                       "time": time,
  //                       "date": date,
  //                       "pic": pic,
  //                       "matricno": matricno,
  //                       "phoneno": phoneno,
  //                       "description": description
  //                         });
  //
  //                     _eventTitleController.text = '';
  //                     _TimeController.text = '';
  //                     _DateController.text = '';
  //                     _PicController.text = '';
  //                     _matricNoController.text = '';
  //                     _phoneNoController.text = '';
  //                     _descriptionController.text = '';
  //                     Navigator.of(context).pop();
  //                     showDialog(context: context, builder: (BuildContext context){
  //                       return AlertDialog(
  //                           title: Text("Success"),
  //                           titleTextStyle:
  //                           TextStyle(
  //                               fontWeight: FontWeight.bold,
  //                               color: Colors.black,fontSize: 20),
  //                           actionsOverflowButtonSpacing: 20,
  //                           actions: [
  //                             // ElevatedButton(
  //                             //  child: const Text("Back"),
  //                             //     onPressed:(){
  //                             //       Navigator.push(context,
  //                             //           MaterialPageRoute(builder: (context) => MeetingForm(),)
  //                             //       );},
  //                             //   ),
  //                             ElevatedButton(
  //                               child: const Text("ok"),
  //                               onPressed: (){
  //                                 // _navigateToNextScreen(context);
  //                                 Navigator.of(context).pop();
  //                                 // Navigator.push(
  //                                 //   context,
  //                                 //   MaterialPageRoute(builder: (context) => RequestMeetingList()),
  //                                 // );
  //                                 },
  //                             ),
  //                           ],
  //                           content: Text("Booked successfully"));
  //                     });
  //                     // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //                     //     content: Text('You have successfully added an appointment')));
  //
  //                   }
  //                 },
  //               )
  //             ],
  //           ),
  //         );
  //       });
  // }

  // Future<void> _delete(String appointmentId) async {
  //   await _appointments.doc(appointmentId).delete();
  //
  //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //       content: Text('You have successfully deleted an appointment')));
  // }

  Map<DateTime, List<dynamic>> _groupAppoints(List allAppointment ){
    Map<DateTime, List<dynamic>> data = {};
    allAppointment.forEach((appt) {
      // print(appt['date'].toDate());
      DateTime date = DateTime(DateTime.parse(appt['date'].toDate().toString()).year, DateTime.parse(appt['date'].toDate().toString()).month, DateTime.parse(appt['date'].toDate().toString()).day, DateTime.parse(appt['date'].toDate().toString()).hour, DateTime.parse(appt['date'].toDate().toString()).minute);
      // print(date);
      if(data[date] == null) data[date] = [];
      data[date]?.add(appt);
    });
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text ("CALENDAR"),
        centerTitle: true,
        /*actions: <Widget>[
          IconButton(
            icon: Icon(Icon.person),
            onPressed: () => Navigator.pushNamed(context,
              AppRoutes.profile),
          )
        ],*/
      ),
      body: StreamBuilder(
        stream: globaldart.FFdb.collection("appointments").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(snapshot.hasData){
            List allAppointment = snapshot.data!.docs;
            if(allAppointment.isNotEmpty){
              // _appts = _groupAppoints(allAppointment);
              // print(_appts);
            }
            return Column(
              children: [
                TableCalendar(
                  // eventLoader: (day) {
                  //   final events = LinkedHashMap(
                  //     equals: isSameDay,
                  //     hashCode: getHashCode,
                  //   )..addAll(_appts);
                  //   //TODO: need to solve the conflict day and getHashCode.
                  //   return events[day] ?? [];
                  // },
                  firstDay: DateTime(1980),
                  lastDay: DateTime(2050),
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  selectedDayPredicate: (day) {
                    // Use `selectedDayPredicate` to determine which day is currently selected.
                    // If this returns true, then `day` will be marked as selected.

                    // Using `isSameDay` is recommended to disregard
                    // the time-part of compared DateTime objects.
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
                      }
                      );
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
                      border: Border.all(
                          color: Colors.orange,
                          width: 2
                      ),
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
                /*Expanded(
                    child: ValueListenableBuilder<List<dynamic>>(
                      valueListenable: _selectedEvents,
                      builder: (context, value, _){
                        return ListView.builder(
                          itemCount: value?.length,
                          itemBuilder: (context, index){
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 4.0,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: ListTile(
                                onTap:() => print('${value[index]}'),
                                title: Text('${value[index]}')
                              ),
                            );
                          }
                        );
                      },
                    )
                )*/
              ],
            );
          }
          else{
            return CircularProgressIndicator();
          }

        }
      ),


      /*SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Card(
                clipBehavior: Clip.antiAlias,
                margin: const EdgeInsets.all(8.0),
                child: TableCalendar(
                  firstDay: DateTime(1980),
                  lastDay: DateTime(2050),
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  selectedDayPredicate: (day) {
                    // Use `selectedDayPredicate` to determine which day is currently selected.
                    // If this returns true, then `day` will be marked as selected.

                    // Using `isSameDay` is recommended to disregard
                    // the time-part of compared DateTime objects.
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
                      }
                      );
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
                      color: Colors.blue,
                    ),
                    headerMargin: const EdgeInsets.only(bottom: 10.0),
                    formatButtonVisible: true,
                    titleCentered: true,
                    formatButtonShowsNext: false,
                    formatButtonDecoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    formatButtonTextStyle: TextStyle(
                      color: Colors.white,
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
              ),

              // Center(
              //     child: Column(
              //       children: [
              //         ElevatedButton(
              //           style: ElevatedButton.styleFrom(
              //             minimumSize: Size(50, 35),
              //           ),
              //           onPressed:(){
              //             Navigator.push(
              //               context,
              //               MaterialPageRoute(builder: (context) => listViewAppointment()),
              //             );
              //           },
              //           child: Text("Make Advance Booking"),
              //         ),
              //         ElevatedButton(
              //           style: ElevatedButton.styleFrom(
              //             minimumSize: Size(80, 35),
              //           ),
              //             onPressed:(){
              //               Navigator.push(
              //                 context,
              //                 MaterialPageRoute(builder: (context) => listViewAppointment()),
              //               );
              //             },
              //             child: Text("Set Slot Meeting"),
              //         ),
              //       ],
              //     ),
              // ),

              // SizedBox(
              //   width: 500,
              //   height: 500,
              //   child: StreamBuilder(
              //     stream: _appointments.snapshots(),
              //     builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              //       if (streamSnapshot.hasData) {
              //         return ListView.builder(
              //           itemCount: streamSnapshot.data!.docs.length,
              //           itemBuilder: (context, index) {
              //             final DocumentSnapshot documentSnapshot =
              //             streamSnapshot.data!.docs[index];
              //             return Card(
              //               margin: const EdgeInsets.all(10),
              //               child: ListTile(
              //                 title: Text(documentSnapshot['eventtitle']),
              //                 subtitle: Text(documentSnapshot['time']),
              //                 trailing: SizedBox(
              //                   width: 100,
              //                   child: Row(
              //                     children: [
              //                       IconButton(
              //                           icon: const Icon(Icons.edit, color: Colors.green),
              //                           onPressed: () =>
              //                               _update(documentSnapshot)),
              //                       IconButton(
              //                           icon: const Icon(Icons.delete, color: Colors.red),
              //                           onPressed: () =>
              //                               _delete(documentSnapshot.id)),
              //                     ],
              //                   ),
              //                 ),
              //               ),
              //             );
              //           },
              //         );
              //       }
              //
              //       return const Center(
              //         child: CircularProgressIndicator(),
              //       );
              //     },
              //   ),
              // )
            ]
        ),
      ),*/

      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: (){
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AppointmentWidget()));
        },
        child: const Icon(Icons.add),

      ),



      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add),
      //   //onPressed: showAppointmentDialog,
      //   onPressed: (){
      //     Navigator.push(context,
      //         MaterialPageRoute(builder: (context) => AddAppointment(),)
      //     );
      //   },
      // ),
    );
  }
}

