import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:utmsport/globalVariable.dart' as global;

class TeamAthletePage extends StatefulWidget {
  const TeamAthletePage({Key? key}) : super(key: key);

  @override
  State<TeamAthletePage> createState() => _TeamAthletePageState();
}

class _TeamAthletePageState extends State<TeamAthletePage> {

  @overrideboo
  void initState() {
    // TODO: implement initState
    super.initState();
    // fetchData();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          StreamBuilder(
              stream: FirebaseFirestore.instance.collection("users").doc(global.FA.currentUser!.uid).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot){
                if(snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
                if(snapshot.hasData){
                  // print(snapshot.data!['matric']);
                //  Build FutureBuilder to receive sportTeam Dat
                  return StreamBuilder(
                      stream: FirebaseFirestore.instance.collection("sportTeam").where("athletes", arrayContains: snapshot.data!['matric']).snapshots(),
                      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                        if(snapshot.connectionState == ConnectionState.waiting){
                          return Center(child: CircularProgressIndicator(),);
                        }
                        if(snapshot.hasData){
                          //Return Row that can scroll
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Your Sport Team'),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: List.generate(snapshot.data!.docs.length, (index) {
                                    //Generate Container
                                    return GestureDetector(
                                      onTap: (){
                                        //  TODO: Do SportTeam Details
                                        print("DocumentID sportTeam: "+snapshot.data!.docs[index].id);
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(
                                          top: 10,
                                          right: 20
                                        ),
                                        constraints: BoxConstraints(
                                          minWidth: 175,
                                          maxWidth: 250,
                                          minHeight: 70
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.green
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(snapshot.data!.docs[index]['teamName']),
                                            Text(snapshot.data!.docs[index]['sportType']),
                                          ],
                                        ),
                                      ),
                                    );
                                    // return Text('Generate ${snapshot.data!.docs[index]['teamName']}');
                                  }),
                                ),
                              )
                            ],
                          );
                          return Text('Has nested data');
                        }
                        return Text('Something error in nested');
                      });
                  return Text('Has Data');
                }
                return Text('Error User document retrieve');
            })
        ],
      )
    );
  }
}
