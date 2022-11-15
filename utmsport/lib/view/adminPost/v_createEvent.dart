import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:utmsport/model/m_Event.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

class FormScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FormScreenState();
  }
}

class FormScreenState extends State<FormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _eventName = "";
  String _description = "";
  String _venue = "";
  String _date = "";
  String _platform = "";
  String _image = "";

  final controllerEventName = TextEditingController();
  final controllerDescription = TextEditingController();
  final controllerVenue = TextEditingController();
  final controllerDate = TextEditingController();
  final controllerPlatform = TextEditingController();
  final controllerImage = TextEditingController();
  final eventController = TextEditingController();

  Widget _buildEventNameField() {
    return TextFormField(
      controller: controllerEventName,
      decoration: InputDecoration(labelText: "Event Name"),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Name is required";
        }
      },
      // onSaved: (value) {
      //   _eventName = value;
      // }
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: controllerDescription,
      decoration: InputDecoration(labelText: "Description"),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Description is required";
        }
      },
      // onSaved: (value) {
      //   _description = value;
      // }
    );
  }

  Widget _buildVenueField() {
    return TextFormField(
      controller: controllerVenue,
      decoration: InputDecoration(labelText: "Venue"),
      // onSaved: (value) {
      //   _venue = value;
      // }
    );
  }

  Widget _buildDateField() {
    return TextFormField(
        controller: controllerDate,
        decoration: InputDecoration(
            labelText: "Date", suffixIcon: Icon(Icons.calendar_today)),
        readOnly: true,
        onTap: () async {
          DateTime? value = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100));
          if (value == null) return null;
          setState(() => {
                _date = DateFormat('yyyy-MM-dd').format(value),
                controllerDate.text = _date,
                print(_date),
              });
        });
  }

  Widget _buildPlatformField() {
    return TextFormField(
      controller: controllerPlatform,
      decoration: InputDecoration(labelText: "Platform"),
      // onSaved: (val) {
      //   _platform = val;
      // }
    );
  }

  // Widget _buildImageField() {
  //   PlatformFile? pickedFile;
  //
  //   Future selectFile() async {
  //     print("abc");
  //     final result = await FilePicker.platform.pickFiles();
  //     if (result == null) return;
  //
  //     setState(() {
  //       pickedFile = result.files.first;
  //     });
  //   }
  //
  //   return Column(
  //     children: [
  //       if (pickedFile != null)
  //         Expanded(
  //           child: Container(
  //             color: Colors.blue[100],
  //             child: Center(
  //               child: Image.file(
  //                 File(pickedFile!.path!),
  //                 width: double.infinity,
  //                 fit: BoxFit.cover,
  //               ),
  //             ),
  //           ),
  //         ),
  //       TextFormField(
  //         controller: controllerImage,
  //         decoration: InputDecoration(
  //             labelText: "Image", suffixIcon: Icon(Icons.image)),
  //         onTap: selectFile,
  //         readOnly: true,
  //         validator: (value) {
  //           if (value == null || value.isEmpty) return "Image is required";
  //         },
  //         // onSaved: (value) {
  //         //   _image = value;
  //         // }
  //       ),
  //     ],
  //   );
  // }

  Widget _buildImageField() {
    return TextFormField(
      controller: controllerImage,
      decoration: InputDecoration(labelText: "Image"),
      // onSaved: (value) {
      //   _venue = value;
      // }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text("Create Events",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            Card(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildEventNameField(),
                    _buildDescriptionField(),
                    _buildVenueField(),
                    _buildDateField(),
                    _buildPlatformField(),
                    _buildImageField(),
                    SizedBox(height: 50),
                    ElevatedButton(
                      child: Text("Submit",
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) {
                        } else {
                          _formKey.currentState!.save();
                          final _event = Event(
                            id: FirebaseFirestore.instance
                                .collection('events')
                                .doc()
                                .id,
                            name: controllerEventName.text.trim(),
                            description: controllerDescription.text.trim(),
                            venue: controllerVenue.text.trim(),
                            platform: controllerPlatform.text.trim(),
                            image: controllerImage.text.trim(),
                            date: controllerDate.text,
                          ).toJson();

                          CollectionReference events =
                              FirebaseFirestore.instance.collection('events');

                          events.add(_event);
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

