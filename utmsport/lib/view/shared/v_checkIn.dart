
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:utmsport/athlete/qr_scan.dart';
import 'package:utmsport/utils.dart';

import '../../cm_booking/qr_generator.dart';
import '../training/v_trainingDetail.dart';
import 'package:utmsport/globalVariable.dart' as global;

class CheckIn extends StatelessWidget {
  const CheckIn({Key? key, this.id,}) : super(key: key);
  final id;

  Widget studentView(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('SportEvents'),
        actions: [
          qrCodeOption(context)
        ],
      ),
      body: Column(
        children: [
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
                    stream: FirebaseFirestore.instance.collection('attendance').where('bookingId', isEqualTo: id).snapshots(),
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
                      if(snapshot.hasError) return Text('Soemthing error in v_checkin.dart');
                      return Text('null');
                    })
              ],
            ),
          )
          //  Display attendance Student
        ],
      ),
    );
  }
  Widget trainingView(BuildContext context){
    return TrainingDetailPage(trainingId: id,);
  }
  Widget clubView(BuildContext context){
    return Text('club content');
  }
  Widget otherView(BuildContext context){
    return Text('other content');
  }
  Widget qrCodeOption(BuildContext context) {
    return global.getUserRole() == "athlete" || global.getUserRole() == "student" || global.getUserRole() == "staff"
        ? IconButton(
      icon: Icon(Icons.qr_code_scanner_rounded),
      color: Colors.yellow,
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    QRScan(callback: (qrcodeId, matricNo) async {
                      //check whether the matricNo is located inside the sportTeam
                      var trainingRef = await FirebaseFirestore.instance
                          .collection('training')
                          .doc(qrcodeId)
                          .get();
                      var sprtTeamRef = await FirebaseFirestore.instance
                          .collection('sportTeam')
                          .doc(trainingRef.data()!['sportId'])
                          .get();
                      if (sprtTeamRef
                          .data()!['athletes']
                          .contains(matricNo)) {
                        var athleteList = [];
                        var athleteTimeList = [];
                        FirebaseFirestore.instance
                            .collection('training')
                            .doc(qrcodeId)
                            .get()
                            .then(
                              (training) {
                            athleteList = training['athlete'];
                            athleteTimeList = training['athletetime'];
                            //Perform Data Insert if no matric contain inside trainingDocument
                            if (!athleteList.contains(matricNo)) {
                              athleteList.add(matricNo);
                              var currentTime = DateTime.now();
                              athleteTimeList.add(currentTime);
                              var data = {
                                'athlete': athleteList,
                                'athletetime': athleteTimeList
                              };
                              FirebaseFirestore.instance
                                  .collection('training')
                                  .doc(qrcodeId)
                                  .update(data)
                                  .then((_) {
                                print('updated successsfully');
                              });
                            }
                            Utils.showSnackBar(
                                "your matric has been recorded", "red");
                          },
                        );
                      } else {
                        Utils.showSnackBar(
                            "You are not athlete of this sport Team",
                            "red");
                      }
                    })));
      },
    )
        : IconButton(
        icon: Icon(Icons.qr_code),
        color: Colors.black,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => QRGenerate(
                    qrId: id,
                  )));
        });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('student_appointments').where('id', isEqualTo: id).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasError) return Text('Something Error');
          if(snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator(),);
          if(snapshot.hasData){
            var bookType = snapshot.data!.docs.first['bookingType'];
            print(snapshot.data!.docs.first['bookingType']);
            if(bookType == 'Sport Events') return studentView(context);
            if(bookType == 'Training') return trainingView(context);
            if(bookType == 'Club Event') return clubView(context);
            return Text('Cannot find specific view');
          }
          return Text('Stuck at checkin.dart');
        });
  }
}
