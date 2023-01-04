import 'dart:io';
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

class CreateAdvBooking extends StatefulWidget {
  final List<DateTime> dateList;
  final String formType;
  var slotLists; //List<List<String>>
  dynamic stuAppModel;

  // ignore: avoid_init_to_null
  CreateAdvBooking({
    Key? key,
    required this.dateList,
    this.slotLists: null,
    this.formType: "Create",
    this.stuAppModel:null,
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
  int selectedDays = 0;
  Reference storageRef = FirebaseStorage.instance.ref();
  List<List<String>> selectedCourtTimeslot = [];
  List<List<List<String>>> masterBookingArray = [];

  final dateRangeController = DateRangePickerController();
  final picController = TextEditingController();
  final phoneController = TextEditingController();
  final subjectController = TextEditingController();

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
    super.initState();
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
                        Text("${selectedCourtTimeslot.toString()}"),
                        ..._buildAccordianCourtTimeslot(),
                        _buildSubjectField(),
                        _buildTypeField(),
                        _buildPICField(),
                        _buildPhoneNoField(),
                        SizedBox(height: 10),
                        _buildAttachmentField(),
                        SizedBox(height: 50),
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
          children: generateSelectedCourtBadge(dateIndex),
        ),
        children: [
          // Text("${widget.dateList[dateIndex]}"),
          SizedBox(height: 8),
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
        Padding(
          padding: const EdgeInsets.fromLTRB(1, 3, 1, 3),
          child: ElevatedButton(
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
                shape: StadiumBorder(),
                primary: Colors.lightBlue[700]),
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
        ),
      );

      badgeList.add(SizedBox(width: 3));
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
      onPressed: () {
        if (!_formKey.currentState!.validate()) {
        } else {
          _formKey.currentState!.save();
          if (canSubmit)
            MasterBooking.insertAdvBooking(
              masterBookingArray: masterBookingArray,
              subject: _subject,
              bookingType: _advType,
              widget: widget,
              context: context,
              selectedCourtTimeslot: selectedCourtTimeslot,
              phoneNo: _phoneNo,
              attachment: _attachment,
            );
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
        var time = Utils.getCurrentTimeOnly(slot);
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
              Text(" T${index + 1} $slot ")
            ],
          ),
        );
      })
    ]);
  }
}
