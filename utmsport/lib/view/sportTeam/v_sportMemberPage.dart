import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils.dart';

class SportMemberPage extends StatefulWidget {
  const SportMemberPage(
      {Key? key,
      required this.documentid,
      required this.teamName,
      required this.sportType,
      required this.coaches,
      required this.athlete})
      : super(key: key);

  final String documentid;
  final String teamName;
  final String sportType;
  final List coaches;
  final List athlete;

  @override
  State<SportMemberPage> createState() => _SportMemberPageState();
}

class _SportMemberPageState extends State<SportMemberPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController matricnocontroller = TextEditingController();
  var athleteArr = [];
  var coachArr = [];

  Future<void> EnrollAthlete() async {
    List<String> matricArray =
        matricnocontroller.text.trim().toUpperCase().split(" ");
    final CollectionReference userList =
        FirebaseFirestore.instance.collection("users");
    for (var matric in matricArray) {
      await userList
          .where('matric', isEqualTo: matric)
          .get()
          .then((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          //Define the roles is coach or student
          final DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
          if(documentSnapshot['roles'] == "student" || documentSnapshot['roles'] == "athlete"){
            print("perform add at student");
            if (!athleteArr.contains(documentSnapshot['matric'])){
              athleteArr.add(documentSnapshot['matric']);
              Utils.showSnackBar("Student Enrolled", "green");
            }else{
              Utils.showSnackBar("Athlete Already Existed", "red");
            }
          }else if(documentSnapshot['roles'] == "coach"){
            print("perform add at coach");
            if (!coachArr.contains(documentSnapshot['matric'])){
              coachArr.add(documentSnapshot['matric']);
              Utils.showSnackBar("Coach Enrolled", "green");
            }else{
              Utils.showSnackBar("Athlete Already Existed", "red");
            }
          }else{
            Utils.showSnackBar("The target is not Student or Coach", "red");
          }

        }else{
          Utils.showSnackBar("Query Not Found", "red");
        }
      });
    }
    setState(() {
      matricnocontroller.text = '';
    });
  }

  Future<void> UpdateMember() async {

    //TODO: ADD athlete and coach in your Team
    FirebaseFirestore.instance
        .collection("sportTeam")
        .doc(widget.documentid)
        .set({
      'athletes': athleteArr.isNotEmpty ? athleteArr : widget.athlete,
      'coaches': coachArr.isNotEmpty ? coachArr : widget.coaches,
      'managerid': FirebaseAuth.instance.currentUser!.uid,
      'sportType': widget.sportType,
      'teamName': widget.teamName,
    }).then((value) {
      athleteArr.forEach((element) {
        FirebaseFirestore.instance.collection("users").where('matric', isEqualTo: element).get()
            .then((querySnapshot) {
          final DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
          FirebaseFirestore.instance.collection("users").doc(documentSnapshot.id).set({
            'image': documentSnapshot['image'],
            'matric': documentSnapshot['matric'],
            'name': documentSnapshot['name'],
            'phoneno': documentSnapshot['phoneno'],
            'roles': 'athlete',
            'userId': documentSnapshot['userId'],
          });
        });
      });
    }).then((value) {
      Navigator.of(context).pop();
      Utils.showSnackBar("Added Athlete", "green");
    });
  }

  Widget InputAthlete() {
    //DO a TextArea, collect the data.
    // return Text('data');
    return TextFormField(
      controller: matricnocontroller,
      textInputAction: TextInputAction.done,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: const InputDecoration(
          labelText: 'Insert Matric No', hintText: 'B21EC0059'),
      keyboardType: TextInputType.multiline,
      maxLines: null,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    athleteArr = widget.athlete;
    coachArr = widget.coaches;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Member'),
      ),
      body: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [

              Form(key: _formKey, child: InputAthlete()),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: EnrollAthlete,
                    icon: Icon(Icons.add_circle_rounded),
                    label: Text('Enroll Athlete / Coach'),
                  ),
                ],
              ),
              Text('Sport Team Member List'),
              Expanded(
                  child: FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection("sportTeam")
                          .doc(widget.documentid)
                          .get(),
                      builder:
                          (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.hasError)
                          return Center(
                              child: Text(snapshot.hasError.toString()));
                        if (snapshot.hasData) {
                          //
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('List Coach'),
                              Container(
                                constraints: BoxConstraints(
                                  minHeight: 100,
                                  maxHeight: 200
                                ),
                                color: Colors.green,
                                child: snapshot.data!['coaches'].length == 0
                                    ? Text('Empty')
                                    : SingleChildScrollView(
                                      child: Column(
                                        children: List.generate(
                                            coachArr.length, (index) {
                                            return Container(child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(coachArr[index]),
                                              IconButton(onPressed: (){
                                                coachArr.removeAt(index);
                                                setState(() {

                                                });
                                              }, icon: Icon(Icons.delete), color: Colors.red,)
                                            ],
                                          ));
                                        }),
                                  ),
                                ),
                              ),
                              Text('List Athlete'),
                              Expanded(
                                child: Container(
                                  color: Colors.orange,
                                  child: snapshot.data!['athletes'].length == 0
                                      ? Text('Empty')
                                      : SingleChildScrollView(
                                          child: Column(
                                            children: List.generate(
                                              athleteArr.length, (index) {
                                              return Container(child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(athleteArr[index]),
                                                  IconButton(onPressed: (){
                                                      athleteArr.removeAt(index);
                                                      setState(() {

                                                      });
                                                    }, icon: Icon(Icons.delete), color: Colors.red,)
                                                ],
                                              ));
                                            }),
                                          ),
                                        ),
                                ),
                              )
                            ],
                          );
                          if (snapshot.data!['coaches'].length == 0)
                            print('its empty in coaches');
                          if (snapshot.data!['athletes'].length == 0)
                            print('its empty in athletes');
                          print(snapshot.data!['teamName']);
                          return Text('has Data');
                        }
                        return Text('Something error');
                      })),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: UpdateMember,
                      icon: Icon(Icons.insert_chart_sharp ),
                      label: Text('Update Member'),
                    ),
                  ),
                ],
              )
            ],
          )),
    );
  }
}
