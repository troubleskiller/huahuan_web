import 'package:flutter/material.dart';
import 'package:huahuan_web/api/collector_api.dart';
import 'package:huahuan_web/constant/common_constant.dart';
import 'package:huahuan_web/model/admin/CollectorModel.dart';
import 'package:huahuan_web/model/api/response_api.dart';
import 'package:huahuan_web/model/application/event_model.dart';
import 'package:huahuan_web/screen/item/collector_edit.dart';
import 'package:huahuan_web/screen/item/data_source/common_data.dart';
import 'package:huahuan_web/screen/sensor_manager/sensorTest.dart';
import 'package:huahuan_web/util/tro_util.dart';
import 'package:huahuan_web/widget/dialog/tro_dialog.dart';
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

  List<SensorTest> projects = [];

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
        .map((e) => SensorTest.fromJson(e))
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
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: init(),
              builder: (_, s) => ListView(
                children: projects
                    .map(
                      (e) => SensorContent(
                        sensorTest: e,
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          GestureDetector(
            child: Container(
              child: Text('添加'),
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 20,
              ),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1)),
            ),
            onTap: () {
              _edit();
            },
          )
        ],
      ),
    );
  }
// Widget _buildProjectList
}

class SensorContent extends StatelessWidget {
  final SensorTest sensorTest;

  const SensorContent({Key? key, required this.sensorTest}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      margin: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(sensorTest.name ?? '-'),
          ...(sensorTest.list ?? [])
              .map((e) => SensorData(
                    sensorP: e,
                  ))
              .toList()
        ],
      ),
    );
  }
}

class SensorData extends StatefulWidget {
  final SensorP sensorP;

  const SensorData({Key? key, required this.sensorP}) : super(key: key);

  @override
  State<SensorData> createState() => _SensorDataState();
}

class _SensorDataState extends State<SensorData> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      margin: EdgeInsets.symmetric(vertical: 20),
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.sensorP.name ?? '-'),
              GestureDetector(
                child: Container(
                  child: Text('添加'),
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1)),
                ),
                onTap: () {
                  _edit(
                      isUpdate: false,
                      sensorModel: CollectorModel(
                        projectId: widget.sensorP.id,
                      ));
                },
              )
            ],
          ),
          (widget.sensorP.collectors ?? []).isNotEmpty
              ? Builder(builder: (context) {
                  CollectorSource cur = CollectorSource(
                    commonData: widget.sensorP.collectors ?? [],
                    context: context,
                    edit: (CollectorModel? sensorModel) {
                      _edit(sensorModel: sensorModel, isUpdate: true);
                    },
                  );
                  return Container(
                    height: ((widget.sensorP.collectors ?? []).length + 1) * 60,
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
                  );
                })
              : Container(),
        ],
      ),
    );
  }

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
}

class SensorLine extends StatefulWidget {
  final CollectorModel data;

  const SensorLine({Key? key, required this.data}) : super(key: key);

  @override
  State<SensorLine> createState() => _SensorLineState();
}

class _SensorLineState extends State<SensorLine> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(widget.data.name ?? '--'),

        Text(widget.data.sn ?? '--'),

        Text(sensorMap[widget.data.collectorTypeId] ?? '--'),
        Text(widget.data.downString ?? '--'),
        Text(widget.data.cycle.toString() ?? '--'),
        Text(widget.data.userId ?? '--'),

        Text(widget.data.port.toString() ?? '--'),

        //读取毫秒级的时间，再通过拆字符串得到精确到秒的时间。
        ButtonBar(
          alignment: MainAxisAlignment.start,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                _edit(sensorModel: widget.data);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                troConfirm(context, '确认删除', (context) async {
                  var result =
                      await CollectorApi.delete('{"id": ${widget.data.id}}');
                  if (result.code == 200) {
                    TroUtils.message('success');
                  }
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  _edit({CollectorModel? sensorModel}) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: CollectorEdit(
          collectorModel: sensorModel,
          isUpdate: true,
        ),
      ),
    ).then((v) {});
  }
}
