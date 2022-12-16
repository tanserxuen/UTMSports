import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:utmsport/view/advBooking/v_createAdvancedForm.dart';

class CreateAdvBookingCalendar extends StatefulWidget {
  const CreateAdvBookingCalendar({Key? key}) : super(key: key);

  @override
  State<CreateAdvBookingCalendar> createState() =>
      _CreateAdvBookingCalendarState();
}

class _CreateAdvBookingCalendarState extends State<CreateAdvBookingCalendar> {
  final dateRangeController = DateRangePickerController();
  List<DateTime> _dateList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Container(
        margin: EdgeInsets.all(12),
        child: Column(
          children: [
            SfDateRangePicker(
              selectionMode: DateRangePickerSelectionMode.multiple,
              controller: dateRangeController,
              initialSelectedDate: DateTime.now(),
              view: DateRangePickerView.month,
              onSelectionChanged: selectionDateChanged,
              showTodayButton: true,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: CircleBorder(),
                ),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CreateAdvBooking(dateList: this._dateList),
                  ),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }

  void selectionDateChanged(DateRangePickerSelectionChangedArgs args) {
    List<Timestamp> formattedDates = [];
    // args.value.forEach((e)=>formattedDates.add(DateFormat('yyyy-MM-dd').format(e)));
    this._dateList = List.castFrom(args.value);
    this._dateList.sort();
    print(this._dateList);
  }
}
