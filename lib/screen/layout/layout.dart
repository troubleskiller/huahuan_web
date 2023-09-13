import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:huahuan_web/api/image_api.dart';
import 'package:huahuan_web/constant/common_constant.dart';
import 'package:huahuan_web/constant/constant.dart';
import 'package:huahuan_web/model/admin/menu_model.dart';
import 'package:huahuan_web/model/api/response_api.dart';
import 'package:huahuan_web/model/mall/Image.dart';
import 'package:huahuan_web/route/Tro.dart';
import 'package:huahuan_web/screen/layout/layout_center.dart';
import 'package:huahuan_web/screen/layout/layout_controller.dart';
import 'package:huahuan_web/screen/layout/layout_menu.dart';
import 'package:huahuan_web/screen/layout/layout_setting.dart';
import 'package:huahuan_web/util/store_util.dart';
import 'package:huahuan_web/util/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

late LayoutState layoutState;

class Layout extends StatefulWidget {
  const Layout({Key? key}) : super(key: key);

  @override
  State<Layout> createState() {
    layoutState = LayoutState();
    return layoutState;
  }
}

class LayoutState extends State<Layout> {
  final GlobalKey<LayoutCenterState> layoutCenterKey =
      GlobalKey<LayoutCenterState>();
  final GlobalKey<ScaffoldState> scaffoldStateKey = GlobalKey<ScaffoldState>();
  List<ImageDataModel> images = [];
  XFile? pickedFile;
  final ImagePicker imagePicker = ImagePicker();
  ImageDataModel imageModel = ImageDataModel();
  Uint8List? imageBytes;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getCurImage();
  }

  Future getCurImage() async {
    ResponseBodyApi responseBodyApi = await ImageApi.getImageByIdAndType(
        '{"thisId":${StoreUtil.getCurrentCusInfo().id},"type": 6}');
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
      imageBytes = null;
    } else {
      final response2 =
          await dio.get('/config/findImageById', queryParameters: {
        'name': images.last.url,
      });

      imageBytes = response2.data;
    }
    setState(() {
      isLoading = false;
    });
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var layoutMenu = LayoutMenu(onClick: (MenuModel menu) {
      Utils.openTab(menu.id!);
      setState(() {});
    });
    var controller = context.watch<LayoutController>();
    var body = Utils.isMenuDisplayTypeDrawer(context) || controller.isMaximize
        ? Row(children: [LayoutCenter(key: layoutCenterKey)])
        : Row(
            children: <Widget>[
              layoutMenu,
              VerticalDivider(
                width: 2,
                color: Colors.black12,
                thickness: 2,
              ),
              LayoutCenter(key: layoutCenterKey),
            ],
          );
    Scaffold subWidget = controller.isMaximize
        ? Scaffold(body: body)
        : Scaffold(
            backgroundColor: CommonConstant.backgroundColor,
            key: scaffoldStateKey,
            drawer: layoutMenu,
            endDrawer: LayoutSetting(),
            body: body,
            appBar: getAppBar(),
          );
    return subWidget;
  }

  getAppBar() {
    var userInfo = StoreUtil.getCurrentUserInfo();
    var customer = StoreUtil.getCurrentCusInfo();
    return AppBar(
      backgroundColor: Colors.cyan,
      automaticallyImplyLeading: false,
      leading: !Utils.isMenuDisplayTypeDrawer(context)
          ? isLoading
              ? Container(
                  width: 10,
                  height: 10,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                )
              : imageBytes == null
                  ? Container()
                  : Container(
                      height: 20,
                      width: 20,
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                            image: MemoryImage(imageBytes!), fit: BoxFit.cover),
                      ),
                    )
          : Tooltip(
              message: '菜单',
              child: IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  scaffoldStateKey.currentState!.openDrawer();
                },
              )),
      title: Row(children: [
        Text(customer.name ?? '--'),
        SizedBox(
          width: 10,
        ),
        Text(userInfo.name ?? '--'),
      ]),
      actions: <Widget>[
        Tooltip(
          message: '设置',
          child: IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              scaffoldStateKey.currentState!.openEndDrawer();
            },
          ),
        ),
        Tooltip(
          message: '退出登陆',
          child: IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Utils.logout();
              // Navigator.pushReplacement(context,
              //     MaterialPageRoute(builder: (_) {
              //   return Login();
              // }));
              Tro.pushNamedAndRemove('/login');
              // Tro.init(context, Login());
            },
          ),
        )
      ],
    );
  }
}
