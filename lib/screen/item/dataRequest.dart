class DataRequest {
  DataRequest({
    this.id,
    this.statDate,
    this.type,
    this.direction,
    this.endDate,
    this.sampMinutes,
  });

  DataRequest.fromJson(dynamic json) {
    id = json['id'];
    statDate = json['statDate'];
    direction = json['direction'];
    type = json['type'];
    endDate = json['endDate'];
    sampMinutes = json['sampMinutes'];
  }
  int? id;
  String? statDate;
  int? direction;
  int? type;
  int? sampMinutes;
  String? endDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['statDate'] = statDate;
    map['direction'] = direction;
    map['type'] = type;
    map['endDate'] = endDate;
    map['sampMinutes'] = sampMinutes;
    return map;
  }
}
