import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';


class AddAppointmentPage extends StatefulWidget {
  @override
  _AddAppointmentPageState createState() => _AddAppointmentPageState();
}

class _AddAppointmentPageState extends State<AddAppointmentPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Appointment Form"),
          //centerTitle: true,
          //backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.clear,),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions:[
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  //save appointment
                },
                child: Text("Save"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.orange),
                ),
              ),
            )
          ]
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          FormBuilder(
            child: Column(
              children: [
                FormBuilderTextField(
                  name: "title",
                  decoration: InputDecoration(
                    hintText: "Add Title",
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.only(left: 48.0),
                  ),
                ),
                Divider(),
                FormBuilderTextField(
                  name: "description",
                  minLines: 1,
                  maxLines: 5,
                  decoration: InputDecoration(
                      hintText: "Add Details",
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.short_text)
                  ),
                ),
                Divider(),
                FormBuilderSwitch(
                  name: "public",
                  title: Text("Public"),
                  initialValue: false,
                  controlAffinity: ListTileControlAffinity.leading,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
                Divider(),
                FormBuilderDateTimePicker(
                  name: "date",
                  initialValue: DateTime.now(),
                  fieldHintText: "Add Date",
                  inputType: InputType.date,
                  format: DateFormat('EEEE, dd MMMM, yyyy'),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.calendar_today_sharp),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
