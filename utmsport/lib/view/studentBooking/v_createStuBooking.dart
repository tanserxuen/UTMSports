import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:utmsport/model/m_CourtBooking.dart';

import 'package:utmsport/globalVariable.dart' as global;

class CreateStuBooking extends StatefulWidget {
  const CreateStuBooking({Key? key, required this.sportsType})
      : super(key: key);

  final String sportsType;

  @override
  State<StatefulWidget> createState() {
    return CreateStuBookingState();
  }
}

class CreateStuBookingState extends State<CreateStuBooking> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  String _name1 = "";
  String _matric1 = "";
  String _name2 = "";
  String _matric2 = "";
  String _name3 = "";
  String _matric3 = "";
  String _name4 = "";
  String _matric4 = "";

  List _resourceIds = [];
  bool _isAllDay = false;
  String _color = "0xffb74093";
  String _sportType = "";

  List<int> selectedCourts = [];

  final controllerStartTime = TextEditingController();
  final controllerEndTime = TextEditingController();
  final controllerResourceIds = TextEditingController();
  final controllerIsAllDay = TextEditingController();

  // final controllerColor = TextEditingController();
  final controllerName1 = TextEditingController();
  final controllerMatric1 = TextEditingController();
  final controllerName2 = TextEditingController();
  final controllerMatric2 = TextEditingController();
  final controllerName3 = TextEditingController();
  final controllerMatric3 = TextEditingController();
  final controllerName4 = TextEditingController();
  final controllerMatric4 = TextEditingController();

  Widget _buildStartTimeField() {
    return TextFormField(
      controller: controllerStartTime,
      decoration: InputDecoration(
          labelText: "Start Time", suffixIcon: Icon(Icons.access_time)),
      readOnly: true,
      onTap: () async {
        TimeOfDay? startTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        setState(() => {
              _startTime = startTime!,
              controllerStartTime.text = startTime.format(context),
            });
      },
    );
  }

  Widget _buildEndTimeField() {
    return TextFormField(
      controller: controllerEndTime,
      decoration: InputDecoration(
          labelText: "End Time", suffixIcon: Icon(Icons.access_time)),
      readOnly: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Name 1 is required";
        }
      },
      onTap: () async {
        TimeOfDay? endTime = await showTimePicker(
          context: context,
          initialTime: _startTime,
        );
        setState(() => {
              _endTime = endTime!,
              controllerEndTime.text = endTime.format(context),
            });
      },
    );
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

  Widget _buildSportsTypeColorField() {
    // print(widget.sportsType);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select Sports Type",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        DropdownButton(
          hint: Text("Sports Type"),
          isExpanded: true,
          items: global.sports.map((option) {
            return DropdownMenuItem(
              value: option,
              child: Text("$option"),
            );
          }).toList(),
          value: widget.sportsType,
          onChanged: (value) {
            setState(() {
              print(value);
              switch (value) {
                case 'Badminton':
                  _color = Colors.redAccent.value.toRadixString(16);
                  break;
                case 'Squash':
                  _color = Colors.yellowAccent.value.toRadixString(16);
                  break;
                case 'PingPong':
                  _color = Colors.greenAccent.value.toRadixString(16);
                  break;
              }
              _sportType = value.toString();
            });
          },
        ),
      ],
    );
  }

  Widget _badmintonResourceIdField() {
    int courtNumbers = 0;
    switch (widget.sportsType) {
      case "Badminton":
        courtNumbers = global.badmintonCourt;
        break;
      case "PingPong":
        courtNumbers = global.pingPongCourt;
        break;
      case "Squash":
        courtNumbers = global.squashCourt;
        break;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select Courts",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 80,
            childAspectRatio: 16 / 8,
            crossAxisSpacing: 10,
            mainAxisSpacing: 20,
          ),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: courtNumbers,
          itemBuilder: (BuildContext context, int index) => GestureDetector(
            onTap: () {
              setState(() {
                selectedCourts.contains(index)
                    ? selectedCourts.remove(index)
                    : selectedCourts.add(index);
                // print(this.selectedCourts);
              });
            },
            child: Card(
              color: selectedCourts.contains(index)
                  ? Colors.lightBlueAccent
                  : Colors.white,
              child: Column(
                children: <Widget>[Text("Court ${index + 1}")],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void insertCourtBooking() {
// TODO: form validation
    List<String> selectedCourtIds = selectedCourts
        .map((index) => "${(index + 1).toString().padLeft(4, "0")}")
        .toList();
    final now = new DateTime.now();

    //TODO: convert to timestamp wrong
    final _courtBooking = CourtBooking(
      userId: global.USERID,
      startTime: Timestamp.fromDate(DateTime(
          now.year, now.month, now.day, _startTime.hour, _startTime.minute)),
      endTime: Timestamp.fromDate(DateTime(
          now.year, now.month, now.day, _endTime.hour, _endTime.minute)),
      subject: "Student Booking",
      status: "approved",
      createdAt: Timestamp.fromDate(DateTime.now()),
      resourceIds: selectedCourtIds,
      isAllDay: false,
      color: this._color,
      name1: controllerName1.text.trim(),
      matric1: controllerMatric1.text.trim(),
      name2: controllerName2.text.trim(),
      matric2: controllerMatric2.text.trim(),
      name3: controllerName3.text.trim(),
      matric3: controllerMatric3.text.trim(),
      name4: controllerName4.text.trim(),
      matric4: controllerMatric4.text.trim(),
      id: global.FFdb.collection('student_appointment').doc().id,
    ).stuToJson();

    CollectionReference courtBooking =
        FirebaseFirestore.instance.collection('student_appointments');

    // print(_courtBooking);
    try {
      courtBooking.add(_courtBooking);
      Navigator.pushNamed(context, '/');
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              Text("Book Court",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              SizedBox(height: 15),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // SizedBox(height: 15),
                        // _buildSportsTypeColorField(),
                        SizedBox(height: 24),
                        _badmintonResourceIdField(),
                        SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: _buildStartTimeField(),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: _buildEndTimeField(),
                            )
                          ],
                        ),
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
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16)),
                          onPressed: () {
                            if (!_formKey.currentState!.validate()) {
                            } else {
                              _formKey.currentState!.save();
                              insertCourtBooking();
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context),
        child: Icon(Icons.arrow_back_rounded, size: 25),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
