import 'package:flutter/material.dart';

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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildEventNameField() {
    return TextFormField(
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

  Widget _buildDescriptionField() {
    return TextFormField(
        decoration: InputDecoration(labelText: "Description"),
        validator: (String value) {
          if (value.isEmpty) {
            return "Description is required";
          }
        },
        onSaved: (String value) {
          _description = value;
        });
  }

  Widget _buildVenueField() {
    return TextFormField(
        decoration: InputDecoration(labelText: "Venue"),
        onSaved: (String value) {
          _venue = value;
        });
  }

  Widget _buildDateField() {
    String toOriginalFormatString(DateTime dateTime) {
      final y = dateTime.year.toString().padLeft(4, '0');
      final m = dateTime.month.toString().padLeft(2, '0');
      final d = dateTime.day.toString().padLeft(2, '0');
      return "$y$m$d";
    }

    bool isValidDate(String input) {
      final date = DateTime.parse(input);
      final originalFormatString = toOriginalFormatString(date);
      return input == originalFormatString;
    }
    return TextFormField(
        decoration: InputDecoration(labelText: "Date"),
        validator: (String value){
          if(!isValidDate(value)){
            return "Invalid Date";
          }
          else if(value.isEmpty){
            return "Date is required.";
          }
        },
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
                  SizedBox(height: 100),
                  ElevatedButton(
                    child: Text("Submit",
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                    onPressed: () => {
                      if (!_formKey.currentState.validate()){
                        print('abc'),
                      }else
                        {_formKey.currentState.save()},
                      print(_eventName),
                    },
                  )
                ]))));
  }
}
