import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:utmsport/model/m_Event.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'package:utmsport/view/adminPost/v_createEvent.dart';

class EventDataSource extends DataGridSource {
  EventDataSource({required List<Event> events}) {
    dataGridRows = events
        .map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'Action', value: ""),
              DataGridCell<String>(columnName: 'Name', value: dataGridRow.name),
              DataGridCell<DateTime>(
                  columnName: 'Date', value: dataGridRow.date),
              DataGridCell<String>(
                  columnName: 'Venue', value: dataGridRow.venue),
            ]))
        .toList();

    dataGridDetailRows = events
        .map((event) => Event(
              id: event.id,
              name: event.name,
              description: event.description,
              date: event.date,
              image: event.description,
              venue: event.venue,
              platform: event.platform,
            ))
        .toList();
  }

  List<DataGridRow> dataGridRows = [];
  List<Event> dataGridDetailRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      int idx = dataGridRows.indexOf(row);

      return Container(
          alignment: dataGridCell.columnName == 'date'
              ? Alignment.centerRight
              : Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 2.0),
          child: dataGridCell.columnName == 'Action'
              ? LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                  return Row(
                    children: [
                      SizedBox(width: 5),
                      IconButton(padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        icon: Icon(Icons.format_list_numbered_outlined),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              content: SizedBox(
                                height: 150,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${dataGridDetailRows[idx].name}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)),
                                    Text(
                                        "Id: ${dataGridDetailRows[idx].id}"),
                                    Text(
                                        "Description: ${dataGridDetailRows[idx].description}"),
                                    Text(
                                        "Date: ${DateFormat("dd MMMM yyyy").format(dataGridDetailRows[idx].date)}"),
                                    Text(
                                        "Image: ${dataGridDetailRows[idx].image}"),
                                    Text(
                                        "Venue: ${dataGridDetailRows[idx].venue}"),
                                    Text(
                                        "Platform: ${dataGridDetailRows[idx].platform}"),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        icon: Icon(Icons.edit),
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => FormScreen(
                                formType: "edit",
                                eventModel: dataGridDetailRows[idx]),
                          ),
                        ),
                      ),
                      IconButton(padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        icon: Icon(Icons.delete, color:Colors.red),
                        onPressed: () => deleteEvents(context,dataGridDetailRows[idx].id)
                    ),
                    ],
                  );
                })
              : Text(
                  dataGridCell.value.toString(),
                  overflow: TextOverflow.ellipsis,
                ));
    }).toList());
  }
}
