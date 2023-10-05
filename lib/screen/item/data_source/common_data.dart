import 'package:flutter/material.dart';
import 'package:huahuan_web/api/collector_api.dart';
import 'package:huahuan_web/api/project_api.dart';
import 'package:huahuan_web/constant/common_constant.dart';
import 'package:huahuan_web/model/admin/CollectorModel.dart';
import 'package:huahuan_web/model/admin/project_model.dart';
import 'package:huahuan_web/screen/item/DateModel2.dart';
import 'package:huahuan_web/screen/item/date_model.dart';
import 'package:huahuan_web/screen/sensor_manager/main_sensor.dart';
import 'package:huahuan_web/util/tro_util.dart';
import 'package:huahuan_web/widget/button/buttons.dart';
import 'package:huahuan_web/widget/dialog/tro_dialog.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class CommonDataSource extends DataGridSource {
  CommonDataSource({required List<DateModel> commonData}) {
    dataGridRows = commonData.map<DataGridRow>((dataGridRow) {
      DateTime? refTime = DateTime.tryParse(dataGridRow.refTime ?? '');
      DateTime? curTime = DateTime.tryParse(dataGridRow.curTime ?? '');
      String ref = refTime.toString().split('.')[0];

      String cur = curTime.toString().split('.')[0];
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'sn', value: dataGridRow.sn),
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
          alignment: Alignment.center,
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
        DataGridCell<String>(columnName: 'sn', value: dataGridRow.sn),
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
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            dataGridCell.value.toString(),
            overflow: TextOverflow.ellipsis,
          ));
    }).toList());
  }
}

class QinXieDataSource extends DataGridSource {
  QinXieDataSource({required List<DateModel2> commonData}) {
    dataGridRows = commonData.map<DataGridRow>((dataGridRow) {
      // DateTime? refTime = DateTime.tryParse(dataGridRow.refTime ?? '');
      // DateTime? curTime = DateTime.tryParse(dataGridRow.curTime ?? '');
      // String ref =
      //     '${refTime?.year ?? '/'}-${refTime?.month ?? '/'}-${refTime?.day ?? '/'} ${refTime?.hour ?? '/'}:${refTime?.minute ?? '/'}:${refTime?.second ?? '/'}';
      // String cur =
      //     '${curTime?.year ?? '/'}-${curTime?.month ?? '/'}-${curTime?.day ?? '/'} ${curTime?.hour ?? '/'}:${curTime?.minute ?? '/'}:${curTime?.second ?? '/'}';
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'sn', value: dataGridRow.sn),
        DataGridCell<String>(columnName: 'name', value: dataGridRow.name),
        DataGridCell<String>(
            columnName: 'location', value: dataGridRow.location),
        DataGridCell<num>(
            columnName: 'curShapeX', value: dataGridRow.curValueX),
        DataGridCell<num>(
            columnName: 'curShapeY', value: dataGridRow.curValueY),
        DataGridCell<num>(
            columnName: 'refShapeX', value: dataGridRow.refValueX),
        DataGridCell<num>(
            columnName: 'refShapeX', value: dataGridRow.refValueY),
        DataGridCell<num>(
            columnName: 'curShapeOffsetX', value: dataGridRow.curOffsetX),
        DataGridCell<num>(
            columnName: 'curShapeOffsetY', value: dataGridRow.curOffsetY),
        DataGridCell<num>(columnName: 'curValueX', value: dataGridRow.offSetX),
        DataGridCell<num>(columnName: 'curValueY', value: dataGridRow.offSetY),
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
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            dataGridCell.value.toString(),
            overflow: TextOverflow.ellipsis,
          ));
    }).toList());
  }
}

class ProjectSource extends DataGridSource {
  ProjectSource({
    required List<ProjectModel> commonData,
    required BuildContext context,
    required Function(ProjectModel projectModel) editProject,
    required Function getAllProjects,
    required State state,
  }) {
    dataGridRows = commonData.map<DataGridRow>((dataGridRow) {
      DateTime? refTime = DateTime.tryParse(dataGridRow.created ?? '');
      // DateTime? curTime = DateTime.tryParse(dataGridRow.curTime ?? '');
      String createTime = refTime.toString().split('.')[0];

      // String cur =
      //     '${curTime?.year ?? '/'}-${curTime?.month ?? '/'}-${curTime?.day ?? '/'} ${curTime?.hour ?? '/'}:${curTime?.minute ?? '/'}:${curTime?.second ?? '/'}';
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'name', value: dataGridRow.name),
        DataGridCell<int>(columnName: 'userId', value: dataGridRow.userId),
        DataGridCell<String>(
            columnName: 'location', value: dataGridRow.location),
        DataGridCell<String>(
            columnName: 'describe', value: dataGridRow.description),
        DataGridCell<String>(columnName: 'createTime', value: createTime),
        DataGridCell<Widget>(
            columnName: 'operation',
            value: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: ButtonWithIcons.edit(context, () {
                      editProject(dataGridRow);
                    }, showLabel: false),
                  ),
                  Expanded(
                    child: ButtonWithIcons.delete(context, () {
                      troConfirm(context, '确认删除', (context) async {
                        var result = await ProjectApi.deleteProjectById(
                            '{"id": ${dataGridRow.id}}');
                        if (result.code == 200) {
                          getAllProjects();
                          TroUtils.message('success');
                          state.setState(() {});
                        }
                      });
                    }, showLabel: false),
                  )
                ],
              ),
            )),
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
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: dataGridCell.columnName == 'operation'
              ? Container(
                  child: dataGridCell.value,
                )
              : Text(
                  dataGridCell.value.toString(),
                  overflow: TextOverflow.ellipsis,
                ));
    }).toList());
  }
}

class EventSource extends DataGridSource {
  EventSource({
    required List<ProjectModel> commonData,
    required BuildContext context,
    required Function(ProjectModel projectModel) editEvent,
    required Function(int? id) editCollectors,
    required Function(int? id, int? prjectTypeId) editSensor,
    required Function getAllProjects,
    required State state,
  }) {
    dataGridRows = commonData.map<DataGridRow>((dataGridRow) {
      DateTime? refTime = DateTime.tryParse(dataGridRow.created ?? '');
      // DateTime? curTime = DateTime.tryParse(dataGridRow.curTime ?? '');
      String createTime = refTime.toString().split('.')[0];

      // String cur =
      //     '${curTime?.year ?? '/'}-${curTime?.month ?? '/'}-${curTime?.day ?? '/'} ${curTime?.hour ?? '/'}:${curTime?.minute ?? '/'}:${curTime?.second ?? '/'}';
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'name', value: dataGridRow.name),
        DataGridCell<int>(columnName: 'userId', value: dataGridRow.userId),
        DataGridCell<int>(columnName: 'eventId', value: dataGridRow.id),
        DataGridCell<String>(
            columnName: 'type', value: eventType[dataGridRow.projectTypeId]),
        DataGridCell<String>(columnName: 'createTime', value: createTime),
        DataGridCell<Widget>(
            columnName: 'operation',
            value: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    flex: 2,
                    child: ButtonWithIcons.collect(
                      context,
                      () {
                        editCollectors(dataGridRow.id);
                      },
                    ),
                  ),
                  Spacer(),
                  Expanded(
                    flex: 2,
                    child: ButtonWithIcons.detect(
                      context,
                      () {
                        editSensor(dataGridRow.id, dataGridRow.projectTypeId);
                      },
                    ),
                  ),
                  Expanded(
                    child: ButtonWithIcons.edit(context, () {
                      editEvent(dataGridRow);
                    }, showLabel: false),
                  ),
                  Expanded(
                    child: ButtonWithIcons.delete(context, () {
                      troConfirm(context, '确认删除', (context) async {
                        var result = await ProjectApi.deleteProjectById(
                            '{"id": ${dataGridRow.id}}');
                        if (result.code == 200) {
                          getAllProjects();
                          TroUtils.message('success');
                          state.setState(() {});
                        }
                      });
                    }, showLabel: false),
                  ),
                ],
              ),
            )),
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
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: dataGridCell.columnName == 'operation'
              ? Container(
                  child: dataGridCell.value,
                )
              : Text(
                  dataGridCell.value.toString(),
                  overflow: TextOverflow.ellipsis,
                ));
    }).toList());
  }
}

class CollectorSource extends DataGridSource {
  CollectorSource({
    required List<CollectorModel> commonData,
    required BuildContext context,
    required Function(CollectorModel? sensorModel) edit,
  }) {
    dataGridRows = commonData.map<DataGridRow>((dataGridRow) {
      DateTime? refTime = DateTime.tryParse(dataGridRow.created ?? '');
      // DateTime? curTime = DateTime.tryParse(dataGridRow.curTime ?? '');
      String createTime =
          '${refTime?.year ?? '/'}-${refTime?.month ?? '/'}-${refTime?.day ?? '/'} ${refTime?.hour ?? '/'}:${refTime?.minute ?? '/'}:${refTime?.second ?? '/'}';
      // String cur =
      //     '${curTime?.year ?? '/'}-${curTime?.month ?? '/'}-${curTime?.day ?? '/'} ${curTime?.hour ?? '/'}:${curTime?.minute ?? '/'}:${curTime?.second ?? '/'}';
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'name', value: dataGridRow.name),
        DataGridCell<String>(columnName: 'sn', value: dataGridRow.sn),
        DataGridCell<String>(
            columnName: 'type',
            value: collectorType[dataGridRow.collectorTypeId]),
        DataGridCell<int>(columnName: 'cycle', value: dataGridRow.cycle),
        DataGridCell<int>(columnName: 'port', value: dataGridRow.port),
        DataGridCell<String>(columnName: 'userId', value: dataGridRow.userId),
        DataGridCell<Widget>(
            columnName: 'operation',
            value: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      child: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          edit(dataGridRow);
                        },
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          troConfirm(context, '确定删除', (context) async {
                            var result = await CollectorApi.delete(
                                '{"id": ${dataGridRow.id}}');
                            if (result.code == 200) {
                              TroUtils.message('success');
                            }
                            mainSensorState.refresh();
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
            )),
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
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: dataGridCell.columnName == 'operation'
              ? Container(
                  child: dataGridCell.value,
                )
              : Text(
                  dataGridCell.value.toString(),
                  overflow: TextOverflow.ellipsis,
                ));
    }).toList());
  }
}
