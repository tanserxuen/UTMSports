import 'package:flutter/material.dart';

class RequestMeetingList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Request List')),
      body: const Center(
        child: Text(
          'This is a Request Meeting List screen',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}