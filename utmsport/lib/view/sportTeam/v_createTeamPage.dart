import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:utmsport/utils.dart';

import '../../main.dart';

class TeamListPage extends StatefulWidget {
  const TeamListPage({Key? key}) : super(key: key);

  @override
  State<TeamListPage> createState() => _TeamListPageState();
}

final _formKey = GlobalKey<FormState>();
TextEditingController teamNameController = TextEditingController();
List<String> sportType = <String>[
  'basketball',
  'tennis',
  'netball',
  'pingpong'
];

class _TeamListPageState extends State<TeamListPage> {
  String dropdownValue = sportType.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Sport Team UTM')),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              //  SportTeam type:
              Row(
                children: [
                  Expanded(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: dropdownValue,
                      icon: Icon(Icons.arrow_downward),
                      elevation: 16,
                      style: TextStyle(color: Colors.deepPurple, fontSize: 16),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurple,
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          dropdownValue = value!;
                        });
                      },
                      items: sportType
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              //  SportTeam name:
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Team Name',
                ),
                controller: teamNameController,
                textInputAction: TextInputAction.done,
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),

              Row(
                children: [
                  Expanded(
                      child: ElevatedButton.icon(
                    onPressed: () async {
                      var data = {
                        "coaches" : [],
                        "athletes": [],
                        "sportType": dropdownValue,
                        "teamName": teamNameController.text,
                        "managerid": FirebaseAuth.instance.currentUser!.uid
                      };
                      print(data);
                      await FirebaseFirestore.instance.collection("sportTeam").add(data)
                          .then((value) => Utils.showSnackBar("Sport Team Created", "green"));
                      navigatorKey.currentState!.popUntil((route) => route.isFirst);
                    },
                    icon: Icon(Icons.add),
                    label: Text('Create Sport Team'),
                  )),
                ],
              )
              //  athlete:  []
              //  coach:    []
            ],
          ),
        ),
      ),
    );
  }
}
