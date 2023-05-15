import 'dart:convert';

/// id : 113
/// sn : "282212211122D3D9"
/// addr : 0
/// name : "CX16-01"
/// created : "2023-02-10T08:49:37.000+00:00"
/// collectorId : null
/// sensorTypeId : 2011
/// protocolTypeId : null
/// refSensorId : null
/// initTime : "2023-02-10T08:07:00.000+00:00"
/// initTemp : null
/// initValue : "1.543,2.131"
/// sensorOffset : "0.5"
/// sensorZero : "0"
/// sensorGroupName : null
/// userId : 1
/// holeDepth : 0.0
/// unitId : 1
/// projectId : 20
/// location : "00"
/// paramsEx : null
/// status : 0
/// sensorTypeName : "双轴测斜"
/// unitName : "mm"

SensorHoleModel sensorHoleModelFromJson(String str) =>
    SensorHoleModel.fromJson(json.decode(str));
String sensorHoleModelToJson(SensorHoleModel data) =>
    json.encode(data.toJson());

class SensorHoleModel {
  SensorHoleModel({
    this.id,
    this.sn,
    this.addr,
    this.name,
    this.created,
    this.collectorId,
    this.sensorTypeId,
    this.protocolTypeId,
    this.refSensorId,
    this.initTime,
    this.initTemp,
    this.initValue,
    this.sensorOffset,
    this.sensorZero,
    this.sensorGroupName,
    this.userId,
    this.holeDepth,
    this.unitId,
    this.projectId,
    this.location,
    this.paramsEx,
    this.status,
    this.sensorTypeName,
    this.unitName,
  });

  SensorHoleModel.fromJson(dynamic json) {
    id = json['id'];
    sn = json['sn'];
    addr = json['addr'];
    name = json['name'];
    created = json['created'];
    collectorId = json['collectorId'];
    sensorTypeId = json['sensorTypeId'];
    protocolTypeId = json['protocolTypeId'];
    refSensorId = json['refSensorId'];
    initTime = json['initTime'];
    initTemp = json['initTemp'];
    initValue = json['initValue'];
    sensorOffset = json['sensorOffset'];
    sensorZero = json['sensorZero'];
    sensorGroupName = json['sensorGroupName'];
    userId = json['userId'];
    holeDepth = json['holeDepth'];
    unitId = json['unitId'];
    projectId = json['projectId'];
    location = json['location'];
    paramsEx = json['paramsEx'];
    status = json['status'];
    sensorTypeName = json['sensorTypeName'];
    unitName = json['unitName'];
  }
  int? id;
  String? sn;
  int? addr;
  String? name;
  String? created;
  dynamic collectorId;
  int? sensorTypeId;
  dynamic protocolTypeId;
  int? refSensorId;
  String? initTime;
  dynamic initTemp;
  String? initValue;
  String? sensorOffset;
  String? sensorZero;
  dynamic sensorGroupName;
  int? userId;
  double? holeDepth;
  int? unitId;
  int? projectId;
  String? location;
  dynamic paramsEx;
  int? status;
  String? sensorTypeName;
  String? unitName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['sn'] = sn;
    map['addr'] = addr;
    map['name'] = name;
    map['created'] = created;
    map['collectorId'] = collectorId;
    map['sensorTypeId'] = sensorTypeId;
    map['protocolTypeId'] = protocolTypeId;
    map['refSensorId'] = refSensorId;
    map['initTime'] = initTime;
    map['initTemp'] = initTemp;
    map['initValue'] = initValue;
    map['sensorOffset'] = sensorOffset;
    map['sensorZero'] = sensorZero;
    map['sensorGroupName'] = sensorGroupName;
    map['userId'] = userId;
    map['holeDepth'] = holeDepth;
    map['unitId'] = unitId;
    map['projectId'] = projectId;
    map['location'] = location;
    map['paramsEx'] = paramsEx;
    map['status'] = status;
    map['sensorTypeName'] = sensorTypeName;
    map['unitName'] = unitName;
    return map;
  }
}
