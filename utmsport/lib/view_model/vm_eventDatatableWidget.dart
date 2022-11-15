import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';

Widget EventDatatableWidget(_employeeDataSource) => SfDataGridTheme(
  data: SfDataGridThemeData(
    headerColor: const Color(0xff009889),
    rowHoverColor: Colors.yellow,
  ),
  child: SfDataGrid(
      columnWidthMode: ColumnWidthMode.auto,
      source: _employeeDataSource,
      isScrollbarAlwaysShown: true,
      columns: [
        GridColumn(
            columnName: 'id',
            label: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.centerRight,
                child: Text(
                  'ID',
                  overflow: TextOverflow.ellipsis,
                ))),
        GridColumn(
            columnName: 'name',
            label: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Name',
                  overflow: TextOverflow.ellipsis,
                ))),
        GridColumn(
            columnName: 'description',
            label: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Description',
                  overflow: TextOverflow.ellipsis,
                ))),
        GridColumn(
            columnName: 'date',
            label: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Date',
                  overflow: TextOverflow.ellipsis,
                ))),
        GridColumn(
            columnName: 'image',
            label: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Image',
                  overflow: TextOverflow.ellipsis,
                ))),
        GridColumn(
            columnName: 'venue',
            label: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Venue',
                  overflow: TextOverflow.ellipsis,
                ))),
        GridColumn(
            columnName: 'platform',
            label: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Platform',
                  overflow: TextOverflow.ellipsis,
                )))
      ]),
);