import 'package:flutter/material.dart';

import 'package:utmsport/globalVariable.dart' as global;
import 'package:utmsport/view/advBooking/v_createAdvancedForm.dart';
import 'package:utmsport/view/studentBooking/v_createStuBooking.dart';
import 'package:utmsport/view/advBooking/v_createAdvancedCalendar.dart';

class StuBookingChooseSports extends StatefulWidget {
  var params;
  var dateList;
  String formType;

  StuBookingChooseSports({
    Key? key,
    this.params: null,
    this.dateList: null,
    this.formType: "Create",
  }) : super(key: key);

  @override
  State<StuBookingChooseSports> createState() => StuBookingChooseSportsState();
}

class StuBookingChooseSportsState extends State<StuBookingChooseSports> {
  String sportType = "";

  @override
  void initState() {
    if (widget.formType == "Edit") {
      sportType = widget.params['sportType'];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      title: Text(
        'Calendar',
        ),
    ),
      body: Center(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Choose Sport Type",
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
        backgroundColor: sportType == '' ? Colors.grey : Colors.blue,
        onPressed: () => sportType == ''
            ? null
            : Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => redirectToForm()),
              ),
        child: Icon(
          Icons.arrow_forward_rounded,
          size: 25,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  List<Widget> _buildSportsOptionButton(context) {
    bool isEditForm = widget.formType == 'Edit';
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
                  : isEditForm
                      ? Colors.grey
                      : Colors.blue,
              elevation: !matchEditValue && isEditForm ? 0 : 4,
            ),
            onPressed: () {
              setState(() {
                isEditForm ? null : sportType = sport;
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

  redirectToForm() {
    if (widget.formType == 'Edit')
      switch (global.getUserRole()) {
        case "admin":
        case "manager":
          return CreateAdvBooking(
            sportType: sportType,
            dateList: widget.params['dateList'],
            formType: widget.params['formType'],
            slotLists: widget.params['slotLists'],
            stuAppModel: widget.params['stuAppModel'],
          );
        default:
          return CreateStuBooking(
            formType: widget.formType,
            sportType: widget.params['sportType'],
            stuAppModel: widget.params['stuAppModel'],
            slotLists: widget.params['slotLists'],
            date: widget.params['date'],
          );
      }
    else //create
      switch (global.getUserRole()) {
        case "admin":
        case "manager":
          return CreateAdvBookingCalendar(
            sportType: sportType,
          );
        default:
          return CreateStuBooking(
            sportType: sportType,
          );
      }
  }
}
