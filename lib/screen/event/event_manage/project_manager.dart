import 'package:card_swiper/card_swiper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:huahuan_web/api/project_api.dart';
import 'package:huahuan_web/constant/common_constant.dart';
import 'package:huahuan_web/model/admin/project_model.dart';
import 'package:huahuan_web/model/admin/project_state_model.dart';
import 'package:huahuan_web/model/admin/user_info.dart';
import 'package:huahuan_web/model/api/response_api.dart';
import 'package:huahuan_web/screen/event/event_manage/event_list.dart';
import 'package:huahuan_web/screen/event/event_manage/project_edit.dart';
import 'package:huahuan_web/screen/event/event_manage/state_edit.dart';
import 'package:huahuan_web/util/store_util.dart';
import 'package:huahuan_web/widget/button/icon_button.dart';

class ProjectManager extends StatefulWidget {
  const ProjectManager({Key? key}) : super(key: key);

  @override
  State<ProjectManager> createState() => _ProjectManagerState();
}

class _ProjectManagerState extends State<ProjectManager> {
  bool loadData = true;
  List<ProjectModel> projects = [];
  late ProjectModel curProject;
  List<ProjectStateModel> curAllStates = [];
  List<ProjectStateModel> curAllDiseases = [];

  List<EventLine> eventsUnProject = [];

  ///todo: 用当前用户的id
  UserInfo curUser = StoreUtil.getCurrentUserInfo();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllProjects();
  }

  ///得到现有的所有项目
  void getAllProjects() async {
    ResponseBodyApi responseBodyApi = ResponseBodyApi();
    responseBodyApi = await ProjectApi.findAllById({"id": curUser.id});
    projects = List.from(responseBodyApi.data)
        .map((e) => ProjectModel.fromJson(e))
        .toList();

    ///默认访问第一个
    curProject = projects[0];
    await getCurEvents(curProject.id!);
    await getAllStates(curProject.id!);
    setState(() {
      loadData = false;
    });
  }

  Future getCurEvents(int i) async {
    print('--------------这是当前的项目id：$i');
    ResponseBodyApi responseBodyApi = await ProjectApi.getCurEvents({"id": i});
    if (responseBodyApi.code == 200) {
      setState(() {
        eventsUnProject = List.from(responseBodyApi.data)
            .map((e) => EventLine(event: ProjectModel.fromJson(e)))
            .toList();
      });
    }
  }

  Future getAllStates(int i) async {
    ResponseBodyApi responseBodyApi = await ProjectApi.getAllStates({"id": i});
    print(responseBodyApi.data);
    if (responseBodyApi.code == 200) {
      setState(() {
        curAllStates = List.from(responseBodyApi.data['operatingMode'])
            .map((e) => ProjectStateModel.fromJson(e))
            .toList();
        curAllDiseases = List.from(responseBodyApi.data['disease'])
            .map((e) => ProjectStateModel.fromJson(e))
            .toList();
      });
    }
  }

  void _editProject({ProjectModel? curProject, int? parentProjectId}) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: ProjectEdit(
          curProject: curProject,
        ),
      ),
    ).then((v) {
      if (v != null) {
        // _query();
      }
    });
  }
  void _editState({ProjectStateModel? curState}) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: StateEdit(
          curState: curState,
        ),
      ),
    ).then((v) {
      if (v != null) {
        // _query();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return loadData
        ? Container()
        : Scaffold(
            backgroundColor: Colors.white,
            body: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
              child: Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Text(
                            tr('Project Name'),
                            style: TextStyle(fontSize: 30, color: Colors.black),
                          ),
                          Expanded(
                            flex: 12,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              child: ListView(
                                children: projects
                                    .map((e) => Container(
                                          margin: EdgeInsets.only(top: 20),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 10),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12)),
                                              color: e.id == curProject.id
                                                  ? Colors.amberAccent
                                                  : CommonConstant
                                                      .backgroundColor),
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                curProject = e;
                                                getCurEvents(curProject.id!);
                                                getAllStates(curProject.id!);
                                              });
                                            },
                                            child: Flex(
                                              direction: Axis.horizontal,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    e.name ?? '--',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
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
                          ),
                          Expanded(
                              flex: 1,
                              child: ButtonWithIcon(
                                iconData: Icons.add,
                                onPressed: () {
                                  _editProject();
                                },
                              ))
                        ],
                      )),
                  Expanded(
                    flex: 6,
                    child: Flex(
                      direction: Axis.vertical,
                      children: [
                        Expanded(
                          ///项目描述、时间和地点
                          flex: 8,

                          ///项目描述、时间和地点
                          child: Flex(
                            direction: Axis.horizontal,
                            // mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ///项目图片
                              Expanded(
                                flex: 6,
                                child: Image.network(
                                  'https://t7.baidu.com/it/u=1595072465,3644073269&fm=193&f=GIF',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Spacer(
                                flex: 1,
                              ),

                              ///项目描述和时间
                              Expanded(
                                flex: 12,
                                child: Flex(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  direction: Axis.vertical,
                                  children: [
                                    Expanded(
                                        flex: 8,
                                        child: Flex(
                                          direction: Axis.horizontal,
                                          children: [
                                            Expanded(
                                                child: Text(
                                              curProject.name ?? '--',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                            Spacer(),
                                            ButtonWithIcon(
                                              iconData: Icons.edit,
                                              onPressed: () {
                                                _editProject(
                                                    curProject: curProject);
                                              },
                                            ),
                                          ],
                                        )),
                                    Spacer(
                                      flex: 1,
                                    ),
                                    Expanded(
                                        flex: 7,
                                        child: Flex(
                                          direction: Axis.horizontal,
                                          children: [
                                            Expanded(
                                              flex: 20,
                                              child: Text(DateTime.parse(
                                                      curProject.created ?? '')
                                                  .toString()
                                                  .split('.')[0]),
                                            ),
                                            Spacer(
                                              flex: 2,
                                            ),
                                            Container(
                                              width: 2,
                                              color: Colors.grey,
                                            ),
                                            Spacer(
                                              flex: 2,
                                            ),
                                            Expanded(
                                              flex: 18,
                                              child: Text(
                                                  curProject.location ?? '--'),
                                            ),
                                          ],
                                        )),
                                    Spacer(
                                      flex: 3,
                                    ),
                                    Expanded(
                                      flex: 20,
                                      child:
                                          Text(curProject.description ?? '--'),
                                    ),
                                    Spacer(
                                      flex: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacer(
                          flex: 1,
                        ),
                        Container(
                          height: 1,
                          color: Colors.grey,
                        ),

                        ///项目工况和项目下属测项
                        Expanded(
                          flex: 24,
                          child: Flex(
                            direction: Axis.horizontal,
                            children: [
                              Expanded(
                                flex: 18,
                                child: Flex(
                                  direction: Axis.vertical,
                                  children: [
                                    ///工况轮播图
                                    Spacer(),
                                    Expanded(
                                        flex: 8,
                                        child: Swiper(
                                          autoplay: false,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return StateOrDiseaseWidget(
                                              projectStateModel:
                                                  curAllStates[index], edit: (){
                                                _editState(curState:curAllStates[index]);
                                            },
                                            );
                                          },
                                          itemCount: curAllStates.length,
                                          pagination: SwiperPagination(),
                                          control: SwiperControl(),
                                        )),
                                    Spacer(),
                                    Container(
                                      height: 1,
                                      color: Colors.grey,
                                    ),
                                    Spacer(),
                                    Expanded(
                                        flex: 8,
                                        child: Swiper(
                                          autoplay: false,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return StateOrDiseaseWidget(
                                              projectStateModel:
                                                  curAllDiseases[index], edit: (){
                                                _editState(curState:curAllDiseases[index]);
                                            },
                                            );
                                          },
                                          itemCount: curAllDiseases.length,
                                          pagination: SwiperPagination(),
                                          control: SwiperControl(),
                                        )),
                                    Spacer(),
                                    Expanded(flex:1,child: ButtonWithIcon(iconData: Icons.add,onPressed: (){
                                      _editState();
                                    },)),
                                    Spacer(),
                                  ],
                                ),
                              ),
                              Container(
                                width: 1,
                                color: Colors.grey,
                              ),
                              Spacer(
                                flex: 1,
                              ),
                              Expanded(
                                flex: 6,
                                child: Flex(
                                  direction: Axis.vertical,
                                  children: [
                                    Expanded(
                                      flex: 12,
                                      child: ListView(
                                        children: eventsUnProject,
                                      ),
                                    ),
                                    Expanded(
                                        flex: 1,
                                        child: ButtonWithIcon(
                                          iconData: Icons.add,
                                          onPressed: () {
                                            _editProject(parentProjectId:curProject.id);
                                          },
                                        ))
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
  }

}

class StateOrDiseaseWidget extends StatelessWidget {
  final ProjectStateModel projectStateModel;
  final Function edit;

  const StateOrDiseaseWidget({Key? key, required this.projectStateModel, required this.edit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      // mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ///项目图片
        Expanded(
          flex: 6,
          child: Image.network(
            'https://t7.baidu.com/it/u=1595072465,3644073269&fm=193&f=GIF',
            fit: BoxFit.cover,
          ),
        ),
        Spacer(
          flex: 1,
        ),

        ///项目描述和时间
        Expanded(
          flex: 12,
          child: Flex(
            crossAxisAlignment: CrossAxisAlignment.start,
            direction: Axis.vertical,
            children: [
              Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                    flex: 8,
                    child: Text(
                      projectStateModel.name ?? '--',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ButtonWithIcon(iconData: Icons.edit,onPressed: (){
                    edit();
                  },)
                ],
              ),
              Spacer(
                flex: 1,
              ),
              Expanded(
                  flex: 7,
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      Expanded(
                        flex: 20,
                        child: Text(
                            DateTime.parse(projectStateModel.startTime ?? '')
                                .toString()
                                .split('.')[0]),
                      ),
                      Spacer(
                        flex: 2,
                      ),
                      Container(
                        width: 2,
                        color: Colors.grey,
                      ),
                      Spacer(
                        flex: 2,
                      ),
                      Expanded(
                        flex: 18,
                        child: Text(
                            DateTime.parse(projectStateModel.endTime ?? '')
                                .toString()
                                .split('.')[0]),
                      ),
                    ],
                  )),
              Spacer(
                flex: 3,
              ),
              Expanded(
                flex: 20,
                child: Text(projectStateModel.description ?? '--'),
              ),
              Spacer(
                flex: 1,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
