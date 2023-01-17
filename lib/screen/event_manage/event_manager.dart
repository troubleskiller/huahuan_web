import 'package:flutter/material.dart';
import 'package:huahuan_web/api/project_api.dart';
import 'package:huahuan_web/constant/common_constant.dart';
import 'package:huahuan_web/model/admin/project_model.dart';
import 'package:huahuan_web/model/admin/user_info.dart';
import 'package:huahuan_web/model/api/response_api.dart';
import 'package:huahuan_web/screen/event_manage/event_list.dart';
import 'package:flutter_2d_amap/flutter_2d_amap.dart';
import 'package:huahuan_web/util/store_util.dart';
import 'package:huahuan_web/widget/input/TroInput.dart';

class ProjectManager extends StatefulWidget {
  const ProjectManager({Key? key}) : super(key: key);

  @override
  State<ProjectManager> createState() => _ProjectManagerState();
}

class _ProjectManagerState extends State<ProjectManager> {
  bool loadData = true;
  List<ProjectModel> projects = [];
  late ProjectModel curProject;

  AMap2DController? _aMap2DController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllProjects();
  }

  ///得到现有的所有项目
  void getAllProjects() async {
    ///todo: 用当前用户的id
    UserInfo curUser = StoreUtil.getCurrentUserInfo();
    ResponseBodyApi responseBodyApi = ResponseBodyApi();
    responseBodyApi = await ProjectApi.findAllById({"id": 2});
    projects = List.from(responseBodyApi.data)
        .map((e) => ProjectModel.fromJson(e))
        .toList();

    ///默认访问第一个
    curProject = projects[0];
    // getCurProject(projects[0]);
    setState(() {
      loadData = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loadData
        ? Container()
        : Scaffold(
            backgroundColor: Colors.white,
            body: Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Text(
                          '- 项目名称',
                          style: TextStyle(fontSize: 30, color: Colors.black),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                            child: ListView(
                              children: projects
                                  .map((e) => Container(
                                        margin: EdgeInsets.only(top: 20),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12)),
                                          color: CommonConstant.backgroundColor
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              curProject = e;
                                            });
                                          },
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: 150,
                                                child: Text(
                                                  e.name ?? '--',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                              ),
                                              Icon(Icons.arrow_right)
                                            ],
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                        )
                      ],
                    )),
                Expanded(
                  flex: 6,
                  child: Flex(
                    direction: Axis.vertical,
                    children: [
                      Expanded(
                        ///项目描述、时间和地点
                        flex: 1,

                        ///项目描述、时间和地点
                        child: Flex(
                          direction: Axis.horizontal,
                          children: [
                            ///项目描述和时间
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TroInput(
                                        label: '项目名称',
                                        value: curProject.name ?? '--',
                                        onChange: (value) {},
                                      ),
                                      Text(curProject.created ?? '--')
                                    ],
                                  ),
                                  TroInput(
                                    label: '描述',
                                    value: curProject.description ?? '--',
                                    onChange: (value) {},
                                    width: 1000,
                                  ),
                                  Expanded(
                                      child: Image.network(
                                    'https://t7.baidu.com/it/u=1595072465,3644073269&fm=193&f=GIF',
                                    fit: BoxFit.cover,
                                  ))
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: AMap2DView(
                                onAMap2DViewCreated: (controller) {
                                  _aMap2DController = controller;
                                  if (curProject.location != null) {
                                    print(curProject.location);
                                    List<String> latLon =
                                        curProject.location!.split(',');
                                    _aMap2DController!
                                        .move(latLon[0], latLon[1]);
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                      ),

                      ///项目工况和项目下属测项
                      Expanded(
                        flex: 2,
                        child: Flex(
                          direction: Axis.horizontal,
                          children: [
                            Expanded(
                              child: Container(
                                color: Colors.blue,
                              ),
                              flex: 3,
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.red,
                              ),
                              flex: 1,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
  }
}
