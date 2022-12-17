import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';

List<String> colNames = [
  'action',
  // 'id',
  'name',
  // 'description',
  'date',
  // 'image',
  'venue',
  // 'platform',
];

List<GridColumn> getColumns() => colNames
    .map(
      (name) => GridColumn(
          columnName: name,
          width: name == "action" ? 160 : 100,
          label: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: Text(
                name,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
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
