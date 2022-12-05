import 'package:utmsport/globalVariable.dart' as global;

class MasterBooking {
  static final timeslot = [
    1000,
    1030,
    1100,
    1130,
    1200,
    1230,
    1400,
    1430,
    1500,
    1530,
    1600,
    1630,
    1700,
    1730,
    1800,
    1830,
  ];

  static final badmintonCourt = 11;

  List<dynamic> booked_courtTimeslot;
  DateTime date;
  String userId;
  String bookingId;

  MasterBooking({
    required this.booked_courtTimeslot,
    required this.date,
    required this.userId,
    required this.bookingId,
    //TODO: cm-add sports-type into master-booking db
    // required this.sportsType,
  });

  Map<String, dynamic> toJson() => {
        "booked_courtTimeslot": booked_courtTimeslot,
        "date": date,
        "userId": userId,
        "bookingId": bookingId,
      };

  static List nestedArrayToObject(courtTimeslot, _noOfTimeslot) {
    List newObjectArray = [];
    for (int i = 0; i < _noOfTimeslot + 1; i++) {
      newObjectArray.add({'court': courtTimeslot[i]});
    }
    print(newObjectArray);
    return newObjectArray;
  }

  static void fetchFBObjectToNestedArray(
      {required List<List<String>> courtTimeslot,
      noOfTimeslot: 9,
      noOfCourt}) async {
    // List<List<String>> newNestedArray = [];
    var a;
    await global.FFdb.collection('master_booking')
        .where('date', isEqualTo: DateTime(2022, 12, 5))
        .get()
        .then((val) {
      if (val.docs.length == 0)
        createNestedCTArray(
            // courtTimeslot: courtTimeslot,
            noOfTimeslot: noOfTimeslot,
            noOfCourt: noOfCourt);
      else
        val.docs.forEach((element) {
          a = element['booked_courtTimeslot'];
          for (int i = 0; i < noOfTimeslot + 1; i++) {
            courtTimeslot.add(a[i]['court']);
          }
        });
    });
  }

  //create court-timeslot
  static List<List<String>> createNestedCTArray(
      {required noOfTimeslot, required noOfCourt}) {
    List<List<String>> ct = [];
    for (int i = 0; i <= noOfTimeslot; i++) {
      List<String> a = [];
      for (int j = 0; j <= noOfCourt; j++) {
        if (i == 0 && j == 0)
          a.add("B");
        else if (j != 0 && i == 0)
          a.add("C$j");
        else if (j == 0 && i != 0)
          a.add("T$i");
        // a.add("${MasterBooking.timeslot[i-1]}");
        // else if (j == 0 && i != 0) a.add("Icon")
        else
          a.add("");
      }
      ct.add(a);
    }
    return ct;
  }
}
