import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:utmsport/globalVariable.dart' as global;
import '../../utils.dart';
import 'detailsView_cm_advbooking.dart';

class  CMlistviewNcrudCourtBook extends StatefulWidget {
  @override
  State<CMlistviewNcrudCourtBook > createState() => _CMlistviewNcrudCourtBookState();
}

class _CMlistviewNcrudCourtBookState extends State<CMlistviewNcrudCourtBook > {
  final TextEditingController _TitleController = TextEditingController();
  final TextEditingController _TimeController = TextEditingController();
  final TextEditingController _DateController = TextEditingController();
  final TextEditingController _matricNoController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final CollectionReference _cmCourtBooks = global.FFdb.collection('cmCourtBooks');

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _TitleController.text = documentSnapshot['title'];
      _TimeController.text = documentSnapshot['time'].toString();
      _DateController.text = documentSnapshot['date'];
      _matricNoController.text = documentSnapshot['matricno'];
      _phoneNoController.text = documentSnapshot['phoneno'].toString();
      _descriptionController.text = documentSnapshot['description'];
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return SingleChildScrollView(
            child: Padding(
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
                    controller: _TitleController,
                    decoration: const InputDecoration(labelText: 'Title'),
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
                      }),
                  TextField(
                    controller: _matricNoController,
                    decoration:
                    const InputDecoration(labelText: 'Staff Number'),
                  ),
                  TextField(
                    controller: _phoneNoController,
                    decoration:
                    const InputDecoration(labelText: 'Phone Number'),
                  ),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    child: const Text('Update'),
                    onPressed: () async {
                      final String title = _TitleController.text;
                      final String time = _TimeController.text;
                      final String date = _DateController.text;
                      final String matricno = _matricNoController.text;
                      final String phoneno = _phoneNoController.text;
                      final String description = _descriptionController.text;

                      await _cmCourtBooks.doc(documentSnapshot!.id).update({
                        "title": title,
                        "time": time,
                        "date": date,
                        "matricno": matricno,
                        "phoneno": phoneno,
                        "description": description
                      });

                      _TitleController.text = '';
                      _TimeController.text = '';
                      _DateController.text = '';
                      _matricNoController.text = '';
                      _phoneNoController.text = '';
                      _descriptionController.text = '';
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                              'You have successfully updated your booking')));
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  Future<void> _delete(String cmCourtBookId) async {
    await _cmCourtBooks.doc(cmCourtBookId).delete();
    // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //     content: Text('You have successfully deleted an appointment')));
    Utils.showSnackBar('You have successfully deleted a booking');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text ("Court Booking List"),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // GestureDetector(
              //   onTap: () => Navigator.push(
              //       context, MaterialPageRoute(builder: (context) => Calendar())),
              //   child: Container(
              //     width: 500,
              //     height: 150,
              //     padding: EdgeInsets.all(10),
              //     margin: EdgeInsets.all(10),
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(10),
              //       color: Colors.red,
              //     ),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         Container(
              //           padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
              //           child: Column(
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Text(
              //                 'Meeting Appointment',
              //                 style: TextStyle(
              //                     fontWeight: FontWeight.bold, fontSize: 18),
              //               ),
              //               Text('Click to Book Now')
              //             ],
              //           ),
              //         ),
              //         Container(
              //           height: 120,
              //           width: 150,
              //           decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(10),
              //             color: Colors.blue,
              //           ),
              //           transform: Matrix4.rotationZ(-0.05),
              //         )
              //       ],
              //     ),
              //   ),
              // ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Text(
                  'Your Request List',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
              Container(
                // color: Colors.green,
                width: 500,
                height: 360,
                child: StreamBuilder(
                  stream: _cmCourtBooks
                      .where('uid',
                      isEqualTo: global.FA.currentUser!.uid)
                      .orderBy('created_at', descending: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                    if (streamSnapshot.connectionState == ConnectionState.waiting)
                      return Center(child: CircularProgressIndicator());
                    if (streamSnapshot.hasData) {
                      //TODO: filter the users data
                      return ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: streamSnapshot.data!.docs.length,
                          //Here you can see that I will get the count of my data
                          itemBuilder: (context, int) {
                            //perform the task you want to do here
                            final DocumentSnapshot documentSnapshot =
                            streamSnapshot.data!.docs[int];

                            return Card(
                              margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                              child: GestureDetector(
                                onTap: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => cmCourtBookingDetail(
                                              document: documentSnapshot)));
                                },
                                child: ListTile(
                                  title: Text(documentSnapshot['title']),
                                  // subtitle: Text(documentSnapshot['time']),
                                  subtitle: Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(documentSnapshot['time']),
                                            Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.horizontal(
                                                      left: Radius.circular(10),
                                                      right:
                                                      Radius.circular(10)),
                                                  color:
                                                  documentSnapshot['status'] ==
                                                      'rejected'
                                                      ? Colors.red
                                                      : documentSnapshot[
                                                  'status'] ==
                                                      'approved'
                                                      ? Colors.green
                                                      : Colors.yellow,
                                                ),
                                                width: 85,
                                                margin: EdgeInsets.fromLTRB(
                                                    10, 0, 0, 0),
                                                padding: EdgeInsets.fromLTRB(
                                                    10, 2, 10, 2),
                                                child: Text(
                                                  documentSnapshot['status'],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w900),
                                                )),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  trailing: SizedBox(
                                    width: 100,
                                    child: Row(
                                      children: [
                                        // IconButton(
                                        //     icon: Icon(Icons.qr_code_scanner_outlined,
                                        //         color:
                                        //         documentSnapshot['status'] == 'approved'
                                        //             ? Colors.orange
                                        //             : Colors.grey
                                        //     ),
                                        //     // onPressed:
                                        //     // documentSnapshot['status'] == 'approved'
                                        //     //     ? () => QRGenerate()
                                        //     //     : null
                                        //     onPressed:(){
                                        //       Navigator.push(context,
                                        //           MaterialPageRoute(builder: (context) => QRGenerate() ,)
                                        //       );},
                                        // ),
                                        IconButton(
                                            icon: Icon(Icons.edit,
                                                color:
                                                documentSnapshot['status'] == 'pending'
                                                    ? Colors.green
                                                    : Colors.grey
                                            ),
                                            onPressed:
                                            documentSnapshot['status'] == 'pending'
                                                ? () => _update(documentSnapshot)
                                                : null
                                        ),
                                        IconButton(
                                            icon: Icon(Icons.delete,
                                                color:
                                                documentSnapshot['status'] == 'pending'
                                                    ? Colors.red
                                                    : Colors.grey
                                            ),
                                            onPressed:
                                            documentSnapshot['status'] == 'pending'
                                                ? ()=>  _delete(documentSnapshot.id)
                                                : null
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                    }
                    if (streamSnapshot.hasError)
                      return Text('Something went wrong');
                    return Text('No Recorded founded');
                  },
                ),
              )
            ]),
      ),
    );
  }
}
