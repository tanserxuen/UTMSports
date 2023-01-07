import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:utmsport/view/authentication/v_homePage.dart';

class ViewFeedback extends StatefulWidget {
  const ViewFeedback({Key? key}) : super(key: key);

  @override
  State<ViewFeedback> createState() => _ViewFeedbackState();
}

class _ViewFeedbackState extends State<ViewFeedback> {
  List feedbacks = [];

  final CollectionReference feedbackList =
      FirebaseFirestore.instance.collection("feedback");

  @override
  void initState() {
    super.initState();
    fetchFeedbacks();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: feedbackList.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text("Something went wrong");
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          if (!snapshot.hasData)
            return MyHomePage();
          else
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(13, 16, 8, 16),
                  child: Text("List of Feedbacks",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w700)),
                ),
                buildDatatable(snapshot)
              ],
            );
        });
  }

  Widget buildDatatable(snapshot) {
    var data = snapshot.data!.docs;
    var listOfColumns = [];
    for (int i = 0; i < data.length; i++) {
      var dataRow = data[i];
      listOfColumns.add({
        "id": dataRow['id'] ?? "",
        "image": dataRow['image'] ?? "",
        "comment": dataRow['comment'] ?? "",
      });
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DataTable(
            headingRowColor: MaterialStateColor.resolveWith(
                (states) => const Color(0x5540C4FF)),
            columns: [
              DataColumn(
                label: Text('#'),
              ),
              DataColumn(
                label: Text('Image'),
              ),
              DataColumn(
                label: Text('Comments'),
              ),
            ],
            rows: listOfColumns.map(
              ((element) {
                int index = listOfColumns.indexOf(element) + 1;
                return DataRow(
                  cells: <DataCell>[
                    DataCell(Container(
                        width: 10,
                        child: Text(
                          index.toString(),
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ))),
                    DataCell(Text(
                      element?["image"] ?? "",
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    )),
                    DataCell(
                      Container(
                        width: 150,
                        child: Text(
                          element?["comment"] ?? "",
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ).toList(),
          ),
        ],
      ),
    );
  }

  void fetchFeedbacks() async {
    try {
      await feedbackList.get().then((querySnapshot) {
        setState(() {
          this.feedbacks = querySnapshot.docs
              .map((fb) => {
                    "id": fb['id'],
                    "image": fb['image'],
                    "comment": fb['comment'],
                  })
              .toList();
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
