import 'package:flutter/material.dart';
import 'package:huahuan_web/constant/constant.dart';
import 'package:huahuan_web/constant/enum.dart';
import 'package:huahuan_web/constant/icon.dart';
import 'package:huahuan_web/extension/common_extension.dart';
import 'package:huahuan_web/model/admin/tabPage_model.dart';
import 'package:huahuan_web/route/routes.dart';
import 'package:huahuan_web/screen/layout/layout_controller.dart';
import 'package:huahuan_web/util/store_util.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  static fullscreenDialog(BuildContext context, Widget widget) {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => widget,
        fullscreenDialog: true,
      ),
    );
  }

  static openTab(int id) {
    TabPage? tabPage = (StoreUtil.getDefaultTabs() + Routes.otherTabPage)
        .firstWhereOrNull((element) => element.id == id);
    if (tabPage == null) {
      var menuList = StoreUtil.getMenuList();
      var menu = menuList.firstWhereOrNull((element) => element.id == id);
      if (menu == null) {
        return;
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
    // LayoutController layoutController = Get.find();
    // layoutController.update();
  }

  static closeTab(TabPage? tabPage) {
    List<TabPage?> openedTabPageList = StoreUtil.readOpenedTabPageList();
    int index = openedTabPageList.indexWhere((note) => note!.id == tabPage!.id);
    if (index < 0) {
      return;
    }
    openedTabPageList.removeAt(index);
    StoreUtil.writeOpenedTabPageList(openedTabPageList);
    if (StoreUtil.readCurrentOpenedTabPageId() == tabPage!.id) {
      StoreUtil.writeCurrentOpenedTabPageId(
          openedTabPageList.length > 0 ? openedTabPageList.last!.id : null);
    }
    // LayoutController layoutController = Get.find();
    // layoutController.update();
  }

  static closeAllTab() {
    StoreUtil.init();
    // LayoutController layoutController = Get.find();
    // layoutController.update();
  }

  static closeOtherTab(TabPage tabPage) {
    List<TabPage?> openedTabPageList = StoreUtil.readOpenedTabPageList();
    openedTabPageList.removeWhere((element) =>
        element!.id != tabPage.id &&
        !StoreUtil.getDefaultTabs().contains(element));
    StoreUtil.writeCurrentOpenedTabPageId(tabPage.id);
    StoreUtil.writeOpenedTabPageList(openedTabPageList);
    // LayoutController layoutController = Get.find();
    // layoutController.update();
  }

  static closeAllToTheRightTab(TabPage tabPage) {
    List<TabPage?> openedTabPageList = StoreUtil.readOpenedTabPageList();
    int index = openedTabPageList.indexWhere((note) => note!.id == tabPage.id);
    openedTabPageList.removeWhere((element) =>
        openedTabPageList.indexOf(element) > index &&
        !StoreUtil.getDefaultTabs().contains(element));
    StoreUtil.writeCurrentOpenedTabPageId(tabPage.id);
    StoreUtil.writeOpenedTabPageList(openedTabPageList);
    // LayoutController layoutController = Get.find();
    // layoutController.update();
  }

  static closeAllToTheLeftTab(TabPage tabPage) {
    List<TabPage?> openedTabPageList = StoreUtil.readOpenedTabPageList();
    int index = openedTabPageList.indexWhere((note) => note!.id == tabPage.id);
    openedTabPageList.removeWhere((element) =>
        openedTabPageList.indexOf(element) < index &&
        !StoreUtil.getDefaultTabs().contains(element));
    StoreUtil.writeCurrentOpenedTabPageId(tabPage.id);
    StoreUtil.writeOpenedTabPageList(openedTabPageList);
    // LayoutController layoutController = Get.find();
    // layoutController.update();
  }

  // static isLocalEn(BuildContext context) {
  //   return (Get.locale ?? Get.deviceLocale)!.languageCode == 'en';
  // }

  static isMenuDisplayTypeDrawer(BuildContext context) {
    var menuDisplayType = context.read<LayoutController>().menuDisplayType;
    return menuDisplayType == MenuDisplayType.drawer;
  }

  static getThemeData(
      {Color? themeColor, String? fontFamily, bool isDark = false}) {
    if (fontFamily != null) {
      currentFontFamily = fontFamily;
    }
    if (themeColor == null) {
      themeColor = Colors.cyanAccent;
    }
    return ThemeData(
      brightness: isDark ? Brightness.dark : Brightness.light,
      primaryColor: themeColor,
      iconTheme: IconThemeData(color: themeColor),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: themeColor,
      ),
      buttonTheme: ButtonThemeData(buttonColor: themeColor),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(themeColor))),
      fontFamily: currentFontFamily,
    );
  }

  static String currentFontFamily = "Roboto";

  static isLogin() {
    return StoreUtil.hasData(Constant.KEY_TOKEN);
  }

  static logout() {
    StoreUtil.cleanAll();
  }

  static launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // static toPortal(BuildContext context, String message, String buttonText,
  //     {String url = "http://www.cairuoyu.com/flutter_portal"}) {
  //   cryAlertWidget(
  //     context,
  //     Container(
  //       height: 100,
  //       child: Column(
  //         children: [
  //           Text(message),
  //           SizedBox(
  //             height: 20,
  //           ),
  //           ElevatedButton(
  //             child: Text(buttonText),
  //             onPressed: () {
  //               Utils.launchURL(url);
  //             },
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  static toIconData(String? icon) {
    if (icon == null || icon == '') {
      return Icons.menu;
    }
    // IconData iconData = IconData(int.parse(icon), fontFamily: 'MaterialIcons');
    return iconMap[icon] ?? Icons.menu;
  }

// static bool isCurrentOpenedMenu(List<TreeVO<Menu>> data) {
//   for (var treeVO in data) {
//     if (treeVO.children != null && treeVO.children.length > 0) {
//       return isCurrentOpenedMenu(treeVO.children);
//     }
//     return StoreUtil.readCurrentOpenedTabPageId() == treeVO.data.id;
//   }
//   return false;
// }
}
