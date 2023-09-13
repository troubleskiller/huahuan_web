import 'package:flutter/material.dart';
import 'package:huahuan_web/api/project_api.dart';
import 'package:huahuan_web/model/admin/project_model.dart';
import 'package:huahuan_web/model/api/response_api.dart';
import 'package:huahuan_web/screen/event/event_manage/project_edit.dart';
import 'package:huahuan_web/screen/item/data_source/common_data.dart';
import 'package:huahuan_web/util/store_util.dart';
import 'package:huahuan_web/widget/button/buttons.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

late ProjectManagerListState _projectManagerListState;

class ProjectManagerList extends StatefulWidget {
  const ProjectManagerList({Key? key}) : super(key: key);

  @override
  State<ProjectManagerList> createState() {
    _projectManagerListState = ProjectManagerListState();
    return _projectManagerListState;
  }
}

class ProjectManagerListState extends State<ProjectManagerList> {
  List<ProjectModel> projects = [];

  Future getAllProjects() async {
    ResponseBodyApi responseBodyApi = await ProjectApi.findAllById(
        '{"id":${StoreUtil.getCurrentUserInfo().id}}');
    if (responseBodyApi.code == 200) {
      projects = List.from(responseBodyApi.data)
          .map((e) => ProjectModel.fromJson(e))
          .toList();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getAllProjects();
    super.initState();
  }

  void _editProject({
    ProjectModel? curProject,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: ProjectEdit(
          curProject: curProject,
        ),
      ),
    ).then((v) {
      if (v != null) {
        getAllProjects();
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Column(
        children: [
          Expanded(
            child: FutureBuilder(
                future: getAllProjects(),
                builder: (_, as) {
                  ProjectSource cur = ProjectSource(
                    commonData: projects,
                    context: context,
                    editProject: (ProjectModel ad) {
                      _editProject(curProject: ad);
                    },
                    getAllProjects: () {
                      getAllProjects();
                    },
                    state: _projectManagerListState,
                  );
                  return Container(
                    height: 1080,
                    child: SfDataGrid(
                      columnWidthCalculationRange:
                          ColumnWidthCalculationRange.visibleRows,
                      gridLinesVisibility: GridLinesVisibility.both,
                      headerGridLinesVisibility: GridLinesVisibility.both,
                      selectionMode: SelectionMode.single,
                      navigationMode: GridNavigationMode.cell,
                      source: cur,
                      columnWidthMode: ColumnWidthMode.fill,
                      columns: [
                        GridColumn(
                          columnName: 'name',
                          label: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            alignment: Alignment.center,
                            child: Text(
                              '项目名称',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        GridColumn(
                          columnWidthMode: ColumnWidthMode.none,
                          width: 80,
                          columnName: 'userId',
                          label: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            alignment: Alignment.center,
                            child: Text(
                              '用户id',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'location',
                          label: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            alignment: Alignment.center,
                            child: Text(
                              '经纬度',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'describe',
                          label: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            alignment: Alignment.center,
                            child: Text(
                              '描述',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'createTime',
                          label: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            alignment: Alignment.center,
                            child: Text(
                              '创建时间',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        GridColumn(
                          columnWidthMode: ColumnWidthMode.none,
                          width: 200,
                          columnName: 'operation',
                          label: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            alignment: Alignment.center,
                            child: Text(
                              '操作',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                  // return Table(
                  //     border:
                  //         TableBorder.all(width: 0.5, color: Colors.black),
                  //     children: [
                  //       TableRow(
                  //         children: [
                  //           Container(
                  //             padding: EdgeInsets.symmetric(
                  //                 horizontal: 15, vertical: 10),
                  //             child: Center(child: Text('项目名称')),
                  //           ),
                  //           Container(
                  //             padding: EdgeInsets.symmetric(
                  //                 horizontal: 15, vertical: 10),
                  //             child: Center(child: Text('用户id')),
                  //           ),
                  //           Container(
                  //             padding: EdgeInsets.symmetric(
                  //                 horizontal: 15, vertical: 10),
                  //             child: Center(child: Text('经纬度')),
                  //           ),
                  //           Container(
                  //             padding: EdgeInsets.symmetric(
                  //                 horizontal: 15, vertical: 10),
                  //             child: Center(child: Text('描述')),
                  //           ),
                  //           Container(
                  //             padding: EdgeInsets.symmetric(
                  //                 horizontal: 15, vertical: 10),
                  //             child: Center(child: Text('创建时间')),
                  //           ),
                  //           Container(
                  //             padding: EdgeInsets.symmetric(
                  //                 horizontal: 15, vertical: 10),
                  //             child: Center(child: Text('操作')),
                  //           )
                  //         ],
                  //       ),
                  //       ...projects
                  //           .map(
                  //             (e) => TableRow(
                  //               children: [
                  //                 Container(
                  //                     padding: EdgeInsets.symmetric(
                  //                         horizontal: 15, vertical: 10),
                  //                     child: Row(
                  //                       crossAxisAlignment:
                  //                           CrossAxisAlignment.center,
                  //                       children: [Text(e.name ?? '-')],
                  //                     )),
                  //                 Container(
                  //                     padding: EdgeInsets.symmetric(
                  //                         horizontal: 15, vertical: 10),
                  //                     child: Row(
                  //                       crossAxisAlignment:
                  //                           CrossAxisAlignment.center,
                  //                       children: [
                  //                         Text(e.userId.toString() ?? '-')
                  //                       ],
                  //                     )),
                  //                 Container(
                  //                     padding: EdgeInsets.symmetric(
                  //                         horizontal: 15, vertical: 10),
                  //                     child: Row(
                  //                       crossAxisAlignment:
                  //                           CrossAxisAlignment.center,
                  //                       children: [Text(e.location ?? '-')],
                  //                     )),
                  //                 Container(
                  //                     padding: EdgeInsets.symmetric(
                  //                         horizontal: 15, vertical: 10),
                  //                     child: Row(
                  //                       crossAxisAlignment:
                  //                           CrossAxisAlignment.center,
                  //                       children: [
                  //                         Text(e.description ?? '-')
                  //                       ],
                  //                     )),
                  //                 Container(
                  //                   padding: EdgeInsets.symmetric(
                  //                       horizontal: 15, vertical: 10),
                  //                   child: Center(
                  //                     child: Text(
                  //                       DateTime.tryParse(e.created ?? '-')
                  //                           .toString(),
                  //                     ),
                  //                   ),
                  //                 ),
                  //                 Container(
                  //                   padding: EdgeInsets.symmetric(
                  //                       horizontal: 15, vertical: 5),
                  //                   child: Row(
                  //                     mainAxisSize: MainAxisSize.min,
                  //                     children: [
                  //                       Expanded(
                  //                         child: ButtonWithIcons.edit(context,
                  //                             () {
                  //                           _editProject(curProject: e);
                  //                         }, showLabel: false),
                  //                       ),
                  //                       Expanded(
                  //                         child: ButtonWithIcons.delete(
                  //                             context, () {
                  //                           troConfirm(
                  //                               context, 'confirmDelete',
                  //                               (context) async {
                  //                             var result = await ProjectApi
                  //                                 .deleteProjectById(
                  //                                     '{"id": ${e.id}}');
                  //                             if (result.code == 200) {
                  //                               getAllProjects();
                  //                               TroUtils.message('success');
                  //                               setState(() {});
                  //                             }
                  //                           });
                  //                         }, showLabel: false),
                  //                       )
                  //                     ],
                  //                   ),
                  //                 )
                  //               ],
                  //             ),
                  //           )
                  //           .toList(),
                  //     ]);
                }),
          ),
          ButtonWithIcons.add(context, () {
            _editProject();
          }),
        ],
      ),
    );
  }
}
