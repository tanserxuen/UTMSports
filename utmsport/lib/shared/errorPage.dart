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
    return Container(
      child: Center(
        child: Text(
          "Some error occurred",
          style: const TextStyle(
            // color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      color: Colors.white,
      margin: EdgeInsets.zero,
    );
  }
}
