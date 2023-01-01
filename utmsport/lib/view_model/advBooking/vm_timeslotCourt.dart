import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:utmsport/model/m_MasterBooking.dart';
import 'package:utmsport/globalVariable.dart' as global;

class TimeslotCourtTable extends StatefulWidget {
  int noOfTimeslot = MasterBooking.timeslot.length;
  int noOfCourt = MasterBooking.badmintonCourt;
  final List<DateTime> dateList;
  final int index;
  void Function(String, int, String) setSelectedCourtArrayCallback;
  void Function(List<List<String>>, int) setMasterBookingArrayCallback;

  TimeslotCourtTable({
    required this.dateList,
    required this.index,
    required this.setSelectedCourtArrayCallback,
    required this.setMasterBookingArrayCallback,
  });

  @override
  State<TimeslotCourtTable> createState() => TimeslotCourtTableState(
        this.noOfTimeslot,
        this.noOfCourt,
        dateList: this.dateList,
        index: this.index,
        setSelectedCourtArrayCallback: this.setSelectedCourtArrayCallback,
        setMasterBookingArrayCallback: this.setMasterBookingArrayCallback,
      );
}

class TimeslotCourtTableState extends State<TimeslotCourtTable> {
  int noOfTimeslot;
  int noOfCourt;
  List<DateTime> dateList;
  int index;
  void Function(String, int, String) setSelectedCourtArrayCallback;
  void Function(List<List<String>>, int) setMasterBookingArrayCallback;
  bool isFecthingDataDone = false;

  List<List<String>> courtTimeslot = [];

  TimeslotCourtTableState(
    this.noOfTimeslot,
    this.noOfCourt, {
    required this.dateList,
    required this.index,
    required this.setSelectedCourtArrayCallback,
    required this.setMasterBookingArrayCallback,
  });

  @override
  void initState() {
    fetchAdvancedData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return this.isFecthingDataDone == false
        ? CircularProgressIndicator()
        : _buildCourtGrid(widget);
  }

  Widget _buildCourtGrid(widget) {
    late int rowLength = widget.noOfCourt + 1;
    return Row(
      children: [
        // Text("${DateTime(2022, 12, 5).add(Duration(days: widget.index))}"),
        Expanded(
          child: SizedBox(
            height: 35.0 * widget.noOfTimeslot,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: rowLength,
              ),
              itemBuilder: _buildGridItems,
              itemCount: (widget.noOfTimeslot + 1) * (rowLength),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGridItems(BuildContext context, int index) {
    late int rowLength = widget.noOfCourt + 1;
    int courtTimeslotLength = rowLength;
    int x = 0, y = 0;
    x = (index / courtTimeslotLength).floor();
    y = (index % courtTimeslotLength);
    return GestureDetector(
      onTap: () => {},
      child: GridTile(
        child: _buildGridItem(x, y),
      ),
    );
  }

  Widget _buildGridItem(int x, int y) {
    Widget textWidget;
    var containerStyle = null;
    switch (courtTimeslot[x][y]) {
      case '':
        textWidget = TextButton(
            onPressed: () {
              setState(() {
                widget.setSelectedCourtArrayCallback("$x $y", index, "add");
                courtTimeslot[x][y] = "Check";
                print("set check ${courtTimeslot[x][y]}");
              });
            },
            child: Text(courtTimeslot[x][y]));
        break;
      case 'Booked':
        textWidget = Text("${courtTimeslot[x][y].toString()}");
        containerStyle = Colors.black12;
        break;
      default: // x&y axis and check
        if (RegExp("[a-z]").hasMatch(courtTimeslot[x][y])) {
          textWidget = TextButton(
              onPressed: () {
                setState(() {
                  widget.setSelectedCourtArrayCallback(
                      "$x $y", index, "remove");
                  courtTimeslot[x][y] = "";
                });
              },
              child: Text("Selected"));
          containerStyle = Colors.limeAccent;
        } else {
          textWidget = Text(
            courtTimeslot[x][y].toString(),
          );
        }
        break;
    }
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12, width: 0.5),
        color: containerStyle,
      ),
      child: Center(
        child: textWidget,
      ),
    );
  }

  fetchAdvancedData() async {
    final DateTime date = widget.dateList[widget.index];
    List<List<String>> _courtTimeslot = [];
    await global.FFdb.collection('master_booking')
        .where('date', whereIn: widget.dateList)
        .get()
        .then((val) {
        _courtTimeslot = MasterBooking.createNestedCTArray(
          date,
          widget.dateList,
          val.docs.toList(),
          noOfTimeslot: noOfTimeslot,
          noOfCourt: noOfCourt,
        );
      setState(() => {
            this.isFecthingDataDone = true,
            courtTimeslot = _courtTimeslot,
            this.setMasterBookingArrayCallback(courtTimeslot, this.index),
          });
    });
  }
}
