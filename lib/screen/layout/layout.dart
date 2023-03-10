import 'package:flutter/material.dart';
import 'package:huahuan_web/api/user_api.dart';
import 'package:huahuan_web/model/admin/menu_model.dart';
import 'package:huahuan_web/model/admin/user_info.dart';
import 'package:huahuan_web/screen/layout/layout_center.dart';
import 'package:huahuan_web/screen/layout/layout_controller.dart';
import 'package:huahuan_web/screen/layout/layout_menu.dart';
import 'package:huahuan_web/screen/layout/layout_setting.dart';
import 'package:huahuan_web/util/store_util.dart';
import 'package:huahuan_web/util/utils.dart';
import 'package:huahuan_web/widget/button/icon_button.dart';
import 'package:huahuan_web/widget/dialog/rename_dialog.dart';
import 'package:huahuan_web/widget/dialog/tro_dialog.dart';
import 'package:huahuan_web/widget/input/TroInput.dart';
import 'package:provider/provider.dart';

class Layout extends StatefulWidget {
  const Layout({Key? key}) : super(key: key);

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  final GlobalKey<LayoutCenterState> layoutCenterKey =
      GlobalKey<LayoutCenterState>();
  final GlobalKey<ScaffoldState> scaffoldStateKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
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
            key: scaffoldStateKey,
            drawer: layoutMenu,
            endDrawer: LayoutSetting(),
            body: body,
            appBar: getAppBar(),
          );
    return subWidget;
  }

  Future addNewUser(UserInfo userInfo) async {
    //??????????????????
    var user = StoreUtil.getCurrentUserInfo();
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return RenameDialog(
              contentWidget: Container(
                  width: 200,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(12)),
                  padding: EdgeInsets.all(5),
                  child: Column(
                    children: [
                      TroInput(
                        value: '',
                        label: '?????????',
                        onChange: (v) {
                          print(v);
                          userInfo.name = v;
                        },
                        validator: (v) {
                          return v!.isEmpty ? 'S.of(context).required' : null;
                        },
                      ),
                      TroInput(
                        value: '',
                        label: '??????',
                        onChange: (v) {
                          userInfo.loginName = v;
                        },
                        validator: (v) {
                          return v!.isEmpty ? 'S.of(context).required' : null;
                        },
                      ),
                      TroInput(
                        value: '',
                        label: '??????',
                        onChange: (v) {
                          userInfo.password = v;
                        },
                        validator: (v) {
                          return v!.isEmpty ? 'S.of(context).required' : null;
                        },
                      ),
                      TroInput(
                        value: '',
                        label: '????????????',
                        onChange: (v) {
                          userInfo.tel = v;
                        },
                        validator: (v) {
                          return v!.isEmpty ? 'S.of(context).required' : null;
                        },
                      ),
                      // TroSelect(
                      //   label: '????????????',
                      //   value: user.name,
                      //   dataList: DictUtil.getDictSelectOptionList(
                      //       ConstantDict.CODE_FIRM),
                      //   onSaved: (v) {
                      //     // formData.deptId = v;
                      //   },
                      // ),
                      // TroSelect(
                      //   label: '??????',
                      //   value: user.deptId,
                      //   dataList: DictUtil.getDictSelectOptionList(
                      //       ConstantDict.CODE_ROLE),
                      //   onSaved: (v) {
                      //     // formData.deptId = v;
                      //   },
                      // ),
                      Row(
                        children: [
                          TextButton(
                            child: Text('??????'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text('??????'),
                            onPressed: () async {
                              await UserApi.addUser(userInfo);
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      )
                    ],
                  )));
        });
  }

  getAppBar() {
    var userInfo = StoreUtil.getCurrentUserInfo();
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: PopupMenuButton(
            tooltip: userInfo.tel,
            onSelected: (dynamic v) {
              if (v == 'info') {
                // Utils.openTab('userInfoMine');
              } else if (v == 'logout') {
                Utils.logout();
                // Cry.pushNamedAndRemove('/login');
              } else if (v == 'addRole') {
                addNewUser(UserInfo());
              }
            },
            child: Align(
                child:
                    //todo: ?????????????????????&&logo
                    // userInfo.avatarUrl == null
                    //     ?
                    Icon(Icons.person)
                // : CircleAvatar(
                //     backgroundImage: NetworkImage(userInfo.avatarUrl!),
                //     radius: 12.0,
                //   ),
                ),
            itemBuilder: (context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'info',
                child: ListTile(
                  leading: const Icon(Icons.info),
                  title: Text('????????????'),
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem<String>(
                value: 'addRole',
                child: ListTile(
                  leading: const Icon(Icons.person_add),
                  title: Text('????????????'),
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem<String>(
                value: 'logout',
                child: ListTile(
                  leading: const Icon(Icons.logout),
                  title: Text('????????????'),
                ),
              ),
            ],
          ),
        ),
        PopupMenuButton(
          onSelected: (dynamic v) {
            switch (v) {
              case 'code':
                Utils.launchURL("https://github.com/cairuoyu/flutter_admin");
                break;
              case 'android':
                var about = Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/app_download.png',
                      width: 150,
                    ),
                    SizedBox(height: 20),
                    ButtonWithIcon(
                      label: '??????apk',
                      onPressed: () {
                        Utils.launchURL(
                            "http://www.cairuoyu.com/f/lib/app.apk");
                      },
                    ),
                  ],
                );
                troAlertWidget(context, about);
                break;
              case 'about':
                var about = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Author???CaiRuoyu'),
                    SizedBox(height: 20),
                    Text('Github???https://github.com/cairuoyu/flutter_admin'),
                    SizedBox(height: 20),
                    Text('Flutter admin?????????1.4.0'),
                    SizedBox(height: 20),
                    Text('Flutter SDK?????????stable, 2.5.1'),
                  ],
                );
                troAlertWidget(context, about);
                break;
              case 'feedback':
                // Utils.openTab('message');
                break;
              case 'privacy':
                // var privacy = ApplicationContext.instance.privacy;
                // cryAlert(context, privacy);
                break;
            }
          },
          itemBuilder: (context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'code',
              child: ListTile(
                leading: const Icon(Icons.code),
                title: Text('??????'),
              ),
            ),
            const PopupMenuDivider(),
            PopupMenuItem<String>(
              value: 'android',
              child: ListTile(
                leading: const Icon(Icons.android),
                title: Text('android'),
              ),
            ),
            const PopupMenuDivider(),
            PopupMenuItem<String>(
              value: 'feedback',
              child: ListTile(
                leading: const Icon(Icons.feedback),
                title: Text('??????'),
              ),
            ),
            const PopupMenuDivider(),
            PopupMenuItem<String>(
              value: 'about',
              child: ListTile(
                leading: const Icon(Icons.vertical_split),
                title: Text('??????'),
              ),
            ),
            const PopupMenuDivider(),
            PopupMenuItem<String>(
              value: 'privacy',
              child: ListTile(
                leading: const Icon(Icons.privacy_tip),
                title: Text('??????'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
