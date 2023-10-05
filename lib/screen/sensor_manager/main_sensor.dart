import 'package:flutter/material.dart';
import 'package:huahuan_web/api/collector_api.dart';
import 'package:huahuan_web/model/admin/CollectorModel.dart';
import 'package:huahuan_web/model/admin/project_model.dart';
import 'package:huahuan_web/model/api/response_api.dart';
import 'package:huahuan_web/model/application/event_model.dart';
import 'package:huahuan_web/screen/item/collector_edit.dart';
import 'package:huahuan_web/screen/item/data_source/common_data.dart';
import 'package:huahuan_web/widget/button/buttons.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

late MainSensorState mainSensorState;

class MainSensor extends StatefulWidget {
  const MainSensor({Key? key}) : super(key: key);

  @override
  State<MainSensor> createState() {
    mainSensorState = MainSensorState();
    return mainSensorState;
  }
}

class MainSensorState extends State<MainSensor> {
  late EventModel eventModel;

  List<ProjectModel> projects = [];

  @override
  void initState() {
    // TODO: implement initState
    eventModel = context.read<EventModel>();
    init();
    super.initState();
  }

  Future init() async {
    ResponseBodyApi responseBodyApi = await CollectorApi.getAll();
    projects = List.from(responseBodyApi.data)
        .map((e) => ProjectModel.fromJson(e))
        .toList();
  }

  void refresh() async {
    await init();
    setState(() {});
  }

  _edit({
    CollectorModel? sensorModel,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: CollectorEdit(
          collectorModel: sensorModel,
          isUpdate: false,
        ),
      ),
    ).then((v) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white54,
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: init(),
              builder: (_, s) => ListView(
                children: projects
                    .map(
                      (e) => SensorContent(
                        project: e,
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          Container(
            height: 12,
          ),
          ButtonWithIcons.add(
            context,
            () {
              _edit();
            },
          ),
          Container(
            height: 12,
          ),
        ],
      ),
    );
  }
// Widget _buildProjectList
}

class SensorContent extends StatefulWidget {
  final ProjectModel project;

  const SensorContent({Key? key, required this.project}) : super(key: key);

  @override
  State<SensorContent> createState() => _SensorContentState();
}

class _SensorContentState extends State<SensorContent> {
  _edit({CollectorModel? sensorModel, required bool isUpdate}) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: CollectorEdit(
          collectorModel: sensorModel,
          isUpdate: isUpdate,
        ),
      ),
    ).then((v) async {
      if (v != null) {
        mainSensorState.refresh();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black),
          color: Colors.white10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.project.name ?? '-'),
          ...(widget.project.events ?? []).map((e) {
            CollectorSource cur = CollectorSource(
              commonData: e.collectors ?? [],
              context: context,
              edit: (CollectorModel? sensorModel) {
                _edit(sensorModel: sensorModel, isUpdate: true);
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
                      _edit(
                          isUpdate: false,
                          sensorModel: CollectorModel(
                            projectId: e.id,
                          ));
                    },
                  ),
                ],
              ),
              onExpansionChanged: (value) {
                if ((e.collectors ?? []).isEmpty) {
                  return;
                }
              },
              children: (e.collectors ?? []).isEmpty
                  ? <Widget>[]
                  : [
                      Container(
                        height: ((e.collectors ?? []).length + 1) * 60,
                        child: SfDataGrid(
                          columnWidthCalculationRange:
                              ColumnWidthCalculationRange.allRows,
                          gridLinesVisibility: GridLinesVisibility.both,
                          headerGridLinesVisibility: GridLinesVisibility.both,
                          selectionMode: SelectionMode.single,
                          navigationMode: GridNavigationMode.cell,
                          source: cur,
                          columnWidthMode: ColumnWidthMode.fill,
                          columns: [
                            GridColumn(
                              columnName: 'name',
                              label: Container(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                alignment: Alignment.center,
                                child: Text(
                                  '采集仪名称',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'sn',
                              label: Container(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                alignment: Alignment.center,
                                child: Text(
                                  '采集仪编号',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'type',
                              label: Container(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                alignment: Alignment.center,
                                child: Text(
                                  '采集仪类型',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'cycle',
                              label: Container(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                alignment: Alignment.center,
                                child: Text(
                                  '采集周期',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'port',
                              label: Container(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                alignment: Alignment.center,
                                child: Text(
                                  '采集端口',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'userId',
                              label: Container(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                alignment: Alignment.center,
                                child: Text(
                                  '用户id',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            GridColumn(
                              width: 200,
                              columnWidthMode: ColumnWidthMode.none,
                              columnName: 'operation',
                              label: Container(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
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
          }).toList()
        ],
      ),
    );
  }
}
