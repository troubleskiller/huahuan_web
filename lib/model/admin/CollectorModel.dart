class CollectorModel {
  CollectorModel({
    this.id,
    this.sn,
    this.name,
    this.port,
    this.collectorTypeId,
    this.cycle,
    this.downString,
    this.isDown,
    this.created,
    this.simNum,
    this.userId,
    this.status, //状态
    this.projectId,
    this.isEnable,
    this.bat, //电池
    this.csq, //信号
    this.gpsLon, //1
    this.gpsLat, //2
  });

  CollectorModel.fromJson(dynamic json) {
    id = json['id'];
    sn = json['sn'];
    name = json['name'];
    port = json['port'];
    simNum = json['simNum'];
    collectorTypeId = json['collectorTypeId'];
    cycle = json['cycle'];
    downString = json['downString'];
    isDown = json['isDown'];
    created = json['created'];
    userId = json['userId'];
    status = json['status'];
    projectId = json['projectId'];
    isEnable = json['isEnable'];
    bat = json['bat'];
    csq = json['csq'];
    gpsLon = json['gpsLon'];
    gpsLat = json['gpsLat'];
  }
  int? id;
  String? sn;
  String? name;
  int? port;
  int? collectorTypeId;
  int? cycle;
  dynamic downString;
  int? isDown;
  String? created;
  String? userId;
  String? simNum;
  int? status;
  int? projectId;
  int? isEnable;
  int? bat;
  int? csq;
  double? gpsLon;
  double? gpsLat;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['sn'] = sn;
    map['name'] = name;
    map['port'] = port;
    map['collectorTypeId'] = collectorTypeId;
    map['cycle'] = cycle;
    map['downString'] = downString;
    map['isDown'] = isDown;
    map['simNum'] = simNum;
    map['created'] = created;
    map['userId'] = userId;
    map['status'] = status;
    map['projectId'] = projectId;
    map['isEnable'] = isEnable;
    map['bat'] = bat;
    map['csq'] = csq;
    map['gpsLon'] = gpsLon;
    map['gpsLat'] = gpsLat;
    return map;
  }
}
