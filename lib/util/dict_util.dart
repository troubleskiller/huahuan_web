import 'package:huahuan_web/constant/constant.dart';
import 'package:huahuan_web/util/store_util.dart';
import 'package:huahuan_web/widget/input/TroSelect.dart';

class DictUtil {
  static List getDictItemList(String dictCode) {
    var data = StoreUtil.read(Constant.KEY_DICT_ITEM_LIST);
    if (data == null) {
      return [];
    }
    var map = Map.from(data);
    return map[dictCode] ?? [];
  }

  static List<SelectOptionVO> getDictSelectOptionList(String dictCode) {
    return getDictItemList(dictCode)
        .map((e) => SelectOptionVO(value: e['code'], label: e['name']))
        .toList();
  }

  static String? getDictItemName(String? code, String dictCode,
      {defaultValue = ''}) {
    if (code == null) {
      return defaultValue;
    }
    Map? result = getDictItemList(dictCode).firstWhere((v) {
      return v['code'] == code;
    }, orElse: () {
      return null;
    });
    if (result == null) {
      return code;
    }
    return result['name'];
  }
}
