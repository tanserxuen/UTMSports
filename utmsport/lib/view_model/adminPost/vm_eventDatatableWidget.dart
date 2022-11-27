import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';

List<String> colNames = [
  'id',
  'name',
  'description',
  'date',
  'image',
  'venue',
  'platform',
];

List<GridColumn> getColumns() => colNames
    .map(
      (name) => GridColumn(
          columnName: name,
          label: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerRight,
              child: Text(
                name,
                overflow: TextOverflow.ellipsis,

                softWrap: true,
              ))),
    )
    .toList();

Widget EventDatatableWidget(_eventDataSource) => SfDataGridTheme(
      data: SfDataGridThemeData(
        headerColor: const Color(0xff009889),
        rowHoverColor: Colors.yellow,
      ),
      child: SfDataGrid(
        // columnWidthMode: ColumnWidthMode.auto,
        source: _eventDataSource,
        isScrollbarAlwaysShown: true,
        columns: getColumns(),
      ),
    );
