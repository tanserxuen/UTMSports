import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:utmsport/model/m_Event.dart';
import 'package:utmsport/view_model/vm_eventDatatableWidget.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

class EventDataSource extends DataGridSource {
  EventDataSource({required List<Event> events}) {
    dataGridRows = events
        .map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'id', value: dataGridRow.id),
              DataGridCell<String>(columnName: 'name', value: dataGridRow.name),
              DataGridCell<String>(
                  columnName: 'description', value: dataGridRow.description),
              DataGridCell<String>(columnName: 'date', value: dataGridRow.date),
              DataGridCell<String>(
                  columnName: 'image', value: dataGridRow.description),
              DataGridCell<String>(
                  columnName: 'venue', value: dataGridRow.venue),
              DataGridCell<String>(
                  columnName: 'platform', value: dataGridRow.platform),
            ]))
        .toList();
  }

  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
          alignment: (dataGridCell.columnName == 'id' ||
                  dataGridCell.columnName == 'date')
              ? Alignment.centerRight
              : Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            dataGridCell.value.toString(),
            overflow: TextOverflow.ellipsis,
          ));
    }).toList());
  }
}

class EventList extends StatefulWidget {
  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  late EventDataSource _eventDataSource;

  List<Event> _eventsList = <Event>[];

  @override
  void initState() {
    _eventsList = getEmployeeData();
    // fetchEventRecords();
    super.initState();
    _eventDataSource = EventDataSource(events: _eventsList);
  }

  void fetchEventRecords() async {
    final records = await db.collection("events").get();

    // return records.docs
        var _result = records.docs
        .map((event) => Event(
              id: event['id'],
              name: event['name'],
              description: event['description'],
              date: event['date'],
              image: event['image'],
              venue: event['venue'],
              platform: event['platform'],
            ))
        .toList();

    setState(() {
    _eventsList = _result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return EventDatatableWidget(_eventDataSource);
    // return FutureBuilder(
    //     future: _eventDataSource,
    //     builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
    //       List<Widget> children;
    //       if (snapshot.hasData) {
    //         children = [EventDatatableWidget(_eventDataSource)];
    //       } else if (snapshot.hasError) {
    //         children = [
    //           Text("Something went wrong"),
    //         ];
    //       } else
    //         return CircularProgressIndicator();
    //       return Center(
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: children,
    //         ),
    //       );
    //     });
  }
}
