import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:utmsport/globalVariable.dart';
import 'package:utmsport/model/m_MasterBooking.dart';
import 'package:utmsport/view_model/advBooking/vm_timeslotCourt.dart';
import 'package:utmsport/utils.dart';
import 'package:utmsport/globalVariable.dart' as global;

class CreateAdvBooking extends StatefulWidget {
  final List<DateTime> dateList;
  final String formType;
  var slotLists; //List<List<String>>
  dynamic stuAppModel;
  final sportId;

  // ignore: avoid_init_to_null
  CreateAdvBooking({
    Key? key,
    required this.dateList,
    this.slotLists: null,
    this.formType: "Create",
    this.stuAppModel:null,
    this.sportId,
  }) : super(key: key);

  @override
  State<CreateAdvBooking> createState() => _CreateAdvBookingState();
}

class _CreateAdvBookingState extends State<CreateAdvBooking> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _pic = "";
  String _attachment = "";
  String _subject = "";
  String _advType = "";
  String _phoneNo = "";
  String _sportTeam = "";
  int selectedDays = 0;
  int _index = 0;
  Reference storageRef = FirebaseStorage.instance.ref();
  List<List<String>> selectedCourtTimeslot = [];
  List<List<List<String>>> masterBookingArray = [];

  final dateRangeController = DateRangePickerController();
  final picController = TextEditingController();
  final phoneController = TextEditingController();
  final subjectController = TextEditingController();

  final stud1MatrController = TextEditingController();
  final stud2MatrController = TextEditingController();
  final stud3MatrController = TextEditingController();
  final stud4MatrController = TextEditingController();
  final sportEventController = TextEditingController();
  final bookingId = global.FFdb.collection('student_appointment').doc().id;

  final descriptionController = TextEditingController();

  @override
  void initState() {
    this.selectedDays = widget.dateList.length;

    if(widget.formType == 'Edit') {
      picController.text = widget.stuAppModel['personInCharge'];
      phoneController.text = widget.stuAppModel['phoneNo'];
      subjectController.text = widget.stuAppModel['subject'];
      _advType = widget.stuAppModel['bookingType'];
    }else
      _advType = "Sport Events";

    //set selected court nested array
    widget.formType == 'Edit'
        ? selectedCourtTimeslot = widget.slotLists
        : selectedCourtTimeslot = List.generate(selectedDays, (_) => []);
    _getSportTeam();
    super.initState();
  }
  List<String> sportTeam = [];


  _getSportTeam() async {
    await FirebaseFirestore.instance.collection('sportTeam').get().then((query){

      print(query.docs.length);
      query.docs.forEach((element) {
        sportTeam.add(element['teamName']);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(12),
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Text("Advanced Booking",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              Card(
                child: _buildLegend(),
              ),
              SizedBox(height: 15),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Text("${selectedCourtTimeslot.toString()}"),
                        ..._buildAccordianCourtTimeslot(),
                        _buildSubjectField(),
                        _buildTypeField(),
                        _buildPICField(),
                        _buildPhoneNoField(),
                        SizedBox(height: 10),
                        _buildAttachmentField(),
                        // SizedBox(height: 50),
                        _additionalField(),
                        _buildSubmitAdvanced(),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void setSelectedCourtArray(val, index, action) {
    setState(() {
      action == 'add'
          ? selectedCourtTimeslot[index].add(val)
          : selectedCourtTimeslot[index].removeWhere((item) => item == val);
      selectedCourtTimeslot[index].toSet().toList();
      print(selectedCourtTimeslot);
    });
  }

  void setMasterBookingArray(List<List<String>> val, int dateIndex) {
    setState(() => masterBookingArray.add(val));
  }

  void updateMasterBookingArray(int dateIndex, String val) {
    setState(() {
      var a = val.split(" ").toList();
      int row = int.parse(a[0]);
      int col = int.parse(a[1]);
      masterBookingArray[dateIndex][row][col] = '';
    });
  }

  List<Widget> _buildAccordianCourtTimeslot() {
    List<Widget> accordianList = [];
    for (int dateIndex = 0; dateIndex < selectedDays; dateIndex++) {
      accordianList.add(ExpansionTile(
        maintainState: true,
        title: Text(
          "Day ${dateIndex + 1} - ${DateFormat('dd MMM yyyy').format(widget.dateList[dateIndex])}",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        subtitle: Wrap(
          direction: Axis.horizontal,
          spacing: 5,
          runSpacing: 4,
          children: generateSelectedCourtBadge(dateIndex),
        ),
        children: [
          // Text("${widget.dateList[dateIndex]}"),
          TimeslotCourtTable(
            dateList: widget.dateList,
            formType: widget.formType,
            slots: selectedCourtTimeslot[dateIndex],
            index: dateIndex,
            setSelectedCourtArrayCallback: setSelectedCourtArray,
            setMasterBookingArrayCallback: setMasterBookingArray,
          ),
        ],
      ));
    }
    return accordianList;
  }

  List<Widget> generateSelectedCourtBadge(int dateIndex) {
    List<Widget> badgeList = [];
    for (int elIndex = 0;
        elIndex < selectedCourtTimeslot[dateIndex].length;
        elIndex++) {
      badgeList.add(
        ElevatedButton(
          onPressed: () => setState(() => {
                updateMasterBookingArray(
                    dateIndex, selectedCourtTimeslot[dateIndex][elIndex]),
                selectedCourtTimeslot[dateIndex].removeWhere((element) {
                  return selectedCourtTimeslot[dateIndex][elIndex] == element;
                }),
              }),
          style: ElevatedButton.styleFrom(
              minimumSize: Size(20, 10),
              maximumSize: Size(90, 40),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: EdgeInsets.fromLTRB(7,2,5,2),
              shape: StadiumBorder(),
              primary: Colors.lightBlue),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text("${selectedCourtTimeslot[dateIndex][elIndex]}",
                    style: TextStyle(fontSize: 12)),
                SizedBox(width: 3),
                Icon(
                  Icons.close,
                  size: 14,
                ),
              ],
            ),
          ),
        ),
      );
    }
    return badgeList;
  }

  Widget _buildSubmitAdvanced() {
    //if there is court selected
    bool canSubmit = RegExp('[1-9]').hasMatch(selectedCourtTimeslot.toString());
    return ElevatedButton(
      style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(canSubmit ? Colors.blue : Colors.grey)),
      child:
          Text("Submit", style: TextStyle(color: Colors.white, fontSize: 16)),
      onPressed: () async {
        if (!_formKey.currentState!.validate()) {
        } else {
          _formKey.currentState!.save();
          /*if (canSubmit) MasterBooking.insertAdvBooking(
              masterBookingArray: masterBookingArray,
              subject: _subject,
              bookingType: _advType,
              widget: widget,
              context: context,
              selectedCourtTimeslot: selectedCourtTimeslot,
              phoneNo: _phoneNo,
              attachment: _attachment,
              personInCharge: _pic,
              formType: widget.formType,
              bookingId:  bookingId
            );*/
          var _data;
          switch(_advType) {
            case 'Training':
              //TODO: Create list of training if user choose many datetime
              await FirebaseFirestore.instance.collection('sportTeam').where(
                  'teamName', isEqualTo: _sportTeam).get().then((
                  sportTeam) async {
                    print(widget.dateList);
                    print(widget.)
                    _data = {
                      'appointmentId': bookingId,
                      'athletes': [],
                      'athletetime': [],
                      'coaches': sportTeam.docs.first['coaches'],
                      'created_at': DateTime.now(),
                      'description': descriptionController.text,
                      'sport': 'p',
                      'sportId': sportTeam.docs.first.id,
                      'sportType': sportTeam.docs.first['sportType'],
                      'start_at': '',
                      'subject': _subject
                    };

                /*await FirebaseFirestore.instance.collection('training').add(
                    _data).then((training) {
                  Utils.showSnackBar('document Training: ' + training.id +
                      'has been created', "green");
                  print('document Training: ' + training.id +
                      'has been created');                });*/
              });
              break;
            case 'Sport Events':
              //TODO: ADD DATA REQUIRE FOR SPORT EVENT
              _data = {
                'bookingId': bookingId,
                'created_at': DateTime.now(),
                'sportEvent' : subjectController.text,
                'matrics': [],
              };
              await FirebaseFirestore.instance.collection('attendEvents').add(
                  _data).then((attendEvents) {
                Utils.showSnackBar('document Attendance: ' + attendEvents.id +
                    'has been created', "green");
                print('document Attendance: ' + attendEvents.id +
                    'has been created');
              });
              break;
            case 'Club Events':
            case 'others':
          }
          Navigator.pushNamed(context, '/');
        }
      },
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
        onSaved: (value) => _pic = value!);
  }

  Widget _buildSubjectField() {
    return TextFormField(
        controller: subjectController,
        decoration: InputDecoration(labelText: "Subject"),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Subject is required";
          }
        },
        onSaved: (value) => _subject = value!);
  }

  Widget _buildTypeField() {
    List<String> bookingTypes = [
      "Training",
      "Sport Events",
      "Club Events",
      "Others"
    ];
    return DropdownButtonFormField(
      decoration: InputDecoration(labelText: 'Booking Type'),
      hint: Text("Booking Type"),
      isExpanded: true,
      items: bookingTypes.map((option) {
        var i = bookingTypes.indexOf((option));
        return DropdownMenuItem(
          value: option,
          child: Text("$option"),
        );
      }).toList(),
      value: _advType,
      validator: (value) {
        if (value == null) return "Booking Type is required.";
        return null;
      },
      onChanged: (value) {
        setState(() {
          _advType = value.toString();
        });
      },
    );
  }

  Widget _buildPhoneNoField() {
    return TextFormField(
        controller: phoneController,
        decoration: InputDecoration(labelText: "Phone Number"),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Phone Number is required";
          }
        },
        onSaved: (value) => _phoneNo = value!);
  }

  Widget _additionalField(){
    switch(_advType){
      case 'Training':
        _sportTeam = sportTeam.first;
        return Column(
          children: [
            DropdownButtonFormField(
                decoration: InputDecoration(labelText: 'Sport Team'),
              hint: Text("Booking Type"),
                isExpanded: true,
                items: sportTeam.map((option) {
                var i = sportTeam.indexOf((option));
                return DropdownMenuItem(
                  value: option,
                  child: Text("$option"),
                );
                }).toList(),
                value: _sportTeam,
                validator: (value) {
                  if (value == null) return "Booking Type is required.";
                    return null;
                },
                onChanged: (value) {
                  setState(() {
                    _sportTeam = value.toString();
                  });
              },
            ),
            // TextFormField(decoration: const InputDecoration(labelText: 'TrainingTime')),
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Phone Number is required";
                }
              },
              onSaved: (value) => _phoneNo = value!),
          ],
        );
      case 'Sport Events':
        return Column(
          children: [
            /*Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //Student 1
              children: [
                // Expanded(
                //   child: TextFormField(
                //     controller: stud1NameController,
                //     textInputAction: TextInputAction.next,
                //     autovalidateMode: AutovalidateMode.onUserInteraction,
                //     validator: (name) => name != null && !name.isNotEmpty
                //         ? 'Insert Name'
                //         : null,
                //     decoration: const InputDecoration(labelText: 'Student Name 1'),
                //   ),
                // ),
                Expanded(
                  child: TextFormField(
                    controller: stud1MatrController,
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (name) => name != null && !name.isNotEmpty
                        ? 'Insert Matric'
                        : null,
                    decoration: const InputDecoration(labelText: 'Matric 1'),
                  ),
                ),
              ],
            ),
            Row(
              //Student 2
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Expanded(
                //   child: TextFormField(
                //     controller: stud2NameController,
                //     textInputAction: TextInputAction.next,
                //     autovalidateMode: AutovalidateMode.onUserInteraction,
                //     validator: (name) => name != null && !name.isNotEmpty
                //         ? 'Insert Name'
                //         : null,
                //     decoration: const InputDecoration(labelText: 'Student 2'),),
                // ),
                Expanded(
                  child: TextFormField(
                    controller: stud2MatrController,
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (name) => name != null && !name.isNotEmpty
                        ? 'Insert Matric'
                        : null,
                    decoration: const InputDecoration(labelText: 'Matric 2'),
                  ),
                ),
              ],
            ),
            Row(
              //Student 3
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Expanded(
                //   child: TextFormField(
                //     controller: stud3NameController,
                //     textInputAction: TextInputAction.next,
                //     autovalidateMode: AutovalidateMode.onUserInteraction,
                //     validator: (name) => name != null && !name.isNotEmpty
                //         ? 'Insert Name'
                //         : null,
                //     decoration: const InputDecoration(labelText: 'Student 3'),),
                // ),
                Expanded(
                  child: TextFormField(
                    controller: stud3MatrController,
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (name) => name != null && !name.isNotEmpty
                        ? 'Insert Matric'
                        : null,
                    decoration: const InputDecoration(labelText: 'Matric 3'),
                  ),
                ),
              ],
            ),
            Row(
              //Student 4
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Expanded(
                //   child: TextFormField(
                //     controller: stud4NameController,
                //     textInputAction: TextInputAction.next,
                //     autovalidateMode: AutovalidateMode.onUserInteraction,
                //     validator: (name) => name != null && !name.isNotEmpty
                //         ? 'Insert Name'
                //         : null,
                //     decoration: const InputDecoration(labelText: 'Student Name 4'),),
                // ),
                Expanded(
                  child: TextFormField(
                    controller: stud4MatrController,
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (name) => name != null && !name.isNotEmpty
                        ? 'Insert Matric'
                        : null,
                    decoration: const InputDecoration(labelText: 'Matric 4'),
                  ),
                ),
              ],
            ),*/
          ],
        );
      case 'Club Events':
      case 'Others':
    }
    return Text('');
  }

  Widget _buildAttachmentField() {
    return Column(
      children: [
        OutlinedButton.icon(
          onPressed: () async {
            ImagePicker imagePicker = ImagePicker();
            XFile? file =
                await imagePicker.pickImage(source: ImageSource.gallery);

            if (file == null) return;

            String uniqueFileName =
                DateTime.now().millisecondsSinceEpoch.toString();

            //Get a reference to storage root
            Reference ref_DirImages = storageRef.child("attachments");

            //Create a reference for the image to be stored.
            Reference ref_ImageToUpLoad = ref_DirImages.child(uniqueFileName);

            try {
              //Store the file
              String filePath = '${file!.path}';
              await ref_ImageToUpLoad.putFile(File(filePath));

              //Success: get the download URL
              //TODO: cannot update but remain old picture
              _attachment = await ref_ImageToUpLoad.getDownloadURL();
            } catch (error) {}
          },
          icon: Icon(Icons.attach_file_rounded, size: 22),
          label: Text('Upload Files',
              style:
                  TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
          style: OutlinedButton.styleFrom(
              minimumSize: Size.fromHeight(35),
              side: BorderSide(width: 1.0, color: Colors.blue)),
        )
      ],
    );
  }

  Widget _buildLegend() {
    return Wrap(children: [
      Text(
        "Notes  ",
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
      ...timeslot.map((slot) {
        var time = Utils.formatTime(slot);
        int index = timeslot.indexOf(slot);
        // var timeNow = Utils.getCurrentTimeOnly(slot);
        //TODO: change this
        return Padding(
          padding: const EdgeInsets.fromLTRB(2, 1, 2, 1),
          child: Wrap(
            children: [
              SizedBox(
                width: 13,
                height: 13,
                child: const DecoratedBox(
                  decoration: const BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                ),
              ),
              Text(" T${index + 1} $time ")
            ],
          ),
        );
      })
    ]);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    dateRangeController.dispose();
    picController.clear();
    phoneController.clear();
    subjectController.clear();
    stud1MatrController.clear();
    stud2MatrController.clear();
    stud3MatrController.clear();
    stud4MatrController.clear();
    super.dispose();
  }

}
