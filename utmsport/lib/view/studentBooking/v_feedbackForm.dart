import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:utmsport/globalVariable.dart' as global;

import '../../utils.dart';

class FeedbackForm extends StatefulWidget {
  const FeedbackForm({Key? key}) : super(key: key);

  @override
  State<FeedbackForm> createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _imageUrl = "";
  String _comment = "";
  final controllerComment = TextEditingController();

  Reference storageRef = FirebaseStorage.instance.ref();

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
              Text("Write Your Feedbacks",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _buildCommentField(),
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
                            if (!_formKey.currentState!.validate()) {
                            } else {
                              _formKey.currentState!.save();
                              insertFeedbackFormDetails();
                            }
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => Navigator.pop(context),
      //   child: Icon(Icons.arrow_back_rounded, size: 25),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  Widget _buildImageField() {
    return Column(
      children: [
        //TODO:m Image not updated when
        ElevatedButton.icon(
          onPressed: () async {
            ImagePicker imagePicker = ImagePicker();
            XFile? file =
                await imagePicker.pickImage(source: ImageSource.gallery);

            if (file == null) return;

            String uniqueFileName =
                DateTime.now().millisecondsSinceEpoch.toString();
            Reference ref_DirImages = storageRef.child("images");
            Reference ref_ImageToUpLoad = ref_DirImages.child(uniqueFileName);

            try {
              String filePath = '${file!.path}';
              await ref_ImageToUpLoad.putFile(File(filePath));

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

  Widget _buildCommentField() {
    return TextFormField(
        controller: controllerComment,
        decoration: InputDecoration(labelText: "Comments"),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Comments are required";
          }
        },
        onSaved: (value) {
          _comment = value!;
        });
  }

  void insertFeedbackFormDetails() {
    CollectionReference feedbacks = global.FFdb.collection('feedback');

    final Map<String, dynamic> _feedback = {
      "id": feedbacks.doc().id,
      "image": _imageUrl,
      "comment": controllerComment.text.trim(),
    };

    try {
      feedbacks.add(_feedback).then((_) {
        Utils.showSnackBar('submitted feedback form', "green");
      });
    } on Exception catch (e) {
      print(e);
    }
  }
}
