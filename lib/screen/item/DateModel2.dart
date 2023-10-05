class DateModel2 {
  DateModel2({
    this.id,
    this.sn,
    this.name,
    this.location,
    this.curTime,
    this.refTime,
    this.curValueX,
    this.curValueY,
    this.refValueX,
    this.refValueY,
    this.curShapeX,
    this.curShapeY,
    this.refShapeX,
    this.refShapeY,
    this.curOffsetX,
    this.curOffsetY,
    this.curShapeOffsetX,
    this.curShapeOffsetY,
    this.shapeOffsetX,
    this.shapeOffsetY,
  });

  DateModel2.fromJson(dynamic json) {
    id = json['id'];
    sn = json['sn'];
    name = json['name'];
    location = json['location'];
    curValueX = json['curValueX'];
    curValueY = json['curValueY'];
    refValueX = json['refValueX'];
    refValueY = json['refValueY'];
    curTime = json['curTime'];
    refTime = json['refTime'];
    offSetX = json['offSetX'];
    offSetY = json['offSetY'];
    curShapeX = json['curShapeX'];
    curOffsetY = json['curOffsetY'];
    curOffsetX = json['curOffsetX'];
    curShapeY = json['curShapeY'];
    refShapeX = json['refShapeX'];
    refShapeY = json['refShapeY'];
    curShapeOffsetX = json['curShapeOffsetX'];
    curShapeOffsetY = json['curShapeOffsetY'];
    shapeOffsetX = json['shapeOffsetX'];
    shapeOffsetY = json['shapeOffsetY'];
  }
  num? id;
  String? sn;
  String? name;
  String? location;
  String? curTime;
  String? refTime;
  num? curValueX;
  num? curValueY;
  num? refValueX;
  num? refValueY;
  num? offSetX;
  num? offSetY;
  num? curOffsetX;
  num? curOffsetY;
  num? curShapeX;
  num? curShapeY;
  num? refShapeX;
  num? refShapeY;
  num? curShapeOffsetX;
  num? curShapeOffsetY;
  num? shapeOffsetX;
  num? shapeOffsetY;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['sn'] = sn;
    map['name'] = name;
    map['location'] = location;
    map['curValueX'] = curValueX;
    map['refTime'] = refTime;
    map['curTime'] = curTime;
    map['curValueY'] = curValueY;
    map['refValueX'] = refValueX;
    map['refValueY'] = refValueY;
    map['curShapeX'] = curShapeX;
    map['curShapeY'] = curShapeY;
    map['offSetX'] = offSetX;
    map['offSetY'] = offSetY;
    map['curOffsetX'] = curOffsetX;
    map['curOffsetY'] = curOffsetY;
    map['refShapeX'] = refShapeX;
    map['refShapeY'] = refShapeY;
    map['curShapeOffsetX'] = curShapeOffsetX;
    map['curShapeOffsetY'] = curShapeOffsetY;
    map['shapeOffsetX'] = shapeOffsetX;
    map['shapeOffsetY'] = shapeOffsetY;
    return map;
  }
}
