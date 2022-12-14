import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:utmsport/model/m_MasterBooking.dart';
import 'package:utmsport/globalVariable.dart' as global;

class TimeslotCourtTable extends StatefulWidget {
  //TODO: cm-initialize got many error in console
  // const TimeslotCourtTable({Key? key}) : super(key: key);

  final int noOfTimeslot;
  final int noOfCourt;
  final DateTime date;
  final int index;
  void Function(String, int, String) callback;

  TimeslotCourtTable({
    required this.noOfTimeslot,
    required this.noOfCourt,
    required this.date,
    required this.index,
    required this.callback,
  });

  @override
  State<TimeslotCourtTable> createState() => TimeslotCourtTableState(
        noOfTimeslot: this.noOfTimeslot,
        noOfCourt: this.noOfCourt,
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

  List<List<String>> courtTimeslot = [];

  TimeslotCourtTableState({
    required this.noOfTimeslot,
    required this.noOfCourt,
    required this.date,
    required this.index,
    required this.callback,
  });

  @override
  void initState() {
    fetchObj();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black12, width: 0.5)),
          child: Center(
            child: _buildGridItem(x, y),
          ),
        ),
      ),
    );
  }

  Widget _buildGridItem(int x, int y) {
    switch (courtTimeslot[x][y]) {
      case '':
        return TextButton(
            onPressed: () {
              setState(() {
                widget.callback("T${x}C$y", index, "add");
                courtTimeslot[x][y] = "Check";
                // selectedCourtTimeslot.add(courtTimeslot[x][y]);
                // selectedCourtTimeslot.toSet().toList();
                print("set check ${courtTimeslot[x][y]}");
              });
            },
            child: Text(courtTimeslot[x][y]));
      case 'Check':
        return TextButton(
            onPressed: () {
              setState(() {
                widget.callback("T${x}C$y", index, "remove");
                courtTimeslot[x][y] = "";
                print("uncheck ${courtTimeslot[x][y]}");
              });
            },
            child: Text("T${x}C$y"));
      default:
        return Text(
          courtTimeslot[x][y].toString(),
          style: TextStyle(
            color: Colors.black87,
            backgroundColor: Colors.grey[200],
          ),
        );
    }
  }

  fetchObj() async {
    List<List<String>> _courtTimeslot = [];

    await global.FFdb.collection('master_booking')
        .where('date',
            isEqualTo: DateTime(2022, 12, 5).add(Duration(days: widget.index)))
        .get()
        .then((val) {
      if (val.docs.length == 0) {
        //create a nested array
        _courtTimeslot = MasterBooking.createNestedCTArray(
            noOfTimeslot: noOfTimeslot, noOfCourt: noOfCourt);
        setState(() => courtTimeslot = _courtTimeslot);
      } else {
        //use fetched data and convert to nested array
        val.docs.forEach((element) {
          var a;
          a = element['booked_courtTimeslot'];
          for (int i = 0; i <= noOfTimeslot; i++) {
            _courtTimeslot.add(List.from(a[i]['court']));
          }
          setState(() => courtTimeslot = _courtTimeslot);
        });
      }
    });
  }
}
