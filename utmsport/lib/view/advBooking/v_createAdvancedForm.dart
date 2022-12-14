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
  const CreateAdvBooking({Key? key, required this.dateList}) : super(key: key);

  final List<DateTime> dateList;

  @override
  State<CreateAdvBooking> createState() => _CreateAdvBookingState();
}

class _CreateAdvBookingState extends State<CreateAdvBooking> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late DateTime _date;
  List<DateTime> _dates = [];
  String _pic = "";
  String _subject = "";

  // late Map<String, String> _booked_courtTimeslot;

  int selectedDays = 0;

  //TODO: cm-dynamic show accordian according to number of date selected

  // int _noOfTimeslot = MasterBooking.timeslot.length;
  // int _noOfCourt = MasterBooking.badmintonCourt;

  List<List<String>> selectedCourtTimeslot = [];

  final dateRangeController = DateRangePickerController();
  final picController = TextEditingController();
  final phoneController = TextEditingController();
  final subjectController = TextEditingController();

  void setSelectedCourtArray(val, index, action) {
    setState(() {
      action == 'add'
          ? selectedCourtTimeslot[index].add(val)
          : selectedCourtTimeslot[index].removeWhere((item) => item == val);
      selectedCourtTimeslot[index].toSet().toList();
    });
  }

  List<Widget> _buildAccordianCourtTimeslot() {
    List<Widget> accordianList = [];
    for (int i = 0; i < selectedDays; i++) {
      accordianList.add(ExpansionTile(
        maintainState: true,
        title: Text(
            "Day ${i + 1} - ${DateFormat('dd MMM yyyy').format(widget.dateList[i])}"),
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
            date: widget.dateList[i],
            index: i,
            callback: setSelectedCourtArray,
          ),
        ],
      ));
    }
    return accordianList;
  }

  //TODO: cm- display selected timeslot and court: "T2C8" in the badge
  List<Widget> generateSelectedCourtBadge(int index) {
    List<Widget> badgeList = [];
    for (int i = 0; i < selectedCourtTimeslot[index].length; i++) {
      badgeList.add(
        ElevatedButton(
          onPressed: () => setState(() => {
                selectedCourtTimeslot[index].removeWhere(
                    (element) => selectedCourtTimeslot[index][i] == element)
              }),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(30, 20),
            shape: StadiumBorder(),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("${selectedCourtTimeslot[index][i]}"),
              SizedBox(width: 5),
              Icon(
                Icons.close,
                size: 18,
              ),
            ],
          ),
        ),
      );

      badgeList.add(SizedBox(width: 5));
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
    this.selectedDays = widget.dateList.length;
    print(widget.dateList);

    //TODO: cm-use this set initial value for update form
    //update form combine with create form example: v_createEvent.dart
    picController.text = "dfvx";
    phoneController.text = "erdvs";
    subjectController.text = "waeds";
    _date = DateTime(2022, 12, 5);

    //set selected court nested array
    for (int i = 0; i < selectedDays; i++) selectedCourtTimeslot.add([]);

    super.initState();
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
                        Text("${selectedCourtTimeslot.toString()}"),
                        ..._buildAccordianCourtTimeslot(),
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
