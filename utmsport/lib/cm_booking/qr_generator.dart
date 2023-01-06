import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRGenerate extends StatefulWidget {
  final qrId;
  const QRGenerate({Key? key, this.qrId}): super(key: key);

  @override
  State<QRGenerate> createState() => _QRGenerate();

}

class _QRGenerate extends State<QRGenerate> {
  final controller = TextEditingController();
  @override

  void initState() {
    controller.text = widget.qrId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('QR Generator'),
    ),
    body: Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImage(
              data: controller.text,
              size:200,
              backgroundColor: Colors.white,
            ),
            SizedBox(height: 40),
            buildTextField(context),
          ],
        ),
      ),
    ),
  );

  Widget buildTextField(BuildContext context) => TextField(
    textAlign: TextAlign.center,
    readOnly: true,
    controller: controller,
    style: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ),
      decoration: InputDecoration(
        hintText: 'Enter the data:',
        hintStyle:TextStyle(color: Colors.grey),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blueAccent),
        ),
      ),
  );
}