import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:utmsport/view/appointment/v_requestMeetingDetail.dart';

class RequestMeetingList extends StatefulWidget {
  const RequestMeetingList({Key? key}) : super(key: key);

  @override
  State<RequestMeetingList> createState() => _RequestMeetingListState();
}

class _RequestMeetingListState extends State<RequestMeetingList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Meeting Request',
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          width: 500,
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('appointments')
                .orderBy('created_at', descending: true)
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(child: CircularProgressIndicator());
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (content, index) {
                      final DocumentSnapshot documentSnapshot =
                          snapshot.data!.docs[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RequestMeetingDetail(
                                      document: documentSnapshot)));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: documentSnapshot['status'] == 'approved'
                                  ? Colors.green.shade200
                                  : documentSnapshot['status'] == 'rejected'
                                      ? Colors.red.shade200
                                      : Colors.yellow.shade200,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.shade600,
                                    spreadRadius: 1,
                                    blurRadius: 1,
                                    offset: Offset(0, 2))
                              ]),
                          height: 100,
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                          child: Flex(
                              direction: Axis.horizontal,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 250,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              documentSnapshot['eventtitle'],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                                'Event Date: 10/1/22 - 10/1/22'),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              child: Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      12, 5, 12, 5),
                                                  child: Text(
                                                    documentSnapshot['date'],
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        letterSpacing: 1),
                                                  )),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors
                                                            .grey.shade600,
                                                        spreadRadius: 0,
                                                        blurRadius: 2,
                                                        offset: Offset(0, 2))
                                                  ]),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              child: Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      12, 5, 12, 5),
                                                  child: Text(
                                                    documentSnapshot['time'],
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        letterSpacing: 1),
                                                  )),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors
                                                            .grey.shade600,
                                                        spreadRadius: 0,
                                                        blurRadius: 2,
                                                        offset: Offset(0, 2))
                                                  ]),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        width: 100,
                                        child: ElevatedButton(
                                            onPressed:
                                                documentSnapshot['status'] ==
                                                        'pending'
                                                    ? () => showDialog<String>(
                                                        context: context,
                                                        builder: (BuildContext
                                                                context) =>
                                                            AlertDialog(
                                                              title: const Text(
                                                                  'Confirmation'),
                                                              content: const Text(
                                                                  'Do you want to approve?'),
                                                              actions: <Widget>[
                                                                TextButton(
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                          context,
                                                                          'Cancel'),
                                                                  child: const Text(
                                                                      'Cancel'),
                                                                ),
                                                                TextButton(
                                                                  onPressed: () => _approve(
                                                                          documentSnapshot)
                                                                      .then((value) => Navigator.pop(
                                                                          context,
                                                                          'OK')),
                                                                  child:
                                                                      const Text(
                                                                          'Ok'),
                                                                )
                                                              ],
                                                            ))
                                                    : null,
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.green,
                                            ),
                                            child: Text('Approve')),
                                      ),
                                      Container(
                                        width: 100,
                                        child: ElevatedButton(
                                            onPressed:
                                                documentSnapshot['status'] ==
                                                        'pending'
                                                    ? () => showDialog<String>(
                                                        context: context,
                                                        builder: (BuildContext
                                                                context) =>
                                                            AlertDialog(
                                                              title: const Text(
                                                                  'Confirmation'),
                                                              content: const Text(
                                                                  'Do you want to reject?'),
                                                              actions: <Widget>[
                                                                TextButton(
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                          context,
                                                                          'Cancel'),
                                                                  child: const Text(
                                                                      'Cancel'),
                                                                ),
                                                                TextButton(
                                                                  onPressed: () => _reject(
                                                                          documentSnapshot)
                                                                      .then((value) => Navigator.pop(
                                                                          context,
                                                                          'OK')),
                                                                  child:
                                                                      const Text(
                                                                          'Ok'),
                                                                )
                                                              ],
                                                            ))
                                                    : null,
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.red,
                                            ),
                                            child: Text('Reject')),
                                      ),
                                    ],
                                  ),
                                )
                              ]),
                        ),
                      );
                    });
              }
              return Text('Error data');
            },
          ),
        ),
      ),
    );
  }
}

Future<void> _reject(DocumentSnapshot? documentSnapshot) async {
  if (documentSnapshot != null) {
    //Todo: Send Notification upon rejected
    return update(documentSnapshot, 'rejected')
        .then((_) => print('rejected Successfully'));
  }
}

Future<void> _approve([DocumentSnapshot? documentSnapshot]) async {
  if (documentSnapshot != null) {
    //Todo: Send Notification upon accepted
    return update(documentSnapshot, 'approved')
        .then((_) => print('approved successfully'));
  }
}

update(DocumentSnapshot? documentSnapshot, String status) async {
  return await FirebaseFirestore.instance
      .collection('appointments')
      .doc(documentSnapshot!.id)
      .update({
    'date': documentSnapshot['date'],
    'description': documentSnapshot['description'],
    'email': documentSnapshot['email'],
    'eventtitle': documentSnapshot['eventtitle'],
    'file': documentSnapshot['file'],
    'matricno': documentSnapshot['matricno'],
    'name': documentSnapshot['name'],
    'phoneno': documentSnapshot['phoneno'],
    'pic': documentSnapshot['pic'],
    'status': status,
    'time': documentSnapshot['time'],
    'uid': documentSnapshot['uid']
  });
}
