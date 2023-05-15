class CollectorDto {
  CollectorDto({
    this.collectorSn,
    this.iccid,
    this.model,
    this.created,
    this.bat,
    this.csq,
    this.gpsLon,
    this.gpsLat,
    this.status,
  });

  CollectorDto.fromJson(dynamic json) {
    collectorSn = json['collectorSn'];
    iccid = json['iccid'];
    model = json['model'];
    created = json['created'];
    bat = json['bat'];
    csq = json['csq'];
    gpsLon = json['gpsLon'];
    gpsLat = json['gpsLat'];
    status = json['status'];
  }
  String? collectorSn;
  String? iccid;
  String? model;
  String? created;
  int? bat;
  int? csq;
  double? gpsLon;
  double? gpsLat;
  int? status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['collectorSn'] = collectorSn;
    map['iccid'] = iccid;
    map['model'] = model;
    map['created'] = created;
    map['bat'] = bat;
    map['csq'] = csq;
    map['gpsLon'] = gpsLon;
    map['gpsLat'] = gpsLat;
    map['status'] = status;
    return map;
  }
}
