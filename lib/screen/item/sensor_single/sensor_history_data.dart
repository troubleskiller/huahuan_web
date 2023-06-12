import 'package:flutter/material.dart';
import 'package:huahuan_web/api/collector_api.dart';
import 'package:huahuan_web/api/sensor_api.dart';
import 'package:huahuan_web/constant/common_constant.dart';
import 'package:huahuan_web/model/admin/CollectorDto.dart';
import 'package:huahuan_web/model/admin/CollectorModel.dart';
import 'package:huahuan_web/model/api/page_model.dart';
import 'package:huahuan_web/model/api/response_api.dart';
import 'package:huahuan_web/screen/item/sensor_single/sensorDto.dart';
import 'package:huahuan_web/widget/button/icon_button.dart';

class SensorHistoryData extends StatefulWidget {
  final String? sn;

  const SensorHistoryData({super.key, this.sn});

  @override
  State<SensorHistoryData> createState() => SensorHistoryDataState();
}

class SensorHistoryDataState extends State<SensorHistoryData> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ScrollController scrollController = ScrollController();
  ScrollController aController = ScrollController();
  int rowsPerPage = 10;
  String? sn;
  MyDS myDS = MyDS();
  CollectorModel formData = CollectorModel();

  _query() {
    myDS.page.currentPage = 0;
    myDS.page.pageSize = rowsPerPage;
    sn = widget.sn;
    myDS.loadData();
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
        // ButtonWithIcon(
        //     label: 'add', iconData: Icons.add, onPressed: () => _edit()),
      ],
    );

    Scrollbar table = Scrollbar(
      controller: scrollController,
      child: ListView(
        controller: scrollController,
        padding: const EdgeInsets.all(10.0),
        children: <Widget>[
          PaginatedDataTable(
            header: const Text('测点历史数据'),
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
                label: Text('传感器编号'),
              ),
              DataColumn(
                label: Text('通道'),
              ),
              DataColumn(
                label: Text('采集仪类型'),
              ),
              DataColumn(
                label: Text('采集时间'),
              ),
              DataColumn(
                label: Text('模拟量'),
              ),
              DataColumn(
                label: Text('温度'),
              ),
              DataColumn(
                label: Text('数据值'),
              ),

            ],
            source: myDS,
          ),
        ],
      ),
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
                child: SingleChildScrollView(
                  controller: aController,
                  scrollDirection: Axis.horizontal,
                  child: Container(height: 800, width: 1000, child: table),
                )),
          ),
        ],
      ),
    );
  }
}

class MyDS extends DataTableSource {
  MyDS();

  late SensorHistoryDataState state;
  late BuildContext context;
  late List<SensorDto> dataList;

  PageModel page = PageModel();

  sort(column, ascending) {
    loadData();
  }

  loadData() async {
    ResponseBodyApi sensorData = await SensorApi.historyCurve(
      {"sn": int.tryParse(state.sn ?? '', radix: 16)},
    );
    List<SensorDto> sensors =
        List.from(sensorData.data).map((e) => SensorDto.fromJson(e)).toList();
    if (sensors.length >= 200) {
      dataList = sensors.skip(sensors.length - 100).toList();
    } else {
      dataList = sensors;
    }
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
    SensorDto sensorDto = dataList[dataIndex];

    return DataRow.byIndex(
      index: index,
      cells: <DataCell>[
        DataCell(Text(sensorDto.sensorSn ?? '--')),
        DataCell(Text(sensorDto.channel ?? '--')),
        DataCell(Text(sensorMap[sensorDto.sensorType] ?? '--')),
        DataCell(Text(sensorDto.tested ?? '--')),
        DataCell(Text((sensorDto.ain ?? 0).toString())),
        DataCell(Text((sensorDto.temperature ?? 0).toString())),
        DataCell(Text((sensorDto.value ?? 0).toString())),
        // DataCell(ButtonBar(
        //   alignment: MainAxisAlignment.start,
        //   children: <Widget>[
        //     ButtonWithIcon(
        //       label: '查询历史数据',
        //       iconData: Icons.search,
        //       onPressed: () => getHistoryData(collectorModel.sn),
        //     ),
        //     ButtonWithIcon(
        //       label: '查询历史状态',
        //       iconData: Icons.search,
        //       onPressed: () => getHistoryStatus(collectorModel.sn),
        //     ),
        //   ],
        // )),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => page.sum ?? 0;

  @override
  int get selectedRowCount => 0;
}
