import 'package:flutter/material.dart';
import 'package:huahuan_web/api/collector_api.dart';
import 'package:huahuan_web/constant/common_constant.dart';
import 'package:huahuan_web/model/admin/CollectorModel.dart';
import 'package:huahuan_web/model/api/response_api.dart';
import 'package:huahuan_web/model/application/event_model.dart';
import 'package:huahuan_web/screen/item/collector_edit.dart';
import 'package:huahuan_web/screen/sensor_manager/sensorTest.dart';
import 'package:huahuan_web/util/tro_util.dart';
import 'package:huahuan_web/widget/dialog/tro_dialog.dart';
import 'package:provider/provider.dart';

class MainSensor extends StatefulWidget {
  const MainSensor({Key? key}) : super(key: key);

  @override
  State<MainSensor> createState() => _MainSensorState();
}

class _MainSensorState extends State<MainSensor> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
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
          border: Border.all(color: Colors.blue)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.sensorP.name ?? '-'),
          (widget.sensorP.collectors ?? []).isNotEmpty
              ? Table(
                  border: TableBorder.all(width: 0.5, color: Colors.black),
                  children: [
                      TableRow(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: Center(child: Text('采集仪名称')),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: Center(child: Text('采集仪编号')),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: Center(child: Text('采集仪类型')),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: Center(child: Text('采集周期')),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: Center(child: Text('采集端口')),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: Center(child: Text('用户id')),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: Center(child: Text('操作')),
                          )
                        ],
                      )
                    ])
              : Container(),
          Table(
            border: TableBorder.all(width: 0.5, color: Colors.black),
            children: [
              ...(widget.sensorP.collectors ?? []).map((e) =>
                  TableRow(children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Center(
                        child: Text(e.name ?? '--'),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Center(
                        child: Text(e.sn ?? '--'),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Center(
                        child: Text(collectorType[e.collectorTypeId] ?? '--'),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Center(
                        child: Text(e.cycle.toString() ?? '--'),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Center(
                        child: Text(e.port.toString() ?? '--'),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Center(
                        child: Text(e.userId ?? '--'),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Center(
                        child: ButtonBar(
                          alignment: MainAxisAlignment.start,
                          children: <Widget>[
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                _edit(sensorModel: e);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                troConfirm(context, 'confirmDelete',
                                    (context) async {
                                  var result = await CollectorApi.delete(
                                      '{"id": ${e.id}}');
                                  if (result.code == 200) {
                                    TroUtils.message('success');
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                  ])),
            ],
          ),
          GestureDetector(
            child: Container(
              child: Text('添加'),
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
              color: Colors.blue,
            ),
            onTap: () {
              _edit(
                  sensorModel: CollectorModel(
                projectId: widget.sensorP.id,
              ));
            },
          )
        ],
      ),
    );
  }

  _edit({CollectorModel? sensorModel}) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: CollectorEdit(
          collectorModel: sensorModel,
        ),
      ),
    ).then((v) {});
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
                troConfirm(context, 'confirmDelete', (context) async {
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
        ),
      ),
    ).then((v) {});
  }
}
