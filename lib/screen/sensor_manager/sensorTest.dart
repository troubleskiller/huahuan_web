import 'dart:convert';

import 'package:huahuan_web/model/admin/CollectorModel.dart';

/// id : 1
/// name : "dyhhhjhki"
/// projectTypeId : 0
/// created : "2022-11-23T11:21:32.000+00:00"
/// userId : 2
/// status : 1
/// description : "打电话哈哈哈哈哈哈"
/// parentProjectId : 0
/// location : "121.29974,31.36881"
/// warningId : null
/// list : [{"id":2,"name":"曾-测试","projectTypeId":1,"created":"2022-11-11T04:54:28.000+00:00","userId":2,"status":1,"description":"","parentProjectId":1,"location":null,"warningId":null,"list":null,"collectors":[{"id":162,"sn":"863488055765922","name":"研发测试","port":55888,"collectorTypeId":1,"cycle":1800,"downString":null,"isDown":0,"created":"2022-12-29T06:39:14.000+00:00","userId":"1","status":0,"projectId":2,"isEnable":1},{"id":240,"sn":"868739051509515","name":"node","port":31311,"collectorTypeId":9,"cycle":3600,"downString":null,"isDown":0,"created":"2023-02-20T03:40:27.000+00:00","userId":"2","status":0,"projectId":2,"isEnable":1},{"id":252,"sn":"861714055470490","name":"8通道振弦","port":31311,"collectorTypeId":9,"cycle":1800,"downString":null,"isDown":0,"created":"2023-02-22T07:52:58.000+00:00","userId":"1","status":0,"projectId":2,"isEnable":1},{"id":306,"sn":"861714055464451","name":"8通道振弦采集器","port":31311,"collectorTypeId":9,"cycle":3600,"downString":null,"isDown":0,"created":"2023-03-11T10:38:56.000+00:00","userId":"1","status":0,"projectId":2,"isEnable":1},{"id":397,"sn":"861714055466068","name":"水位","port":31311,"collectorTypeId":6,"cycle":3600,"downString":null,"isDown":0,"created":"2023-04-06T04:24:44.000+00:00","userId":"1","status":0,"projectId":2,"isEnable":1}]},{"id":6,"name":"9号楼内部沉降","projectTypeId":2,"created":"2023-01-11T10:35:01.000+00:00","userId":8,"status":1,"description":"","parentProjectId":1,"location":null,"warningId":null,"list":null,"collectors":null},{"id":18,"name":"测斜JZP17","projectTypeId":4,"created":"2023-02-08T10:04:05.000+00:00","userId":1,"status":1,"description":"","parentProjectId":1,"location":null,"warningId":null,"list":null,"collectors":null},{"id":71,"name":"节点电量","projectTypeId":1,"created":"2023-02-02T02:51:49.000+00:00","userId":2,"status":1,"description":"","parentProjectId":1,"location":null,"warningId":null,"list":null,"collectors":null},{"id":72,"name":"新节点测试（车间）","projectTypeId":1,"created":"2023-02-06T02:07:53.000+00:00","userId":2,"status":1,"description":"新节点测试（勿动）","parentProjectId":1,"location":null,"warningId":null,"list":null,"collectors":[{"id":230,"sn":"868739051505141","name":"节点-69361","port":31311,"collectorTypeId":9,"cycle":3600,"downString":null,"isDown":0,"created":"2023-02-16T03:28:52.000+00:00","userId":"2","status":0,"projectId":72,"isEnable":1},{"id":231,"sn":"868739051511438","name":"节点-69378","port":31311,"collectorTypeId":9,"cycle":3600,"downString":null,"isDown":0,"created":"2023-02-16T04:00:35.000+00:00","userId":"2","status":0,"projectId":72,"isEnable":1},{"id":232,"sn":"868739051514689","name":"节点-69381","port":31311,"collectorTypeId":9,"cycle":3600,"downString":null,"isDown":0,"created":"2023-02-16T05:27:53.000+00:00","userId":"2","status":0,"projectId":72,"isEnable":1},{"id":233,"sn":"868739051504797","name":"节点-69382","port":31311,"collectorTypeId":9,"cycle":3600,"downString":null,"isDown":0,"created":"2023-02-16T05:44:35.000+00:00","userId":"2","status":0,"projectId":72,"isEnable":1},{"id":235,"sn":"868739051514572","name":"节点-69363","port":31311,"collectorTypeId":9,"cycle":3600,"downString":null,"isDown":0,"created":"2023-02-17T02:31:56.000+00:00","userId":"2","status":0,"projectId":72,"isEnable":1},{"id":236,"sn":"868739051511396","name":"节点-69384","port":31311,"collectorTypeId":9,"cycle":3600,"downString":null,"isDown":0,"created":"2023-02-17T03:35:11.000+00:00","userId":"2","status":0,"projectId":72,"isEnable":1},{"id":327,"sn":"868739051505034","name":"节点-69635","port":31311,"collectorTypeId":9,"cycle":3600,"downString":null,"isDown":0,"created":"2023-03-14T05:24:20.000+00:00","userId":"2","status":0,"projectId":72,"isEnable":1},{"id":374,"sn":"861714055470797","name":"新节点-63133","port":31311,"collectorTypeId":9,"cycle":3600,"downString":null,"isDown":0,"created":"2023-03-31T06:36:33.000+00:00","userId":"2","status":0,"projectId":72,"isEnable":1},{"id":375,"sn":"861714055472306","name":"新节点-63134","port":31311,"collectorTypeId":9,"cycle":3600,"downString":null,"isDown":0,"created":"2023-03-31T07:15:47.000+00:00","userId":"2","status":0,"projectId":72,"isEnable":1},{"id":376,"sn":"861714055469583","name":"新节点-63137","port":31311,"collectorTypeId":9,"cycle":3600,"downString":null,"isDown":0,"created":"2023-03-31T07:29:35.000+00:00","userId":"2","status":0,"projectId":72,"isEnable":1},{"id":395,"sn":"861714054470730","name":"新节点-65851","port":31311,"collectorTypeId":9,"cycle":3600,"downString":null,"isDown":0,"created":"2023-04-06T02:04:50.000+00:00","userId":"2","status":0,"projectId":72,"isEnable":1},{"id":396,"sn":"861714055472223","name":"新节点-65852","port":31311,"collectorTypeId":9,"cycle":3600,"downString":null,"isDown":0,"created":"2023-04-06T02:20:44.000+00:00","userId":"2","status":0,"projectId":72,"isEnable":1}]},{"id":85,"name":"洪山坡1","projectTypeId":2,"created":"2023-03-09T09:43:42.000+00:00","userId":2,"status":1,"description":"","parentProjectId":1,"location":null,"warningId":null,"list":null,"collectors":[{"id":299,"sn":"861714055472157","name":"洪山坡","port":55888,"collectorTypeId":1,"cycle":3600,"downString":null,"isDown":0,"created":"2023-03-09T09:47:08.000+00:00","userId":"2","status":0,"projectId":85,"isEnable":1}]},{"id":88,"name":"建科风压采集器测向","projectTypeId":1,"created":"2023-03-15T03:31:31.000+00:00","userId":2,"status":1,"description":"","parentProjectId":1,"location":null,"warningId":null,"list":null,"collectors":[{"id":331,"sn":"868739051505885","name":"建科测向2","port":31311,"collectorTypeId":6,"cycle":3600,"downString":null,"isDown":0,"created":"2023-03-15T03:33:19.000+00:00","userId":"2","status":0,"projectId":88,"isEnable":1},{"id":332,"sn":"868739051516742","name":"建科测向3","port":31311,"collectorTypeId":6,"cycle":3600,"downString":null,"isDown":0,"created":"2023-03-15T03:33:47.000+00:00","userId":"2","status":0,"projectId":88,"isEnable":1},{"id":333,"sn":"868739051506354","name":"建科测向4","port":31311,"collectorTypeId":6,"cycle":3600,"downString":null,"isDown":0,"created":"2023-03-15T03:34:14.000+00:00","userId":"2","status":0,"projectId":88,"isEnable":1},{"id":334,"sn":"868739051506339","name":"建科测向5","port":31311,"collectorTypeId":6,"cycle":3600,"downString":null,"isDown":0,"created":"2023-03-15T03:34:37.000+00:00","userId":"2","status":0,"projectId":88,"isEnable":1},{"id":335,"sn":"868739051509242","name":"建科测向6","port":55888,"collectorTypeId":6,"cycle":3600,"downString":null,"isDown":0,"created":"2023-03-15T03:35:42.000+00:00","userId":"2","status":0,"projectId":88,"isEnable":1},{"id":336,"sn":"868739051506115","name":"建科测向7","port":31311,"collectorTypeId":6,"cycle":3600,"downString":null,"isDown":0,"created":"2023-03-15T03:53:25.000+00:00","userId":"2","status":0,"projectId":88,"isEnable":1},{"id":337,"sn":"868739051506313","name":"建科测向8","port":31311,"collectorTypeId":6,"cycle":3600,"downString":null,"isDown":0,"created":"2023-03-15T03:53:56.000+00:00","userId":"2","status":0,"projectId":88,"isEnable":1},{"id":338,"sn":"868739051516817","name":"建科测向9","port":31311,"collectorTypeId":6,"cycle":3600,"downString":null,"isDown":0,"created":"2023-03-15T03:54:18.000+00:00","userId":"2","status":0,"projectId":88,"isEnable":1},{"id":339,"sn":"868739051505679","name":"建科测向10","port":31311,"collectorTypeId":6,"cycle":3600,"downString":null,"isDown":0,"created":"2023-03-15T03:54:40.000+00:00","userId":"2","status":0,"projectId":88,"isEnable":1},{"id":340,"sn":"868739051510380","name":"建科测向11","port":31311,"collectorTypeId":6,"cycle":3600,"downString":null,"isDown":0,"created":"2023-03-15T03:55:00.000+00:00","userId":"2","status":0,"projectId":88,"isEnable":1},{"id":341,"sn":"868739051505828","name":"建科测向12","port":31311,"collectorTypeId":6,"cycle":3600,"downString":null,"isDown":0,"created":"2023-03-15T03:55:33.000+00:00","userId":"2","status":0,"projectId":88,"isEnable":1},{"id":342,"sn":"868739051510364","name":"建科测向13","port":31311,"collectorTypeId":6,"cycle":3600,"downString":null,"isDown":0,"created":"2023-03-15T03:56:01.000+00:00","userId":"2","status":0,"projectId":88,"isEnable":1},{"id":343,"sn":"868739051514630","name":"建科测向14","port":31311,"collectorTypeId":6,"cycle":3600,"downString":null,"isDown":0,"created":"2023-03-15T03:56:32.000+00:00","userId":"2","status":0,"projectId":88,"isEnable":1},{"id":344,"sn":"868739051509341","name":"建科测向15","port":31311,"collectorTypeId":6,"cycle":3600,"downString":null,"isDown":0,"created":"2023-03-15T03:57:04.000+00:00","userId":"2","status":0,"projectId":88,"isEnable":1},{"id":345,"sn":"868739051510315","name":"建科测向16","port":31311,"collectorTypeId":6,"cycle":3600,"downString":null,"isDown":0,"created":"2023-03-15T03:57:32.000+00:00","userId":"2","status":0,"projectId":88,"isEnable":1},{"id":346,"sn":"868739051509507","name":"建科测向1","port":31311,"collectorTypeId":6,"cycle":3600,"downString":null,"isDown":0,"created":"2023-03-15T07:15:53.000+00:00","userId":"2","status":0,"projectId":88,"isEnable":1}]},{"id":90,"name":"徐晖的测项测试","projectTypeId":0,"created":"2023-03-25T09:14:06.000+00:00","userId":1,"status":1,"description":"测试一下","parentProjectId":1,"location":null,"warningId":null,"list":null,"collectors":null},{"id":91,"name":"车间无线水位计测试","projectTypeId":1,"created":"2023-03-31T07:44:27.000+00:00","userId":2,"status":1,"description":"","parentProjectId":1,"location":null,"warningId":null,"list":null,"collectors":[{"id":377,"sn":"861714055467892","name":"（长期）无线水位-63123","port":31311,"collectorTypeId":9,"cycle":3600,"downString":null,"isDown":0,"created":"2023-03-31T07:45:41.000+00:00","userId":"2","status":0,"projectId":91,"isEnable":1},{"id":378,"sn":"861714055467884","name":"（长期）无线水位-63129","port":31311,"collectorTypeId":9,"cycle":3600,"downString":null,"isDown":0,"created":"2023-03-31T07:54:49.000+00:00","userId":"2","status":0,"projectId":91,"isEnable":1},{"id":379,"sn":"861714055467827","name":"（长期）无线水位-63130","port":31311,"collectorTypeId":9,"cycle":3600,"downString":null,"isDown":0,"created":"2023-03-31T08:04:24.000+00:00","userId":"2","status":0,"projectId":91,"isEnable":1},{"id":380,"sn":"861714055467850","name":"（长期）无线水位-63131","port":31311,"collectorTypeId":9,"cycle":3600,"downString":null,"isDown":0,"created":"2023-03-31T08:09:49.000+00:00","userId":"2","status":0,"projectId":91,"isEnable":1},{"id":381,"sn":"861714055467942","name":"（长期）无线水位-63132","port":31311,"collectorTypeId":9,"cycle":3600,"downString":null,"isDown":0,"created":"2023-03-31T08:29:10.000+00:00","userId":"2","status":0,"projectId":91,"isEnable":1}]},{"id":94,"name":"","projectTypeId":1,"created":"2023-04-03T03:33:51.000+00:00","userId":2,"status":1,"description":"","parentProjectId":1,"location":null,"warningId":null,"list":null,"collectors":null},{"id":100,"name":"16通道无线采集仪（车间测试）","projectTypeId":1,"created":"2023-04-04T01:36:25.000+00:00","userId":2,"status":1,"description":"车间测试，勿动","parentProjectId":1,"location":null,"warningId":null,"list":null,"collectors":null}]
/// collectors : null

SensorTest sensorTestFromJson(String str) =>
    SensorTest.fromJson(json.decode(str));
String sensorTestToJson(SensorTest data) => json.encode(data.toJson());

class SensorTest {
  SensorTest({
    this.id,
    this.name,
    this.projectTypeId,
    this.created,
    this.userId,
    this.status,
    this.description,
    this.parentProjectId,
    this.location,
    this.warningId,
    this.list,
    this.collectors,
  });

  SensorTest.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    projectTypeId = json['projectTypeId'];
    created = json['created'];
    userId = json['userId'];
    status = json['status'];
    description = json['description'];
    parentProjectId = json['parentProjectId'];
    location = json['location'];
    warningId = json['warningId'];
    if (json['list'] != null) {
      list = [];
      json['list'].forEach((v) {
        list?.add(SensorP.fromJson(v));
      });
    }
    collectors = json['collectors'];
  }
  int? id;
  String? name;
  int? projectTypeId;
  String? created;
  int? userId;
  int? status;
  String? description;
  int? parentProjectId;
  String? location;
  dynamic warningId;
  List<SensorP>? list;
  dynamic collectors;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['projectTypeId'] = projectTypeId;
    map['created'] = created;
    map['userId'] = userId;
    map['status'] = status;
    map['description'] = description;
    map['parentProjectId'] = parentProjectId;
    map['location'] = location;
    map['warningId'] = warningId;
    if (list != null) {
      map['list'] = list?.map((v) => v.toJson()).toList();
    }
    map['collectors'] = collectors;
    return map;
  }
}

/// id : 2
/// name : "曾-测试"
/// projectTypeId : 1
/// created : "2022-11-11T04:54:28.000+00:00"
/// userId : 2
/// status : 1
/// description : ""
/// parentProjectId : 1
/// location : null
/// warningId : null
/// list : null
/// collectors : [{"id":162,"sn":"863488055765922","name":"研发测试","port":55888,"collectorTypeId":1,"cycle":1800,"downString":null,"isDown":0,"created":"2022-12-29T06:39:14.000+00:00","userId":"1","status":0,"projectId":2,"isEnable":1},{"id":240,"sn":"868739051509515","name":"node","port":31311,"collectorTypeId":9,"cycle":3600,"downString":null,"isDown":0,"created":"2023-02-20T03:40:27.000+00:00","userId":"2","status":0,"projectId":2,"isEnable":1},{"id":252,"sn":"861714055470490","name":"8通道振弦","port":31311,"collectorTypeId":9,"cycle":1800,"downString":null,"isDown":0,"created":"2023-02-22T07:52:58.000+00:00","userId":"1","status":0,"projectId":2,"isEnable":1},{"id":306,"sn":"861714055464451","name":"8通道振弦采集器","port":31311,"collectorTypeId":9,"cycle":3600,"downString":null,"isDown":0,"created":"2023-03-11T10:38:56.000+00:00","userId":"1","status":0,"projectId":2,"isEnable":1},{"id":397,"sn":"861714055466068","name":"水位","port":31311,"collectorTypeId":6,"cycle":3600,"downString":null,"isDown":0,"created":"2023-04-06T04:24:44.000+00:00","userId":"1","status":0,"projectId":2,"isEnable":1}]

SensorP listFromJson(String str) => SensorP.fromJson(json.decode(str));
String listToJson(SensorP data) => json.encode(data.toJson());

class SensorP {
  SensorP({
    this.id,
    this.name,
    this.projectTypeId,
    this.created,
    this.userId,
    this.status,
    this.description,
    this.parentProjectId,
    this.location,
    this.warningId,
    this.list,
    this.collectors,
  });

  SensorP.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    projectTypeId = json['projectTypeId'];
    created = json['created'];
    userId = json['userId'];
    status = json['status'];
    description = json['description'];
    parentProjectId = json['parentProjectId'];
    location = json['location'];
    warningId = json['warningId'];
    list = json['list'];
    if (json['collectors'] != null) {
      collectors = [];
      json['collectors'].forEach((v) {
        collectors?.add(CollectorModel.fromJson(v));
      });
    }
  }
  int? id;
  String? name;
  int? projectTypeId;
  String? created;
  int? userId;
  int? status;
  String? description;
  int? parentProjectId;
  dynamic location;
  dynamic warningId;
  dynamic list;
  List<CollectorModel>? collectors;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['projectTypeId'] = projectTypeId;
    map['created'] = created;
    map['userId'] = userId;
    map['status'] = status;
    map['description'] = description;
    map['parentProjectId'] = parentProjectId;
    map['location'] = location;
    map['warningId'] = warningId;
    map['list'] = list;
    if (collectors != null) {
      map['collectors'] = collectors?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : 162
/// sn : "863488055765922"
/// name : "研发测试"
/// port : 55888
/// collectorTypeId : 1
/// cycle : 1800
/// downString : null
/// isDown : 0
/// created : "2022-12-29T06:39:14.000+00:00"
/// userId : "1"
/// status : 0
/// projectId : 2
/// isEnable : 1
