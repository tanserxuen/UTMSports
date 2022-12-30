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

import '../../utils.dart';

class CreateAdvBooking extends StatefulWidget {
  const CreateAdvBooking({Key? key, required this.dateList}) : super(key: key);

  final List<DateTime> dateList;

  @override
  State<CreateAdvBooking> createState() => _CreateAdvBookingState();
}

class _CreateAdvBookingState extends State<CreateAdvBooking> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _pic = "";
  String _attachment = "";
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

    //update form combine with create form example: v_createEvent.dart
    picController.text = "dfvx";
    phoneController.text = "erdvs";
    subjectController.text = "waeds";

    //set selected court nested array
    selectedCourtTimeslot = List.generate(selectedDays, (_) => []);
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
              Card(child:_buildLegend(),),
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
                        _buildAttachmentField(),
                        _buildPICField(),
                        _buildPhoneNoField(),
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
              padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
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
    return ElevatedButton(
      child:
          Text("Submit", style: TextStyle(color: Colors.white, fontSize: 16)),
      onPressed: () {
        if (!_formKey.currentState!.validate()) {
        } else {
          _formKey.currentState!.save();
          MasterBooking.insertAdvBooking(
              widget, masterBookingArray, context, selectedCourtTimeslot);
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

  Widget _buildPhoneNoField() {
    return TextFormField(
        controller: phoneController,
        decoration: InputDecoration(labelText: "Phone Number"),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Phone Number is required";
          }
        },
        onSaved: (value) => _pic = value!);
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
      ...timeslot.map((slot){
        int index = timeslot.indexOf(slot);
        // var timeNow = Utils.getCurrentTimeOnly(slot);
        //TODO: change this
        return Padding(
          padding: const EdgeInsets.fromLTRB(2, 1, 2, 1),
          child: Wrap(children: [
            SizedBox(
              width: 14,
              height: 14,
              child: const DecoratedBox(
                decoration: const BoxDecoration(color: Colors.red),
              ),
            ),Text("$index $slot")
          ],),
        );
      })
    ]);
  }
}
