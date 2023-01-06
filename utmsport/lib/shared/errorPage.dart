import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  final FlutterErrorDetails errorDetails;

  const ErrorPage({
    Key? key,
    required this.errorDetails,
  })  : assert(errorDetails != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        child: Text(
          "Some error occurred",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        padding: const EdgeInsets.all(8.0),
      ),
      color: Colors.red,
      margin: EdgeInsets.zero,
    );
  }
}
