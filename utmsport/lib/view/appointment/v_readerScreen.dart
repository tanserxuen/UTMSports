
import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ReaderScreen extends StatefulWidget {
  ReaderScreen(this.pdfName, {Key? key}) : super(key: key);
  String pdfName;
  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pdfName),
      ),
      body: Text("abc"),
      // Container(
      //   child: SfPdfViewer.asset(
      //     'assets/dummy.pdf').
      // )
    );
  }
}
