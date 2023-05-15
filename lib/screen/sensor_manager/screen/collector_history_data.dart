import 'package:flutter/material.dart';
import 'package:huahuan_web/api/collector_api.dart';
import 'package:huahuan_web/model/admin/CollectorDto.dart';
import 'package:huahuan_web/model/admin/CollectorModel.dart';
import 'package:huahuan_web/model/api/page_model.dart';
import 'package:huahuan_web/model/api/response_api.dart';
import 'package:huahuan_web/widget/button/icon_button.dart';

class CollectorHistoryData extends StatefulWidget {
  final String? sn;

  const CollectorHistoryData({super.key, this.sn});

  @override
  State<CollectorHistoryData> createState() => CollectorHistoryDataState();
}

class CollectorHistoryDataState extends State<CollectorHistoryData> {
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
            header: const Text('传感器历史数据'),
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
                label: Text('仪器编号'),
              ),
              DataColumn(
                label: Text('ICCID'),
              ),
              DataColumn(
                label: Text('型号'),
              ),
              DataColumn(
                label: Text('采集时间'),
              ),
              DataColumn(
                label: Text('电量'),
              ),
              DataColumn(
                label: Text('信号'),
              ),
              DataColumn(
                label: Text('经度'),
              ),
              DataColumn(
                label: Text('纬度'),
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

  late CollectorHistoryDataState state;
  late BuildContext context;
  late List<CollectorDto> dataList;

  PageModel page = PageModel();

  sort(column, ascending) {
    loadData();
  }

  loadData() async {
    ResponseBodyApi collectorData = await CollectorApi.getData(
      {"sn": state.sn},
    );
    List<CollectorDto> collectors = List.from(collectorData.data)
        .map((e) => CollectorDto.fromJson(e))
        .toList();
    if (collectors.length >= 200) {
      dataList = collectors.skip(collectors.length - 100).toList();
    } else {
      dataList = collectors;
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
    CollectorDto collectorModel = dataList[dataIndex];

    return DataRow.byIndex(
      index: index,
      cells: <DataCell>[
        DataCell(Text(collectorModel.collectorSn ?? '--')),
        DataCell(Text(collectorModel.iccid ?? '--')),
        DataCell(Text(collectorModel.model ?? '--')),
        DataCell(Text(collectorModel.created ?? '--')),
        DataCell(Text((collectorModel.csq ?? 0).toString())),
        DataCell(Text((collectorModel.bat ?? 0).toString())),
        DataCell(Text((collectorModel.gpsLat ?? 0).toString())),
        DataCell(Text((collectorModel.gpsLon ?? 0).toString())),
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
