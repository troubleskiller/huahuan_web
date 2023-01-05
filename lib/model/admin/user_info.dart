import 'package:huahuan_web/model/admin/Customer_model.dart';
import 'package:huahuan_web/model/admin/role_model.dart';
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
    this.customerModel,
    this.roles,
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
      customerModel: json['customer'] != null
          ? CustomerModel.fromJson(json['customer'])
          : null,
      roles: json['roles'] != null
          ? List.from(json['roles']).map((e) => Role.fromJson(e)).toList()
          : null,
    );
  }

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

  ///用户权限
  List<Role>? roles;

  //用户所属公司
  CustomerModel? customerModel;

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
    map['customerModel'] = customerModel;
    if (roles != null) {
      map['roles'] = roles?.map((v) => v.toJson()).toList();
    }
    if (customerModel != null) {
      map['customer'] = customerModel?.toJson();
    }
    return map;
  }
}
