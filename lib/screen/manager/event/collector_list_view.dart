import 'package:flutter/material.dart';
import 'package:huahuan_web/api/collector_api.dart';
import 'package:huahuan_web/model/admin/CollectorModel.dart';
import 'package:huahuan_web/model/api/page_model.dart';
import 'package:huahuan_web/model/api/response_api.dart';
import 'package:huahuan_web/screen/sensor_manager/screen/collector_history_data.dart';
import 'package:huahuan_web/screen/sensor_manager/screen/collector_history_status.dart';
import 'package:huahuan_web/widget/button/icon_button.dart';

class CollectorListView extends StatefulWidget {
  final int? pid;

  const CollectorListView({super.key, this.pid});

  @override
  State<CollectorListView> createState() => CollectorListViewState();
}

class CollectorListViewState extends State<CollectorListView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ScrollController scrollController = ScrollController();
  ScrollController aController = ScrollController();
  int rowsPerPage = 10;
  int? pid;
  MyDS myDS = MyDS();
  CollectorModel formData = CollectorModel();

  _query() {
    myDS.page.currentPage = 0;
    myDS.page.pageSize = rowsPerPage;
    pid = widget.pid;
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
          label: '刷新',
          iconData: Icons.refresh,
          onPressed: () => _query(),
        ),
      ],
    );

    ListView table = ListView(
      controller: scrollController,
      padding: const EdgeInsets.all(10.0),
      children: <Widget>[
        PaginatedDataTable(
          header: const Text('采集仪查看'),
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
              label: Text('设备名称'),
            ),
            DataColumn(
              label: Text('设备编号'),
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
            DataColumn(
              label: Text('电量'),
            ),
            DataColumn(
              label: Text('状态'),
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
      width: 1200,
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
                  child: Container(height: 800, width: 1200, child: table),
                )),
          ),
        ],
      ),
    );
  }
}

class MyDS extends DataTableSource {
  MyDS();

  late CollectorListViewState state;
  late BuildContext context;
  late List<CollectorModel> dataList;

  PageModel page = PageModel();

  sort(column, ascending) {
    loadData();
  }

  loadData() async {
    ResponseBodyApi curCollectors =
        await CollectorApi.selectByProjectId({"id": state.pid});
    dataList = curCollectors.data!.map<CollectorModel>((v) {
      CollectorModel collectorModel = CollectorModel.fromJson(v);
      return collectorModel;
    }).toList();
    page.sum = dataList.length;
    notifyListeners();
  }

  onPageChanged(firstRowIndex) {
    page.currentPage = firstRowIndex / page.pageSize + 1;
    loadData();
  }

  getHistoryData(String? sn) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: CollectorHistoryData(
          sn: sn,
        ),
      ),
    ).then((v) {
      if (v != null) {
        loadData();
      }
    });
  }

  getHistoryStatus(String? sn) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: CollectorHistoryStatus(
          sn: sn,
        ),
      ),
    ).then((v) {
      if (v != null) {
        loadData();
      }
    });
  }

  @override
  DataRow? getRow(int index) {
    var dataIndex = index;

    if (dataIndex >= dataList.length) {
      return null;
    }
    CollectorModel collectorModel = dataList[dataIndex];

    return DataRow.byIndex(
      index: index,
      cells: <DataCell>[
        DataCell(Text(collectorModel.name ?? '--')),
        DataCell(Text(collectorModel.sn ?? '--')),
        DataCell(Text((collectorModel.csq ?? 0).toString())),
        DataCell(Text((collectorModel.gpsLat ?? 0).toString())),
        DataCell(Text((collectorModel.gpsLon ?? 0).toString())),
        DataCell(Text((collectorModel.bat ?? 0).toString())),
        //用户所属客户
        DataCell(Text(collectorModel.status == 0 ? '在线' : '离线')),
        DataCell(ButtonBar(
          alignment: MainAxisAlignment.start,
          children: <Widget>[
            ButtonWithIcon(
              label: '查询历史数据',
              iconData: Icons.search,
              onPressed: () => getHistoryData(collectorModel.sn),
            ),
            ButtonWithIcon(
              label: '查询历史状态',
              iconData: Icons.search,
              onPressed: () => getHistoryStatus(collectorModel.sn),
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
}
