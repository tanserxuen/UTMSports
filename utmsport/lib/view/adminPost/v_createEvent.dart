import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:utmsport/model/m_Event.dart';
import 'package:utmsport/utils.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

enum FormType { update, create }

class FormScreen extends StatefulWidget {
  final String formType;

  var eventModel;

  // ignore: avoid_init_to_null
  FormScreen({this.formType: "create", this.eventModel: null});

  @override
  State<StatefulWidget> createState() =>
      FormScreenState(event: this.eventModel);
}

class FormScreenState extends State<FormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var event;

  FormScreenState({this.event});

  String _eventName = "";
  String _description = "";
  String _venue = "";
  DateTime _date = DateTime.now();
  String _platform = "";
  String _imageUrl = "";
  String _imgPlaceholder =
      "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png";

  Timer? timer;

  Reference storageRef = FirebaseStorage.instance.ref();

  final controllerEventName = TextEditingController();
  final controllerDescription = TextEditingController();
  final controllerVenue = TextEditingController();
  final controllerDate = TextEditingController();
  final controllerPlatform = TextEditingController();

  // final controllerImage = TextEditingController();
  final eventController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controllerEventName.text = widget.eventModel?['name'] ?? "";
    controllerDescription.text = widget.eventModel?['description'] ?? "";
    controllerVenue.text = widget.eventModel?['venue'] ?? "";
    var _setDate = widget.eventModel?['date'] ?? "";
    controllerDate.text = _setDate != ""
        ? Utils.parsetoStringDateOnly(widget.eventModel?['date'],
            format: 'yyyy-MM-dd')
        : _setDate;
    controllerPlatform.text = widget.eventModel?['platform'] ?? "";
    _imageUrl = widget.eventModel?['imageUrl'] ?? _imgPlaceholder;
  }

  Widget _buildEventNameField() {
    return TextFormField(
        controller: controllerEventName,
        decoration: InputDecoration(labelText: "Event Name"),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Name is required";
          }
        },
        onSaved: (value) {
          _eventName = value!;
        });
  }

  Widget _buildDescriptionField() {
    return TextFormField(
        controller: controllerDescription,
        decoration: InputDecoration(labelText: "Description"),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Description is required";
          }
        },
        onSaved: (value) {
          _description = value!;
        });
  }

  Widget _buildVenueField() {
    return TextFormField(
        controller: controllerVenue,
        decoration: InputDecoration(labelText: "Venue"),
        onSaved: (value) {
          _venue = value!;
        });
  }

  Widget _buildDateField() {
    return TextFormField(
        controller: controllerDate,
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
                _date = value,
                controllerDate.text = DateFormat('yyyy-MM-dd').format(value),
              });
        });
  }

  Widget _buildPlatformField() {
    return TextFormField(
        controller: controllerPlatform,
        decoration: InputDecoration(labelText: "Platform"),
        onSaved: (value) {
          _platform = value!;
        });
  }

  //TODO: test if workable
  Widget _buildImageField() {
    const double _imgHeight = 150;
    const double _imgWidth = 150;
    _imageUrl = widget.eventModel?['image'] ?? _imgPlaceholder;
    return Column(
      children: [
        //TODO: Image not updated when upload image
        // Image.network(
        //   _imageUrl,
        //   height: _imgHeight,
        //   width: _imgWidth,
        // ),
        ElevatedButton.icon(
          onPressed: () async {
            ImagePicker imagePicker = ImagePicker();
            XFile? file =
                await imagePicker.pickImage(source: ImageSource.gallery);
            // print('${file?.path}');

            if (file == null) return;

            String uniqueFileName =
                DateTime.now().millisecondsSinceEpoch.toString();

            //Get a reference to storage root
            Reference ref_DirImages = storageRef.child("images");

            //Create a reference for the image to be stored.
            Reference ref_ImageToUpLoad = ref_DirImages.child(uniqueFileName);

            try {
              //Store the file
              String filePath = '${file!.path}';
              await ref_ImageToUpLoad.putFile(File(filePath));

              //Success: get the download URL
              //TODO: cannot update but remain old picture
              _imageUrl = await ref_ImageToUpLoad.getDownloadURL();
              print("Updated");
            } catch (error) {}
          },
          icon: Icon(Icons.camera_alt, size: 22),
          label: Text('Upload Images'),
          style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(35)),
        )
      ],
    );
  }

  void insertEventDetails({id: null}) {
    final _event = Event(
      id: id ?? FirebaseFirestore.instance.collection('events').doc().id,
      name: controllerEventName.text.trim(),
      description: controllerDescription.text.trim(),
      venue: controllerVenue.text.trim(),
      platform: controllerPlatform.text.trim(),
      image: _imageUrl,
      date: _date,
    ).toJson();

    CollectionReference events =
        FirebaseFirestore.instance.collection('events');

    try {
      if (widget.formType == 'create')
        events.add(_event).then((_) {
          Utils.showSnackBar("${widget.formType} an event");
        });
      else
        events
            .where("id", isEqualTo: widget.eventModel?['id'])
            .get()
            .then((value) {
          value.docs.forEach((element) {
            events.doc(element.id).update(_event).then((_) {
              Utils.showSnackBar("${widget.formType} an event");
            });
          });
        });

      Navigator.pushNamed(context, '/');
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              Text("Create Events",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _buildEventNameField(),
                        _buildDescriptionField(),
                        _buildVenueField(),
                        _buildDateField(),
                        _buildPlatformField(),
                        SizedBox(
                          height: 10,
                        ),
                        _buildImageField(),
                        SizedBox(height: 50),
                        ElevatedButton(
                          child: Text("Submit",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16)),
                          onPressed: () {
                            // timer = Timer.periodic(
                            //     Duration(seconds: 2),
                            //     (_) => {
                            if (!_formKey.currentState!.validate()) {
                            } else {
                              _formKey.currentState!.save();
                              insertEventDetails();
                            }
                            // });
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context),
        child: Icon(Icons.arrow_back_rounded, size: 25),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
