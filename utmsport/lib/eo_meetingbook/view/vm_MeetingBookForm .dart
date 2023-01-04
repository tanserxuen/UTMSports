import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:utmsport/eo_meetingbook/view/vm_requestList.dart';


FirebaseFirestore db = FirebaseFirestore.instance;

class MeetingForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MeetingFormState();
  }
}

class MeetingFormState extends State<MeetingForm> {
  final GlobalKey<FormState> _MeetingformKey = GlobalKey<FormState>();

  String eoName= "";
  String pic= "";
  String matricNo= "";
  String phoneNumber= "";
  String eventName = "";
  String description= "";
  String _endTime = "";
  String _startTime = "";

  final eoNameController = TextEditingController();
  final picController = TextEditingController();
  final matricNoController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final eventNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final controllerstartTime = TextEditingController();
  final controllerendTime = TextEditingController();


  Widget _buildEventOrganizationNameField() {
    return TextFormField(
      controller: eoNameController,
      decoration: InputDecoration(labelText: "Event Organization Name"),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Even Organization Name is required";
        }
      },
      // onSaved: (value) {
      //   _eventName = value;
      // }
    );
  }

  Widget _buildPICField() {
    return TextFormField(
      controller: picController,
      decoration: InputDecoration(labelText: "Person In Charge"),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Person In Charge is required";
        }
      },
    );
  }

  Widget _buildMatricNoField() {
    return TextFormField(
      controller: matricNoController,
      decoration: InputDecoration(labelText: "Matric Number"),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Matric Number is required";
        }
      },
      // onSaved: (value) {
      //   _venue = value;
      // }
    );
  }

  Widget _buildPhoneNumberField() {
    return TextFormField(
      controller: phoneNumberController,
      decoration: InputDecoration(labelText: "Phone Number"),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Phone Number is required";
        }
      },
    );
  }

  Widget _buildeventNameField() {
    return TextFormField(
      controller: eventNameController,
      decoration: InputDecoration(labelText: "Event Name"),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Event Name is required";
        }
      },
    );
  }

  Widget _buildStartDateField() {
    return TextFormField(
        controller: controllerstartTime,
        decoration: InputDecoration(
            labelText: "Date", suffixIcon: Icon(Icons.calendar_today)),
        readOnly: true,

        onTap: () async {
          DateTime? value = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100));
          if (value == null) return null;
          setState(() => {
            _startTime = DateFormat('yyyy-MM-dd').format(value),
            controllerstartTime.text = _startTime,
            print(_startTime),
          });
        });
  }

  Widget _buildEndtDateField() {
    return TextFormField(
        controller: controllerendTime,
        decoration: InputDecoration(
            labelText: "Date", suffixIcon: Icon(Icons.calendar_today)),
        readOnly: true,
        onTap: () async {

          DateTime? value = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100));

          if (value == null) return null;
          setState(() => {
            _endTime = DateFormat('yyyy-MM-dd').format(value),
            controllerendTime.text = _endTime,
            print(_endTime),
          });
        });
  }

  Widget _builddescriptionField() {
    return TextFormField(
      controller: descriptionController,
      decoration: InputDecoration(labelText: "Description"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text("Meeting Appointment",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            Card(
              child: Form(
                key: _MeetingformKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildEventOrganizationNameField(),
                    _buildPICField(),
                    Row(
                      children: [
                        Expanded(child:
                        _buildMatricNoField(),
                        ),
                        SizedBox(height: 50),
                        Expanded(child:
                        _buildPhoneNumberField(),
                        ),
                        SizedBox(height: 50),
                      ],
                    ),
                    _buildeventNameField(),
                    Row(
                      children: [
                        Expanded(child:
                        _buildStartDateField(),
                        ),
                        SizedBox(width:12,),
                        Expanded(child:
                        _buildEndtDateField(),
                        ),
                      ],
                    ),
                    _builddescriptionField(),
                    SizedBox(height: 80),
                    ElevatedButton(
                      child: Text("Book Meeting",
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                      onPressed: ()
                      { showDialog(context: context, builder: (BuildContext context){
                        return AlertDialog(
                            title: Text("Success"),
                            titleTextStyle:
                            TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,fontSize: 20),
                            actionsOverflowButtonSpacing: 20,
                            actions: [
                              ElevatedButton(onPressed: (){
                              }, child: Text("Back")),
                              ElevatedButton(
                               child: const Text("Next"),
                                  onPressed: (){
                                    // _navigateToNextScreen(context);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => RequestMeetingList()),
                                    ); },
                              ),
                            ],
                            content: Text("Booked successfully"));
                      });
                        if (!_MeetingformKey.currentState!.validate()) {
                        } else {
                          _MeetingformKey.currentState!.save();
                          final _meetingBook = MeetingBooking(
                            eoid: FirebaseFirestore.instance
                                .collection('Meeting Book')
                                .doc()
                                .id,

                            eoName: eoNameController.text.trim(),
                            pic: picController.text.trim(),
                            matricNo: matricNoController .text.trim(),
                            phoneNumber: phoneNumberController.text.trim(),
                            eventName : eventNameController.text.trim(),
                            description : descriptionController.text.trim(),
                            // startTime : controllerstartTime.text,
                            // endTime : controllerendTime.text,
                          ).toJson();

                          CollectionReference meetingForm =
                          FirebaseFirestore.instance.collection('Meeting Book');

                          meetingForm.add(_meetingBook);
                        }
                      void _navigateToNextScreen(BuildContext context) {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => RequestMeetingList()));
                      }},
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

  // _addMeetingBookingToDb(){
  //   _meetingBookingController.addMeetingBooking(
  //       meetingBooking: MeetingBooking(
  //         date: DateFormat.yMd().format(_selectedDate),
  //         startTime: _startTime,
  //         endTime:_endTime,
  //         isCompleted:0,
  //       )
  //   );
  // }
  //
  // _getDataFromUser() async{
  //   DateTime? _pickerDate = await showDatePicker(
  //       context:context,
  //       initialDate :DateTime.now(),
  //       firstDate:  DateTime(2015),
  //       lastDate: DateTime(2100)
  //   );
  //   if(_pickerDate!=null){
  //     setState(() {
  //       _selectedDate = _pickerDate;
  //       print(_selectedDate);
  //     } );
  //   }else{
  //     print("Something is Wrong");
  //   }
  // }
  //
  // _getTimeFromUser({required bool isStarTime})async{
  //   var pickedTime = await _showTimePicker();
  //   String formatedTime = pickedTime.format(context);
  //   if(pickedTime == null){
  //     print("Time canceled");
  //   }else if(isStarTime==true){
  //     setState((){
  //       _startTime = formatedTime;
  //     });
  //   }else if(isStarTime==false){
  //     setState((){
  //       _endTime = formatedTime;
  //     });
  //   }
  //   _showTimePicker();
  // }
  //
  // _showTimePicker(){
  //   return showTimePicker(
  //       initialEntryMode: TimePickerEntryMode.input,
  //       context: context,
  //       initialTime : TimeOfDay(
  //         hour: int.parse(_startTime.split(":")[0]),
  //         minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
  //       )
  //   );
  // }

class MeetingBooking {
  String eoid;
  String eoName;
  String pic;
  String matricNo;
  String phoneNumber;
  String eventName ;
  String description;
  DateTime startTime = DateTime.parse("2015-07-20 20:18");
  DateTime endTime = DateTime.parse("2015-07-20 22:18");

  MeetingBooking({
    this.eoid= '',
    this.eoName= '',
    this.pic= '',
    this.matricNo= '',
    this.phoneNumber= '',
    this.eventName= '',
    this.description= '',
    // this.startTime= " ",
    // this.endTime = " ",
  });

  Map<String, dynamic> toJson() => {

    'eoid': eoid,
    'eoName': eoName,
    'pic': pic,
    'matricNo': matricNo,
    'phoneNumber': phoneNumber,
    'eventName': eventName,
    '_startTime': startTime.toString(),
    '_endTime': endTime.toString(),
    'vdescription': description,
  };

}
