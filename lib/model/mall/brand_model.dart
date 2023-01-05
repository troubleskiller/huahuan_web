import 'dart:convert';

/// brandId : 1
/// name : "华为"
/// logo : "www.baidu.com"
/// descript : "加油中国"
/// showStatus : 1
/// firstLetter : "H"
/// sort : 0

BrandModel brandModelFromJson(String str) =>
    BrandModel.fromJson(json.decode(str));
String brandModelToJson(BrandModel data) => json.encode(data.toJson());

class BrandModel {
  BrandModel({
    this.selected,
    this.brandId,
    this.name,
    this.logo,
    this.descript,
    this.showStatus,
    this.firstLetter,
    this.sort,
  });

  BrandModel.fromJson(dynamic json) {
    brandId = json['brandId'];
    name = json['name'];
    logo = json['logo'];
    descript = json['descript'];
    showStatus = json['showStatus'];
    firstLetter = json['firstLetter'];
    sort = json['sort'];
  }
  bool? selected;
  int? brandId;
  String? name;
  String? logo;
  String? descript;
  int? showStatus;
  String? firstLetter;
  int? sort;
  BrandModel copyWith({
    int? brandId,
    String? name,
    String? logo,
    String? descript,
    int? showStatus,
    String? firstLetter,
    int? sort,
  }) =>
      BrandModel(
        brandId: brandId ?? this.brandId,
        name: name ?? this.name,
        logo: logo ?? this.logo,
        descript: descript ?? this.descript,
        showStatus: showStatus ?? this.showStatus,
        firstLetter: firstLetter ?? this.firstLetter,
        sort: sort ?? this.sort,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['brandId'] = brandId;
    map['name'] = name;
    map['logo'] = logo;
    map['descript'] = descript;
    map['showStatus'] = showStatus;
    map['firstLetter'] = firstLetter;
    map['sort'] = sort;
    return map;
  }
}
