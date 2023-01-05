import 'package:flutter/material.dart';

class TreeVO<T extends TreeData> {
  TreeVO({this.data});

  T? data;
  TreeVO<T>? parent;
  List<TreeVO<T>> children = [];
  bool isExpanded = false;
  IconData icon = Icons.menu;
  bool? checked = false;
}

class TreeData {
  TreeData(this.id, this.parentId);
  bool? checked;
  int? id;
  int? parentId;
}

class TreeUtil {
  static findChildren<T extends TreeData>(
      List<TreeVO<T>> list, TreeVO<T> treeVO) {
    for (TreeVO<T> v in list) {
      if (v.data!.parentId == treeVO.data!.id) {
        treeVO.children.add(v);
        v.parent = treeVO;
      }
    }
  }

  static bool findParent<T extends TreeData>(
      List<TreeVO<T>> list, TreeVO<T> treeVO) {
    for (TreeVO<T> v in list) {
      if (v.data!.id == treeVO.data!.parentId) {
        v.children.add(treeVO);
        treeVO.parent = v;
        return true;
      }
      if (v.children.length > 0) {
        if (findParent(v.children, treeVO)) {
          return true;
        }
      }
    }
    return false;
  }

  static addTreeData<T extends TreeData>(List<TreeVO<T>> list, T treeData) {
    TreeVO<T> treeVO = TreeVO<T>(data: treeData);
    if (treeData.checked != null) {
      treeVO.checked = treeData.checked;
    }
    findChildren(list, treeVO);
    findParent(list, treeVO);
    list.add(treeVO);
  }

  static List<TreeVO<T>> toTreeVOList<T extends TreeData>(List<T> data) {
    List<TreeVO<T>> result = [];
    data.forEach((element) {
      addTreeData(result, element);
    });
    //当pid为null时，为根结点
    return result.where((element) => element.data!.parentId == null).toList();
  }

  static List<TreeVO<T>> getSelected<T extends TreeData>(List<TreeVO<T>> data) {
    var selected = <TreeVO<T>>[];
    data.forEach((element) {
      if (element.checked!) {
        selected.add(element);
      }
      if (element.children.length > 0) {
        selected.addAll(getSelected(element.children));
      }
    });
    return selected;
  }
}
