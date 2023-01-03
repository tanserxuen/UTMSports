
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:utmsport/main.dart';
import 'package:utmsport/globalVariable.dart' as global;
import '../../utils.dart';
import '../../local_notification_service.dart';
import '../../view/notification_api.dart';


class AppointmentWidget extends StatefulWidget {
  const AppointmentWidget({Key? key, required this.selectedDay}) : super(key: key);

  final DateTime selectedDay;
  @override
  State<AppointmentWidget> createState() => _AppointmentWidgetState();
}

class _AppointmentWidgetState extends State<AppointmentWidget> {

  //late final LocalNotificationService service;//deb 20/12 coding notification

  final TextEditingController _eventTitleController = TextEditingController();
  final TextEditingController _TimeController = TextEditingController();
  final TextEditingController _DateController = TextEditingController();
  final TextEditingController _PicController = TextEditingController();
  final TextEditingController _matricNoController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _EOnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String filename = '';
  String timeslot = '';
  var fileBytes;
  Reference storageRef = FirebaseStorage.instance.ref();
  final formKey = GlobalKey<FormState>();
  final CollectionReference _appointments = global.FFdb.collection('appointments');
  final CollectionReference _availabletimes = global.FFdb.collection('availabletime');
  var timeslotArray = [];

  @override
  initState()  {
      // TODO: implement initState
      super.initState();
      _DateController.text = DateFormat('yyyy-MM-dd').format(widget.selectedDay);
      getAvailableTime().then((value){
        setState(() {
          timeslotArray = value;
        });
      });

    }

  Future<List>getAvailableTime() async {
    await _availabletimes.get().then((querySnapshot) {
      querySnapshot.docs.forEach((element) {
        // print(element.data());
        timeslotArray.add(element.data());
      });
    });

    return timeslotArray;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // service = LocalNotificationService();//deb
    // service.intialize();//deb

    _eventTitleController.text = '';
    _TimeController.text = '';
    _DateController.text = '';
    _PicController.text = '';
    _matricNoController.text = '';
    _phoneNoController.text = '';
    _descriptionController.text = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meeting Appointment'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: StreamBuilder(
            stream: global.FFdb.collection('users').doc(global.FA.currentUser!.uid).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(child: CircularProgressIndicator());
              if (snapshot.hasData){
                _EOnameController.text = snapshot.data?.data()!['name'];
                _matricNoController.text = snapshot.data?.data()!['matric'];
                _phoneNoController.text = snapshot.data?.data()!['phoneno'];
                _emailController.text = FirebaseAuth.instance.currentUser!.email!;

                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                          controller: _DateController,
                          textInputAction: TextInputAction.next,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (date) => date != null && !date.isNotEmpty
                            ? 'Select a Date'
                            : null,
                          decoration: InputDecoration(
                              labelText: "Date",
                              suffixIcon: Icon(Icons.calendar_today)),
                          readOnly: true,
                          onTap: () async {

                            DateTime? value = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100));

                            if (value == null) return null;
                            String date;
                            setState(() => {
                              date = DateFormat('yyyy-MM-dd').format(value),
                              _DateController.text = date,
                              print(date),
                            });
                          }
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          child: Row(
                              children: List.generate(timeslotArray.length, (index){
                                // Place where admin display the Time Avaiable
                                return InkWell(
                                  onTap: (){
                                    setState(() {
                                      timeslot = timeslotArray[index]['time'];
                                    });
                                  } ,
                                  child: Container(
                                    height: 50,
                                    width: 100,
                                    margin: EdgeInsets.fromLTRB(5, 10, 10, 10),
                                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                    decoration: BoxDecoration(
                                        color:
                                          timeslot == timeslotArray[index]['time']
                                            ? Colors.orange
                                            : Colors.white
                                        ,
                                        borderRadius: BorderRadius.circular(5),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey.shade600,
                                              spreadRadius: 1,
                                              blurRadius: 1,
                                              offset: Offset(0, 2))
                                        ]
                                    ),
                                    child: Center(
                                      child: Text(
                                        timeslotArray[index]['time']+ 'hr',
                                        style: TextStyle(
                                            fontSize: 22,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              })
                          ),
                        ),
                      ),
                      TextFormField(
                        enabled: false,
                        controller: _EOnameController,
                        textInputAction: TextInputAction.next,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (EO) => EO != null && !EO.isNotEmpty
                          ? 'Insert your name'
                          : null,
                        decoration: const InputDecoration(labelText: 'Event Organizer'),
                      ),
                      Row(
                        children:[
                          Expanded(
                            child: TextFormField(
                              controller: _PicController,
                              textInputAction: TextInputAction.next,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (pic) => pic != null && !pic.isNotEmpty
                                ? 'Insert Person Incharge'
                                : null,
                              decoration: const InputDecoration(labelText: 'Person in charge'),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _matricNoController,
                              textInputAction: TextInputAction.next,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (matric) => matric != null && !matric.isNotEmpty
                                ? 'Enter your Matric No'
                                : null,
                              decoration: const InputDecoration(labelText: 'Matric Number'),
                            ),
                          )
                        ]
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: TextFormField(
                                controller: _phoneNoController,
                                textInputAction: TextInputAction.next,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                validator: (phoneno) => phoneno != null && phoneno.length<10
                                  ? 'Enter Phone number (atleast 10 digit)'
                                  : null,
                                decoration: const InputDecoration(labelText: 'Phone Number'),
                              )
                          ),
                          Expanded(
                              child: TextFormField(
                                controller: _emailController,
                                textInputAction: TextInputAction.next,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                validator: (email) => email != null && !EmailValidator.validate(email)
                                  ? 'Enter a valid email'
                                  : null,
                                decoration: const InputDecoration(labelText: 'Email'),
                              )
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _eventTitleController,
                        textInputAction: TextInputAction.next,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (ET) => ET != null && !ET.isNotEmpty
                          ? 'Insert Event Title'
                          : null,
                        decoration: const InputDecoration(labelText: 'Event Title'),
                      ),
                      TextFormField(
                        controller: _descriptionController,
                        textInputAction: TextInputAction.next,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (desc) => desc != null && !desc.isNotEmpty
                          ? 'Insert Description'
                          : null,
                        decoration: const InputDecoration(labelText: 'Description'),
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Attachment:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                        'in .pdf or .doc format',
                        style: TextStyle(
                          fontSize: 12
                        ),
                      ),
                      Text(
                          '$filename',
                      ),
                      OutlinedButton.icon(
                          onPressed: () async {
                            //TODO: Add file with validator

                            FilePickerResult? result = await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              withData: true,
                              allowedExtensions: ['pdf', 'doc'],
                            );
                            if(result != null && result.files.single.path != null){
                              PlatformFile file = result.files.first;

                              setState(() {
                                filename = result.files.first.name;
                                fileBytes = result.files.first.bytes;
                                // print(fileBytes);
                              });

                            }

                          } ,
                          icon: Icon(Icons.file_upload_outlined, size: 22,),
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size.fromHeight(40)
                          ),
                          label: Text('Atachment File'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        child: const Text('Create'),
                        onPressed: () async {
                          // await service.showNotification(
                          //     id: 0,
                          //     title: 'Meeting Request ',
                          //     body: 'Pending'
                          // );//deb

                          final isValid = formKey.currentState!.validate();
                          if(!isValid) return ;
                          if(filename.isEmpty || filename == '') return Utils.showSnackBar('Please Upload PDF file', "red");
                          if(timeslot.isEmpty || timeslot == '') return Utils.showSnackBar('Please Select Timeslot', "red");

                          String concentenateDate = _DateController.text + " " + timeslot + ":00";
                          DateTime date = DateTime.parse(concentenateDate);
                          showDialog(
                              context: context,
                              builder: (BuildContext context){
                                return Center(child: CircularProgressIndicator());
                              }
                          );

                          Reference refDirfiles = storageRef.child("files");
                          Reference refFiletoupload = refDirfiles.child(filename);
                          await refFiletoupload.putData(fileBytes);

                          try{
                            int timestamp = DateTime.now().millisecondsSinceEpoch;

                            await _appointments.add({
                              'created_at': timestamp,
                              "date": date,
                              "name": _EOnameController.text,
                              "pic": _PicController.text,
                              "matricno": _matricNoController.text,
                              "phoneno": _phoneNoController.text,
                              "email": _emailController.text,
                              "eventtitle": _eventTitleController.text,
                              "description": _descriptionController.text,
                              "file": filename,
                              'uid': FirebaseAuth.instance.currentUser!.uid,
                              'status': 'pending'
                            })
                                .then((value) => 'The data inserted successfully')
                                .onError((error, stackTrace) => 'Somethings Error on inserting Appointment');

                          } on FirebaseAuthException catch (e){
                            print(e);

                            Utils.showSnackBar(e.message, "red");
                          }

                          showDialog(
                              context: context,
                              builder: (BuildContext context){
                                return AlertDialog(
                                    title: Text("Success"),
                                    titleTextStyle:
                                    TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,fontSize: 20),
                                    actionsOverflowButtonSpacing: 20,
                                    actions: [
                                      ElevatedButton(
                                        child: const Text("ok"),
                                        onPressed: (){
                                          // _navigateToNextScreen(context);
                                          sendNotification(
                                            title: "Booked",
                                            body: "Booked eventTitle",
                                            //fln: flutterLocalNotificationsPlugin,
                                          );
                                          navigatorKey.currentState!.popUntil((route) => route.isFirst);
                                        },
                                      ),
                                    ],
                                    content: Text("Booked successfully"));
                              }
                          );
                        },
                      )
                    ],
                  ),
                );
              }
              return Center(child: CircularProgressIndicator());
            },

          ),
        ),
      ),
    );
  }
}

class TimeSlot{
  final String time;

  TimeSlot({
    required this.time
  });
}

List <TimeSlot> timeslotRange = [age1, age2, age3];

TimeSlot age1 = TimeSlot(
    time : "0800"
);

TimeSlot age2 = TimeSlot(
    time : "1000"
);

TimeSlot age3 = TimeSlot(
    time : "1200"
);

TimeSlot age4 = TimeSlot(
    time : "40+"
);