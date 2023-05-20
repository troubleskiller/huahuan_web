import 'package:flutter/material.dart';
import 'package:huahuan_web/api/customer_api.dart';
import 'package:huahuan_web/model/admin/Customer_model.dart';
import 'package:huahuan_web/model/api/page_model.dart';
import 'package:huahuan_web/model/api/response_api.dart';
import 'package:huahuan_web/screen/company_manager/company_edit.dart';
import 'package:huahuan_web/util/store_util.dart';
import 'package:huahuan_web/util/tro_util.dart';
import 'package:huahuan_web/widget/button/icon_button.dart';
import 'package:huahuan_web/widget/dialog/tro_dialog.dart';

///当前页面只有admin 和 manger 可以看到
///展示的是admin 或 manager 创建的自用户
class CompanyManager extends StatefulWidget {
  const CompanyManager({super.key});

  @override
  State<StatefulWidget> createState() {
    return CompanyManagerState();
  }
}

class CompanyManagerState extends State {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ScrollController scrollController = ScrollController();
  ScrollController aController = ScrollController();
  int rowsPerPage = 10;
  MyDS myDS = MyDS();
  CustomerModel formData = CustomerModel();

  _query() {
    myDS.page.currentPage = 0;
    myDS.page.pageSize = rowsPerPage;
    myDS.loadData();
  }

  //todo: 编辑页面
  _edit({CustomerModel? customerModel}) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: CompanyEdit(
          customerModel: customerModel,
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
          header: const Text('客户管理'),
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
              label: Text('客户名'),
            ),
            DataColumn(
              label: Text('客户地址'),
            ),
            DataColumn(
              label: Text('创建时间'),
            ),
            DataColumn(
              label: Text('联系电话'),
            ),
            DataColumn(
              label: Text('创建人'),
            ),
            DataColumn(
              label: Text('操作'),
            ),
          ],
          source: myDS,
        ),
      ],
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
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

  late CompanyManagerState state;
  late BuildContext context;
  late List<CustomerModel> dataList;

  // RequestBodyApi requestBodyApi = RequestBodyApi(data: CustomerModel(id: 1));

  PageModel page = PageModel();

  sort(column, ascending) {
    loadData();
  }

  loadData() async {
    ResponseBodyApi responseBodyApi =
        await CustomerApi.list({"id": StoreUtil.getCurrentUserInfo().id});
    List thisCus = List.from(responseBodyApi.data);
    page = PageModel(
      data: thisCus,
      sum: thisCus.length,
    );

    dataList = page.data!.map<CustomerModel>((v) {
      CustomerModel customerModel = CustomerModel.fromJson(v);
      return customerModel;
    }).toList();
    notifyListeners();
  }

  onPageChanged(firstRowIndex) {
    page.currentPage = firstRowIndex / page.pageSize + 1;
    loadData();
  }

  @override
  DataRow? getRow(int index) {
    var dataIndex = index;
    // var dataIndex = index - page.pageSize! * (page.currentPage!);

    if (dataIndex >= dataList.length) {
      return null;
    }
    CustomerModel customerModel = dataList[dataIndex];

    return DataRow.byIndex(
      index: index,
      cells: <DataCell>[
        //用户名
        DataCell(Text(customerModel.name ?? '--')),

        // //用户logo
        // DataCell(Text(customerModel.logo ?? '--')),
        // //用户电话
        // DataCell(Text(customerModel.image ?? '--')),
        //todo： 创建者
        // DataCell(Text(customerModel.creator ?? '--')),
        //用户所属客户
        DataCell(Text(customerModel.address ?? '--')),
        //创建时间
        ///创建时间：先读取毫秒级的时间，再通过拆字符串得到精确到秒的时间。
        DataCell(Text(customerModel.created?.split('.')[0] ?? '--')),
        DataCell(Text(customerModel.tel ?? '--')),
        DataCell(Text(customerModel.userId.toString() ?? '--')),
        // //用户权限等级 todo:add 权限
        DataCell(ButtonBar(
          alignment: MainAxisAlignment.start,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                state._edit(customerModel: customerModel);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                troConfirm(context, 'confirmDelete', (context) async {
                  var result = await CustomerApi.removeByIds(
                      '{"id": ${customerModel.id}}');
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
