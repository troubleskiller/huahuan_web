// import 'package:flutter/material.dart';
// import 'package:huahuan_web/api/user_api.dart';
// import 'package:huahuan_web/model/admin/user_info.dart';
// import 'package:huahuan_web/model/api/page_model.dart';
// import 'package:huahuan_web/model/api/request_api.dart';
// import 'package:huahuan_web/model/api/response_api.dart';
// import 'package:huahuan_web/screen/user_manage/user_edit.dart';
// import 'package:huahuan_web/util/tro_util.dart';
// import 'package:huahuan_web/widget/button/icon_button.dart';
// import 'package:huahuan_web/widget/dialog/tro_dialog.dart';
//
// class EventList extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return EventListState();
//   }
// }
//
// class EventListState extends State {
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();
//   ScrollController scrollController = ScrollController();
//   int rowsPerPage = 10;
//   MyDS myDS = MyDS();
//   EventModel formData = EventModel();
//
//
//   // _reset() {
//   //   // this.formData = UserInfo();
//   //   // formKey.currentState!.reset();
//   //   // myDS.page.data = formData.toJson();
//   //   myDS.loadData();
//   // }
//
//   _query() {
//     // formKey.currentState?.save();
//     // myDS.page.data = formData.toJson();
//     myDS.page.currentPage = 0;
//     myDS.page.pageSize = rowsPerPage;
//     myDS.loadData();
//   }
//
//   //todo: 编辑页面
//   _edit({UserInfo? userInfo}) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) => Dialog(
//         child: EventEdit(
//           userInfo: userInfo,
//         ),
//       ),
//     ).then((v) {
//       if (v != null) {
//         _query();
//       }
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     myDS.context = context;
//     myDS.state = this;
//     myDS.page.pageSize = rowsPerPage;
//     myDS.page.currentPage = 0;
//     myDS.addListener(() {
//       if (mounted) this.setState(() {});
//     });
//     WidgetsBinding.instance.addPostFrameCallback((c) {
//       _query();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var buttonBar = ButtonBar(
//       children: <Widget>[
//         // ButtonWithIcon(
//         //     label: 'query', iconData: Icons.search, onPressed: () => _query()),
//         ButtonWithIcon(
//             label: 'reset', iconData: Icons.refresh, onPressed: () => _query()),
//         ButtonWithIcon(
//             label: 'add', iconData: Icons.add, onPressed: () => _edit()),
//       ],
//     );
//
//     Scrollbar table = Scrollbar(
//       controller: scrollController,
//       child: ListView(
//         controller: scrollController,
//         padding: const EdgeInsets.all(10.0),
//         children: <Widget>[
//           PaginatedDataTable(
//             header: Text('用户管理'),
//             rowsPerPage: rowsPerPage,
//             onRowsPerPageChanged: (int? value) {
//               setState(() {
//                 if (value != null) {
//                   rowsPerPage = value;
//                   myDS.page.pageSize = rowsPerPage;
//                   myDS.loadData();
//                 }
//               });
//             },
//             availableRowsPerPage: <int>[2, 5, 10, 20],
//             onPageChanged: myDS.onPageChanged,
//             columns: <DataColumn>[
//               DataColumn(
//                 label: Text('用户名'),
//                 // onSort: (int columnIndex, bool ascending) =>
//                 //     myDS.sort('name', ascending),
//               ),
//               DataColumn(
//                 label: Text('用户账号'),
//                 // onSort: (int columnIndex, bool ascending) =>
//                 //     myDS.sort('id', ascending),
//               ),
//               DataColumn(
//                 label: Text('用户电话'),
//                 // onSort: (int columnIndex, bool ascending) =>
//                 //     myDS.sort('tel', ascending),
//               ),
//               DataColumn(
//                 label: Text('用户所属客户'),
//                 // onSort: (int columnIndex, bool ascending) =>
//                 //     myDS.sort('customerId', ascending),
//               ),
//               // DataColumn(
//               //   label: Text('用户权限等级'),
//               //   // onSort: (int columnIndex, bool ascending) =>
//               //   //     myDS.sort('create_time', ascending),
//               // ),
//               DataColumn(
//                 label: Text('操作'),
//               ),
//             ],
//             source: myDS,
//           ),
//         ],
//       ),
//     );
//     return Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           SizedBox(height: 10),
//           // form,
//           buttonBar,
//           Expanded(
//             child: table,
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class MyDS extends DataTableSource {
//   MyDS();
//
//   late EventListState state;
//   late BuildContext context;
//   late List<UserInfo> dataList;
//   RequestBodyApi requestBodyApi = RequestBodyApi(data: UserInfo(id: 1));
//
//   // int selectedCount = 0;
//   PageModel page = PageModel();
//
//   sort(column, ascending) {
//     loadData();
//   }
//
//   loadData() async {
//     requestBodyApi.pageVO = page;
//     ResponseBodyApi responseBodyApi =
//     await EventApi.findByCreatedId(requestBodyApi);
//     page = PageModel.fromJson(responseBodyApi.data);
//
//     dataList = page.data!.map<UserInfo>((v) {
//       UserInfo userInfo = UserInfo.fromJson(v);
//       // userInfo.selected = false;
//       return userInfo;
//     }).toList();
//     // selectedCount = 0;
//     notifyListeners();
//   }
//
//   onPageChanged(firstRowIndex) {
//     page.currentPage = firstRowIndex / page.pageSize + 1;
//     loadData();
//   }
//
//   @override
//   DataRow? getRow(int index) {
//     var dataIndex = index;
//     // var dataIndex = index - page.pageSize! * (page.currentPage!);
//
//     if (dataIndex >= dataList.length) {
//       return null;
//     }
//     UserInfo userInfo = dataList[dataIndex];
//
//     return DataRow.byIndex(
//       index: index,
//       // selected: userInfo.selected!,
//       // onSelectChanged: (bool? value) {
//       //   userInfo.selected = value;
//       //   selectedCount += value! ? 1 : -1;
//       //   notifyListeners();
//       // },
//       cells: <DataCell>[
//         //用户名
//         DataCell(Text(userInfo.name ?? '--')),
//
//         //用户账号
//         DataCell(Text(userInfo.loginName ?? '--')),
//         //用户电话
//         DataCell(Text(userInfo.tel ?? '--')),
//         //用户所属客户
//         DataCell(Text(userInfo.customerModel?.name.toString() ?? '--')),
//         // //用户权限等级 todo:add 权限
//         // DataCell(Text(userInfo.creatorId.toString())),
//         DataCell(ButtonBar(
//           alignment: MainAxisAlignment.start,
//           children: <Widget>[
//             IconButton(
//               icon: Icon(Icons.edit),
//               onPressed: () {
//                 state._edit(userInfo: userInfo);
//               },
//             ),
//             IconButton(
//               icon: Icon(Icons.delete),
//               onPressed: () {
//                 troConfirm(context, 'confirmDelete', (context) async {
//                   var result =
//                   await EventApi.deleteEventById('{"id": ${userInfo.id}}');
//                   if (result.code == 200) {
//                     loadData();
//                     TroUtils.message('success');
//                   }
//                 });
//               },
//             ),
//           ],
//         )),
//       ],
//     );
//   }
//
//   @override
//   bool get isRowCountApproximate => false;
//
//   @override
//   int get rowCount => page.sum ?? 0;
//
//   @override
//   int get selectedRowCount => 0;
//
// // @override
// // int get selectedRowCount => selectedCount;
// }
