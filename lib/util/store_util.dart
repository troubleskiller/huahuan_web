import 'package:get_storage/get_storage.dart';
import 'package:huahuan_web/constant/constant.dart';
import 'package:huahuan_web/model/admin/menu_model.dart';
import 'package:huahuan_web/model/admin/tabPage_model.dart';

import '../model/admin/user_info.dart';

class StoreUtil {
  static read(String key) {
    return GetStorage().read(key);
  }

  static write(String key, value) {
    GetStorage().write(key, value);
  }

  static hasData(String key) {
    return GetStorage().hasData(key);
  }

  static cleanAll() {
    GetStorage().erase();
  }

  static init() {
    var list = getDefaultTabs();
    writeOpenedTabPageList(list);
    if (list.isNotEmpty) {
      writeCurrentOpenedTabPageId(list.first.id);
    }
  }

  static List<TabPage?> readOpenedTabPageList() {
    var data = read(Constant.KEY_OPENED_TAB_PAGE_LIST);
    return data == null
        ? []
        : List.from(data).map((e) => TabPage.fromMap(e)).toList();
  }

  static writeOpenedTabPageList(List<TabPage?> list) {
    var data = list.map((e) => e!.toMap()).toList();
    write(Constant.KEY_OPENED_TAB_PAGE_LIST, data);
  }

  static int? readCurrentOpenedTabPageId() {
    return read(Constant.KEY_CURRENT_OPENED_TAB_PAGE_ID);
  }

  static writeCurrentOpenedTabPageId(int? data) {
    write(Constant.KEY_CURRENT_OPENED_TAB_PAGE_ID, data);
  }

  //获取用户信息
  static UserInfo getCurrentUserInfo() {
    var data = GetStorage().read(Constant.KEY_CURRENT_USER_INFO);
    return data == null ? UserInfo() : UserInfo.fromJson(data);
  }

  static List<MenuModel> getMenuList() {
    var data = GetStorage().read(Constant.KEY_MENU_LIST);

    return data == null
        ? []
        : List.from(data).map((e) => MenuModel.fromJson(e)).toList();
  }

  static List<TabPage> getDefaultTabs() {
    var data = GetStorage().read(Constant.KEY_DEFAULT_TABS);
    return data == null
        ? []
        : List.from(data).map((e) => TabPage.fromMap(e)).toList();
  }

  // static Future<bool?> loadDict() async {
  //   ResponseBodyApi responseBodyApi = await DictApi.map();
  //   if (responseBodyApi.success!) {
  //     StoreUtil.write(Constant.KEY_DICT_ITEM_LIST, responseBodyApi.data);
  //   }
  //   return responseBodyApi.success;
  // }
  //
  // static Future<bool?> loadSubsystem() async {
  //   ResponseBodyApi responseBodyApi = await SubsystemApi.listEnable();
  //   if (responseBodyApi.success!) {
  //     StoreUtil.write(Constant.KEY_SUBSYSTEM_LIST, responseBodyApi.data);
  //     List<Subsystem> list = responseBodyApi.data == null
  //         ? []
  //         : List.from(responseBodyApi.data)
  //             .map((e) => Subsystem.fromMap(e))
  //             .toList();
  //     if (list.isNotEmpty) {
  //       StoreUtil.write(Constant.KEY_CURRENT_SUBSYSTEM, list[0].toMap());
  //     }
  //   }
  //   return responseBodyApi.success;
  // }

  // static Future<bool?> loadDefaultTabs() async {
  //   ResponseBodyApi responseBodyApi = await SettingDefaultTabApi.list();
  //   if (responseBodyApi.success!) {
  //     StoreUtil.write(Constant.KEY_DEFAULT_TABS, responseBodyApi.data);
  //   }
  //   return responseBodyApi.success;
  // }
}
