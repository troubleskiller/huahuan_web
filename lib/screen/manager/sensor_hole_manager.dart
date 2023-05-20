import 'package:flutter/material.dart';
import 'package:huahuan_web/api/sensor_api.dart';
import 'package:huahuan_web/constant/common_constant.dart';
import 'package:huahuan_web/model/admin/SensorHoleModel.dart';
import 'package:huahuan_web/model/api/page_model.dart';
import 'package:huahuan_web/model/api/response_api.dart';
import 'package:huahuan_web/screen/manager/sensor_hole_edit.dart';
import 'package:huahuan_web/widget/button/icon_button.dart';

import '../../util/tro_util.dart';
import '../../widget/dialog/tro_dialog.dart';

class SensorHoleManager extends StatefulWidget {
  final int? pid;

  const SensorHoleManager({super.key, this.pid});

  @override
  State<SensorHoleManager> createState() => SensorHoleManagerState();
}

class SensorHoleManagerState extends State<SensorHoleManager> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ScrollController scrollController = ScrollController();
  ScrollController aController = ScrollController();
  int rowsPerPage = 10;
  int? pid;
  MyDS myDS = MyDS();

  _query() {
    myDS.page.currentPage = 0;
    myDS.page.pageSize = rowsPerPage;
    pid = widget.pid;
    myDS.loadData();
  }

  //todo: 编辑页面
  _edit({SensorHoleModel? sensorModel}) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: SensorHoleEdit(
          sensorData: sensorModel,
          refSensors: myDS.dataList
              .map((e) => RefSensor(name: e.name, id: e.id))
              .toList(),
          projectId: widget.pid,
        ),
      ),
    ).then((v) {
      if (v != null) {
        _query();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    myDS.context = context;
    myDS.state = this;
    myDS.page.pageSize = rowsPerPage;
    myDS.page.currentPage = 0;
    myDS.addListener(() {
      if (mounted) setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((c) {
      _query();
    });
  }

  @override
  Widget build(BuildContext context) {
    var buttonBar = ButtonBar(
      alignment: MainAxisAlignment.start,
      children: <Widget>[
        ButtonWithIcon(
          label: '返回',
          iconData: Icons.arrow_back,
          onPressed: () => Navigator.pop(context),
        ),
        ButtonWithIcon(
            label: '刷新', iconData: Icons.refresh, onPressed: () => _query()),
        ButtonWithIcon(
            label: '添加', iconData: Icons.add, onPressed: () => _edit()),
      ],
    );

    ListView table = ListView(
      controller: scrollController,
      padding: const EdgeInsets.all(10.0),
      children: <Widget>[
        PaginatedDataTable(
          header: const Text('测点管理'),
          rowsPerPage: rowsPerPage,
          onRowsPerPageChanged: (int? value) {
            setState(() {
              if (value != null) {
                rowsPerPage = value;
                myDS.page.pageSize = rowsPerPage;
                myDS.loadData();
              }
            });
          },
          availableRowsPerPage: const <int>[2, 5, 10, 20],
          onPageChanged: myDS.onPageChanged,
          columns: const <DataColumn>[
            DataColumn(
              label: Text('测点名'),
            ),
            DataColumn(
              label: Text('位置'),
            ),
            DataColumn(
              label: Text('设备编号'),
            ),
            DataColumn(
              label: Text('设备类型'),
            ),
            DataColumn(
              label: Text('参考点'),
            ),
            DataColumn(
              label: Text('初始值'),
            ),
            DataColumn(
              label: Text('单位'),
            ),
            DataColumn(
              label: Text('创建时间'),
            ),
            DataColumn(
              label: Text('操作'),
            ),
          ],
          source: myDS,
        ),
      ],
    );
    return Container(
      color: Colors.white,
      width: 1000,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 20),
          buttonBar,
          Expanded(
            child: Scrollbar(
              controller: aController,
              child: CustomScrollView(
                scrollDirection: Axis.horizontal,
                controller: aController,
                slivers: [
                  SliverToBoxAdapter(
                    child: Container(height: 800, width: 1920, child: table),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyDS extends DataTableSource {
  MyDS();

  late SensorHoleManagerState state;
  late BuildContext context;
  late List<SensorHoleModel> dataList;

  PageModel page = PageModel();

  sort(column, ascending) {
    loadData();
  }

  loadData() async {
    ResponseBodyApi curSensors =
        await SensorApi.selectByProjectId({"id": state.pid});
    dataList = curSensors.data!.map<SensorHoleModel>((v) {
      SensorHoleModel sensorModel = SensorHoleModel.fromJson(v);
      return sensorModel;
    }).toList();
    page.sum = dataList.length;
    notifyListeners();
  }

  onPageChanged(firstRowIndex) {
    page.currentPage = firstRowIndex / page.pageSize + 1;
    loadData();
  }

  @override
  DataRow? getRow(int index) {
    var dataIndex = index;

    if (dataIndex >= dataList.length) {
      return null;
    }
    SensorHoleModel sensorModel = dataList[dataIndex];

    return DataRow.byIndex(
      index: index,
      cells: <DataCell>[
        //测点名
        DataCell(Text(sensorModel.name ?? '--')),
        //位置
        DataCell(Text(sensorModel.addr.toString() ?? '--')),

        //设备编号
        DataCell(Text(sensorModel.sn ?? '--')),
        //设备类型
        DataCell(Text(sensorMap[sensorModel.sensorTypeId] ?? '--')),
        //参考点
        DataCell(Text(dataList
                .singleWhere((element) => element.id == sensorModel.refSensorId,
                    orElse: () => SensorHoleModel(name: '--'))
                .name ??
            '--')),
        //初始值
        DataCell(Text(sensorModel.initValue.toString() ?? '--')),
        // DataCell(Text(userInfo.creator ?? '--')),
        //用户所属客户
        DataCell(Text(paramsEx[sensorModel.unitId] ?? '--')),
        //创建时间
        DataCell(Text(sensorModel.created.toString() ?? '--')),

        ///创建时间：先读取毫秒级的时间，再通过拆字符串得到精确到秒的时间。
        DataCell(ButtonBar(
          alignment: MainAxisAlignment.start,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                state._edit(sensorModel: sensorModel);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                troConfirm(context, 'confirmDelete', (context) async {
                  var result =
                      await SensorApi.delete('{"id": ${sensorModel.id}}');
                  if (result.code == 200) {
                    loadData();
                    TroUtils.message('success');
                  }
                });
              },
            ),
          ],
        )),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => page.sum ?? 0;

  @override
  int get selectedRowCount => 0;

// @override
// int get selectedRowCount => selectedCount;
}
