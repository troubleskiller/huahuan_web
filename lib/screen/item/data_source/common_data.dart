import 'package:flutter/material.dart';
import 'package:huahuan_web/screen/item/DateModel2.dart';
import 'package:huahuan_web/screen/item/date_model.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class CommonDataSource extends DataGridSource {
  CommonDataSource({required List<DateModel> commonData}) {
    dataGridRows = commonData.map<DataGridRow>((dataGridRow) {
      DateTime? refTime = DateTime.tryParse(dataGridRow.refTime ?? '');
      DateTime? curTime = DateTime.tryParse(dataGridRow.curTime ?? '');
      String ref =
          '${refTime?.year ?? '/'}-${refTime?.month ?? '/'}-${refTime?.day ?? '/'} ${refTime?.hour ?? '/'}:${refTime?.minute ?? '/'}:${refTime?.second ?? '/'}';
      String cur =
          '${curTime?.year ?? '/'}-${curTime?.month ?? '/'}-${curTime?.day ?? '/'} ${curTime?.hour ?? '/'}:${curTime?.minute ?? '/'}:${curTime?.second ?? '/'}';
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'name', value: dataGridRow.name),
        DataGridCell<String>(columnName: 'refTime', value: ref),
        DataGridCell<double>(
            columnName: 'refValue', value: dataGridRow.refValue),
        DataGridCell<String>(columnName: 'curTime', value: cur),
        DataGridCell<double>(
            columnName: 'curValue', value: dataGridRow.curValue),
        DataGridCell<double>(
            columnName: 'curOffset', value: dataGridRow.curOffset),
        DataGridCell<double>(
            columnName: 'totalOffset', value: dataGridRow.totalOffset),
      ]);
    }).toList();
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

class CeXieDataSource extends DataGridSource {
  CeXieDataSource({required List<DateModel2> commonData}) {
    dataGridRows = commonData.map<DataGridRow>((dataGridRow) {
      // DateTime? refTime = DateTime.tryParse(dataGridRow.refTime ?? '');
      // DateTime? curTime = DateTime.tryParse(dataGridRow.curTime ?? '');
      // String ref =
      //     '${refTime?.year ?? '/'}-${refTime?.month ?? '/'}-${refTime?.day ?? '/'} ${refTime?.hour ?? '/'}:${refTime?.minute ?? '/'}:${refTime?.second ?? '/'}';
      // String cur =
      //     '${curTime?.year ?? '/'}-${curTime?.month ?? '/'}-${curTime?.day ?? '/'} ${curTime?.hour ?? '/'}:${curTime?.minute ?? '/'}:${curTime?.second ?? '/'}';
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'name', value: dataGridRow.name),
        DataGridCell<String>(
            columnName: 'location', value: dataGridRow.location),
        DataGridCell<num>(
            columnName: 'curShapeX', value: dataGridRow.curShapeX),
        DataGridCell<num>(
            columnName: 'curShapeY', value: dataGridRow.curShapeY),
        DataGridCell<num>(
            columnName: 'refShapeX', value: dataGridRow.refShapeX),
        DataGridCell<num>(
            columnName: 'refShapeY', value: dataGridRow.refShapeY),
        DataGridCell<num>(
            columnName: 'curShapeOffsetX', value: dataGridRow.curShapeOffsetX),
        DataGridCell<num>(
            columnName: 'curShapeOffsetY', value: dataGridRow.curShapeOffsetY),
        DataGridCell<num>(
            columnName: 'curValueX', value: dataGridRow.curValueX),
        DataGridCell<num>(
            columnName: 'curValueY', value: dataGridRow.curValueY),
      ]);
    }).toList();
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
