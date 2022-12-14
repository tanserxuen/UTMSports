import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:utmsport/globalVariable.dart' as global;
import 'package:utmsport/model/m_CourtBooking.dart';
import 'package:utmsport/model/m_MasterBooking.dart';

import '../../view_model/advBooking/vm_timeslotCourt.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CreateAdvBooking extends StatefulWidget {
  const CreateAdvBooking({Key? key}) : super(key: key);

  @override
  State<CreateAdvBooking> createState() => _CreateAdvBookingState();
}

class _CreateAdvBookingState extends State<CreateAdvBooking> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late DateTime _date;
  List<String> _dates = [];
  List<List<String>> _dateList = [];
  String _pic = "";
  String _subject = "";
  // late Map<String, String> _booked_courtTimeslot;

  int selectedDays = 99;
  //TODO: (DONE) cm-dynamic show accordian according to number of date selected

  // int _noOfTimeslot = MasterBooking.timeslot.length;
  // int _noOfCourt = MasterBooking.badmintonCourt;
  int _noOfTimeslot = 9;
  int _noOfCourt = 4;
  List<List<String>> selectedCourtTimeslot = [];

  final dateController = TextEditingController();
  final dateRangeController = DateRangePickerController();
  final picController = TextEditingController();
  final phoneController = TextEditingController();
  final subjectController = TextEditingController();

  // Todo: How to add the courttime inside their specfic date.
  void setSelectedCourtArray(val, index, action) {
    /*
    * var indicate value corutTime
    * index indicate position of accordian
    * */
    setState(() {
      print(action);
      /*List<String> tempData = [];
      tempData.add(val)*/;
      action == 'add'
          ? _dateList[index].add(val)
          : _dateList[index].remove(val);
      selectedCourtTimeslot.toSet().toList();
    });
  }

  Widget _buildDatePicker() {
    return SfDateRangePicker(
      selectionMode: DateRangePickerSelectionMode.multiple,
      controller: dateRangeController,
      initialSelectedDate: DateTime.now(),
      view: DateRangePickerView.month,
      onSelectionChanged: selectionDateChanged,
      showTodayButton: true,
    );
  }

  void selectionDateChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      //  To add each date inside _dateList
      for(int a=0; a < args.value.length; a++){
        List<String> dateArray = [];
        dateArray.add(DateFormat('yyyy-MM-dd').format(args.value[a]));
        _dateList.add(dateArray);
      }

      //  Make Lists of Object Unique by String property Value
      {
        var seen = Set<String>();
        List<List<String>> uniqueList = _dateList.where((element) => seen.add(element.toString())).toList();
        _dateList = uniqueList;
        print(_dateList);
      }

      //  To Re-add dates inside _dateList
      if(args.value.length < _dateList.length){
        _dateList = [];
        for(int a=0; a < args.value.length; a++){
          List<String> dateArray = [];
          dateArray.add(DateFormat('yyyy-MM-dd').format(args.value[a]));
          _dateList.add(dateArray);
        }
        var seen = Set<String>();
        List<List<String>> uniqueList = _dateList.where((element) => seen.add(element.toString())).toList();
        _dateList = uniqueList;
      }

      //  Sort Ascending Date
      _dateList.sort((a, b) {
        return DateTime.parse(a[0]).compareTo(DateTime.parse(b[0]));
      });
      // selectedCourtTimeslot = _dateList;
    });
  }

  List<Widget> _buildAccordianCourtTimeslot() {
    List<Widget> accordianList = [];
    for (int i = 0; i < selectedDays; i++) {
      accordianList.add(ExpansionTile(
        title: Text("Day ${i + 1} "),
        subtitle: Row(
          children: [
            Flexible(
              child: Wrap(
                direction: Axis.horizontal,
                children: generateSelectedCourtBadge(i),
              ),
            ),
          ],
        ),
        children: [
          TimeslotCourtTable(
            noOfTimeslot: _noOfTimeslot,
            noOfCourt: _noOfCourt,
            date: _date,
            index: i,
            callback: setSelectedCourtArray,
          ),
        ],
      ));
    }
    return accordianList;
  }

  List<Widget> generateSelectedCourtBadge(int index) {
    List<Widget> badgeList = [];
    for (int i = 1; i <= _dateList[index].length; i++) {
      badgeList.add(
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              minimumSize: Size(30, 20),
              shape: StadiumBorder(),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // Text("$i"),
                Text(_dateList[index][i-1]),
                SizedBox(width: 5),
                Icon(
                  Icons.highlight_remove_rounded,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return badgeList;
  }

  Widget _buildPICField() {
    return TextFormField(
        controller: picController,
        decoration: InputDecoration(labelText: "Person In Charge"),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Person In Charge is required";
          }
        },
        onSaved: (value) => _pic = value!);
  }

  Widget _buildPhoneNoField() {
    return TextFormField(
        controller: phoneController,
        decoration: InputDecoration(labelText: "Phone Number"),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Phone Number is required";
          }
        },
        onSaved: (value) => _pic = value!);
  }

  Widget _buildSubjectField() {
    return TextFormField(
        controller: subjectController,
        decoration: InputDecoration(labelText: "Subject"),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Subject is required";
          }
        },
        onSaved: (value) => _subject = value!);
  }

  //TODO: cm-insert master and stu-appointment sekali gus
  //TODO: cm-add sports-type into master-booking db
  void insertAdvBooking() {
    final _bookingId = global.FFdb.collection('student_appointment').doc().id;
    // final _bookingDetails = CourtBooking(
    //   id: _bookingId,
    //   userId: global.USERID,
    //   subject: "Advanced Booking",
    //   color: "${Colors.blueAccent.value.toRadixString(16)}",
    //   status: "Pending",
    //   created_at: DateTime.now(),
    // ).toJson();

    // final _masterDetails = MasterBooking(
    //   booked_courtTimeslot:
    //       MasterBooking.nestedArrayToObject(courtTimeslot, _noOfTimeslot),
    //   date: _date,
    //   userId: global.USERID,
    //   bookingId: _bookingId,
    // ).toJson();
    //
    // CollectionReference advCourtBooking =
    //     global.FFdb.collection('student-appointments');
    // CollectionReference masterBooking =
    //     global.FFdb.collection('master_booking');
    // advCourtBooking.add(_bookingDetails);
    // try {
    //   masterBooking.where("date", isEqualTo: _date).get().then((value) {
    //     if (value.docs.length == 0) {
    //       masterBooking.add(_masterDetails);
    //     } else {
    //       value.docs.forEach((element) {
    //         masterBooking.doc(element.id).update(_masterDetails).then((_) {
    //           Utils.showSnackBar("Updated an advanced booking");
    //         });
    //       });
    //     }
    //   });
    //   Navigator.pushNamed(context, '/');
    // } catch (e) {
    //   print(e);
    // }
  }

  @override
  void initState() {
    // fetchObj();
    super.initState();

    //TODO: cm-use this set initial value for update form
    //update form combine with create form example: v_createEvent.dart
    picController.text = "dfvx";
    phoneController.text = "erdvs";
    subjectController.text = "waeds";
    _date = DateTime(2022, 12, 5);
    dateController.text = DateFormat('yyyy-MM-dd').format(_date);

    //set selected court nested array
    for (int i = 0; i < selectedDays; i++) selectedCourtTimeslot.add([]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(12),
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Text("Advanced Booking",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              SizedBox(height: 15),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("$_dateList"),
                        _buildDatePicker(),

                        //  Generate Date Accordian
                        Container(
                          child: Column(
                            children: List.generate(_dateList.length, (index) {
                              return ExpansionTile(
                                title: Text("${_dateList[index][0]}"),
                                subtitle: Row(
                                  children: [
                                    Flexible(
                                      child: Wrap(
                                        direction: Axis.horizontal,
                                        children:
                                            generateSelectedCourtBadge(index),
                                      ),
                                    ),
                                  ],
                                ),
                                children: [
                                  TimeslotCourtTable(
                                    noOfTimeslot: _noOfTimeslot,
                                    noOfCourt: _noOfCourt,
                                    date: _date,
                                    index: index,
                                    callback: setSelectedCourtArray,
                                  ),
                                ],
                              );




                            }),
                          ),
                        ),
                        _buildSubjectField(),
                        _buildPICField(),
                        _buildPhoneNoField(),
                        SizedBox(height: 50),
                        ElevatedButton(
                          child: Text("Submit",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16)),
                          onPressed: () {
                            if (!_formKey.currentState!.validate()) {
                            } else {
                              _formKey.currentState!.save();
                              insertAdvBooking();
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
