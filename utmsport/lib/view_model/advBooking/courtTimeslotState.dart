import 'package:flutter/cupertino.dart';

class CourtTimeslotState extends InheritedWidget {

  final Widget child;
  final Function setSelectedCourtArray;

  CourtTimeslotState({
    Key? key,
    required this.child,
    required this.setSelectedCourtArray,
  })
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(CourtTimeslotState oldWidget) {
    //return true;
    return count != oldWidget.count;
  }
}
