import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:utmsport/globalVariable.dart' as global;

class ProfileUpdatePage extends StatefulWidget {
  const ProfileUpdatePage({Key? key}) : super(key: key);

  @override
  State<ProfileUpdatePage> createState() => _ProfileUpdatePageState();
}

class _ProfileUpdatePageState extends State<ProfileUpdatePage> {
  final fullnameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  FirebaseFirestore db = global.FFdb;
  Reference storageRef = FirebaseStorage.instance.ref();
  String imageUrl = '';
  Timer? timer;

  updateProfile() {
    if (formKey.currentState!.validate()) {
      var data = {
        'name': fullnameController.text.trim(),
        'roles': 'student',
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'image': imageUrl
      };

      db
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update(data)
          .then((value) => print("User Updated"))
          .catchError((error) =>
          print("Failed to update user: $error"));

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) =>
      Scaffold(
        appBar: AppBar(
          title: Text('Update Profile'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: fullnameController,
                  cursorColor: Colors.white,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(labelText: 'Full Name'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (fullname) =>
                  fullname != null && !fullname.isNotEmpty
                      ? 'Enter your name'
                      : null,
                ),
                SizedBox(
                  height: 16,
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    ImagePicker imagePicker = ImagePicker();
                    XFile? file = await imagePicker.pickImage(
                        source: ImageSource.gallery);

                    if (file == null) return;

                    String uniqueFileName =
                    DateTime
                        .now()
                        .millisecondsSinceEpoch
                        .toString();

                    //Get a reference to storage root
                    Reference ref_DirImages = storageRef.child("images");

                    //Create a reference for the image to be stored.
                    Reference ref_ImageToUpLoad =
                    ref_DirImages.child(uniqueFileName);

                    try {
                      //Store the file
                      String filePath = '${file.path}';
                      await ref_ImageToUpLoad.putFile(File(filePath));

                      //Success: get the download URL
                      imageUrl = await ref_ImageToUpLoad.getDownloadURL();
                    } catch (error) {

                    }
                  },
                  icon: Icon(Icons.camera_alt, size: 22),
                  label: Text('Upload Images'),
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(35)),
                ),
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(35),
                    ),
                    icon: Icon(Icons.arrow_forward, size: 22),
                    label: Text('Confirm'),
                    onPressed: () {
                      timer = Timer.periodic(
                          Duration(seconds: 2),
                              (_) => updateProfile()
                      );
                    }),
              ],
            ),
          ),
        ),
      );
}
