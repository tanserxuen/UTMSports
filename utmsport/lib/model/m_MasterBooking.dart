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
  String sportType;

  MasterBooking({
    required this.booked_courtTimeslot,
    required this.date,
    required this.userId,
    required this.bookingId,
    required this.sportType,
  });

  Map<String, dynamic> masterToJson() => {
        "booked_courtTimeslot": booked_courtTimeslot,
        "date": date,
        "userId": userId,
        "bookingId": bookingId,
        "sportType": sportType,
      };

  static mapStartTime(selectedCourtTimeslot, dateList) {
    List a = selectedCourtTimeslot.map((e) {
      int index = selectedCourtTimeslot.indexOf(e);
      return {"${dateList[index]}": e};
    }).toList();
    return a;
  }

  static List nestedArrayToObject(
    courtTimeslot,
  ) {
    List newObjectArray = [];
    for (int i = 0; i < global.timeslot.length + 1; i++) {
      var convertedCourtTimeslot = courtTimeslot[i]
          .map((e) => e.contains("Check") ? "Booked" : e)
          .toList();
      newObjectArray.add({'court': convertedCourtTimeslot});
    }
    return newObjectArray;
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
      {required String subject,
      String bookingType: "Sport Events",
      dynamic widget,
      required List<List<List<String>>> masterBookingArray,
      context,
      selectedCourtTimeslot,
      phoneNo,
      attachment,
      personInCharge,
      formType, bookingId}) async {
    bool isEditForm = formType == 'Edit';
    // widget.stuAppModel?['id'] != null &&
    // widget.stuAppModel?['id'] != "";
    // final _bookingId = global.FFdb.collection('student_appointment').doc().id;
    final color = getColor(bookingType);
    final _bookingDetails = CourtBooking(
      id: isEditForm ? widget.stuAppModel['id'] : bookingId,
      userId: global.USERID,
      subject: subject,
      color: color,
      status: "Pending",
      createdAt: Timestamp.fromDate(DateTime.now()),
      startTime: mapStartTime(selectedCourtTimeslot, widget.dateList),
      dateList: widget.dateList,
      bookingType: bookingType,
      attachment: attachment,
      phoneNo: phoneNo,
      personInCharge: personInCharge,
    ).advToJson();

    var _masterBooking;

    CollectionReference advCourtBooking =
        global.FFdb.collection('student_appointments');
    CollectionReference masterCourtBooking =
        global.FFdb.collection('master_booking');

    try {
      //update existing adv booking
      if (isEditForm) {
        advCourtBooking
            .where("id", isEqualTo: widget.stuAppModel['id'])
            .get()
            .then((value) {
          value.docs.forEach((element) {
            advCourtBooking
                .doc(element.id)
                .update(_bookingDetails)
                .then((_) async {
              for (int dateIndex = 0;
                  dateIndex < widget.dateList.length;
                  dateIndex++) {
                var date = widget.dateList[dateIndex];
                _masterBooking = MasterBooking(
                  booked_courtTimeslot: MasterBooking.nestedArrayToObject(
                      masterBookingArray[dateIndex]),
                  date: date,
                  userId: global.USERID,
                  bookingId: bookingId,
                  sportType: widget.sportType,
                ).masterToJson();

                //update student_appointments
                await masterCourtBooking
                    .where("date", isEqualTo: date)
                    .where("sportType", isEqualTo: widget.sportType)
                    .get()
                    .then((value) {
                  value.docs.forEach((element) {
                    masterCourtBooking
                        .doc(element.id)
                        .update(_masterBooking)
                        .then((_) {
                      Utils.showSnackBar(
                          "Updated an advanced booking", "green");
                      Navigator.pushNamed(context, '/');
                    });
                  });
                });
              }
            });
          });
        });
      } else {
        //create new adv booking
        advCourtBooking.add(_bookingDetails).then((_) async {
          for (int dateIndex = 0;
              dateIndex < widget.dateList.length;
              dateIndex++) {
            var date = widget.dateList[dateIndex];
            _masterBooking = MasterBooking(
              booked_courtTimeslot: MasterBooking.nestedArrayToObject(
                  masterBookingArray[dateIndex]),
              date: date,
              userId: global.USERID,
              bookingId: bookingId,
              sportType: widget.sportType,
            ).masterToJson();
            await masterCourtBooking
                .where("date", isEqualTo: date)
                .where("sportType", isEqualTo: widget.sportType)
                .get()
                .then((value) {
              if (value.docs.length == 0) {
                print("add adv");
                masterCourtBooking.add(_masterBooking).then((_) {
                  Utils.showSnackBar("Created an advanced booking", "green");
                  Navigator.pushNamed(context, '/');
                });
              } else {
                print("update adv");
                value.docs.forEach((element) {
                  masterCourtBooking
                      .doc(element.id)
                      .update(_masterBooking)
                      .then((_) {
                    Utils.showSnackBar("Created an advanced booking", "green");
                  });
                });
              }
            });
          }
        });
      }
    } catch (e) {
      Utils.showSnackBar(e.toString(), "red");
    }
  }

  static String getColor(String bookingType, {defaultColor: null}) {
    var color;
    switch (bookingType) {
      case "Training":
        color = Colors.redAccent;
        break;
      case "Sport Events":
        color = Colors.purpleAccent;
        break;
      case "Club Events":
        color = Colors.blueAccent;
        break;
      default: //Others
        color = Colors.greenAccent;
        break;
    }
    return "0x${color.value.toRadixString(16)}";
  }
}
