import 'package:flutter/cupertino.dart';
import 'package:utmsport/model/m_Event.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class EventDataSource extends DataGridSource {
  EventDataSource({required List<Event> events}) {
    dataGridRows = events
        .map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'id', value: dataGridRow.id),
              DataGridCell<String>(columnName: 'name', value: dataGridRow.name),
              DataGridCell<String>(
                  columnName: 'description', value: dataGridRow.description),
              DataGridCell<DateTime>(columnName: 'date', value: dataGridRow.date),
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
