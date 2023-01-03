import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:utmsport/utils.dart';

class QRScan extends StatefulWidget {
  @override
  State<QRScan> createState() => _QRScan();
}

class _QRScan extends State<QRScan> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  var matricNo;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  Future<void> getMatric() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((user) {
      this.matricNo = user['matric'];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getMatric();
    super.initState();
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
              icon: FutureBuilder<bool?>(
                future: controller?.getFlashStatus(),
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    return Icon(
                        snapshot.data! ? Icons.flash_on : Icons.flash_off);
                  } else {
                    return Container();
                  }
                },
              ),
              onPressed: () async {
                await controller?.toggleFlash();
                setState(() {});
              },
            ),
            IconButton(
              icon: FutureBuilder(
                future: controller?.getCameraInfo(),
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    return Icon(Icons.switch_camera);
                  } else {
                    return Container();
                  }
                },
              ),
              onPressed: () async {
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
          color: Colors.white,
        ),
        child: (result != null)
            // ? Text('Your attendance has been recorded: \n\n ${result!.code}')
            ? AlertDialog(
                content: Text(
                    'Your attendance has been recorded: \n\n ${result!.code}'),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        //HERE PERFORM UPDATE ATTENDANCE
                        var athleteList = [];
                        FirebaseFirestore.instance
                            .collection('training')
                            .doc(result!.code)
                            .get()
                            .then((training) {
                          athleteList = training['athlete'];
                          if (!athleteList.contains(matricNo)) {
                            athleteList.add(matricNo);
                            var data = {'athlete': athleteList};
                            FirebaseFirestore.instance
                                .collection('training')
                                .doc(result!.code)
                                .update(data)
                                .then((_) {
                              print('updated successsfully');
                            });
                          }
                          Utils.showSnackBar("your matric has been recorded","red");
                          Navigator.of(context).pop();
                        });
                      },
                      child: Text('OK'))
                ],
              )
            : Text('Scan a code'),
      );

  Widget buildQRView(BuildContext context) => QRView(
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
      if (!mounted) {
        print("operation peform");
        return;
      }
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
