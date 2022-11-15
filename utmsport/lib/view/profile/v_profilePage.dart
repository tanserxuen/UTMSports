
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:utmsport/model/m_User.dart';
import 'package:utmsport/view/profile/v_profileUpdatePage.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Reference storageRef = FirebaseStorage.instance.ref();
  String imageUrl = '';
  FirebaseFirestore db = FirebaseFirestore.instance;
  List<UserDb> userList = [];

  @override
  void initState() {
    // TODO: implement initState
    // fetchRecords();
    super.initState();
  }
  //
  // fetchRecords() async {
  //   var record = await db
  //       .collection("users")
  //       .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
  //       .get();
  //   mapRecords(record);
  // }
  //
  // void mapRecords(QuerySnapshot<Map<String, dynamic>> records) {
  //   var _result = records.docs
  //       .map((user) => UserDb(
  //           id: user.id,
  //           name: user['name'],
  //           roles: user['roles'],
  //           userId: user['userId'],
  //           image: user['image']))
  //       .toList();
  //
  //   setState(() {
  //     userList = _result;
  //     // print(userList[0].name);
  //   });
  // }

  var uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("users").doc(uid).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if(snapshot.hasError) return Text('Something went wrong');
          if(snapshot.connectionState == ConnectionState.waiting) return Text('Loading');
          if(snapshot.hasData) {
            var output = snapshot.data!.data();
            var name = output!['name'];
            print('$output');
            return Padding(
                padding: EdgeInsets.all(60),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //  TODO: Add Picture button here
                            Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    // image: snapshot.data?.data()!['image'] != null ? NetworkImage(output['image']) : NetworkImage('https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png') ,
                                    image: NetworkImage(output['image']),
                                    fit: BoxFit.fitHeight
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              output['name'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                                letterSpacing: -1,

                              ),
                            ),
                            SizedBox(height: 20),
                            Text(output['roles']),
                            SizedBox(height: 20),
                            ElevatedButton.icon(
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> ProfileUpdatePage()));
                              },
                              icon: Icon(Icons.attribution_sharp, size: 22),
                              label: Text(
                                  'Update Information'
                              ),
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size.fromHeight(35),
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () => FirebaseAuth.instance.signOut(),
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size.fromHeight(35),
                              ),
                              icon: Icon(Icons.arrow_back, size: 22),
                              label: Text(
                                'Sign Out',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                ),);
          }
          return Center(child: CircularProgressIndicator());
        }
      ),
      // body: ListView.builder(
      //   itemCount: userList.length,
      //   itemBuilder: (context, index) => Padding(
      //       padding: EdgeInsets.all(60),
      //       child: Column(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           //  TODO: Add Picture button here
      //           CircleAvatar(
      //             radius: 100,
      //             backgroundColor: Colors.transparent,
      //             child: Image.network('${userList[0].image}')
      //             // backgroundImage: NetworkImage(userList[0].image)
      //           ),
      //           //  TODO: display username, roles
      //           SizedBox(height: 20),
      //           Text(userList[0].name),
      //           SizedBox(height: 20),
      //           Text(userList[0].roles),
      //           SizedBox(height: 20),
      //           ElevatedButton.icon(
      //             onPressed: (){
      //               //  Todo: Update username
      //               Navigator.push(context, MaterialPageRoute(builder: (context)=> ProfileUpdatePage())).then((value) {
      //                 setState(() async{
      //                   await fetchRecords();
      //                 });
      //               });
      //
      //             },
      //             icon: Icon(Icons.attribution_sharp, size: 22),
      //             label: Text(
      //                 'Update Information'
      //             ),
      //             style: ElevatedButton.styleFrom(
      //               minimumSize: Size.fromHeight(35),
      //             ),
      //           )
      //         ],
      //       )),
      // ),
    );
  }
}
