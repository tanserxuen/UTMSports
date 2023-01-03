
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TrainingDetailPage extends StatelessWidget {
  const TrainingDetailPage({Key? key, this.trainingId, this.trainingTitle}) : super(key: key);
  final trainingId;
  final trainingTitle;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Session ${trainingTitle}'),
        actions: [
          IconButton(
              onPressed: (){print('Scan');},
              icon: Icon(Icons.qr_code_scanner_rounded),
            color: Colors.yellow
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("training").doc(trainingId).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
          if(snapshot.hasData){
            // print(snapshot.data?.data()!['sportId']);
            var documentSnapshot = snapshot.data?.data();
            String date = DateFormat.yMMMMd('en_US').format(documentSnapshot!['start_at'].toDate());
            String time = DateFormat.jm().format(documentSnapshot!['start_at'].toDate());
            // return Text("Data Found");
            return Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Training Time: ${time}'),
                  Text('Description: '),
                  Text(documentSnapshot!['description']),
                  SizedBox(height: 20,),
                  Text('List Attendance Athlete: ')

                ]
              ),
            );
          }
          return Text('Something Error in TrainingDetail.dart');
        },

      )

    );
  }
}
