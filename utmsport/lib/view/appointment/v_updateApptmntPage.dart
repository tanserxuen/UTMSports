import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UpdateAppointmentPage extends StatelessWidget {
  const UpdateAppointmentPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    var appointment;
    return Scaffold(
      appBar: AppBar(
        title: Text(appointment.eventtitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(appointment.description),
      ),
    );
  }
}
