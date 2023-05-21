import 'package:bruno/bruno.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:huahuan_web/api/collector_api.dart';
import 'package:huahuan_web/api/event_api.dart';
import 'package:huahuan_web/api/project_api.dart';
import 'package:huahuan_web/api/sensor_api.dart';
import 'package:huahuan_web/constant/common_constant.dart';
import 'package:huahuan_web/model/admin/CollectorModel.dart';
import 'package:huahuan_web/model/admin/project_model.dart';
import 'package:huahuan_web/model/api/response_api.dart';
import 'package:huahuan_web/model/application/event_model.dart';
import 'package:huahuan_web/screen/item/date_model.dart';
import 'package:huahuan_web/screen/item/sensor_single/sensor_single.dart';
import 'package:huahuan_web/screen/manager/event/collector_list_view.dart';
import 'package:huahuan_web/util/store_util.dart';
import 'package:huahuan_web/widget/button/icon_button.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'DataRequest.dart';
import 'DateModel2.dart';
import 'delegate.dart';
import 'item_line.dart';

class ItemManager extends StatefulWidget {
  const ItemManager({
    Key? key,
  }) : super(key: key);

  // final int curProject;

  @override
  State<ItemManager> createState() => _ItemManagerState();
}

class _ItemManagerState extends State<ItemManager> {
  PageController pageController = PageController(initialPage: 0);
  int timestamp = 60;
  int selectedIndex = 0;
  var conditions = [
    "5分钟",
    "10分钟",
    "30分钟",
    "1小时",
    "2小时",
    "3小时",
    "6小时",
    "12小时",
    "1天"
  ];
  int direction = 0;
  int ceSelectedIndex = 0;
  var ceConditions = ['自上而下', '自下而上'];
  List<DateModel> ans = [];
  List<DateModel2> ceXies = [];
  List<CollectorModel> collectors = [];
  late EventModel controller;
  bool a = true;
  String endData = '2023-03-14 15:43:48';
  String statDate = '2023-03-14 09:43:48';

  @override
  void initState() {
    controller = context.read<EventModel>();
    init();
    super.initState();
  }

  ///导出excel文件
  void downLoad() {
    Excel outPutExcel = Excel.createExcel();
    Sheet sheetObject = outPutExcel['Sheet1'];
    sheetObject.cell(CellIndex.indexByString('A1')).value = '测点名';
    sheetObject.cell(CellIndex.indexByString('B1')).value = '本期数据';
    sheetObject.cell(CellIndex.indexByString('C1')).value = '参考数据';
    sheetObject.cell(CellIndex.indexByString('D1')).value = '本期变化';
    sheetObject.cell(CellIndex.indexByString('E1')).value = '累计变化';
    for (int i = 0; i < ans.length; i++) {
      DateModel date = ans[i];
      for (int j = 0; j < 5; j++) {
        dynamic val;
        switch (j) {
          case 0:
            val = date.name;
            break;
          case 1:
            val = date.curValue;
            break;
          case 2:
            val = date.refValue;
            break;
          case 3:
            val = date.curOffset;
            break;
          case 4:
            val = date.totalOffset;
            break;
        }
        sheetObject
            .cell(CellIndex.indexByColumnRow(columnIndex: j, rowIndex: i + 1))
            .value = val;
      }
    }

    sheetObject.updateCell(
        CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 1), 2);

    outPutExcel.save(fileName: '数据.xlsx');
  }

  void downLoadCeXie() {
    Excel outPutExcel = Excel.createExcel();
    Sheet sheetObject = outPutExcel['Sheet1'];
    sheetObject.cell(CellIndex.indexByString('A1')).value = '测点名	';
    sheetObject.cell(CellIndex.indexByString('B1')).value = '位置	';
    sheetObject.cell(CellIndex.indexByString('C1')).value = '本期管形X';
    sheetObject.cell(CellIndex.indexByString('D1')).value = '本期管形Y';
    sheetObject.cell(CellIndex.indexByString('E1')).value = '参考管形X';
    sheetObject.cell(CellIndex.indexByString('F1')).value = '参考管形Y';
    sheetObject.cell(CellIndex.indexByString('G1')).value = '本期变化X';
    sheetObject.cell(CellIndex.indexByString('H1')).value = '本期变化Y';

    for (int i = 0; i < ceXies.length; i++) {
      DateModel2 date = ceXies[i];
      for (int j = 0; j < 8; j++) {
        dynamic val;
        switch (j) {
          case 0:
            val = date.name;
            break;
          case 1:
            val = date.location;
            break;
          case 2:
            val = date.curShapeX;
            break;
          case 3:
            val = date.curShapeY;
            break;
          case 4:
            val = date.refShapeX;
            break;
          case 5:
            val = date.refShapeY;
            break;
          case 6:
            val = date.curShapeOffsetX;
            break;
          case 7:
            val = date.curShapeOffsetY;
            break;
        }
        sheetObject
            .cell(CellIndex.indexByColumnRow(columnIndex: j, rowIndex: i + 1))
            .value = val;
      }
    }

    sheetObject.updateCell(
        CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 1), 2);

    outPutExcel.save(fileName: '测斜数据.xlsx');
  }

  void init() async {
    if (controller.nowProject == null) {
      ResponseBodyApi responseBodyApi = await ProjectApi.findAllById(
          '{"id":${StoreUtil.getCurrentUserInfo().id}}');
      ResponseBodyApi res = await ProjectApi.getCurEvents({
        "id": List.from(responseBodyApi.data)
            .map((e) => ProjectModel.fromJson(e))
            .toList()[0]
            .id
      });
      controller.updateEventModel(
          nPs: List.from(responseBodyApi.data)
              .map((e) => ProjectModel.fromJson(e))
              .toList(),
          nP: List.from(responseBodyApi.data)
              .map((e) => ProjectModel.fromJson(e))
              .toList()[0],
          nEs:
              List.from(res.data).map((e) => ProjectModel.fromJson(e)).toList(),
          nE: List.from(res.data)
              .map((e) => ProjectModel.fromJson(e))
              .toList()[0]);
    } else if (controller.nowEvent == null) {
      ResponseBodyApi res =
          await ProjectApi.getCurEvents({"id": controller.nowProject?.id});
      controller.updateEventModel(
        nEs: List.from(res.data).map((e) => ProjectModel.fromJson(e)).toList(),
        nE: controller.nowEvents?[0],
      );
    }
    [4, 8, 9].contains(controller.nowEvent?.projectTypeId)
        ? getCurCeXie(DataRequest(
            id: controller.nowEvent?.id,
            type: controller.nowEvent?.projectTypeId,
            direction: direction,
            sampMinutes: timestamp,
          ))
        : getCurData(DataRequest(
            id: controller.nowEvent?.id,
            type: controller.nowEvent?.projectTypeId,
            direction: 0,
            sampMinutes: timestamp,
          ));
  }

  void getCurCeXie(DataRequest dataRequest) async {
    ResponseBodyApi responseBodyApi = await EventApi.getCeXie(
      dataRequest.toJson(),
    );
    ResponseBodyApi curCollectors =
        await CollectorApi.selectByProjectId({"id": controller.nowEvent?.id});
    collectors = List.from(curCollectors.data)
        .map((e) => CollectorModel.fromJson(e))
        .toList();
    if (responseBodyApi.code == 200) {
      ceXies = List.from(responseBodyApi.data)
          .map((e) => DateModel2.fromJson(e))
          .toList();
      a = false;
      setState(() {});
    }
  }

  void getCurData(DataRequest dataRequest) async {
    ResponseBodyApi responseBodyApi = await EventApi.getData(
      dataRequest.toJson(),
    );
    ResponseBodyApi curCollectors =
        await CollectorApi.selectByProjectId({"id": controller.nowEvent?.id});
    collectors = List.from(curCollectors.data)
        .map((e) => CollectorModel.fromJson(e))
        .toList();
    if (responseBodyApi.code == 200) {
      ans = List.from(responseBodyApi.data)
          .map((e) => DateModel.fromJson(e))
          .toList();
      a = false;
      setState(() {});
    }
  }

  ///点击进入传感器
  void getAllSensors(int? id) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: CollectorListView(
          // sensors: sensors,
          pid: id,
        ),
      ),
    ).then((v) {
      if (v != null) {
        // _query();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var controller = context.read<EventModel>();
    return a
        ? Container()
        : Scaffold(
            body: Flex(
              direction: Axis.vertical,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      BrnMultiDataPicker(
                        context: context,
                        title: '来源',
                        delegate: Brn1RowDelegate(controller.nowProjects ?? []),
                        confirmClick: (list) async {
                          BrnToast.show(list.toString(), context);
                          ResponseBodyApi res = await ProjectApi.getCurEvents(
                              {"id": controller.nowProjects?[list[0]].id});
                          controller.updateEventModel(
                            nP: controller.nowProjects?[list[0]],
                            nEs: List.from(res.data)
                                .map((e) => ProjectModel.fromJson(e))
                                .toList(),
                            nE: List.from(res.data)
                                .map((e) => ProjectModel.fromJson(e))
                                .toList()[0],
                          );
                          setState(() {});
                        },
                      ).show();
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: 40,
                        ),
                        Text(
                          controller.nowProject?.name ?? '-',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 9,
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Flex(
                          direction: Axis.vertical,
                          children: [
                            Expanded(
                              flex: 7,
                              child: ListView(
                                children: [
                                  ...?controller.nowEvents
                                      ?.map((e) => EventLineUnderItem(
                                            event: e,
                                            onClick: () {
                                              controller.updateEventModel(
                                                nE: e,
                                              );
                                              [4, 8, 9].contains(controller
                                                      .nowEvent?.projectTypeId)
                                                  ? getCurCeXie(DataRequest(
                                                      id: controller
                                                          .nowEvent?.id,
                                                      direction: direction,
                                                      sampMinutes: timestamp,
                                                      type: controller.nowEvent
                                                          ?.projectTypeId,
                                                    ))
                                                  : getCurData(DataRequest(
                                                      id: controller
                                                          .nowEvent?.id,
                                                      direction: direction,
                                                      sampMinutes: timestamp,
                                                      type: controller.nowEvent
                                                          ?.projectTypeId,
                                                    ));
                                              setState(() {});
                                            },
                                          ))
                                      .toList(),
                                ],
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                child: TextButton(
                                  onPressed: () {
                                    getAllSensors(controller.nowEvent?.id);
                                  },
                                  child: Text(
                                    '当前测项采集仪查看',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                      Spacer(),
                      Expanded(
                        flex: 8,
                        child: Flex(
                          direction: Axis.vertical,
                          children: [
                            Expanded(
                              child: StatefulBuilder(builder: (context, set) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      child: Container(
                                        height: 50,
                                        width: 150,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: const [
                                                Text(
                                                  '本期数据时间',
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                                Icon(
                                                  Icons.calendar_month,
                                                  size: 16,
                                                  color: Colors.blueAccent,
                                                ),
                                              ],
                                            ),
                                            Text(statDate),
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        BrnDatePicker.showDatePicker(context,
                                            maxDateTime: DateTime.parse(
                                                '2024-01-01 00:00:00'),
                                            minDateTime: DateTime.parse(
                                                '2019-01-01 00:00:00'),
                                            initialDateTime: DateTime.parse(
                                                '2023-03-14 15:43:48'),
                                            // 支持DateTimePickerMode.date、DateTimePickerMode.datetime、DateTimePickerMode.time
                                            pickerMode:
                                                BrnDateTimePickerMode.datetime,
                                            minuteDivider: 1,
                                            pickerTitleConfig:
                                                BrnPickerTitleConfig.Default,
                                            dateFormat:
                                                'yyyy年,MM月,dd日,HH时:mm分:ss秒',
                                            onConfirm: (dateTime, list) {
                                          set(
                                            () {
                                              statDate = dateTime
                                                  .toString()
                                                  .split('.')[0];
                                              BrnToast.show(
                                                  "onConfirm:  $dateTime ",
                                                  context);
                                            },
                                          );
                                        }, onClose: () {
                                          print("onClose");
                                        }, onCancel: () {
                                          print("onCancel");
                                        }, onChange: (dateTime, list) {
                                          print(
                                              "onChange:  $dateTime    $list");
                                        });
                                      },
                                    ),
                                    Container(
                                      width: 20,
                                    ),
                                    InkWell(
                                      child: Container(
                                        height: 50,
                                        width: 150,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: const [
                                                Text(
                                                  '参考数据时间',
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                                Icon(
                                                  Icons.calendar_month,
                                                  size: 16,
                                                  color: Colors.blueAccent,
                                                ),
                                              ],
                                            ),
                                            Text(endData),
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        BrnDatePicker.showDatePicker(context,
                                            maxDateTime: DateTime.parse(
                                                '2024-01-01 00:00:00'),
                                            minDateTime: DateTime.parse(
                                                '2019-01-01 00:00:00'),
                                            initialDateTime: DateTime.parse(
                                                '2023-03-14 09:43:48'),
                                            // 支持DateTimePickerMode.date、DateTimePickerMode.datetime、DateTimePickerMode.time
                                            pickerMode:
                                                BrnDateTimePickerMode.datetime,
                                            minuteDivider: 1,
                                            pickerTitleConfig:
                                                BrnPickerTitleConfig.Default,
                                            dateFormat: 'yyyy,MM,dd,HH:mm:ss',
                                            onConfirm: (dateTime, list) {
                                          set(() {
                                            endData = dateTime
                                                .toString()
                                                .split('.')[0];
                                            BrnToast.show(
                                                "onConfirm:  $dateTime",
                                                context);
                                          });
                                        }, onClose: () {
                                          print("onClose");
                                        }, onCancel: () {
                                          print("onCancel");
                                        }, onChange: (dateTime, list) {
                                          print(
                                              "onChange:  $dateTime    $list");
                                        });
                                      },
                                    ),
                                    Container(
                                      width: 20,
                                    ),
                                    //时间间隔选择
                                    InkWell(
                                      child: Row(
                                        children: [
                                          Text('时间间隔'),
                                          Icon(Icons.arrow_drop_down),
                                        ],
                                      ),
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (_) => StatefulBuilder(
                                                  builder: (context, state) {
                                                    return BrnSingleSelectDialog(
                                                        isClose: true,
                                                        title: '请选择测量间隔时间',
                                                        conditions: conditions,
                                                        checkedItem: conditions[
                                                            selectedIndex],
                                                        submitText: '提交',
                                                        isCustomFollowScroll:
                                                            true,
                                                        onItemClick:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          selectedIndex = index;
                                                          state(() {});
                                                        },
                                                        onSubmitClick: (data) {
                                                          timestamp = timeMap[
                                                                  selectedIndex] ??
                                                              60;
                                                          BrnToast.show(
                                                              data!, context);
                                                        });
                                                  },
                                                ));
                                      },
                                    ),
                                    Container(
                                      width: 20,
                                    ),
                                    //检测方向选择
                                    [4, 8, 9].contains(
                                            controller.nowEvent?.projectTypeId)
                                        ? InkWell(
                                            child: Row(
                                              children: [
                                                Text('测量方向'),
                                                Icon(Icons.arrow_drop_down),
                                              ],
                                            ),
                                            onTap: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (_) =>
                                                      StatefulBuilder(
                                                        builder:
                                                            (context, state) {
                                                          return BrnSingleSelectDialog(
                                                              isClose: true,
                                                              title: '请选择测量方向',
                                                              conditions:
                                                                  ceConditions,
                                                              checkedItem:
                                                                  ceConditions[
                                                                      ceSelectedIndex],
                                                              submitText: '提交',
                                                              isCustomFollowScroll:
                                                                  true,
                                                              onItemClick:
                                                                  (BuildContext
                                                                          context,
                                                                      int
                                                                          index) {
                                                                ceSelectedIndex =
                                                                    index;
                                                                state(() {});
                                                              },
                                                              onSubmitClick:
                                                                  (data) {
                                                                direction =
                                                                    ceSelectedIndex;
                                                                BrnToast.show(
                                                                    data!,
                                                                    context);
                                                              });
                                                        },
                                                      ));
                                            },
                                          )
                                        : Container(),
                                    Container(
                                      width: 20,
                                    ),
                                    ButtonWithIcon(
                                      iconData: Icons.search,
                                      onPressed: () {
                                        [4, 8, 9].contains(controller
                                                .nowEvent?.projectTypeId)
                                            ? getCurCeXie(DataRequest(
                                                id: controller.nowEvent?.id,
                                                direction: direction,
                                                sampMinutes: timestamp,
                                                type: controller
                                                    .nowEvent?.projectTypeId,
                                                statDate: statDate,
                                                endDate: endData))
                                            : getCurData(DataRequest(
                                                id: controller.nowEvent?.id,
                                                direction: direction,
                                                sampMinutes: timestamp,
                                                type: controller
                                                    .nowEvent?.projectTypeId,
                                                statDate: statDate,
                                                endDate: endData));
                                      },
                                    ),
                                  ],
                                );
                              }),
                            ),
                            Expanded(
                              flex: 7,
                              child: PageView(
                                controller: pageController,
                                children: [
                                  [
                                    4,
                                    8,
                                    9
                                  ].contains(controller.nowEvent?.projectTypeId)
                                      ? _buildCeXieCells()
                                      : _buildDataCells(),
                                  [
                                    4,
                                    8,
                                    9
                                  ].contains(controller.nowEvent?.projectTypeId)
                                      ? _buildCeXieChart()
                                      : _buildLineChart(),
                                ],
                              ),
                            ),
                            StatefulBuilder(builder: (context, set) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: pageController.page != 1
                                            ? Colors.lightBlue
                                            : Colors.white),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    child: GestureDetector(
                                      child: Text('数据表'),
                                      onTap: () {
                                        pageController.jumpToPage(0);
                                        set(() {});
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 80,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: pageController.page == 1
                                            ? Colors.lightBlue
                                            : Colors.white),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    child: GestureDetector(
                                      child: Text('数据图'),
                                      onTap: () {
                                        pageController.jumpToPage(1);
                                        set(() {});
                                      },
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  Widget _buildLineChart() {
    return Container(
        height: 300,
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
        child: SfCartesianChart(
            primaryXAxis: CategoryAxis(
              isVisible: true,
              //显示时间轴置顶
              opposedPosition: false,
              //时间轴反转
              isInversed: false,
            ),
            //标题
            title: ChartTitle(text: '折线图测试'),
            //选中类型
            selectionType: SelectionType.series,
            //时间轴与值轴换位
            isTransposed: false,
            //选中手势
            selectionGesture: ActivationMode.singleTap,
            //图示
            legend: Legend(
                isVisible: true,
                iconHeight: 10,
                iconWidth: 10,
                //切换系列显示
                toggleSeriesVisibility: true,
                //图示显示位置
                position: LegendPosition.bottom,
                overflowMode: LegendItemOverflowMode.wrap,
                //图示左右位置
                alignment: ChartAlignment.center),
            //十字架
            crosshairBehavior: CrosshairBehavior(
              lineType: CrosshairLineType.horizontal, //横向选择指示器
              enable: true,
              shouldAlwaysShow: false, //十字架始终显示(横向选择指示器)
              activationMode: ActivationMode.singleTap,
            ),
            //跟踪球
            trackballBehavior: TrackballBehavior(
              lineType: TrackballLineType.vertical,
              //纵向选择指示器
              activationMode: ActivationMode.singleTap,
              enable: true,
              tooltipAlignment: ChartAlignment.near,
              //工具提示位置(顶部)
              shouldAlwaysShow: true,
              //跟踪球始终显示(纵向选择指示器)
              tooltipDisplayMode:
                  TrackballDisplayMode.groupAllPoints, //工具提示模式(全部分组)
            ),
            //打开工具提示
            tooltipBehavior: TooltipBehavior(
              enable: true,
              shared: true,
              activationMode: ActivationMode.singleTap,
            ),
            //SplineSeries为曲线 LineSeries为折线ChartSeries
            series: <ChartSeries<DateModel, String>>[
              LineSeries<DateModel, String>(
                name: '当前测值',
                dataSource: ans,
                xValueMapper: (DateModel data, _) => data.name,
                yValueMapper: (DateModel data, _) => data.curValue,
                //显示数据标签
                dataLabelSettings: DataLabelSettings(
                  isVisible: false,
                  // alignment: ChartAlignment.near,
                  // labelAlignment: ChartDataLabelAlignment.outer,
                  // textStyle: ChartTextStyle(
                  //   fontSize: 14,
                  // ),
                ),
                //修饰数据点(显示圆圈)
                markerSettings: MarkerSettings(isVisible: true),
              ),
              LineSeries<DateModel, String>(
                name: '参考测值',
                dataSource: ans,
                xValueMapper: (DateModel data, _) => data.name,
                yValueMapper: (DateModel data, _) => data.refValue,
                //显示数据标签
                dataLabelSettings: DataLabelSettings(
                  isVisible: false,
                  // alignment: ChartAlignment.near,
                  // labelAlignment: ChartDataLabelAlignment.outer,
                  // textStyle: ChartTextStyle(
                  //   fontSize: 14,
                  // ),
                ),
                //修饰数据点(显示圆圈)
                markerSettings: MarkerSettings(isVisible: true),
              ),
              LineSeries<DateModel, String>(
                name: '本期变化',
                dataSource: ans,
                xValueMapper: (DateModel data, _) => data.name,
                yValueMapper: (DateModel data, _) => data.curOffset,
                //显示数据标签
                dataLabelSettings: DataLabelSettings(
                  isVisible: false,
                  // alignment: ChartAlignment.near,
                  // labelAlignment: ChartDataLabelAlignment.outer,
                  // textStyle: ChartTextStyle(
                  //   fontSize: 14,
                  // ),
                ),
                //修饰数据点(显示圆圈)
                markerSettings: MarkerSettings(isVisible: true),
              ),
              LineSeries<DateModel, String>(
                name: '累计变化',
                dataSource: ans,
                xValueMapper: (DateModel data, _) => data.name,
                yValueMapper: (DateModel data, _) => data.totalOffset,
                //显示数据标签
                dataLabelSettings: DataLabelSettings(
                  isVisible: false,
                  // alignment: ChartAlignment.near,
                  // labelAlignment: ChartDataLabelAlignment.outer,
                  // textStyle: ChartTextStyle(
                  //   fontSize: 14,
                  // ),
                ),
                //修饰数据点(显示圆圈)
                markerSettings: MarkerSettings(isVisible: true),
              ),
            ]));
  }

  Widget _buildDataCells() {
    return Flex(
      direction: Axis.horizontal,
      children: [
        Expanded(
          flex: 9,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blueAccent)),
                        child: const Center(
                          child: Text(
                            '测点名',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blueAccent)),
                        child: const Center(
                          child: Text(
                            '参考时间',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blueAccent)),
                        child: const Center(
                          child: Text(
                            '本期时间',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent)),
                      child: const Center(
                          child: Text(
                        '本期数据',
                        style: TextStyle(fontSize: 15),
                      )),
                    )),
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent)),
                      child: const Center(
                          child: Text(
                        '参考数据',
                        style: TextStyle(fontSize: 15),
                      )),
                    )),
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent)),
                      child: const Center(
                          child: Text(
                        '本期变化',
                        style: TextStyle(fontSize: 15),
                      )),
                    )),
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent)),
                      child: const Center(
                          child: Text(
                        '累计变化',
                        style: TextStyle(fontSize: 15),
                      )),
                    )),
                    const Spacer(),
                  ],
                ),
                if (ans.isEmpty)
                  Flex(direction: Axis.horizontal, children: [
                    Spacer(
                      flex: 2,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 200,
                        ),
                        Text(
                          '当前似乎没有数据哦～',
                          style: TextStyle(fontSize: 30),
                        ),
                        Text(
                          '请选择正确的监测时间～',
                          style: TextStyle(fontSize: 30),
                        ),
                      ],
                    ),
                    Spacer(
                      flex: 1,
                    ),
                  ]),
                ...ans
                    .map((e) => ItemLine(
                          dateModel: e,
                          onTap: (String sn) async {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => Dialog(
                                child: SensorSingle(
                                  curSensor: e,
                                ),
                              ),
                            ).then((v) {
                              if (v != null) {
                                setState(() {});
                              }
                            });
                            ResponseBodyApi response =
                                await SensorApi.historyCurve('{"sn":$sn}');
                            print(response.data);
                          },
                        ))
                    .toList(),
                BrnIconButton(
                  name: '下载报表',
                  iconWidget: Icon(Icons.download),
                  onTap: () {
                    downLoad();
                  },
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCeXieCells() {
    return Flex(
      direction: Axis.horizontal,
      children: [
        Expanded(
          flex: 9,
          child: ListView(
            children: [
              Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                      child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent)),
                    child: const Center(
                        child: Text(
                      '测点名',
                      style: TextStyle(fontSize: 10),
                    )),
                  )),
                  Expanded(
                      child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent)),
                    child: const Center(
                        child: Text(
                      '位置',
                      style: TextStyle(fontSize: 10),
                    )),
                  )),
                  Expanded(
                      child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent)),
                    child: const Center(
                        child: Text(
                      '本期管形X',
                      style: TextStyle(fontSize: 10),
                    )),
                  )),
                  Expanded(
                      child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent)),
                    child: const Center(
                        child: Text(
                      '本期管形Y',
                      style: TextStyle(fontSize: 10),
                    )),
                  )),
                  Expanded(
                      child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent)),
                    child: const Center(
                        child: Text(
                      '参考管形X',
                      style: TextStyle(fontSize: 10),
                    )),
                  )),
                  Expanded(
                      child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent)),
                    child: const Center(
                        child: Text(
                      '参考管形Y',
                      style: TextStyle(fontSize: 10),
                    )),
                  )),
                  Expanded(
                      child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent)),
                    child: const Center(
                        child: Text(
                      '本期变化X',
                      style: TextStyle(fontSize: 10),
                    )),
                  )),
                  Expanded(
                      child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent)),
                    child: const Center(
                        child: Text(
                      '本期变化Y',
                      style: TextStyle(fontSize: 10),
                    )),
                  )),
                  Expanded(
                      child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent)),
                    child: const Center(
                        child: Text(
                      '累计变化X',
                      style: TextStyle(fontSize: 10),
                    )),
                  )),
                  Expanded(
                      child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent)),
                    child: const Center(
                        child: Text(
                      '累计变化Y',
                      style: TextStyle(fontSize: 10),
                    )),
                  )),
                  const Spacer(),
                ],
              ),
              ...ceXies.map((e) => CeXieLine(dateModel: e)).toList(),
              BrnIconButton(
                name: '下载报表',
                iconWidget: Icon(Icons.download),
                onTap: () {
                  downLoadCeXie();
                },
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCeXieChart() {
    return Container(
        height: 300,
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
        child: SfCartesianChart(
            primaryXAxis: CategoryAxis(
                isVisible: true,
                //显示时间轴置顶
                opposedPosition: true,
                //时间轴反转
                isInversed: true,
                autoScrollingMode: AutoScrollingMode.start),
            //标题
            title: ChartTitle(text: '折线图测试'),
            //选中类型
            selectionType: SelectionType.series,
            //时间轴与值轴换位
            isTransposed: true,
            //选中手势
            selectionGesture: ActivationMode.singleTap,
            //图示
            legend: Legend(
                isVisible: true,
                iconHeight: 10,
                iconWidth: 10,
                //切换系列显示
                toggleSeriesVisibility: true,
                //图示显示位置
                position: LegendPosition.bottom,
                overflowMode: LegendItemOverflowMode.wrap,
                //图示左右位置
                alignment: ChartAlignment.center),
            //十字架
            crosshairBehavior: CrosshairBehavior(
              lineType: CrosshairLineType.horizontal, //横向选择指示器
              enable: true,
              shouldAlwaysShow: false, //十字架始终显示(横向选择指示器)
              activationMode: ActivationMode.singleTap,
            ),
            //跟踪球
            trackballBehavior: TrackballBehavior(
              lineType: TrackballLineType.vertical,
              //纵向选择指示器
              activationMode: ActivationMode.singleTap,
              enable: true,
              tooltipAlignment: ChartAlignment.near,
              //工具提示位置(顶部)
              shouldAlwaysShow: true,
              //跟踪球始终显示(纵向选择指示器)
              tooltipDisplayMode:
                  TrackballDisplayMode.groupAllPoints, //工具提示模式(全部分组)
            ),
            //打开工具提示
            tooltipBehavior: TooltipBehavior(
              enable: true,
              shared: true,
              activationMode: ActivationMode.singleTap,
            ),
            //SplineSeries为曲线 LineSeries为折线ChartSeries
            series: <LineSeries<DateModel2, num>>[
              LineSeries<DateModel2, num>(
                name: '本期管形X',
                dataSource: ceXies,
                yValueMapper: (DateModel2 data, num _) => data.curShapeX,
                xValueMapper: (DateModel2 data, num _) => data.location,
                //显示数据标签
                dataLabelSettings: DataLabelSettings(
                  isVisible: false,
                  // alignment: ChartAlignment.near,
                  // labelAlignment: ChartDataLabelAlignment.outer,
                  // textStyle: ChartTextStyle(
                  //   fontSize: 14,
                  // ),
                ),
                //修饰数据点(显示圆圈)
                markerSettings: MarkerSettings(isVisible: true),
              ),
              LineSeries<DateModel2, num>(
                name: '本期管形Y',
                dataSource: ceXies,
                yValueMapper: (DateModel2 data, num _) => data.curShapeY,
                xValueMapper: (DateModel2 data, num _) => data.location,
                //显示数据标签
                dataLabelSettings: DataLabelSettings(
                  isVisible: false,
                  // alignment: ChartAlignment.near,
                  // labelAlignment: ChartDataLabelAlignment.outer,
                  // textStyle: ChartTextStyle(
                  //   fontSize: 14,
                  // ),
                ),
                //修饰数据点(显示圆圈)
                markerSettings: MarkerSettings(isVisible: true),
              ),
              LineSeries<DateModel2, num>(
                name: '参考管形X',
                dataSource: ceXies,
                yValueMapper: (DateModel2 data, num _) => data.refShapeX,
                xValueMapper: (DateModel2 data, num _) => data.location,
                //显示数据标签
                dataLabelSettings: DataLabelSettings(
                  isVisible: false,
                  // alignment: ChartAlignment.near,
                  // labelAlignment: ChartDataLabelAlignment.outer,
                  // textStyle: ChartTextStyle(
                  //   fontSize: 14,
                  // ),
                ),
                //修饰数据点(显示圆圈)
                markerSettings: MarkerSettings(isVisible: true),
              ),
              LineSeries<DateModel2, num>(
                name: '参考管形Y',
                dataSource: ceXies,
                yValueMapper: (DateModel2 data, num _) => data.refShapeY,
                xValueMapper: (DateModel2 data, num _) => data.location,
                //显示数据标签
                dataLabelSettings: DataLabelSettings(
                  isVisible: false,
                  // alignment: ChartAlignment.near,
                  // labelAlignment: ChartDataLabelAlignment.outer,
                  // textStyle: ChartTextStyle(
                  //   fontSize: 14,
                  // ),
                ),
                //修饰数据点(显示圆圈)
                markerSettings: MarkerSettings(isVisible: true),
              ),
              LineSeries<DateModel2, num>(
                name: '本期变化X',
                dataSource: ceXies,
                yValueMapper: (DateModel2 data, num _) => data.curShapeOffsetX,
                xValueMapper: (DateModel2 data, num _) => data.location,
                //显示数据标签
                dataLabelSettings: DataLabelSettings(
                  isVisible: false,
                  // alignment: ChartAlignment.near,
                  // labelAlignment: ChartDataLabelAlignment.outer,
                  // textStyle: ChartTextStyle(
                  //   fontSize: 14,
                  // ),
                ),
                //修饰数据点(显示圆圈)
                markerSettings: MarkerSettings(isVisible: true),
              ),
              LineSeries<DateModel2, num>(
                name: '本期变化Y',
                dataSource: ceXies,
                yValueMapper: (DateModel2 data, num _) => data.curShapeOffsetY,
                xValueMapper: (DateModel2 data, num _) => data.location,
                //显示数据标签
                dataLabelSettings: DataLabelSettings(
                  isVisible: false,
                  // alignment: ChartAlignment.near,
                  // labelAlignment: ChartDataLabelAlignment.outer,
                  // textStyle: ChartTextStyle(
                  //   fontSize: 14,
                  // ),
                ),
                //修饰数据点(显示圆圈)
                markerSettings: MarkerSettings(isVisible: true),
              ),
              LineSeries<DateModel2, num>(
                name: '累计变化X',
                dataSource: ceXies,
                yValueMapper: (DateModel2 data, num _) => data.curValueX,
                xValueMapper: (DateModel2 data, num _) => data.location,
                //显示数据标签
                dataLabelSettings: DataLabelSettings(
                  isVisible: false,
                  // alignment: ChartAlignment.near,
                  // labelAlignment: ChartDataLabelAlignment.outer,
                  // textStyle: ChartTextStyle(
                  //   fontSize: 14,
                  // ),
                ),
                //修饰数据点(显示圆圈)
                markerSettings: MarkerSettings(isVisible: true),
              ),
              LineSeries<DateModel2, num>(
                name: '累计变化Y',
                dataSource: ceXies,
                yValueMapper: (DateModel2 data, num _) => data.curValueY,
                xValueMapper: (DateModel2 data, num _) => data.location,
                //显示数据标签
                dataLabelSettings: DataLabelSettings(
                  isVisible: false,
                  // alignment: ChartAlignment.near,
                  // labelAlignment: ChartDataLabelAlignment.outer,
                  // textStyle: ChartTextStyle(
                  //   fontSize: 14,
                  // ),
                ),
                //修饰数据点(显示圆圈)
                markerSettings: MarkerSettings(isVisible: true),
              ),
            ]));
  }
}

class EventLineUnderItem extends StatelessWidget {
  const EventLineUnderItem(
      {Key? key,
      required this.event,
      // required this.curProject,
      required this.onClick})
      : super(key: key);
  final ProjectModel event;

  // final int curProject;
  final Function onClick;

  @override
  Widget build(BuildContext context) {
    var controller = context.watch<EventModel>();
    return Container(
      margin: EdgeInsets.only(bottom: 20, left: 30),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          color: controller.nowEvent?.id == event.id
              ? Colors.lightBlueAccent
              : CommonConstant.backgroundColor),
      child: GestureDetector(
        onTap: () {
          onClick();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                event.name ?? '--',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Icon(Icons.arrow_right)
          ],
        ),
      ),
    );
  }
}
