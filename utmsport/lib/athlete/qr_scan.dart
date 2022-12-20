import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScan extends StatefulWidget {
  @override
  State<QRScan> createState() => _QRScan();

}

class _QRScan extends State<QRScan> {

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) => SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            buildQRView(context),
            Positioned(bottom: 10, child: buildResult()),
            Positioned(top: 10, child: buildControlButtons()),
          ],
        ),
      ),
  );

  Widget buildControlButtons() => Container(
    padding: EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: Colors.white24,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[

        IconButton(
          icon:FutureBuilder<bool?>(
            future: controller?.getFlashStatus(),
            builder: (context, snapshot) {
              if (snapshot.data != null){
                return Icon(
                  snapshot.data! ? Icons.flash_on : Icons.flash_off
                );
              } else {
                return Container();
              }
              },
          ),
          onPressed: () async{
            await controller?.toggleFlash();
            setState(() {});
          },
        ),

        IconButton(
          icon:FutureBuilder(
            future: controller?.getCameraInfo(),
            builder: (context, snapshot) {
              if (snapshot.data != null){
                return Icon(Icons.switch_camera);
              } else {
                return Container();
              }
            },
          ),
          onPressed: () async{
            await controller?.flipCamera();
            setState(() {});
          },
        ),
      ],
    ),
  );

  // Widget buildResult() => Container(
  //   padding: EdgeInsets.all(12),
  //   decoration: BoxDecoration(
  //     borderRadius: BorderRadius.circular(8),
  //     color:  Colors.white24,
  //   ),
  //   child: (result != null)
  //       ? Text('Attended: ${result!.code}')
  //       : Text('Scan a code'),
  //   //   Text(
  //   //   barcode != null? 'Attended: ${barcode!.code}' : 'Scan a code!',
  //   //   maxLines: 3,
  //   // ),
  // );

  Widget buildResult() => Container(
    padding: EdgeInsets.all(12),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color:  Colors.white,
    ),

      child: (result != null)
      // ? Text('Your attendance has been recorded: \n\n ${result!.code}')
      ? AlertDialog(
        content: Text('Your attendance has been recorded: \n\n ${result!.code}'),
        actions: [
          ElevatedButton(onPressed: (){
            Navigator.of(context).pop();
            print('ok');},
              child: Text('OK')
          )
        ],
      )
      : Text('Scan a code'),
  );


  Widget buildQRView(BuildContext context) => QRView (
    key: qrKey,
    onQRViewCreated: _onQRViewCreated,
    overlay: QrScannerOverlayShape(
      borderWidth: 10,
      borderLength: 20,
      borderRadius: 10,
      borderColor: Colors.redAccent,
      cutOutSize: MediaQuery.of(context).size.width * 0.8,
    ),
  );

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (!mounted) return;
      setState(() {
        result = scanData;
      });
    });
  }

  // @override
  // void dispose(){
  //   controller?.dispose();
  //   super.dispose();
  // }
}