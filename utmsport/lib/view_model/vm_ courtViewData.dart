import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class Employee {
  int id = 0;
  String name = "";
  String designation = "";
  int salary = 0;

  Employee(id, name, posi, sal) {
    this.id = id;
    this.name = name;
    this.designation = posi;
    this.salary = sal;
  }
}

List<Employee> getEmployeeData() {
  return [
    Employee(2, "Joan", "Manager", 20000),
    Employee(3, "Michelle", "Student", 20000),
    Employee(4, "Emma", "Manager", 20000),
  ];
}

class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource({required List<Employee> employees}) {
    dataGridRows = employees
        .map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
      DataGridCell<int>(columnName: 'id', value: dataGridRow.id),
      DataGridCell<String>(columnName: 'name', value: dataGridRow.name),
      DataGridCell<String>(
          columnName: 'designation', value: dataGridRow.designation),
      DataGridCell<int>(
          columnName: 'salary', value: dataGridRow.salary),
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
                  dataGridCell.columnName == 'salary')
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
