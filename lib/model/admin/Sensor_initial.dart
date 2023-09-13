import 'dart:convert';

/// sn : "6"
/// date : "2023-04-03 14:06:44"
/// value : "1"

SensorInitial sensorInitialFromJson(String str) =>
    SensorInitial.fromJson(json.decode(str));
String sensorInitialToJson(SensorInitial data) => json.encode(data.toJson());

class SensorInitial {
  SensorInitial({
    this.sn,
    this.date,
    this.value,
  });

  SensorInitial.fromJson(dynamic json) {
    sn = json['sn'];
    date = json['date'];
    value = json['value'];
  }
  String? sn;
  String? date;
  String? value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['sn'] = sn;
    map['date'] = date;
    map['value'] = value;
    return map;
  }
}
