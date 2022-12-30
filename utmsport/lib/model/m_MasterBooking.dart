import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:utmsport/globalVariable.dart' as global;
import 'package:utmsport/utils.dart';
import 'package:utmsport/model/m_CourtBooking.dart';

class MasterBooking {
  List<dynamic> booked_courtTimeslot;
  DateTime date;
  String userId;
  String bookingId;
  String sportsType;

  MasterBooking({
    required this.booked_courtTimeslot,
    required this.date,
    required this.userId,
    required this.bookingId,
    required this.sportsType,
    // required this.sportsType,
  });

  Map<String, dynamic> toJson() => {
        "booked_courtTimeslot": booked_courtTimeslot,
        "date": date,
        "userId": userId,
        "bookingId": bookingId,
      };

  static mapStartTime(selectedCourtTimeslot, dateList) {
    List a = selectedCourtTimeslot.map((e) {
      int index = selectedCourtTimeslot.indexOf(e);
      return {"${dateList[index]}": e};
    }).toList();
    // print(a[0]['2022-12-19 00:00:00.000']);
    return a;
  }

  static List nestedArrayToObject(
    courtTimeslot,
  ) {
    List newObjectArray = [];
    for (int i = 0; i < global.timeslot.length + 1; i++) {
      print(courtTimeslot[i]);
      var convertedCourtTimeslot = courtTimeslot[i]
          .map((e) => e.contains("Check") ? "Booked" : e)
          .toList();
      newObjectArray.add({'court': convertedCourtTimeslot});
    }
    print(newObjectArray);
    return newObjectArray;
  }

  static void fetchFBObjectToNestedArray(
      {required List<List<String>> courtTimeslot,
      noOfTimeslot: 9,
      noOfCourt}) async {
    await global.FFdb.collection('master_booking')
        .where('date', isEqualTo: DateTime(2022, 12, 5))
        .get()
        .then((val) {
      if (val.docs.length == 0)
        createNestedCTArray(null, null, null,
            noOfTimeslot: noOfTimeslot, noOfCourt: noOfCourt);
      else
        val.docs.forEach((element) {
          var cts = element['booked_courtTimeslot'];
          for (int i = 0; i < noOfTimeslot + 1; i++) {
            courtTimeslot.add(cts[i]['court']);
          }
        });
    });
  }

  //create court-timeslot 2d array
  static List<List<String>> createNestedCTArray(
      dynamic date, dynamic dateList, dynamic documents,
      {required int noOfTimeslot, required int noOfCourt}) {
    List mapDocDates = documents.map((e) => e["date"].toDate()).toList();
    List<List<String>> ct = [];
    int docIndex = mapDocDates.indexOf(date);
    if (docIndex >= 0) {
      var ctRowCol = documents[docIndex]['booked_courtTimeslot'];
      for (int row = 0; row <= noOfTimeslot; row++)
        ct.add(List.from(ctRowCol[row]['court']));
    } else {
      for (int row = 0; row <= noOfTimeslot; row++) {
        List<String> ctRow = [];
        for (int col = 0; col <= noOfCourt; col++) {
          if (row == 0 && col == 0)
            ctRow.add("B");
          else if (col != 0 && row == 0)
            ctRow.add("C$col");
          else if (col == 0 && row != 0)
            ctRow.add("T$row");
          else
            ctRow.add("");
        }
        ct.add(ctRow);
      }
    }
    return ct;
  }

  //TODO: cm-add sports-type into master-booking db
  static void insertAdvBooking(
      dynamic widget,
      List<List<List<String>>> masterBookingArray,
      context,
      selectedCourtTimeslot) async {
    final _bookingId = global.FFdb.collection('student_appointment').doc().id;
    final _bookingDetails = CourtBooking(
      id: _bookingId,
      userId: global.USERID,
      subject: "Advanced Booking",
      color: "0x${Colors.blueAccent.value.toRadixString(16)}",
      status: "Pending",
      createdAt: Timestamp.fromDate(DateTime.now()),
      personInCharge: "Joan",
      attachment: "insert file",
      startTime: mapStartTime(selectedCourtTimeslot, widget.dateList),
      dateList: widget.dateList,
    ).advToJson();

    var _masterBooking;

    CollectionReference advCourtBooking =
        global.FFdb.collection('student_appointments');
    CollectionReference masterCourtBooking =
        global.FFdb.collection('master_booking');

    try {
      //add student_appointments
      advCourtBooking.add(_bookingDetails);

      //add master_booking
      for (int dateIndex = 0; dateIndex < widget.dateList.length; dateIndex++) {
        var date = widget.dateList[dateIndex];
        _masterBooking = MasterBooking(
          booked_courtTimeslot:
              MasterBooking.nestedArrayToObject(masterBookingArray[dateIndex]),
          date: date,
          userId: global.USERID,
          bookingId: _bookingId,
          sportsType: "Badminton", //TODO: Joan Change this
        ).toJson();
        await masterCourtBooking.where("date", isEqualTo: date).get().then((value) {
          if (value.docs.length == 0) {
            print("add adv");
            masterCourtBooking.add(_masterBooking);
          } else {
            print("update adv");
            value.docs.forEach((element) {
              masterCourtBooking
                  .doc(element.id)
                  .update(_masterBooking)
                  .then((_) {
                Utils.showSnackBar("Updated an advanced booking", "green");
                Navigator.pushNamed(context, '/');
              });
            });
          }

          Navigator.pushNamed(context, '/');
        });
      }
    } catch (e) {
      print(e);
    }
  }
}
