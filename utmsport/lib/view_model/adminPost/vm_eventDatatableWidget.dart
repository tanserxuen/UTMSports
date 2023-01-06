import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';

List<String> colNames = [
  'Action',
  // 'id',
  'Name',
  // 'description',
  'Date',
  // 'image',
  'Venue',
  // 'platform',
];

List<GridColumn> getColumns() => colNames
    .map(
      (name) => GridColumn(
          columnName: name,
          width: name == "Action" ? 120 : 100,
          label: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: Text(
                name,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                style: TextStyle(fontWeight: FontWeight.bold),
              ))),
    )
    .toList();

Widget EventDatatableWidget(_eventDataSource) => SfDataGridTheme(
      data: SfDataGridThemeData(
        headerColor: const Color(0x5540C4FF),
        rowHoverColor: Colors.yellow,
      ),
      child: SfDataGrid(
        columnWidthMode: ColumnWidthMode.auto,
        source: _eventDataSource,
        isScrollbarAlwaysShown: true,
        columns: getColumns(),
      ),
    );
