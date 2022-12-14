import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';


class listViewAppointment extends StatefulWidget {
  @override
  State<listViewAppointment> createState() => _listViewAppointmentState();

}

class _listViewAppointmentState extends State<listViewAppointment> {

  final TextEditingController _eventTitleController = TextEditingController();
  final TextEditingController _TimeController = TextEditingController();
  final TextEditingController _DateController = TextEditingController();
  final TextEditingController _PicController = TextEditingController();
  final TextEditingController _matricNoController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final CollectionReference _appointments =
  FirebaseFirestore.instance.collection('appointments');

  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _eventTitleController,
                  decoration: const InputDecoration(labelText: 'Event Title'),
                ),
                TextField(
                  controller: _TimeController,
                  decoration: const InputDecoration(labelText: 'Time'),
                ),
                TextField(
                    controller: _DateController,
                    decoration: InputDecoration(
                        labelText: "Date",
                        suffixIcon: Icon(Icons.calendar_today)),
                    readOnly: true,
                    onTap: () async {

                      DateTime? value = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100));

                      if (value == null) return null;
                      String date;
                      setState(() => {
                        date = DateFormat('yyyy-MM-dd').format(value),
                        _DateController.text = date,
                        print(date),
                      });
                    }
                ),
                TextField(
                  controller: _PicController,
                  decoration: const InputDecoration(labelText: 'Person in charge'),
                ),
                TextField(
                  controller: _matricNoController,
                  decoration: const InputDecoration(labelText: 'Matric Number'),
                ),
                TextField(
                  controller: _phoneNoController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Create'),
                  onPressed: () async {
                    // final String name = _nameController.text;
                    final String eventtitle = _eventTitleController.text;
                    final String time = _TimeController.text;
                    final String date = _DateController.text;
                    final String pic = _PicController.text;
                    final String matricno = _matricNoController.text;
                    final String phoneno = _phoneNoController.text;
                    final String description = _descriptionController.text;

                    if (eventtitle != null) {
                      await _appointments.add({
                        "eventtitle": eventtitle,
                        "time": time,
                        "date": date,
                        "pic": pic,
                        "matricno": matricno,
                        "phoneno": phoneno,
                        "description": description

                      });

                      _eventTitleController.text = '';
                      _TimeController.text = '';
                      _DateController.text = '';
                      _PicController.text = '';
                      _matricNoController.text = '';
                      _phoneNoController.text = '';
                      _descriptionController.text = '';
                      Navigator.of(context).pop();
                      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      //     content: Text('You have successfully added an appointment')));
                      showDialog(context: context, builder: (BuildContext context){
                        return AlertDialog(
                            title: Text("Success"),
                            titleTextStyle:
                            TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,fontSize: 20),
                            actionsOverflowButtonSpacing: 20,
                            actions: [
                              // ElevatedButton(
                              //  child: const Text("Back"),
                              //     onPressed:(){
                              //       Navigator.push(context,
                              //           MaterialPageRoute(builder: (context) => MeetingForm(),)
                              //       );},
                              //   ),
                              ElevatedButton(
                                child: const Text("ok"),
                                onPressed: (){
                                  // _navigateToNextScreen(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => listViewAppointment()),
                                  );
                                  //Navigator.of(context).pop();
                                },
                              ),
                            ],
                            content: Text("Booked successfully"));
                      });
                    }
                  },
                )
              ],
            ),
          );

        });
  }

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {

    if (documentSnapshot != null) {

      _eventTitleController.text = documentSnapshot['eventtitle'];
      _TimeController.text = documentSnapshot['time'].toString();
      _DateController.text = documentSnapshot['date'];
      _PicController.text = documentSnapshot['pic'].toString();
      _matricNoController.text = documentSnapshot['matricno'];
      _phoneNoController.text = documentSnapshot['phoneno'].toString();
      _descriptionController.text = documentSnapshot['description'];

    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _eventTitleController,
                  decoration: const InputDecoration(labelText: 'Event Title'),
                ),
                TextField(
                  controller: _TimeController,
                  decoration: const InputDecoration(labelText: 'Time'),
                ),
                TextField(
                    controller: _DateController,
                    decoration: InputDecoration(
                        labelText: "Date",
                        suffixIcon: Icon(Icons.calendar_today)),
                    readOnly: true,
                    onTap: () async {

                      DateTime? value = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100));

                      if (value == null) return null;
                      String date;
                      setState(() => {
                        date = DateFormat('yyyy-MM-dd').format(value),
                        _DateController.text = date,
                        print(date),
                      });
                    }
                ),
                TextField(
                  controller: _PicController,
                  decoration: const InputDecoration(labelText: 'Person in charge'),
                ),
                TextField(
                  controller: _matricNoController,
                  decoration: const InputDecoration(labelText: 'Matric Number'),
                ),
                TextField(
                  controller: _phoneNoController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text( 'Update'),
                  onPressed: () async {
                    final String eventtitle = _eventTitleController.text;
                    final String time = _TimeController.text;
                    final String date = _DateController.text;
                    final String pic = _PicController.text;
                    final String matricno = _matricNoController.text;
                    final String phoneno = _phoneNoController.text;
                    final String description = _descriptionController.text;

                    if (eventtitle != null) {
                      await _appointments
                          .doc(documentSnapshot!.id)
                          .update({
                        "eventtitle": eventtitle,
                        "time": time,
                        "date": date,
                        "pic": pic,
                        "matricno": matricno,
                        "phoneno": phoneno,
                        "description": description
                      });

                      _eventTitleController.text = '';
                      _TimeController.text = '';
                      _DateController.text = '';
                      _PicController.text = '';
                      _matricNoController.text = '';
                      _phoneNoController.text = '';
                      _descriptionController.text = '';
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('You have successfully updated your appointment')));

                    }
                  },
                )
              ],
            ),
          );
        });
  }

  Future<void> _delete(String appointmentId) async {
    await _appointments.doc(appointmentId).delete();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted an appointment')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text ("Appointment List"),
        centerTitle: true,
        /*actions: <Widget>[
          IconButton(
            icon: Icon(Icon.person),
            onPressed: () => Navigator.pushNamed(context,
              AppRoutes.profile),
          )
        ],*/
      ),
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 500,
                height: 600,
                child: StreamBuilder(
                  stream: _appointments.snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                    if (streamSnapshot.hasData) {
                      return ListView.builder(
                        itemCount: streamSnapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final DocumentSnapshot documentSnapshot =
                          streamSnapshot.data!.docs[index];
                          return Card(
                            margin: const EdgeInsets.all(10),
                            child: ListTile(
                              title: Text(documentSnapshot['eventtitle']),
                              subtitle: Text(documentSnapshot['time']),
                              trailing: SizedBox(
                                width: 100,
                                child: Row(
                                  children: [
                                    IconButton(
                                        icon: const Icon(Icons.edit, color: Colors.green),
                                        onPressed: () =>
                                            _update(documentSnapshot)),
                                    IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () =>
                                            _delete(documentSnapshot.id)),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }

                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              )
            ]
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _create(),
        child: const Icon(Icons.add,),

      ),
      // // floatingActionButton: FloatingActionButton(
      // //   child: Icon(Icons.add),
      // //   //onPressed: showAppointmentDialog,
      // //   onPressed: (){
      // //     Navigator.push(context,
      // //         MaterialPageRoute(builder: (context) => AddAppointment(),)
      // //     );
      // //   },
      // // ),
    );
  }
}


