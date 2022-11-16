import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:utmsport/model/m_Event.dart';

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

  // String subject = "";
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

  // final controllerSubject = TextEditingController();
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
      decoration: InputDecoration(labelText: "Name1"),
    );
  }

  Widget _buildMatric1Field() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Matric1"),
    );
  }

  Widget _buildName2Field() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Name2"),
    );
  }

  Widget _buildMatric2Field() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Matric2"),
    );
  }

  Widget _buildName3Field() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Name3"),
    );
  }

  Widget _buildMatric3Field() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Matric3"),
    );
  }

  Widget _buildName4Field() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Name4"),
    );
  }

  Widget _buildMatric4Field() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Matric4"),
    );
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
