/// @author: cairuoyu
/// @homepage: http://cairuoyu.com
/// @github: https://github.com/cairuoyu/flutter_admin
/// @date: 2021/6/21
/// @version: 1.0
/// @description:
import 'package:flutter/material.dart';
import 'package:huahuan_web/model/admin/tabPage_model.dart';
import 'package:huahuan_web/screen/event/event_auth/event_auth.dart';
import 'package:huahuan_web/screen/event/event_manage/event_manager.dart';
import 'package:huahuan_web/screen/layout/layout.dart';
import 'package:huahuan_web/screen/role_manager/role_manager.dart';
import 'package:huahuan_web/screen/user_manage/role_list.dart';
import 'package:huahuan_web/screen/user_manage/user_list.dart';

class Routes {
  // static List<GetPage>? pages;

  static Map<String, Widget> layoutPagesMap = {
    '/': Layout(),
    '/user': UserList(),
    '/role': RoleManager(),
    '/event':ProjectManager(),
    '/eventAuth':ProjectAuth(),
    // '/addRole': AddRole(),
    // '/dashboard': Dashboard(),
    // '/sAreaAgeGenderMain': SAreaAgeGenderMain(),
    // '/roleList': RoleList(),
    // '/personList': PersonList(),
    // '/menuList': MenuMain(),
    // '/userInfoList': UserInfoList(),
    // '/deptMain': DeptMain(),
    // '/imageUpload': ImageUpload(),
    // '/videoUpload': VideoUpload(),
    // '/product/brand': BrandList(),
    // '/product/category': CategoryList(),
    // '/layout401': Page401(),
    // '/layout404': Page404(),
    // '/layoutTest': MyTest(1),
    // '/dictList': DictList(),
    // '/message': MessageMain(),
    // '/subsystemList': SubsystemMain(),
    // '/settingBase': SettingBase(),
    // '/secondLevel': SecondList(),
    // '/threeLevel': OnlyText('三级菜单页面'),
  };
  static List<String> whiteRoutes = ['/register'];

  static List<TabPage> otherTabPage = [
    TabPage(
      id: 0,
      url: '/userInfoMine',
      name: '我的信息',
    ),
    TabPage(
      id: 200,
      url: '/message',
      name: '反馈',
    ),
  ];

  // static init() {
  //   List<GetPage> layoutPages = layoutPagesMap.entries
  //       .map((e) => GetPage(name: e.key, page: () => e.value))
  //       .toList();
  //   pages = [
  //     GetPage(
  //       name: '/login',
  //       page: () => Login(),
  //     ),
  //     GetPage(
  //       name: '/',
  //       page: () => Layout(),
  //       middlewares: [AuthMiddleware()],
  //     ),
  //     GetPage(
  //       name: '/layout',
  //       page: () => Layout(),
  //       middlewares: [AuthMiddleware()],
  //       children: layoutPages,
  //     ),
  //   ];
  // }
}

// class AuthMiddleware extends GetMiddleware {
//   @override
//   RouteSettings? redirect(String? route) {
//     return Utils.isLogin() ? null : RouteSettings(name: '/login');
//   }
// }
