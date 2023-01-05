class Role {
  Role({
    this.id,
    this.name,
    this.isDel,
  });

  Role.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    isDel = json['isDel'];
  }
  int? id;
  String? name;
  int? isDel;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['isDel'] = isDel;
    return map;
  }
}
