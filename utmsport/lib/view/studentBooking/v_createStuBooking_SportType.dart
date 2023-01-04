import 'package:flutter/material.dart';
import 'package:utmsport/globalVariable.dart' as global;
import 'package:utmsport/view/studentBooking/v_createStuBooking.dart';

class StuBookingChooseSports extends StatefulWidget {
  var params;
  String formType;

  StuBookingChooseSports({
    Key? key,
    this.params: null,
    this.formType: "Create",
  }) : super(key: key);

  @override
  State<StuBookingChooseSports> createState() => StuBookingChooseSportsState();
}

class StuBookingChooseSportsState extends State<StuBookingChooseSports> {
  String sportType = "";

  @override
  void initState() {
    if (widget.formType == "Edit") sportType = widget.params['sportsType'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Book Court",
                    style:
                        TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                SizedBox(height: 24),
                ..._buildSportsOptionButton(context),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => widget.formType == 'Edit'
                ? CreateStuBooking(
                    sportsType: widget.params['sportsType'],
                    formType: widget.formType,
                    stuAppModel: widget.params['stuAppModel'],
                    slotLists: widget.params['slotLists'],
                    date: widget.params['date'],
                  )
                : CreateStuBooking(
                    sportsType: sportType,
                  ),
          ),
        ),
        child: Icon(Icons.arrow_forward_rounded, size: 25),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  List<Widget> _buildSportsOptionButton(context) {
    List<Widget> buttons = [];
    global.sports.forEach((sport) {
      int index = global.sports.indexOf(sport);
      bool matchEditValue = sportType == sport;
      buttons.add(
        SizedBox(
          width: 200,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: matchEditValue
                  ? Colors.lightBlueAccent
                  : widget.formType == 'Edit'
                      ? Colors.grey
                      : Colors.blue,
              elevation: !matchEditValue && widget.formType == 'Edit' ? 0 : 4,
            ),
            onPressed: () {
              setState(() {
                widget.formType == 'Edit' ? null : sportType = sport;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                sport,
                style: TextStyle(fontSize: 22),
              ),
            ),
            // style: ,
          ),
        ),
      );
      if (index != global.sports.length - 1 || index != 0)
        buttons.add(
          SizedBox(height: 18),
        );
    });
    return buttons;
  }
}
