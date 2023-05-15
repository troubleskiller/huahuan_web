import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:huahuan_web/api/user_api.dart';
import 'package:huahuan_web/model/admin/user_info.dart';
import 'package:huahuan_web/model/api/page_model.dart';
import 'package:huahuan_web/model/api/request_api.dart';
import 'package:huahuan_web/model/api/response_api.dart';
import 'package:huahuan_web/screen/user_manage/role_edit_in_user_list.dart';
import 'package:huahuan_web/screen/user_manage/user_edit.dart';
import 'package:huahuan_web/util/tro_util.dart';
import 'package:huahuan_web/widget/button/icon_button.dart';
import 'package:huahuan_web/widget/dialog/tro_dialog.dart';

///当前页面只有admin 和 manger 可以看到
///展示的是admin 或 manager 创建的自用户
class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  State<StatefulWidget> createState() {
    return UserListState();
  }
}

class UserListState extends State {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ScrollController scrollController = ScrollController();
  ScrollController aController = ScrollController();
  int rowsPerPage = 10;
  MyDS myDS = MyDS();
  UserInfo formData = UserInfo();

  _query() {
    myDS.page.currentPage = 0;
    myDS.page.pageSize = 9990;
    myDS.loadData();
  }

  _roles({UserInfo? userInfo}) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: RoleEditInUserScreen(
          userInfo: userInfo,
        ),
      ),
    ).then((v) {
      if (v != null) {
        _query();
      }
    });
  }

  //todo: 编辑页面
  _edit({UserInfo? userInfo}) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: UserEdit(
          userInfo: userInfo,
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
            label: '刷新', iconData: Icons.refresh, onPressed: () => _query()),
        ButtonWithIcon(
            label: '添加', iconData: Icons.add, onPressed: () => _edit()),
      ],
    );

    Scrollbar table = Scrollbar(
      controller: scrollController,
      child: ListView(
        controller: scrollController,
        padding: const EdgeInsets.all(10.0),
        children: <Widget>[
          PaginatedDataTable(
            header: const Text('用户管理'),
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
                label: Text('用户名'),
              ),
              DataColumn(
                label: Text('用户账号'),
              ),
              DataColumn(
                label: Text('用户电话'),
              ),
              DataColumn(
                label: Text('用户所属客户'),
              ),
              DataColumn(
                label: Text('用户创建时间'),
              ),
              DataColumn(
                label: Text('用户是否启用'),
              ),
              DataColumn(
                label: Text('用户角色'),
              ),
              DataColumn(
                label: Text('操作'),
              ),
            ],
            source: myDS,
          ),
        ],
      ),
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
                child: SingleChildScrollView(
                  controller: aController,
                  scrollDirection: Axis.horizontal,
                  child: Container(height: 800, width: 1920, child: table),
                )),
          ),
        ],
      ),
    );
  }
}

class MyDS extends DataTableSource {
  MyDS();

  late UserListState state;
  late BuildContext context;
  late List<UserInfo> dataList;
  RequestBodyApi requestBodyApi = RequestBodyApi(data: UserInfo(id: 1));

  PageModel page = PageModel();

  sort(column, ascending) {
    loadData();
  }

  loadData() async {
    requestBodyApi.pageVO = page;
    ResponseBodyApi responseBodyApi =
        await UserApi.findByCreatedId(requestBodyApi);
    page = PageModel.fromJson(responseBodyApi.data);
    page.pageSize = page.sum;

    dataList = page.data!.map<UserInfo>((v) {
      UserInfo userInfo = UserInfo.fromJson(v);
      return userInfo;
    }).toList();
    notifyListeners();
  }

  onPageChanged(firstRowIndex) {
    page.currentPage = (firstRowIndex / page.pageSize + 1).toInt();
    loadData();
  }

  @override
  DataRow? getRow(int index) {
    var dataIndex = index;
    // var dataIndex = index - page.pageSize! * (page.currentPage!);

    if (dataIndex >= dataList.length) {
      return null;
    }
    UserInfo userInfo = dataList[dataIndex];

    return DataRow.byIndex(
      index: index,
      cells: <DataCell>[
        //用户名
        DataCell(Text(userInfo.name ?? '--')),

        //用户账号
        DataCell(Text(userInfo.loginName ?? '--')),
        //用户电话
        DataCell(Text(userInfo.tel ?? '--')),
        //用户所属客户
        DataCell(Text(userInfo.customerModel?.name.toString() ?? '--')),
        //创建时间
        ///创建时间：先读取毫秒级的时间，再通过拆字符串得到精确到秒的时间。
        DataCell(Text(
            DateTime.parse(userInfo.created ?? '').toString().split('.')[0])),
        //是否启用，状态
        DataCell(
          BrnSwitchButton(
              value: userInfo.isEnable == 1,
              onChanged: (value) {
                userInfo.isEnable = value ? 1 : 0;
                notifyListeners();
                //todo: 设置更改用户启用状态api
              }),
        ),
        // //用户权限等级 todo:add 权限
        DataCell(
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              state._roles(userInfo: userInfo);
            },
          ),
        ),
        DataCell(ButtonBar(
          alignment: MainAxisAlignment.start,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                state._edit(userInfo: userInfo);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                troConfirm(context, 'confirmDelete', (context) async {
                  var result =
                      await UserApi.deleteUser('{"id": ${userInfo.id}}');
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
}
