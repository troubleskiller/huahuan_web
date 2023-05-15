import 'dart:math';

import 'package:flutter/material.dart';
import 'package:huahuan_web/api/project_api.dart';
import 'package:huahuan_web/model/admin/project_model.dart';
import 'package:huahuan_web/model/api/response_api.dart';
import 'package:huahuan_web/util/store_util.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SystemScreen extends StatefulWidget {
  const SystemScreen({Key? key}) : super(key: key);

  @override
  State<SystemScreen> createState() => _SystemScreenState();
}

class _SystemScreenState extends State<SystemScreen> {
  List<ChartData> pojCharts = [];
  bool loadData = true;
  @override
  void initState() {
    super.initState();
    getEvents();
  }

  void getEvents() async {
    List<ProjectModel> pojAns = [];
    ResponseBodyApi resProjects = await ProjectApi.findAllById(
        '{"id":${StoreUtil.getCurrentUserInfo().id}}');
    List<ProjectModel> projects = List.from(resProjects.data)
        .map((e) => ProjectModel.fromJson(e))
        .toList();
    for (ProjectModel project in projects) {
      ResponseBodyApi tmpEvents =
          await ProjectApi.getCurEvents('{"id":${project.id}}');
      List<ProjectModel> tmp = List.from(tmpEvents.data)
          .map((e) => ProjectModel.fromJson(e))
          .toList();
      pojAns.addAll(tmp);
    }
    pojCharts = getCurCharts(pojAns);
    setState(() {
      loadData = false;
    });
  }

  List<ChartData> getCurCharts(List<ProjectModel> pojAns) {
    print(pojAns);
    pojAns.map((e) {
      if (pojCharts
          .where((element) => element.index == e.projectTypeId)
          .toList()
          .isNotEmpty) {
        pojCharts.firstWhere((element) => element.index == e.projectTypeId).y++;
      } else {
        pojCharts.add(ChartData(
            index: e.projectTypeId,
            y: 1,
            color: getRandomColor(e.projectTypeId ?? 0)));
      }
    });
    print(pojCharts);
    return pojCharts;
  }

  Color getRandomColor(int index) {
    final random = Random(index);
    final r = random.nextInt(256);
    final g = random.nextInt(256);
    final b = random.nextInt(256);
    return Color.fromRGBO(r, g, b, 1);
  }

  @override
  Widget build(BuildContext context) {
    return loadData
        ? Container()
        : Scaffold(
            body: Flex(
              direction: Axis.vertical,
              children: [
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    ///构造测项统计

                    _buildItemSta(),

                    ///构造数据统计

                    _buildDataSta(),

                    ///构造预警模块
                    _buildWarning(),
                  ],
                ),
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    ///构造月项目统计
                    _buildMonthSta(),

                    ///构造年项目统计
                    _buildYearSta(),

                    ///构造传感器统计
                    _buildSensorSta(),
                  ],
                ),
              ],
            ),
          );
  }

  Widget _buildItemSta() {
    return Container(
        child: SfCircularChart(
      title: ChartTitle(text: 'Sales by region'),
      legend: Legend(isVisible: true),
      series: <CircularSeries>[
        PieSeries<ChartData, String>(
          dataSource: pojCharts,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y,
          dataLabelSettings: DataLabelSettings(isVisible: true),
          pointColorMapper: (ChartData data, _) => data.color,
          explode: true,
          explodeIndex: 0,
          explodeOffset: '10%',
        ),
      ],
    ));
  }

  Widget _buildDataSta() {
    return Container();
  }

  Widget _buildWarning() {
    return Container();
  }

  Widget _buildMonthSta() {
    return Container();
  }

  Widget _buildYearSta() {
    return Container();
  }

  Widget _buildSensorSta() {
    return Container();
  }
}

class ChartData {
  String? x;
  int? index;
  double y;
  Color? color;

  ChartData({this.x, this.y = 0, this.color, this.index});
}
