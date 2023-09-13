import 'package:flutter/material.dart';
import 'package:huahuan_web/api/project_api.dart';
import 'package:huahuan_web/model/admin/project_model.dart';
import 'package:huahuan_web/model/api/response_api.dart';
import 'package:huahuan_web/model/application/event_model.dart';
import 'package:huahuan_web/screen/event/event_manage/event_edit.dart';
import 'package:huahuan_web/screen/item/data_source/common_data.dart';
import 'package:huahuan_web/screen/manager/sensor_hole_manager.dart';
import 'package:huahuan_web/screen/sensor_manager/collector_list_manager.dart';
import 'package:huahuan_web/widget/button/buttons.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

late DataManagerListState _dataManagerListState;

class DataManagerList extends StatefulWidget {
  const DataManagerList({Key? key}) : super(key: key);

  @override
  State<DataManagerList> createState() {
    _dataManagerListState = DataManagerListState();
    return _dataManagerListState;
  }
}

class DataManagerListState extends State<DataManagerList> {
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

  void _editSensor(int? id, int? projectTypeId) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: SensorHoleManager(
          pid: id,
          projectTypeId: projectTypeId,
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
                      ...projects.map((e) {
                        EventSource cur = EventSource(
                          commonData: e.events ?? [],
                          context: context,
                          editEvent: (ProjectModel ad) {
                            _editEvent(curProject: ad);
                          },
                          getAllProjects: () {
                            getAllProjects();
                          },
                          state: _dataManagerListState,
                          editCollectors: (int? id) {
                            _editCollectors(id);
                          },
                          editSensor: (int? id, int? prjectTypeId) {
                            _editSensor(id, prjectTypeId);
                          },
                        );
                        return ExpansionTile(
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
                            if ((e.events ?? []).isEmpty) {
                              return;
                            }
                          },
                          children: (e.events ?? []).isEmpty
                              ? <Widget>[]
                              : [
                                  Container(
                                    height: (e.events!.length + 1) * 60,
                                    child: SfDataGrid(
                                      columnWidthCalculationRange:
                                          ColumnWidthCalculationRange.allRows,
                                      gridLinesVisibility:
                                          GridLinesVisibility.both,
                                      headerGridLinesVisibility:
                                          GridLinesVisibility.both,
                                      selectionMode: SelectionMode.single,
                                      navigationMode: GridNavigationMode.cell,
                                      source: cur,
                                      columnWidthMode: ColumnWidthMode.fill,
                                      columns: [
                                        GridColumn(
                                          columnName: 'name',
                                          label: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16.0),
                                            alignment: Alignment.center,
                                            child: Text(
                                              '项目名称',
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        GridColumn(
                                          columnWidthMode:
                                              ColumnWidthMode.fitByColumnName,
                                          columnName: 'userId',
                                          label: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16.0),
                                            alignment: Alignment.center,
                                            child: Text(
                                              '用户id',
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        GridColumn(
                                          columnWidthMode:
                                              ColumnWidthMode.fitByColumnName,
                                          columnName: 'eventId',
                                          label: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16.0),
                                            alignment: Alignment.center,
                                            child: Text(
                                              '测项id',
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        GridColumn(
                                          columnName: 'type',
                                          label: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16.0),
                                            alignment: Alignment.center,
                                            child: Text(
                                              '测项类型',
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        GridColumn(
                                          columnName: 'createTime',
                                          label: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16.0),
                                            alignment: Alignment.center,
                                            child: Text(
                                              '创建时间',
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        GridColumn(
                                          width: 500,
                                          columnWidthMode: ColumnWidthMode.none,
                                          columnName: 'operation',
                                          label: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16.0),
                                            alignment: Alignment.center,
                                            child: Text(
                                              '操作',
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                        );
                      }),
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
