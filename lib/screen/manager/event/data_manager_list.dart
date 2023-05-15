import 'package:flutter/material.dart';
import 'package:huahuan_web/api/project_api.dart';
import 'package:huahuan_web/model/admin/project_model.dart';
import 'package:huahuan_web/model/api/response_api.dart';
import 'package:huahuan_web/model/application/event_model.dart';
import 'package:huahuan_web/screen/event/event_manage/event_edit.dart';
import 'package:huahuan_web/screen/manager/sensor_hole_manager.dart';
import 'package:huahuan_web/screen/sensor_manager/collector_list_manager.dart';
import 'package:huahuan_web/widget/button/buttons.dart';
import 'package:provider/provider.dart';

import '../../../constant/common_constant.dart';
import '../../../util/tro_util.dart';
import '../../../widget/dialog/tro_dialog.dart';

class DataManagerList extends StatefulWidget {
  const DataManagerList({Key? key}) : super(key: key);

  @override
  State<DataManagerList> createState() => _DataManagerListState();
}

class _DataManagerListState extends State<DataManagerList> {
  late EventModel controller;
  List<ProjectModel> projects = [];

  @override
  void initState() {
    controller = context.read<EventModel>();
    super.initState();
  }

  Future getAllProjects() async {
    ResponseBodyApi responseBodyApi = await ProjectApi.findAll();
    if (responseBodyApi.code == 200) {
      projects = List.from(responseBodyApi.data)
          .map((e) => ProjectModel.fromJson(e))
          .toList();
    }
  }

  ///点击进入采集仪管理
  void _editCollectors(int? id) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: CollectorListManager(
          pid: id,
        ),
      ),
    ).then((v) {
      if (v != null) {
        setState(() {});
      }
    });
  }

  void _editEvent({ProjectModel? curProject, int? parentProjectId}) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: EventEdit(
          curProject: curProject,
          pId: parentProjectId,
        ),
      ),
    ).then((v) {
      if (v != null) {
        setState(() {});
      }
    });
  }

  void _editSensor(int? id) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: SensorHoleManager(
          pid: id,
        ),
      ),
    ).then((v) {
      if (v != null) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: FutureBuilder(
                future: getAllProjects(),
                builder: (_, as) {
                  return Column(
                    children: [
                      ...projects.map(
                        (e) => ExpansionTile(
                          title: Row(
                            children: [
                              Text(e.name ?? '-'),
                              Spacer(),
                              ButtonWithIcons.add(
                                context,
                                () {
                                  _editEvent(
                                    parentProjectId: e.id,
                                  );
                                },
                              ),
                            ],
                          ),
                          onExpansionChanged: (value) {
                            if (value) {}
                          },
                          children: [
                            Table(
                                columnWidths: <int, TableColumnWidth>{
                                  0: FlexColumnWidth(1),
                                  1: FlexColumnWidth(1),
                                  2: FlexColumnWidth(1),
                                  3: FlexColumnWidth(1),
                                  4: FlexColumnWidth(3),
                                },
                                border: TableBorder.all(
                                    width: 0.5, color: Colors.black),
                                children: [
                                  TableRow(
                                    children: [
                                      Center(child: Text('项目名称')),
                                      Center(child: Text('用户id')),
                                      Center(child: Text('测项类型')),
                                      Center(child: Text('创建时间')),
                                      Center(child: Text('操作')),
                                    ],
                                  ),
                                  ...e.events!
                                      .map(
                                        (e) => TableRow(
                                          children: [
                                            Center(child: Text(e.name ?? '-')),
                                            Center(
                                                child:
                                                    Text(e.userId.toString())),
                                            Center(
                                                child: Text(eventType[
                                                        e.projectTypeId] ??
                                                    '-')),
                                            Center(
                                              child: Text(
                                                DateTime.tryParse(
                                                        e.created ?? '-')
                                                    .toString(),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 15, vertical: 5),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Expanded(
                                                    flex: 2,
                                                    child:
                                                        ButtonWithIcons.collect(
                                                      context,
                                                      () {
                                                        _editCollectors(e.id);
                                                      },
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child:
                                                        ButtonWithIcons.detect(
                                                      context,
                                                      () {
                                                        _editSensor(e.id);
                                                      },
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: ButtonWithIcons.edit(
                                                        context, () {
                                                      _editEvent(curProject: e);
                                                    }, showLabel: false),
                                                  ),
                                                  Expanded(
                                                    child:
                                                        ButtonWithIcons.delete(
                                                            context, () {
                                                      troConfirm(context,
                                                          'confirmDelete',
                                                          (context) async {
                                                        var result = await ProjectApi
                                                            .deleteProjectById(
                                                                '{"id": ${e.id}}');
                                                        if (result.code ==
                                                            200) {
                                                          getAllProjects();
                                                          TroUtils.message(
                                                              'success');
                                                          setState(() {});
                                                        }
                                                      });
                                                    }, showLabel: false),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                      .toList(),
                                ]),
                            // ...e.events!.map((e) => Text(e.name ?? '--'))
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
