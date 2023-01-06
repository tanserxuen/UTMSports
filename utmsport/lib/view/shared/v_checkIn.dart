
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:utmsport/athlete/qr_scan.dart';
import 'package:utmsport/utils.dart';

import '../../cm_booking/qr_generator.dart';

class CheckIn extends StatefulWidget {
  const CheckIn({Key? key, this.qrid}) : super(key: key);
  final qrid;
  @override
  State<CheckIn> createState() => _CheckInState();
}

class _CheckInState extends State<CheckIn> {

  @override
  void initState() {
    // TODO: implement initState
    print(widget.qrid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            /*ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => QRGenerate(qrId: widget.qrid,))).then((_) {
                print('Generate Attendance');
              });
            }, child: Text('Generate QrCode')),*/
            QrImage(
              data: widget.qrid,
              size:200,
              backgroundColor: Colors.white,
            ),
            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => QRScan(callback: (qrcodeId, matricNo) {
              //    Check matric student whether exist anot
                FirebaseFirestore.instance.collection('attendance').where('bookingId', isEqualTo: qrcodeId).get()
                    .then((query){
                      print(matricNo);
                      if(query.docs.first['matrics'].contains(matricNo)){
                        int index = query.docs.first['matrics'].indexOf(matricNo);
                        var array = query.docs.first['status'];
                        array[index] = true;
                        print(array);
                        FirebaseFirestore.instance.collection('attendance').doc(query.docs.first.id).update({
                          'status': array
                        }).then((value){
                          Utils.showSnackBar('Attendance Recorded',"green");
                        });
                      }else{
                        Utils.showSnackBar('NOT Performing Update',"red");
                      }
                });
              },)));
            }, child: Text('Scan QrCode')),
            Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Attendance Student'),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('attendance').where('bookingId', isEqualTo: widget.qrid).snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                        if(snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
                        if(snapshot.hasData){
                          final DocumentSnapshot documentSnapshot = snapshot.data!.docs.first;
                          print(snapshot.data!.docs.first['matrics']);
                          return ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: documentSnapshot['matrics'].length,
                              itemBuilder: (BuildContext context, int index){
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(documentSnapshot['matrics'][index]),
                                      Text(documentSnapshot['status'][index] == true ?'checked' : 'unchecked')
                                    ],
                                  );
                              });
                        }

                        return Text('Soemthing error in v_checkin.dart');
                      })
                ],
              ),
            )
          //  Display attendance Student

          ],
        )
      ),
    );
  }
}
