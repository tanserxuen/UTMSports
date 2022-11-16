import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  String _imageUrl = "";

  Reference storageRef = FirebaseStorage.instance.ref();

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


  //TODO: test if workable
  Widget _buildImageField() {
    return ElevatedButton.icon(
      onPressed: () async {
        ImagePicker imagePicker = ImagePicker();
        XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
        // print('${file?.path}');

        if (file == null) return;

        //Import Dart:core
        String uniqueFileName =
            DateTime.now().millisecondsSinceEpoch.toString();

        //Get a reference to storage root
        Reference ref_DirImages = storageRef.child("images");

        //Create a reference for the image to be stored.
        Reference ref_ImageToUpLoad = ref_DirImages.child(uniqueFileName);

        try {
          //Store the file
          String filePath = '${file!.path}';
          await ref_ImageToUpLoad.putFile(File(filePath));

          //Success: get the download URL
          _imageUrl = await ref_ImageToUpLoad.getDownloadURL();
        } catch (error) {}
      },
      icon: Icon(Icons.camera_alt, size: 22),
      label: Text('Upload Images'),
      style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(35)),
    );
  }

  void insertEventDetails() {
    final _event = Event(
      id: FirebaseFirestore.instance.collection('events').doc().id,
      name: controllerEventName.text.trim(),
      description: controllerDescription.text.trim(),
      venue: controllerVenue.text.trim(),
      platform: controllerPlatform.text.trim(),
      image: _imageUrl,
      date: controllerDate.text,
    ).toJson();

    CollectionReference events =
        FirebaseFirestore.instance.collection('events');

    events.add(_event);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text("Create Events",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
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
                      SizedBox(height: 10,),
                      _buildImageField(),
                      SizedBox(height: 50),
                      ElevatedButton(
                        child: Text("Submit",
                            style: TextStyle(color: Colors.white, fontSize: 16)),
                        onPressed: () {
                          if (!_formKey.currentState!.validate()) {
                          } else {
                            _formKey.currentState!.save();
                            insertEventDetails();
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
    );
  }
}
