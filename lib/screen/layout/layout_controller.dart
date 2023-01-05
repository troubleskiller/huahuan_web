import 'package:flutter/cupertino.dart';
import 'package:huahuan_web/constant/enum.dart';

class LayoutController extends ChangeNotifier {
  MenuDisplayType? menuDisplayType = MenuDisplayType.side;
  bool isMaximize = false;

  toggleMaximize() {
    isMaximize = !isMaximize;
    notifyListeners();
  }

  updateMenuDisplayType(v) {
    menuDisplayType = v;
    notifyListeners();
  }

  void update() {
    notifyListeners();
  }
}
