import 'dart:typed_data';

import 'package:card_swiper/card_swiper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:huahuan_web/api/image_api.dart';
import 'package:huahuan_web/api/project_api.dart';
import 'package:huahuan_web/constant/common_constant.dart';
import 'package:huahuan_web/constant/constant.dart';
import 'package:huahuan_web/model/admin/project_model.dart';
import 'package:huahuan_web/model/admin/project_state_model.dart';
import 'package:huahuan_web/model/admin/user_info.dart';
import 'package:huahuan_web/model/api/response_api.dart';
import 'package:huahuan_web/model/application/event_model.dart';
import 'package:huahuan_web/model/mall/Image.dart';
import 'package:huahuan_web/screen/event/event_manage/event_list.dart';
import 'package:huahuan_web/screen/event/event_manage/state_edit.dart';
import 'package:huahuan_web/screen/item/item_manager.dart';
import 'package:huahuan_web/screen/layout/layout.dart';
import 'package:huahuan_web/screen/layout/layout_controller.dart';
import 'package:huahuan_web/util/store_util.dart';
import 'package:huahuan_web/util/utils.dart';
import 'package:huahuan_web/widget/button/icon_button.dart';
import 'package:huahuan_web/widget/common/common_card.dart';
import 'package:provider/provider.dart';

class ProjectView extends StatefulWidget {
  const ProjectView({Key? key}) : super(key: key);

  @override
  State<ProjectView> createState() => _ProjectViewState();
}

class _ProjectViewState extends State<ProjectView> {
  SwiperController swiperController = SwiperController();
  late EventModel controller;
  LayoutController layoutController = LayoutController();
  bool loadData = true;
  List<ProjectModel> projects = [];
  late ProjectModel curProject;
  List<ProjectStateModel> curAllStates = [];
  List<ProjectStateModel> curAllDiseases = [];

  List<EventLine> eventsUnProject = [];

  List<ImageDataModel> images = [];
  Uint8List? projectBytes;
  List<Uint8List> stateBytes = [];
  List<Uint8List> diseaseBytes = [];

  ///todo: 用当前用户的id
  UserInfo curUser = StoreUtil.getCurrentUserInfo();

  @override
  void initState() {
    controller = context.read<EventModel>();
    getAllProjects();
    super.initState();
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
    controller.updateEventModel(
      nP: projects[0],
      nPs: projects,
    );
    await getAllStates(curProject.id!);
    setState(() {
      loadData = false;
    });
  }

  Future getCurEvents(int i) async {
    ResponseBodyApi responseBodyApi = await ProjectApi.getCurEvents({"id": i});
    if (responseBodyApi.code == 200) {
      setState(() {
        eventsUnProject = List.from(responseBodyApi.data)
            .map((e) => EventLine(
                  event: ProjectModel.fromJson(e),
                  curProject: curProject.id ?? 0,
                  onClick: () async {
                    await controller.updateEventModel(
                      nE: ProjectModel.fromJson(e),
                      nP: curProject,
                      nEs: List.from(responseBodyApi.data)
                          .map((e) => ProjectModel.fromJson(e))
                          .toList(),
                      nPs: projects,
                    );
                    Utils.openTab(14);
                    layoutState.setState(() {});
                    if (itemManagerState != null) {
                      itemManagerState!.setState(() {});
                      itemManagerState!.init();
                    }
                    // layoutController.update(9);
                  },
                ))
            .toList();
        getCurImage();
      });
    }
  }

  ///得到当前的图片
  void getCurImage() async {
    ResponseBodyApi responseBodyApi = await ImageApi.getImageByIdAndType(
        '{"thisId":${curProject.id},"type": 5}');
    if (responseBodyApi.code == 200) {
      images = List.from(responseBodyApi.data)
          .map((e) => ImageDataModel.fromJson(e))
          .toList();
    }
    BaseOptions options = BaseOptions(
      baseUrl: 'http://huahuan.f3322.net:14500',
      connectTimeout: 20000,
      receiveTimeout: 20000,
      sendTimeout: 20000,
      headers: {
        'User-Agent': 'Mozilla 5.10',
        'USERNAME': 'SANDBOX',
        'token': StoreUtil.read(Constant.KEY_TOKEN),
      },
    );

    Dio dio = Dio(options);
    dio.options.responseType = ResponseType.bytes;
    if (images.isEmpty) {
      projectBytes = null;
    } else {
      final response2 =
          await dio.get('/config/findImageById', queryParameters: {
        'name': images.last.url,
      });

      projectBytes = response2.data;
    }
    setState(() {});
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

  void _editState({ProjectStateModel? curState, Uint8List? bytes}) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: StateEdit(
          curState: curState,
          pid: curProject.id,
          bytes: bytes,
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
            // backgroundColor: Colors.white30,
            backgroundColor: Colors.white30,
            body: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
              child: Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                      flex: 14,
                      child: CommonCard(
                        backgroundColor: Colors.white,
                        child: Column(
                          children: [
                            Text(
                              '项目名称',
                              style:
                                  TextStyle(fontSize: 30, color: Colors.black),
                            ),
                            Expanded(
                              flex: 12,
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
                          ],
                        ),
                      )),
                  Spacer(),
                  Expanded(
                    flex: 75,
                    child: Flex(
                      direction: Axis.vertical,
                      children: [
                        Expanded(
                          flex: 8,
                          child: Flex(
                            direction: Axis.horizontal,
                            // mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ///项目图片
                              Expanded(
                                  flex: 6,
                                  child: CommonCard(
                                    backgroundColor: Colors.white,
                                    child: projectBytes != null
                                        ? Image.memory(
                                            projectBytes!,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.network(
                                            'https://t7.baidu.com/it/u=1595072465,3644073269&fm=193&f=GIF',
                                            fit: BoxFit.cover,
                                          ),
                                  )),
                              Spacer(
                                flex: 1,
                              ),

                              ///项目描述和时间
                              Expanded(
                                flex: 12,
                                child: CommonCard(
                                  child: Flex(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                              Spacer(),
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
                                                        curProject.created ??
                                                            '')
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
                                                    curProject.location ??
                                                        '--'),
                                              ),
                                            ],
                                          )),
                                      Spacer(
                                        flex: 3,
                                      ),
                                      Expanded(
                                        flex: 20,
                                        child: Text(
                                            curProject.description ?? '--'),
                                      ),
                                      Spacer(
                                        flex: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacer(
                          flex: 1,
                        ),

                        ///项目工况和项目下属测项
                        Expanded(
                          flex: 24,
                          child: Container(
                            child: Flex(
                              direction: Axis.horizontal,
                              children: [
                                Expanded(
                                  flex: 45,
                                  child: Flex(
                                    direction: Axis.vertical,
                                    children: [
                                      ///工况轮播图
                                      Expanded(
                                          flex: 8,
                                          child: Swiper(
                                            autoplay: false,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return CommonCard(
                                                backgroundColor: Colors.white,
                                                child: StateOrDiseaseWidget(
                                                  projectStateModel:
                                                      curAllStates[index],
                                                  edit: (Uint8List? bytes) {
                                                    _editState(
                                                        curState:
                                                            curAllStates[index],
                                                        bytes: bytes);
                                                  },
                                                ),
                                              );
                                            },
                                            itemCount: curAllStates.length,
                                            pagination: SwiperPagination(),
                                            control: SwiperControl(),
                                          )),
                                      Spacer(),
                                      Expanded(
                                          flex: 8,
                                          child: Swiper(
                                            autoplay: false,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return CommonCard(
                                                backgroundColor: Colors.white,
                                                child: StateOrDiseaseWidget(
                                                  projectStateModel:
                                                      curAllDiseases[index],
                                                  edit: (Uint8List? bytes) {
                                                    _editState(
                                                        curState:
                                                            curAllDiseases[
                                                                index],
                                                        bytes: bytes);
                                                  },
                                                ),
                                              );
                                            },
                                            itemCount: curAllDiseases.length,
                                            pagination: SwiperPagination(),
                                            control: SwiperControl(),
                                          )),
                                      Spacer(),
                                      Expanded(
                                          flex: 1,
                                          child: ButtonWithIcon(
                                            iconData: Icons.add,
                                            onPressed: () {
                                              _editState();
                                            },
                                          )),
                                      Spacer(),
                                    ],
                                  ),
                                ),
                                Spacer(
                                  flex: 1,
                                ),
                                Expanded(
                                  flex: 15,
                                  child: Flex(
                                    direction: Axis.vertical,
                                    children: [
                                      Expanded(
                                        flex: 12,
                                        child: CommonCard(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          backgroundColor: Colors.white,
                                          child: ListView(
                                            children: eventsUnProject,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
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

class StateOrDiseaseWidget extends StatefulWidget {
  final ProjectStateModel projectStateModel;
  final Function edit;

  const StateOrDiseaseWidget({
    Key? key,
    required this.projectStateModel,
    required this.edit,
  }) : super(key: key);

  @override
  State<StateOrDiseaseWidget> createState() => _StateOrDiseaseWidgetState();
}

class _StateOrDiseaseWidgetState extends State<StateOrDiseaseWidget> {
  List<ImageDataModel> images = [];
  Uint8List? bytes;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future getCurImage() async {
    ResponseBodyApi responseBodyApi = await ImageApi.getImageByIdAndType(
        '{"thisId":${widget.projectStateModel.id},"type": ${widget.projectStateModel.type}}');
    if (responseBodyApi.code == 200) {
      images = List.from(responseBodyApi.data)
          .map((e) => ImageDataModel.fromJson(e))
          .toList();
    }
    BaseOptions options = BaseOptions(
      baseUrl: 'http://huahuan.f3322.net:14500',
      connectTimeout: 20000,
      receiveTimeout: 20000,
      sendTimeout: 20000,
      headers: {
        'User-Agent': 'Mozilla 5.10',
        'USERNAME': 'SANDBOX',
        'token': StoreUtil.read(Constant.KEY_TOKEN),
      },
    );

    Dio dio = Dio(options);
    dio.options.responseType = ResponseType.bytes;
    final response2 = await dio.get('/config/findImageById', queryParameters: {
      'name': images.first.url,
    });

    bytes = response2.data;
  }

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      // mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ///项目图片
        Expanded(
          flex: 6,
          child: CommonCard(
              backgroundColor: Colors.white30,
              child: FutureBuilder(
                  future: getCurImage(),
                  initialData: null,
                  builder: (_, as) {
                    return bytes != null
                        ? Image.memory(
                            bytes!,
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            'https://t7.baidu.com/it/u=1595072465,3644073269&fm=193&f=GIF',
                          );
                  })),
        ),
        Spacer(
          flex: 1,
        ),

        ///项目描述和时间
        Expanded(
          flex: 12,
          child: CommonCard(
            backgroundColor: Color.fromRGBO(240, 242, 246, 1),
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
                        widget.projectStateModel.name ?? '--',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ButtonWithIcon(
                      iconData: Icons.edit,
                      onPressed: () {
                        widget.edit(bytes);
                      },
                    )
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
                          child: Text(DateTime.parse(
                                  widget.projectStateModel.startTime ?? '')
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
                          child: Text(DateTime.parse(
                                  widget.projectStateModel.endTime ?? '')
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
                  child: Text(widget.projectStateModel.description ?? '--'),
                ),
                Spacer(
                  flex: 1,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
