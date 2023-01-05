import 'package:huahuan_web/model/admin/tabPage_model.dart';
import 'package:huahuan_web/model/admin/treeVo.dart';

/*
    {
"type": 1,
"url": "/test",
"icon": null,
"list": [

*/

class MenuModel extends TreeData {
  MenuModel({
    this.id,
    this.name,
    this.thisName,
    this.icon,
    this.parentId,
    this.url,
    this.type,
    //是否删除
    this.isDel,
  }) : super(id, parentId);

  factory MenuModel.fromJson(dynamic json) {
    return MenuModel(
      id: json['id'],
      name: json['name'],
      thisName: json['thisName'],
      icon: json['icon'],
      parentId: json['parentId'],
      url: json['url'],
      type: json['type'],
      isDel: json['isDel'],
    );
  }

  int? id;
  String? name;
  String? thisName;
  dynamic icon;
  int? parentId;
  String? url;
  int? type;
  int? isDel;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['thisName'] = thisName;
    map['icon'] = icon;
    map['parentId'] = parentId;
    map['url'] = url;
    map['type'] = type;
    map['isDel'] = isDel;
    return map;
  }

  toTabPage() {
    return TabPage(
      id: id,
      name: name,
      thisName: thisName,
      url: url,
    );
  }
}
