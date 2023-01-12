import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:utmsport/view/advBooking/v_createAdvancedForm.dart';

class CreateAdvBookingCalendar extends StatefulWidget {
  final String sportType;

  CreateAdvBookingCalendar({Key? key, required this.sportType})
      : super(key: key);

  @override
  State<CreateAdvBookingCalendar> createState() =>
      _CreateAdvBookingCalendarState();
}

class _CreateAdvBookingCalendarState extends State<CreateAdvBookingCalendar> {
  final dateRangeController = DateRangePickerController();
  List<DateTime> _dateList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      title: Text(
        'Calendar',
      ),
    ),
      body: SingleChildScrollView(
          child: Container(
        margin: EdgeInsets.all(12),
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Text("Advanced Court Booking",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
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
                  backgroundColor:
                      this._dateList.length <= 0 ? Colors.grey : Colors.blue,
                  shape: CircleBorder(),
                ),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                ),
                onPressed: () => this._dateList.length <= 0
                    ? null
                    : Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CreateAdvBooking(
                            dateList: this._dateList,
                            sportType: widget.sportType,
                          ),
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
    setState(() {
      this._dateList = List.castFrom(args.value);
      this._dateList.sort();
    });
  }
}
