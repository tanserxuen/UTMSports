import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:utmsport/utils.dart';
import 'package:utmsport/view/sportTeam/v_createTeamPage.dart';
import 'package:utmsport/view/sportTeam/v_sportMemberPage.dart';
import 'package:utmsport/view/training/v_trainingList.dart';

import '../advBooking/v_createAdvancedCalendar.dart';

class SportTeamPage extends StatefulWidget {
  const SportTeamPage({Key? key}) : super(key: key);

  @override
  State<SportTeamPage> createState() => _SportTeamPageState();
}

TextEditingController teamNameController = TextEditingController();
List<String> sportType = <String>[
  'basketball',
  'tennis',
  'netball',
  'pingpong'
];

class _SportTeamPageState extends State<SportTeamPage> {
  String dropdownValue = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //  Create SportTeam
          Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("sportTeam")
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator());
                  if (snapshot.hasData) {
                    return ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final DocumentSnapshot documentSnapshot =
                              snapshot.data!.docs[index];
                          return GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => TrainingListPage(sportid: documentSnapshot.id,)));
                            },
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(documentSnapshot['teamName']),
                                  Wrap(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          //  TODO: documentSnapshot.id  ---  SportTeamID
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => CreateAdvBookingCalendar(sportID: documentSnapshot.id)));
                                        },
                                        icon: Icon(Icons.calendar_today_rounded),
                                        color: Colors.indigo
                                      ),
                                      IconButton(
                                        onPressed: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SportMemberPage(
                                                        documentid: documentSnapshot.id,
                                                        teamName: documentSnapshot['teamName'],
                                                        sportType: documentSnapshot['sportType'],
                                                        coaches: documentSnapshot['coaches'],
                                                        athlete: documentSnapshot['athletes'],
                                                    ))),
                                        icon: Icon(Icons.people),
                                        color: Colors.green,
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          if (documentSnapshot != null) {
                                            teamNameController.text =
                                                documentSnapshot['teamName'];
                                            dropdownValue =
                                                documentSnapshot['sportType'];
                                          }
                                          await showModalBottomSheet(
                                              context: context,
                                              builder: (BuildContext ctx) {
                                                return SingleChildScrollView(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                      top: 20,
                                                      left: 20,
                                                      right: 20,
                                                      bottom: MediaQuery.of(ctx)
                                                              .viewInsets
                                                              .bottom +
                                                          20,
                                                    ),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        DropdownButton<String>(
                                                          isExpanded: true,
                                                          value: dropdownValue,
                                                          icon: Icon(Icons
                                                              .arrow_downward),
                                                          elevation: 16,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .deepPurple,
                                                              fontSize: 16),
                                                          underline: Container(
                                                            height: 2,
                                                            color:
                                                                Colors.deepPurple,
                                                          ),
                                                          onChanged:
                                                              (String? value) {
                                                            setState(() {
                                                              dropdownValue =
                                                                  value!;
                                                            });
                                                          },
                                                          items: sportType.map<
                                                              DropdownMenuItem<
                                                                  String>>((String
                                                              value) {
                                                            return DropdownMenuItem<
                                                                String>(
                                                              value: value,
                                                              child: Text(value),
                                                            );
                                                          }).toList(),
                                                        ),
                                                        TextField(
                                                          controller:
                                                              teamNameController,
                                                          decoration:
                                                              InputDecoration(
                                                            labelText:
                                                                "Sport Team Name",
                                                          ),
                                                        ),
                                                        ElevatedButton(
                                                            onPressed: () async {
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      "sportTeam")
                                                                  .doc(
                                                                      documentSnapshot
                                                                          .id)
                                                                  .update({
                                                                "coaches": [],
                                                                "athletes": [],
                                                                "sportType":
                                                                    dropdownValue,
                                                                "teamName":
                                                                    teamNameController
                                                                        .text,
                                                                "managerid":
                                                                    FirebaseAuth
                                                                        .instance
                                                                        .currentUser!
                                                                        .uid
                                                              }).then((value) {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                Utils.showSnackBar(
                                                                    "Updated your Team Details",
                                                                    "green");
                                                              });
                                                            },
                                                            child: Text('Update'))
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              });
                                        },
                                        icon: Icon(Icons.edit),
                                        color: Colors.blue,
                                      ),
                                      IconButton(
                                          onPressed: () async {
                                            //  AlertDialog
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text(
                                                      "Delete Team ${documentSnapshot['teamName']}"),
                                                  titleTextStyle: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,
                                                      fontSize: 20),
                                                  actionsOverflowButtonSpacing:
                                                      20,
                                                  actions: [
                                                    ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text('Cancel')),
                                                    ElevatedButton(
                                                        onPressed: () async {
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "sportTeam")
                                                              .doc(
                                                                  documentSnapshot
                                                                      .id)
                                                              .delete()
                                                              .then((value) => Utils
                                                                  .showSnackBar(
                                                                      "Deleted " +
                                                                          documentSnapshot[
                                                                              'teamName'],
                                                                      "red"));

                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text('Delete')),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          icon: Icon(Icons.delete),
                                          color: Colors.red),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        });

                    return Text(snapshot.data!.docs[0]['teamName']);
                  } else {
                    return Text('No SportTeam Data');
                  }
                }),
          ),
          ElevatedButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TeamListPage())),
              child: Text('Add UTM Sport Team')),

          // add Athlete in Sport Team
        ],
      ),
    );
  }
}
