import 'dart:convert';

/// id : 175
/// sn : "28F5A3BE34210165"
/// name : "Q08"
/// location : "K349+945.32"
/// curValue : 41.78
/// refValue : 41.7967
/// curOffset : 0.24009705
/// totalOffset : -1.1617031

DateModel dateModelFromJson(String str) => DateModel.fromJson(json.decode(str));
String dateModelToJson(DateModel data) => json.encode(data.toJson());

class DateModel {
  DateModel({
    this.id,
    this.sn,
    this.name,
    this.location,
    this.curValue,
    this.refValue,
    this.curOffset,
    this.totalOffset,
  });

  DateModel.fromJson(dynamic json) {
    id = json['id'];
    sn = json['sn'];
    name = json['name'];
    location = json['location'];
    curValue = json['curValue'];
    refValue = json['refValue'];
    curOffset = json['curOffset'];
    totalOffset = json['totalOffset'];
  }
  int? id;
  String? sn;
  String? name;
  String? location;
  double? curValue;
  double? refValue;
  double? curOffset;
  double? totalOffset;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['sn'] = sn;
    map['name'] = name;
    map['location'] = location;
    map['curValue'] = curValue;
    map['refValue'] = refValue;
    map['curOffset'] = curOffset;
    map['totalOffset'] = totalOffset;
    return map;
  }
}
