import 'package:flutter/material.dart';
import 'package:huahuan_web/extension/common_extension.dart';
import 'package:huahuan_web/route/route_delegate.dart';
import 'package:huahuan_web/route/routes.dart';

import '../model/admin/tabPage_model.dart';
import '../screen/layout/layout.dart';
import '../screen/login.dart';
import '../util/store_util.dart';
import '../util/utils.dart';

class MainRouterDelegate extends TroRouterDelegate {
  MainRouterDelegate({required Map pageMap}) : super(pageMap: pageMap);

  @override
  RouteInformation get currentConfiguration {
    return RouteInformation(location: location ?? '/');
  }

  @override
  pushNamed(String name) {
    pages.add(
      MaterialPage(
        key: UniqueKey(),
        child: getPageChild(name)!,
      ),
    );

    notifyListeners();
  }

  Widget? getPageChild(String name) {
    if (!Utils.isLogin() && !Routes.whiteRoutes.contains(name)) {
      location = '/login';
      return Login();
    }
    if (name == '/' || (name == '/login' && Utils.isLogin())) {
      location = '/';
      return Layout();
    }
    if (pageMap.containsKey(name)) {
      location = name;
      return pageMap[name];
    }

    TabPage? tabPage = (StoreUtil.getDefaultTabs() + Routes.otherTabPage)
        .firstWhereOrNull((element) => element.url == name);
    if (tabPage == null) {
      var menuList = StoreUtil.getMenuList();
      var menu = menuList.firstWhereOrNull((element) => element.url == name);
      if (menu == null) {
        location = '/404';
        return Login();
      }
      tabPage = menu.toTabPage();
    }

    List<TabPage?> openedTabPageList = StoreUtil.readOpenedTabPageList();
    StoreUtil.writeCurrentOpenedTabPageId(tabPage!.id);
    int index = openedTabPageList.indexWhere((note) => note!.id == tabPage!.id);
    if (index <= -1) {
      openedTabPageList.add(tabPage);
      StoreUtil.writeOpenedTabPageList(openedTabPageList);
    }
    location = name;
    return Layout();
  }
}
