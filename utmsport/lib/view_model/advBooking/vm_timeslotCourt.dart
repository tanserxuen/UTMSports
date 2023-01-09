import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:utmsport/model/m_MasterBooking.dart';
import 'package:utmsport/globalVariable.dart' as global;

class TimeslotCourtTable extends StatefulWidget {
  int noOfTimeslot = global.timeslot.length;
  int noOfCourt = global.badmintonCourt;
  final List<DateTime> dateList;
  final String formType;
  final List<String> slots;
  final int index;
  void Function(String, int, String) setSelectedCourtArrayCallback;
  void Function(List<List<String>>, int) setMasterBookingArrayCallback;

  TimeslotCourtTable({
    required this.dateList,
    required this.formType,
    required this.slots,
    required this.index,
    required this.setSelectedCourtArrayCallback,
    required this.setMasterBookingArrayCallback,
  });

  @override
  State<TimeslotCourtTable> createState() => TimeslotCourtTableState(
        this.noOfTimeslot,
        this.noOfCourt,
        dateList: this.dateList,
        formType: this.formType,
        slots: this.slots,
        index: this.index,
        setSelectedCourtArrayCallback: this.setSelectedCourtArrayCallback,
        setMasterBookingArrayCallback: this.setMasterBookingArrayCallback,
      );
}

class TimeslotCourtTableState extends State<TimeslotCourtTable> {
  int noOfTimeslot;
  int noOfCourt;
  List<DateTime> dateList;
  String formType;
  List<String> slots;
  int index;
  void Function(String, int, String) setSelectedCourtArrayCallback;
  void Function(List<List<String>>, int) setMasterBookingArrayCallback;
  bool isFecthingDataDone = false;

  List<List<String>> courtTimeslot = [];

  TimeslotCourtTableState(
    this.noOfTimeslot,
    this.noOfCourt, {
    required this.dateList,
    required this.formType,
    required this.slots,
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
        Expanded(
          child: SizedBox(
            height: 29.0 * widget.noOfTimeslot,
            width: 1000,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: rowLength,
                // mainAxisExtent: 35,
                // childAspectRatio: 3/2,
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
              });
            },
            child: Text(courtTimeslot[x][y]));
        break;
      case 'Booked':
        if (widget.formType == 'Edit' && slots.contains("$x $y")) {
          textWidget = TextButton(
            onPressed: () {
              setState(() {
                widget.setSelectedCourtArrayCallback("$x $y", index, "remove");
                courtTimeslot[x][y] = "";
              });
            },
            child: Icon(
              Icons.remove_circle_outline,size: 16,
              color: Colors.white,
            ),
          );
          containerStyle = Colors.green[200];
        } else {
          textWidget = Icon(
            Icons.close,
            color: Colors.white,
          );
          containerStyle = Colors.black12;
        }
        break;
      default: // x&y axis and check
        if (RegExp("[a-z]").hasMatch(courtTimeslot[x][y])) {
          textWidget = TextButton(
            onPressed: () {
              setState(() {
                widget.setSelectedCourtArrayCallback("$x $y", index, "remove");
                courtTimeslot[x][y] = "";
              });
            },
            child: Icon(Icons.check_circle, size: 16, color: Colors.red),
          );
          // containerStyle = Colors.limeAccent;
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
