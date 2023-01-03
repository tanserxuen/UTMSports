import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:utmsport/view/training/v_trainingDetail.dart';

class TrainingListPage extends StatelessWidget {
  const TrainingListPage({Key? key, this.sportid}) : super(key: key);
  final sportid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Training List'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("training").where('sportId',isEqualTo: sportid).orderBy('created_at', descending: true).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
          if(snapshot.hasData){
            // return Text('${snapshot.data?.docs.length}');
            return Container(
              padding: EdgeInsets.all(10),
              child: ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (BuildContext context,int index){
                    final DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];
                    String date = DateFormat.yMMMMd('en_US').format(documentSnapshot['start_at'].toDate());
                    String time = DateFormat.jm().format(documentSnapshot['start_at'].toDate());
                    // print(documentSnapshot['startTime'][0]);
                    return Card(
                      child: ListTile(
                        title: Text(date),
                        leading: FlutterLogo(size: 56.0),
                        subtitle: Text(time),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => TrainingDetailPage(trainingTitle: date,trainingId: documentSnapshot.id,)));
                          }
                      ),
                    );
                  }),
            );
          }
          return Center(child: Text('Something bugged at trainingList.dart'),);
        }
      ),
    );
  }
}
