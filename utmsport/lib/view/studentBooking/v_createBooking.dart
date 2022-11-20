import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:time_picker_widget/time_picker_widget.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

class CreateBooking extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CreateBookingState();
  }
}

class CreateBookingState extends State<CreateBooking> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _startTime = "";
  String _endTime = "";
  String _name1 = "";
  String _matric1 = "";
  String _name2 = "";
  String _matric2 = "";
  String _name3 = "";
  String _matric3 = "";
  String _name4 = "";
  String _matric4 = "";

  final controllerStartTime = TextEditingController();
  final controllerEndTime = TextEditingController();
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
        if (startTime == null) return null;
        setState(() => {
              _startTime = "${startTime.hour}: ${startTime.minute}",
              controllerStartTime.text = _startTime,
              print(_startTime),
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
      onTap: () async {
        TimeOfDay? endTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (endTime == null) return null;
        setState(() => {
              _endTime = "${endTime.hour}: ${endTime.minute}",
              controllerEndTime.text = _endTime,
              print(_endTime),
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
        }, onSaved: (value)=> _name1 = value!);
  }

  Widget _buildMatric1Field() {
    return TextFormField(
        controller: controllerMatric1,
        decoration: InputDecoration(labelText: "Matric 1"),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Matric 1 is required";
          }
        }, onSaved: (value)=> _matric1 = value!);
  }

  Widget _buildName2Field() {
    return TextFormField(
        controller: controllerName2,
        decoration: InputDecoration(labelText: "Name 2"),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Name 2 is required";
          }
        }, onSaved: (value)=> _name2 = value!);
  }

  Widget _buildMatric2Field() {
    return TextFormField(
        controller: controllerMatric2,
        decoration: InputDecoration(labelText: "Matric 2"),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Matric 2 is required";
          }
        }, onSaved: (value)=> _matric2 = value!);
  }

  Widget _buildName3Field() {
    return TextFormField(
        controller: controllerName3,
        decoration: InputDecoration(labelText: "Name 3"),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Name 3 is required";
          }
        }, onSaved: (value)=> _name3 = value!);
  }

  Widget _buildMatric3Field() {
    return TextFormField(
        controller: controllerMatric3,
        decoration: InputDecoration(labelText: "Matric 3"),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Matric 3 is required";
          }
        }, onSaved: (value)=> _matric3 = value!);
  }

  Widget _buildName4Field() {
    return TextFormField(
        controller: controllerName4,
        decoration: InputDecoration(labelText: "Name 4"),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Name 4 is required";
          }
        }, onSaved: (value)=> _name4 = value!);
  }

  Widget _buildMatric4Field() {
    return TextFormField(
        controller: controllerMatric4,
        decoration: InputDecoration(labelText: "Matric 4"),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Matric 4 is required";
          }
        }, onSaved: (value)=> _matric4 = value!);
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
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 15),
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
                              //TODO: form validation
                              // final _event = Event(
                              //   id: FirebaseFirestore.instance
                              //       .collection('events')
                              //       .doc()
                              //       .id,
                              //   name: controllerEventName.text.trim(),
                              //   description: controllerDescription.text.trim(),
                              //   venue: controllerVenue.text.trim(),
                              //   platform: controllerPlatform.text.trim(),
                              //   image: controllerImage.text.trim(),
                              //   date: controllerDate.text,
                              // ).toJson();

                              CollectionReference events = FirebaseFirestore
                                  .instance
                                  .collection('events');

                              // events.add(_event);
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
