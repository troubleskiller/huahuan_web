import 'dart:convert';

/// id : 1
/// name : "华桓电子科技有限公司"
/// logo : null
/// title : null
/// image : null
/// created : "2022-12-01T02:30:04.000+00:00"
/// address : "上海嘉定"
/// tel : "021-59552853"
/// userId : 1

CustomerModel customerModelFromJson(String str) =>
    CustomerModel.fromJson(json.decode(str));
String customerModelToJson(CustomerModel data) => json.encode(data.toJson());

class CustomerModel {
  CustomerModel({
    this.id,
    this.name,
    this.logo,
    this.title,
    this.image,
    this.created,
    this.address,
    this.tel,
    this.userId,
  });

  CustomerModel.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    logo = json['logo'];
    title = json['title'];
    image = json['image'];
    created = json['created'];
    address = json['address'];
    tel = json['tel'];
    userId = json['userId'];
  }
  int? id;
  String? name;
  dynamic logo;
  dynamic title;
  dynamic image;
  String? created;
  String? address;
  String? tel;
  int? userId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['logo'] = logo;
    map['title'] = title;
    map['image'] = image;
    map['created'] = created;
    map['address'] = address;
    map['tel'] = tel;
    map['userId'] = userId;
    return map;
  }
}
