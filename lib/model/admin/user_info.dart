import 'package:huahuan_web/model/admin/treeVo.dart';

class UserInfo extends TreeData {
  UserInfo({
    this.id,
    this.name,
    this.loginName,
    this.password,
    this.tel,
    this.isDel,
    this.creatorId,
    this.customerId,
    this.isEnable,
    this.created,
  }) : super(id, creatorId);

  factory UserInfo.fromJson(dynamic json) {
    return UserInfo(
      id: json['id'],
      name: json['name'],
      loginName: json['loginName'],
      password: json['password'],
      tel: json['tel'],
      isDel: json['isDel'],
      creatorId: json['creatorId'],
      customerId: json['customerId'],
      isEnable: json['isEnable'],
      created: json['created'],
    );
  }

//是否被选择
  bool? selected;

  int? id;
  String? name;
  String? loginName;
  String? password;
  String? tel;
  int? isDel;
  int? creatorId;
  int? customerId;
  int? isEnable;
  String? created;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['loginName'] = loginName;
    map['password'] = password;
    map['tel'] = tel;
    map['isDel'] = isDel;
    map['creatorId'] = creatorId;
    map['customerId'] = customerId;
    map['isEnable'] = isEnable;
    map['created'] = created;
    return map;
  }
}
