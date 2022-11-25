// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'appointment.dart';
//
//
//
// class AddAppointment extends StatefulWidget{
//   @override
//   State<AddAppointment> createState() => _AddAppointmentState();
// }
//
// class _AddAppointmentState extends State<AddAppointment>{
//
//   final controllerTitle = TextEditingController();
//   final controllerTime = TextEditingController();
//   final controllerDate = TextEditingController();
//   final controllerPIC = TextEditingController();
//   final controllermatricNo = TextEditingController();
//   final controllerphoneNo = TextEditingController();
//   final controllerDescription = TextEditingController();
//
//
//   @override
//   Widget build(BuildContext context) => Scaffold(
//     appBar: AppBar(
//       title: Text('Appointment Form'),
//     ),
//
//     body: ListView(
//       padding: EdgeInsets.all(16),
//       children: <Widget>[
//         TextField(
//           controller: controllerTitle,
//           decoration: decoration('Title'),
//         ),
//         const SizedBox(height:10),
//         TextField(
//           controller: controllerTime,
//           decoration: decoration('Time'),
//         ),
//         const SizedBox(height:10),
//         TextField(
//             controller: controllerDate,
//             //decoration: decoration('Date'),
//             decoration: InputDecoration(
//                 labelText: "Date",
//                 suffixIcon: Icon(Icons.calendar_today)),
//             readOnly: true,
//             onTap: () async {
//
//               DateTime? value = await showDatePicker(
//                   context: context,
//                   initialDate: DateTime.now(),
//                   firstDate: DateTime(1900),
//                   lastDate: DateTime(2100));
//
//               if (value == null) return null;
//               String date;
//               setState(() => {
//                 date = DateFormat('yyyy-MM-dd').format(value),
//                 controllerDate.text = date,
//                 print(date),
//               });
//             }
//         ),
//         const SizedBox(height:15),
//         TextField(
//           controller: controllerPIC,
//           decoration: decoration('Person in charge'),
//         ),
//         const SizedBox(height:10),
//         TextField(
//           controller: controllermatricNo,
//           decoration: decoration('Matric Number'),
//         ),
//         const SizedBox(height:10),
//         TextField(
//           controller: controllerphoneNo,
//           decoration: decoration('Phone Number'),
//         ),
//         const SizedBox(height:10),
//         TextField(
//           controller: controllerDescription,
//           decoration: decoration('Description'),
//         ),
//         const SizedBox(height:10),
//         //const SizedBox(height: 32),
//         ElevatedButton(
//             child: Text('Submit'),
//             onPressed: (){
//               final appointment = Appointment(
//                 title: controllerTitle.text,
//                 time: controllerTime.text,
//                 date: controllerDate.text,
//                 pic: controllerPIC.text,
//                 matricNo: controllermatricNo.text,
//                 phoneNo: controllerphoneNo.text,
//                 description: controllerDescription.text,
//               );
//               createAppointment(appointment);
//               Navigator.pop(context);
//             }
//         )
//       ],
//     ),
//   );
//
//   InputDecoration decoration(String label) => InputDecoration(
//     labelText: label,
//     border: OutlineInputBorder(),
//   );
//
//   Future createAppointment(Appointment appointment) async{
//     final docAppointment = FirebaseFirestore.instance.collection('appointments').doc();
//
//     final json = appointment.toJson();
//     await docAppointment.set(json);
//   }
//
//   // Future<void> updateAppointment(Appointment appointment) async {
//   //   final docAppointment = FirebaseFirestore.instance.collection('appointments').doc();
//   //
//   //   final json = appointment.toJson();
//   //
//   //   await showModalBottomSheet(
//   //       isScrollControlled: true,
//   //       context: context,
//   //       builder: (BuildContext ctx) {
//   //         return Padding(
//   //           padding: EdgeInsets.only(
//   //               top: 20,
//   //               left: 20,
//   //               right: 20,
//   //               bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
//   //           child: Column(
//   //             mainAxisSize: MainAxisSize.min,
//   //             crossAxisAlignment: CrossAxisAlignment.start,
//   //             children: [
//   //               TextField(
//   //                 controller: controllerTitle,
//   //                 decoration: const InputDecoration(labelText: 'Name'),
//   //               ),
//   //               TextField(
//   //                 keyboardType:
//   //                 const TextInputType.numberWithOptions(decimal: true),
//   //                 controller: controllerTime,
//   //                 decoration: const InputDecoration(
//   //                   labelText: 'Price',
//   //                 ),
//   //               ),
//   //               const SizedBox(
//   //                 height: 20,
//   //               ),
//   //               ElevatedButton(
//   //                 child: const Text( 'Update'),
//   //                 onPressed: () async {
//   //                   final String name = _nameController.text;
//   //                   final double? price =
//   //                   double.tryParse(_priceController.text);
//   //                   if (price != null) {
//   //
//   //                     await _products
//   //                         .doc(documentSnapshot!.id)
//   //                         .update({"name": name, "price": price});
//   //                     _nameController.text = '';
//   //                     _priceController.text = '';
//   //                     Navigator.of(context).pop();
//   //                   }
//   //                 },
//   //               )
//   //             ],
//   //           ),
//   //         );
//   //       });
//   // }
// }
//
