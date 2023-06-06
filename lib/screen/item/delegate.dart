import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:huahuan_web/model/admin/project_model.dart';

class Brn1RowDelegate implements BrnMultiDataPickerDelegate {
  final List<ProjectModel> list;
  int firstSelectedIndex = 1;
  int secondSelectedIndex = 0;
  int thirdSelectedIndex = 0;

  Brn1RowDelegate(this.list,
      {this.firstSelectedIndex = 0, this.secondSelectedIndex = 0});

  @override
  int numberOfComponent() {
    return 1;
  }

  @override
  int numberOfRowsInComponent(int component) {
    return list.length;
  }

  @override
  String titleForRowInComponent(int component, int index) {
    if (0 == component) {
      return list[index].name ?? '-';
    }
    return '--';
  }

  @override
  double? rowHeightForComponent(int component) {
    return null;
  }

  @override
  selectRowInComponent(int component, int row) {
    if (0 == component) {
      firstSelectedIndex = row;
    } else if (1 == component) {
      secondSelectedIndex = row;
    } else {
      thirdSelectedIndex = row;
      print('_thirdSelectedIndex  is selected to $thirdSelectedIndex');
    }
  }

  @override
  int initSelectedRowForComponent(int component) {
    if (0 == component) {
      return firstSelectedIndex;
    }
    return 0;
  }
}
///默认的选择轮盘滚动行为，Android去除默认的水波纹动画效果
class _ScrollBehavior extends ScrollBehavior {
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}