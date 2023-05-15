import 'package:flutter/material.dart';
import 'package:huahuan_web/constant/common_constant.dart';
import 'package:huahuan_web/model/admin/menu_model.dart';
import 'package:huahuan_web/screen/layout/layout_center.dart';
import 'package:huahuan_web/screen/layout/layout_controller.dart';
import 'package:huahuan_web/screen/layout/layout_menu.dart';
import 'package:huahuan_web/screen/layout/layout_setting.dart';
import 'package:huahuan_web/util/store_util.dart';
import 'package:huahuan_web/util/utils.dart';
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

  @override
  void initState() {
    super.initState();
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
    // var subsystemList = StoreUtil.getSubsystemList();
    // var currentSubsystem = StoreUtil.getCurrentSubsystem();
    return AppBar(
      backgroundColor: Colors.cyan,
      automaticallyImplyLeading: false,
      leading: !Utils.isMenuDisplayTypeDrawer(context)
          ? Tooltip(
              message: 'Home',
              child: IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  // Utils.launchURL('http://www.cairuoyu.com');
                },
              ))
          : Tooltip(
              message: 'Menu',
              child: IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  scaffoldStateKey.currentState!.openDrawer();
                },
              )),
      title: Row(children: [
        Text(userInfo.name ?? '--'),
        SizedBox(
          width: 10,
        ),
        Text(customer.name ?? '--'),
      ]),
      actions: <Widget>[
        Tooltip(
          message: 'Setting',
          child: IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              scaffoldStateKey.currentState!.openEndDrawer();
            },
          ),
        ),
      ],
    );
  }
}
