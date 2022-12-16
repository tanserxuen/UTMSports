import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:utmsport/model/m_MasterBooking.dart';
import 'package:utmsport/globalVariable.dart' as global;

class TimeslotCourtTable extends StatefulWidget {
  // int noOfTimeslot = 9;
  // int noOfCourt = 4;
  int noOfTimeslot = MasterBooking.timeslot.length;
  int noOfCourt = MasterBooking.badmintonCourt;
  final DateTime date;
  final int index;
  void Function(String, int, String) callback;

  TimeslotCourtTable({
    required this.date,
    required this.index,
    required this.callback,
  });

  @override
  State<TimeslotCourtTable> createState() => TimeslotCourtTableState(
        this.noOfTimeslot,
        this.noOfCourt,
        date: this.date,
        index: this.index,
        callback: this.callback,
      );
}

class TimeslotCourtTableState extends State<TimeslotCourtTable> {
  int noOfTimeslot;
  int noOfCourt;
  DateTime date;
  int index;
  void Function(String, int, String) callback;
  bool isFecthingDataDone = false;

  List<List<String>> courtTimeslot = [];

  TimeslotCourtTableState(
    this.noOfTimeslot,
    this.noOfCourt, {
    required this.date,
    required this.index,
    required this.callback,
  });

  @override
  void initState() {
    fetchAdvancedData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    late int rowLength = widget.noOfCourt + 1;
    // return Text("abc");
    return this.isFecthingDataDone == false
        ? CircularProgressIndicator()
        : Row(
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
                widget.callback("$x $y", index, "add");
                courtTimeslot[x][y] = "Check";
                // selectedCourtTimeslot.add(courtTimeslot[x][y]);
                // selectedCourtTimeslot.toSet().toList();
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
                  widget.callback("$x $y", index, "remove");
                  courtTimeslot[x][y] = "";
                  print("uncheck ${courtTimeslot[x][y]}");
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
    List<List<String>> _courtTimeslot = [];
    await global.FFdb.collection('master_booking')
        .where('date', isEqualTo: this.date.add(Duration(days: widget.index)))
        .get()
        .then((val) {
      if (val.docs.length == 0) {
        //create a nested array
        _courtTimeslot = MasterBooking.createNestedCTArray(
            noOfTimeslot: noOfTimeslot, noOfCourt: noOfCourt);
      } else {
        //use fetched data and convert to nested array
        val.docs.forEach((element) {
          var a;
          a = element['booked_courtTimeslot'];
          for (int i = 0; i <= noOfTimeslot; i++) {
            _courtTimeslot.add(List.from(a[i]['court']));
          }
        });
      }
      setState(() => {
            this.isFecthingDataDone = true,
            courtTimeslot = _courtTimeslot,
          });
    });
  }

  String updateTimeslotCourtArray(int row, int col) {
    return "abc";
  }
}
