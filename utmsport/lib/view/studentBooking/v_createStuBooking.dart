import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:utmsport/model/m_CourtBooking.dart';
import 'package:utmsport/globalVariable.dart' as global;
import 'package:utmsport/model/m_MasterBooking.dart';
import 'package:utmsport/utils.dart';
import 'package:utmsport/view_model/advBooking/vm_timeslotCourt.dart';

class CreateStuBooking extends StatefulWidget {
  final String sportType;
  final String formType;
  dynamic stuAppModel;
  var date;
  var slotLists;

  CreateStuBooking({
    Key? key,
    required this.sportType,
    this.date: null,
    this.slotLists: null,
    this.formType: "Create",
    this.stuAppModel: null,
  }) : super(key: key);

  @override
  State<CreateStuBooking> createState() {
    return CreateStuBookingState();
  }
}

class CreateStuBookingState extends State<CreateStuBooking> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _name1 = "";
  String _matric1 = "";
  String _name2 = "";
  String _matric2 = "";
  String _name3 = "";
  String _matric3 = "";
  String _name4 = "";
  String _matric4 = "";

  String _sportType = "";
  List<int> selectedCourts = [];
  final now = new DateTime.now();
  int selectedDays = 0;
  DateTime date = Utils.getCurrentDateOnly();
  List<List<String>> selectedCourtTimeslot = [];
  List<List<List<String>>> masterBookingArray = [];

  final controllerName1 = TextEditingController();
  final controllerMatric1 = TextEditingController();
  final controllerName2 = TextEditingController();
  final controllerMatric2 = TextEditingController();
  final controllerName3 = TextEditingController();
  final controllerMatric3 = TextEditingController();
  final controllerName4 = TextEditingController();
  final controllerMatric4 = TextEditingController();

  @override
  void initState() {
    if (widget.formType == 'Edit') {
      date = widget.date;
      controllerName1.text = widget.stuAppModel['name1'];
      controllerMatric1.text = widget.stuAppModel['matric1'];
      controllerName2.text = widget.stuAppModel['name2'];
      controllerMatric2.text = widget.stuAppModel['matric2'];
      controllerName3.text = widget.stuAppModel['name3'];
      controllerMatric3.text = widget.stuAppModel['matric3'];
      controllerName4.text = widget.stuAppModel['name4'];
      controllerMatric4.text = widget.stuAppModel['matric4'];
    }

    this.selectedDays = 1; //set selected court nested array
    widget.formType == 'Edit'
        ? selectedCourtTimeslot = widget.slotLists
        : selectedCourtTimeslot = List.generate(1, (_) => []);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Booking',
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              Text("Normal Court Booking",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              SizedBox(height: 15),
              Card(
                child: Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: _buildLegend(),
                    ),
                    SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            _buildAccordianCourtTimeslot(),
                            Row(
                              children: [
                                Expanded(child: _buildName1Field()),
                                SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: _buildMatric1Field(),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(child: _buildName2Field()),
                                SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: _buildMatric2Field(),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(child: _buildName3Field()),
                                SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: _buildMatric3Field(),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(child: _buildName4Field()),
                                SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: _buildMatric4Field(),
                                )
                              ],
                            ),
                            SizedBox(height: 50),
                            ElevatedButton(
                              child: Text("Submit",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16)),
                              onPressed: () {
                                //if there is court selected
                                bool canSubmit = RegExp('[1-9]')
                                    .hasMatch(selectedCourtTimeslot.toString());
                                if (!_formKey.currentState!.validate()) {
                                } else {
                                  _formKey.currentState!.save();
                                  if (canSubmit) insertCourtBooking();
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccordianCourtTimeslot() {
    int dateIndex = 0;
    return ExpansionTile(
      maintainState: true,
      title: Text(
        "${DateFormat('dd MMM yyyy').format(date)}",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      subtitle: Wrap(
        direction: Axis.horizontal,
        spacing: 5,
        runSpacing: 4,
        children: generateSelectedCourtBadge(dateIndex),
      ),
      children: [
        // Text("${widget.dateList[dateIndex]}"),
        TimeslotCourtTable(
          dateList: [date],
          formType: widget.formType,
          slots: selectedCourtTimeslot[dateIndex],
          index: 0,
          sportType: widget.sportType,
          setSelectedCourtArrayCallback: setSelectedCourtArray,
          setMasterBookingArrayCallback: setMasterBookingArray,
        ),
      ],
    );
  }

  List<Widget> generateSelectedCourtBadge(int dateIndex) {
    List<Widget> badgeList = [];
    for (int elIndex = 0;
        elIndex < selectedCourtTimeslot[dateIndex].length;
        elIndex++) {
      badgeList.add(
        ElevatedButton(
          onPressed: () => setState(() => {
                updateMasterBookingArray(
                    dateIndex, selectedCourtTimeslot[dateIndex][elIndex]),
                selectedCourtTimeslot[dateIndex].removeWhere((element) {
                  return selectedCourtTimeslot[dateIndex][elIndex] == element;
                }),
              }),
          style: ElevatedButton.styleFrom(
              minimumSize: Size(20, 10),
              maximumSize: Size(90, 40),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: EdgeInsets.fromLTRB(7, 2, 5, 2),
              shape: StadiumBorder(),
              primary: Colors.lightBlue),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text("${selectedCourtTimeslot[dateIndex][elIndex]}",
                    style: TextStyle(fontSize: 12)),
                SizedBox(width: 3),
                Icon(
                  Icons.close,
                  size: 14,
                ),
              ],
            ),
          ),
        ),
      );
    }
    return badgeList;
  }

  void setSelectedCourtArray(val, index, action) {
    setState(() {
      action == 'add'
          ? selectedCourtTimeslot[index].add(val)
          : selectedCourtTimeslot[index].removeWhere((item) => item == val);
      selectedCourtTimeslot[index].toSet().toList();
    });
  }

  void setMasterBookingArray(List<List<String>> val, int dateIndex) {
    setState(() => masterBookingArray.add(val));
  }

  void updateMasterBookingArray(int dateIndex, String val) {
    setState(() {
      var a = val.split(" ").toList();
      int row = int.parse(a[0]);
      int col = int.parse(a[1]);
      masterBookingArray[dateIndex][row][col] = '';
    });
  }

  Widget _buildName1Field() {
    return TextFormField(
        controller: controllerName1,
        decoration: InputDecoration(labelText: "Name 1"),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Name 1 is required";
          }
        },
        onSaved: (value) => _name1 = value!);
  }

  Widget _buildMatric1Field() {
    return TextFormField(
        controller: controllerMatric1,
        decoration: InputDecoration(labelText: "Matric 1"),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Matric 1 is required";
          }
        },
        onSaved: (value) => _matric1 = value!);
  }

  Widget _buildName2Field() {
    return TextFormField(
        controller: controllerName2,
        decoration: InputDecoration(labelText: "Name 2"),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Name 2 is required";
          }
        },
        onSaved: (value) => _name2 = value!);
  }

  Widget _buildMatric2Field() {
    return TextFormField(
        controller: controllerMatric2,
        decoration: InputDecoration(labelText: "Matric 2"),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Matric 2 is required";
          }
        },
        onSaved: (value) => _matric2 = value!);
  }

  Widget _buildName3Field() {
    return TextFormField(
        controller: controllerName3,
        decoration: InputDecoration(labelText: "Name 3"),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Name 3 is required";
          }
        },
        onSaved: (value) => _name3 = value!);
  }

  Widget _buildMatric3Field() {
    return TextFormField(
        controller: controllerMatric3,
        decoration: InputDecoration(labelText: "Matric 3"),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Matric 3 is required";
          }
        },
        onSaved: (value) => _matric3 = value!);
  }

  Widget _buildName4Field() {
    return TextFormField(
        controller: controllerName4,
        decoration: InputDecoration(labelText: "Name 4"),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Name 4 is required";
          }
        },
        onSaved: (value) => _name4 = value!);
  }

  Widget _buildMatric4Field() {
    return TextFormField(
        controller: controllerMatric4,
        decoration: InputDecoration(labelText: "Matric 4"),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Matric 4 is required";
          }
        },
        onSaved: (value) => _matric4 = value!);
  }

  Widget _buildLegend() {
    return Wrap(spacing: 15, children: [
      ...global.timeslot.map((slot) {
        var time = Utils.formatTime(slot);
        int index = global.timeslot.indexOf(slot);
        return Padding(
          padding: const EdgeInsets.fromLTRB(2, 1, 2, 1),
          child: Wrap(
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
              Text(" T${index + 1} $time ")
            ],
          ),
        );
      })
    ]);
  }

  void insertCourtBooking() {
    bool isEditForm = widget.formType == 'Edit';
    // widget.stuAppModel?['id'] != null && widget.stuAppModel?['id'] != "";
    final _courtBooking = CourtBooking(
      id: isEditForm
          ? widget.stuAppModel['id']
          : global.FFdb.collection('student_appointment').doc().id,
      userId: global.USERID,
      startTime: MasterBooking.mapStartTime(selectedCourtTimeslot, [date]),
      endTime: [Timestamp.fromDate(DateTime(now.year, now.month, now.day))],
      subject: "Student Booking",
      status: "approved",
      sportType: widget.sportType,
      createdAt: Timestamp.fromDate(DateTime.now()),
      isAllDay: false,
      color: "0x${Colors.deepOrangeAccent.value.toRadixString(16)}",
      name1: controllerName1.text.trim(),
      matric1: controllerMatric1.text.trim(),
      name2: controllerName2.text.trim(),
      matric2: controllerMatric2.text.trim(),
      name3: controllerName3.text.trim(),
      matric3: controllerMatric3.text.trim(),
      name4: controllerName4.text.trim(),
      matric4: controllerMatric4.text.trim(),
    ).stuToJson();

    CollectionReference courtBooking =
        FirebaseFirestore.instance.collection('student_appointments');
    CollectionReference masterCourtBooking =
        global.FFdb.collection('master_booking');

    try {
      var _masterBooking;
      final _bookingId = global.FFdb.collection('student_appointment').doc().id;

      if (isEditForm) {
        //update existing student booking
        courtBooking
            .where("id", isEqualTo: widget.stuAppModel['id'])
            .get()
            .then((value) {
          value.docs.forEach((element) {
            courtBooking.doc(element.id).update(_courtBooking).then((_) async {
              await masterCourtBooking
                  .where("date", isEqualTo: date)
                  .where("sportType", isEqualTo: widget.sportType)
                  .get()
                  .then((value) {
                _masterBooking = MasterBooking(
                  booked_courtTimeslot:
                      MasterBooking.nestedArrayToObject(masterBookingArray[0]),
                  date: date,
                  userId: global.USERID,
                  bookingId: _bookingId,
                  sportType: widget.sportType,
                ).masterToJson();
                print("update stu booking");
                value.docs.forEach((element) {
                  masterCourtBooking
                      .doc(element.id)
                      .update(_masterBooking)
                      .then((_) {
                    Utils.showSnackBar("Edited a booking", "green");
                    Navigator.pushNamed(context, '/');
                  });
                });
              });
            });
          });
        });
      } else {
        //add new student booking
        courtBooking.add(_courtBooking).then((_) async {
          await masterCourtBooking
              .where("date", isEqualTo: date)
              .where("sportType", isEqualTo: widget.sportType)
              .get()
              .then((value) {
            _masterBooking = MasterBooking(
              booked_courtTimeslot:
                  MasterBooking.nestedArrayToObject(masterBookingArray[0]),
              date: date,
              userId: global.USERID,
              bookingId: _bookingId,
              sportType: widget.sportType,
            ).masterToJson();
            if (value.docs.length == 0) {
              print("add adv");
              masterCourtBooking.add(_masterBooking).then((_) {
                Utils.showSnackBar("Created a booking", "green");
                Navigator.pushNamed(context, '/');
              });
            } else {
              print("update adv");
              value.docs.forEach((element) {
                masterCourtBooking
                    .doc(element.id)
                    .update(_masterBooking)
                    .then((_) {
                  Utils.showSnackBar("Created a booking", "green");
                  Navigator.pushNamed(context, '/');
                });
              });
            }
          });
        });
      }
    } catch (e) {
      print(e);
    }
  }
}
