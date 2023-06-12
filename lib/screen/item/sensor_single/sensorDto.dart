class SensorDto {
  SensorDto({
    this.sensorSn,
    this.created,
    this.tested,
    this.sensorType,
    this.channel,
    this.ain,
    this.value,
    this.temperature,
  });

  SensorDto.fromJson(dynamic json) {
    sensorSn = json['sensorSn'];
    created = json['created'];
    tested = json['tested'];
    sensorType = json['sensorType'];
    channel = json['channel'];
    ain = json['ain'];
    value = json['value'];
    temperature = json['temperature'];
  }
  String? sensorSn;
  String? created;
  String? tested;
  int? sensorType;
  dynamic channel;
  double? ain;
  double? value;
  double? temperature;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['sensorSn'] = sensorSn;
    map['created'] = created;
    map['tested'] = tested;
    map['sensorType'] = sensorType;
    map['channel'] = channel;
    map['ain'] = ain;
    map['value'] = value;
    map['temperature'] = temperature;
    return map;
  }
}
