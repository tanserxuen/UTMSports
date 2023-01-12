import 'package:flutter/material.dart';

import 'package:utmsport/model/m_MasterBooking.dart';
import 'package:utmsport/globalVariable.dart' as global;

class TimeslotCourtTable extends StatefulWidget {
  final List<DateTime> dateList;
  final String formType;
  final List<String> slots;
  final int index;
  final String sportType;
  void Function(String, int, String) setSelectedCourtArrayCallback;
  void Function(List<List<String>>, int) setMasterBookingArrayCallback;

  TimeslotCourtTable({
    required this.dateList,
    required this.formType,
    required this.slots,
    required this.index,
    required this.sportType,
    required this.setSelectedCourtArrayCallback,
    required this.setMasterBookingArrayCallback,
  });

  @override
  State<TimeslotCourtTable> createState() => TimeslotCourtTableState();
}

class TimeslotCourtTableState extends State<TimeslotCourtTable> {
  bool isFecthingDataDone = false;
  List<List<String>> courtTimeslot = [];
  int noOfTimeslot = global.timeslot.length;
  int noOfCourt = 0;

  @override
  void initState() {
    switch (widget.sportType) {
      case 'Badminton':
        noOfCourt = global.badmintonCourt;
        break;
      case 'Squash':
        noOfCourt = global.squashCourt;
        break;
      case 'PingPong':
        noOfCourt = global.pingPongCourt;
        break;
    }
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
    late int rowLength = noOfCourt + 1;
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 29.0 * noOfTimeslot,
            width: 1000,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: rowLength,
              ),
              itemBuilder: _buildGridItems,
              itemCount: (noOfTimeslot + 1) * (rowLength),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGridItems(BuildContext context, int index) {
    late int rowLength = noOfCourt + 1;
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
                widget.setSelectedCourtArrayCallback(
                    "$x $y", widget.index, "add");
                courtTimeslot[x][y] = "Check";
              });
            },
            child: Text(courtTimeslot[x][y]));
        break;
      case 'Booked':
        if (widget.formType == 'Edit' && widget.slots.contains("$x $y")) {
          textWidget = TextButton(
            onPressed: () {
              setState(() {
                widget.setSelectedCourtArrayCallback(
                    "$x $y", widget.index, "remove");
                courtTimeslot[x][y] = "";
              });
            },
            child: Icon(
              Icons.remove_circle_outline,
              size: 16,
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
                widget.setSelectedCourtArrayCallback(
                    "$x $y", widget.index, "remove");
                courtTimeslot[x][y] = "";
              });
            },
            child: Icon(Icons.check_circle, size: 16, color: Colors.red),
          );
          // containerStyle = Colors.limeAccent;
        } else {
          // if(courtTimeslot[x][y]==)
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
    print(widget.dateList);
    await global.FFdb.collection('master_booking')
        .where('date', whereIn: widget.dateList)//get all data matches the values in this date array
        .where('sportType', isEqualTo: widget.sportType) //get all data that is equal to the sportType
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
            widget.setMasterBookingArrayCallback(courtTimeslot, widget.index),
          });
    });
  }
}
