import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:utmsport/model/m_User.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  FirebaseFirestore db = FirebaseFirestore.instance;
  List<UserDb> userList = [];

  @override
  void initState() {
    // TODO: implement initState
    fetchRecords();
    super.initState();
  }
  
  fetchRecords() async {
    var record = await db.collection("users").where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
    mapRecords(record);
  }

  void mapRecords(QuerySnapshot<Map<String, dynamic>> records) {
    var _result = records.docs
        .map((user) => UserDb(id: user.id, name: user['name'], roles: user['roles'], userId: user['userId'])).toList();

    setState(() {
      userList = _result;
      print(userList[0].name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }


}
