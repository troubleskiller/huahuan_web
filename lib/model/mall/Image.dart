class ImageDataModel {
  ImageDataModel({
    this.id,
    this.url,
    this.thisId,
    this.type,
    this.date,
  });

  ImageDataModel.fromJson(dynamic json) {
    id = json['id'];
    url = json['url'];
    thisId = json['thisId'];
    type = json['type'];
    date = json['date'];
  }
  int? id;
  String? url;
  int? thisId;
  int? type;
  String? date;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['url'] = url;
    map['thisId'] = thisId;
    map['type'] = type;
    map['date'] = date;
    return map;
  }
}
