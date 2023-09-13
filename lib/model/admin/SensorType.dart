import 'dart:convert';

/// name : "param_k"
/// title : "轴力计k值"
/// type : "double"

SensorType sensorTypeFromJson(String str) =>
    SensorType.fromJson(json.decode(str));
String sensorTypeToJson(SensorType data) => json.encode(data.toJson());

class SensorType {
  SensorType({
    this.name,
    this.title,
    this.type,
  });

  SensorType.fromJson(dynamic json) {
    name = json['name'];
    title = json['title'];
    type = json['type'];
  }
  String? name;
  String? title;
  String? type;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['title'] = title;
    map['type'] = type;
    return map;
  }
}
