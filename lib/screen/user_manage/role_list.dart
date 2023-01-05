// import 'package:flutter/material.dart';
// import 'package:huahuan_web/model/api/page_model.dart';
// import 'package:huahuan_web/model/api/request_api.dart';
// import 'package:huahuan_web/model/api/response_api.dart';
// import 'package:huahuan_web/util/data_table.dart';
// import 'package:huahuan_web/widget/button/icon_button.dart';
//
// class RoleList extends StatefulWidget {
//   const RoleList({Key? key}) : super(key: key);
//
//   @override
//   _RoleListState createState() => _RoleListState();
// }
//
// class _RoleListState extends State<RoleList> {
//   final GlobalKey<TroDataTableState> tableKey = GlobalKey<TroDataTableState>();
//   PageModel page = PageModel(orders: [OrderItemModel(column: 'name')]);
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((c) {
//       _query();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     TroDataTable table = TroDataTable(
//       key: tableKey,
//       onPageChanged: (firstRowIndex) {
//         page.currentPage = (firstRowIndex ~/ page.pageSize! + 1);
//         _query();
//       },
//       onRowsPerPageChanged: (int size) {
//         page.pageSize = size;
//         page.currentPage = 1;
//         _query();
//       },
//       onSelectChanged: (Map selected) {
//         this.setState(() {});
//       },
//       columns: [
//         DataColumn(
//           label: Container(
//             alignment: Alignment.center,
//             child: Text('operating'),
//             width: 240,
//           ),
//         ),
//         DataColumn(
//           label: Container(
//             child: Text('name'),
//             width: 800,
//           ),
//           onSort: (int columnIndex, bool ascending) => _sort('name', ascending),
//         ),
//       ],
//       getCells: (m) {
//         Role role = Role.fromMap(m);
//         return [
//           DataCell(
//             ButtonBar(
//               children: [
//                 ButtonWithIcon(
//                     iconData: Icons.edit,
//                     tip: 'modify',
//                     onPressed: () => _edit(role)),
//                 ButtonWithIcon(
//                     iconData: Icons.delete,
//                     tip: 'delete',
//                     onPressed: () => _delete([role])),
//                 ButtonWithIcon(
//                     iconData: Icons.person,
//                     tip: 'selectUsers',
//                     onPressed: () => _selectUser(role)),
//                 ButtonWithIcon(
//                     iconData: Icons.menu,
//                     tip: 'selectMenus',
//                     onPressed: () => _selectMenu(role)),
//               ],
//             ),
//           ),
//           DataCell(Text(role.name ?? '--')),
//         ];
//       },
//     );
//     List<Role> selectedList = tableKey.currentState
//             ?.getSelectedList(page)
//             .map<Role>((e) => Role.fromMap(e))
//             .toList() ??
//         [];
//     var buttonBar = ButtonBar(
//       alignment: MainAxisAlignment.start,
//       children: <Widget>[
//         ButtonWithIcon(
//           label: 'query',
//           iconData: Icons.search,
//           onPressed: () {
//             _query();
//           },
//         ),
//         ButtonWithIcon(
//           label: 'add',
//           iconData: Icons.add,
//           onPressed: () {
//             _edit(null);
//           },
//         ),
//         ButtonWithIcon(
//           label: 'delete',
//           iconData: Icons.delete,
//           onPressed: selectedList.length == 0
//               ? null
//               : () {
//                   _delete(selectedList);
//                 },
//         ),
//       ],
//     );
//     var result = Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           SizedBox(height: 10),
//           buttonBar,
//           Expanded(child: SingleChildScrollView(child: table)),
//         ],
//       ),
//     );
//     return result;
//   }
//
//   _selectMenu(Role role) {
//     Utils.fullscreenDialog(RoleSubsystemList(role: role));
//   }
//
//   _selectUser(Role role) {
//     Utils.fullscreenDialog(RoleUserSelect(role: role));
//   }
//
//   _edit(Role? role) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) => Dialog(
//         child: RoleEdit(
//           role: role,
//         ),
//       ),
//     ).then((v) {
//       if (v != null) {
//         _query();
//       }
//     });
//   }
//
//   _delete(List<Role> roleList) {
//     if (roleList.length == 0) {
//       return;
//     }
//     TroConfirm(context, S.of(context).confirmDelete, (context) async {
//       var result =
//           await RoleApi.removeByIds(roleList.map((e) => e.id).toList());
//       if (result.success) {
//         _query();
//         TroUtils.message(S.of(context).success);
//       }
//     });
//   }
//
//   _query() async {
//     RequestBodyApi requestBodyApi = RequestBodyApi();
//     requestBodyApi.page = page;
//     ResponseBodyApi responseBodyApi =
//         await RoleApi.page(requestBodyApi.toMap());
//     page = responseBodyApi.data != null
//         ? PageModel.fromJson(responseBodyApi.data)
//         : PageModel();
//     setState(() {
//       tableKey.currentState!.loadData(page);
//     });
//   }
//
//   _sort(column, ascending) {
//     page.orders![0].column = column;
//     page.orders![0].asc = !page.orders![0].asc!;
//     _query();
//   }
// }
