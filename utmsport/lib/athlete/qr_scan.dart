import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';


class QRScan extends StatefulWidget {
  @override
  State<QRScan> createState() => _QRScan();

}

class _QRScan extends State<QRScan> {
  // final qrKey = GlobalKey(debugLabel: 'QR');
  // QRViewController? controller;
  // Barcode? barcode;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  // void reassemble() {
  //   super.reassemble();
  //   if (Platform.isAndroid) {
  //     controller!.pauseCamera();
  //   }
  //   controller!.resumeCamera();
  // }
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: Column(
  //       children: <Widget>[
  //         Expanded(
  //           flex: 5,
  //           child: QRView(
  //             key: qrKey,
  //             onQRViewCreated: _onQRViewCreated,
  //           ),
  //         ),
  //         Expanded(
  //           flex: 1,
  //           child: Center(
  //             child: (result != null)
  //                 ? Text('Attended: ${result!.code}')
  //                 : Text('Scan a code'),
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

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
        // IconButton(
        //   icon: Icon(Icons.flash_off),
        //   onPressed: () async{
        //     await controller?.toggleFlash();
        //     setState(() {});
        //   },
        // ),
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
        // IconButton(
        //   icon: Icon(Icons.switch_camera),
        //   onPressed: () async{
        //     await controller?.flipCamera();
        //     setState(() {});
        //   },
        // ),
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
      color:  Colors.white24,
    ),
    child: (result != null)
        ? Text('Attended: ${result!.code}')
        : Text('Scan a code'),
    //   Text(
    //   barcode != null? 'Attended: ${barcode!.code}' : 'Scan a code!',
    //   maxLines: 3,
    // ),
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

  // void onQRViewCreated(QRViewController controller){
  //   setState(() => this.controller = controller);
  //
  //   controller.scannedDataStream
  //   .listen((bacode) => setState(() => this.barcode = barcode));
  // }
  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void dispose(){
    controller?.dispose();
    super.dispose();
  }
}