import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

class FormScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FormScreenState();
  }
}

class FormScreenState extends State<FormScreen> {
  String _eventName;
  String _description;
  String _venue;
  String _date;
  String _platform;
  String _image;

  final contollerEventName = TextEditingController();
  final contollerDescription = TextEditingController();
  final contollerVenue = TextEditingController();
  final contollerDate = TextEditingController();
  final contollerPlatform = TextEditingController();
  final contollerImage = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final eventController = TextEditingController();

  Widget _buildEventNameField() {
    return TextFormField(
        controller: contollerEventName,
        decoration: InputDecoration(labelText: "Event Name"),
        validator: (String value) {
          if (value.isEmpty) {
            return "Name is required";
          }
        },
        onSaved: (String value) {
          _eventName = value;
        });
  }

  // Widget _buildDescriptionField() {
  //   return TextFormField(
  //       decoration: InputDecoration(labelText: "Description"),
  //       validator: (String value) {
  //         if (value.isEmpty) {
  //           return "Description is required";
  //         }
  //       },
  //       onSaved: (String value) {
  //         _description = value;
  //       });
  // }
  //
  // Widget _buildVenueField() {
  //   return TextFormField(
  //       decoration: InputDecoration(labelText: "Venue"),
  //       onSaved: (String value) {
  //         _venue = value;
  //       });
  // }

  Widget _buildDateField() {
    // String toOriginalFormatString(DateTime dateTime) {
    //   final y = dateTime.year.toString().padLeft(4, '0');
    //   final m = dateTime.month.toString().padLeft(2, '0');
    //   final d = dateTime.day.toString().padLeft(2, '0');
    //   return "$y$m$d";
    // }
    //
    // bool isValidDate(String input) {
    //   final date = DateTime.parse(input);
    //   final originalFormatString = toOriginalFormatString(date);
    //   return input == originalFormatString;
    // }

    return TextFormField(
        controller: contollerDate,
        decoration: InputDecoration(labelText: "Date"),
        // validator: (String value) {
        //   if (!isValidDate(value)) {
        //     return "Invalid Date";
        //   } else if (value.isEmpty) {
        //     return "Date is required.";
        //   }
        // },
        onSaved: (String value) {
          _date = value;
        });
  }

  Widget _buildPlatformField() {
    return TextFormField(
        decoration: InputDecoration(labelText: "Platform"),
        onSaved: (String value) {
          _platform = value;
        });
  }

  Widget _buildImageField() {
    return TextFormField(
        decoration: InputDecoration(labelText: "Image"),
        validator: (String value) {
          if (value.isEmpty) {
            return "Image is required";
          }
        },
        onSaved: (String value) {
          _image = value;
        });
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
                    // _buildDescriptionField(),
                    // _buildVenueField(),
                    // _buildDateField(),
                    // _buildPlatformField(),
                    // _buildImageField(),
                    SizedBox(height: 50),
                    ElevatedButton(
                      child: Text("Submit",
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                      onPressed: () {
                        if (!_formKey.currentState.validate()) {
                        } else {
                          _formKey.currentState.save();
                          final _event = Event(
                            id: FirebaseFirestore.instance.collection('events').doc().id,
                            name: contollerEventName.text.trim(),
                            // date: DateTime.parse(contollerDate.text),
                          ).toJson();


                          CollectionReference events = FirebaseFirestore.instance.collection('events');

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

  // Future createEvent(Event event) async {
  //   DateTime now = new DateTime.now();
  //   final docEvent = FirebaseFirestore.instance.collection('events').doc();
  //   event.id = docEvent.id;
  //
  //   final json = event.toJson();
  //   await event.set(json);
  // }
}

class Event {
  String id;
  final String name;
  final DateTime date;
  final String description = "abc";
  final String image = "123.png";
  final String platform = "gmeet";
  final String venue = "L50";

  Event({
    this.id = '',
    this.name,
    this.date,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        // 'date': date,
      };
}
