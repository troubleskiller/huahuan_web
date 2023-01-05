import 'package:huahuan_web/model/admin/treeVo.dart';

class CategoryModel extends TreeData {
  CategoryModel(
      {this.id,
      this.name,
      this.pid,
      this.catLevel,
      this.showStatus,
      this.sort,
      this.icon,
      this.productUnit,
      this.productCount,
      this.children})
      : super(id, pid);

  factory CategoryModel.fromJson(dynamic json) {
    return CategoryModel(
      id: json['catId'],
      name: json['name'],
      pid: json['parentCid'],
      catLevel: json['catLevel'],
      showStatus: json['showStatus'],
      sort: json['sort'],
      icon: json['icon'],
      productUnit: json['productUnit'],
      productCount: json['productCount'],
      children: json['children'],
    );
  }

  bool? selected;
  int? id;
  String? name;
  int? pid;
  int? catLevel;
  int? showStatus;
  int? sort;
  dynamic icon;
  dynamic productUnit;
  int? productCount;

  //树状结构，三级表
  dynamic children;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['catId'] = id;
    map['name'] = name;
    map['parentCid'] = pid;
    map['catLevel'] = catLevel;
    map['showStatus'] = showStatus;
    map['sort'] = sort;
    map['icon'] = icon;
    map['productUnit'] = productUnit;
    map['productCount'] = productCount;
    map['children'] = children;
    return map;
  }
}
