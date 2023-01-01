import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:utmsport/globalVariable.dart' as globaldart;
import 'package:utmsport/utils.dart';

class TimesAvailableMeet extends StatefulWidget {
  const TimesAvailableMeet({Key? key}) : super(key: key);

  @override
  State<TimesAvailableMeet> createState() => _TimesAvailableMeetState();
}

class _TimesAvailableMeetState extends State<TimesAvailableMeet> {
  TimeOfDay _time = TimeOfDay(hour: 7, minute: 15);
  String timedata = "";

  void _selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (newTime != null) {
      setState(() {
        //ADD data in TS_Meet

        _time = newTime;
        print(_time.runtimeType);
        print(_time);
        timedata = formatTimeOfDay(_time);
        globaldart.FFdb.collection("availabletime")
            .add({"time": timedata})
            .then((value) => Utils.showSnackBar("Added new time", "green"))
            .onError((error, stackTrace) =>
                "something error occured during add availabletime");
      });
    }
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.Hm(); //"6:00 AM"
    return format.format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Time Available"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            ElevatedButton.icon(
                onPressed: _selectTime,
                icon: Icon(Icons.add),
                label: Text("Add New Time ")),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  constraints: BoxConstraints(minWidth: 100, maxWidth: 370),

                  height: 450,
                  child: StreamBuilder(
                      stream: globaldart.FFdb.collection("availabletime")
                          .orderBy("time", descending: false)
                          .snapshots(),
                      builder:
                          (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting)
                          return Center(child: CircularProgressIndicator());
                        if (snapshot.hasData) {
                          return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                final DocumentSnapshot documentSnapshot =
                                    snapshot.data!.docs[index];
                                //Create gesture
                                return Container(
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black38),
                                      borderRadius: BorderRadius.circular(5)
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(documentSnapshot['time']),
                                          IconButton(
                                              onPressed: () async {
                                                await globaldart.FFdb.collection("availabletime").doc(documentSnapshot.id).delete();
                                                print("delete");
                                                Utils.showSnackBar("Deleted " + documentSnapshot['time'], "red");
                                                },
                                              icon: Icon(Icons.delete))

                                        ]));
                              });
                          print(snapshot.data!.docs.length);
                          Text("test");
                        }
                        return Text("Test");
                      }),
                ),
              ),
            ),

            //  Display List of time they added
          ],
        ),
      ),
    );
  }
}
