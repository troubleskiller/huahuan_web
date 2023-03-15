class ProjectStateModel {
  ProjectStateModel({
      this.id, 
      this.projectId, 
      this.startTime, 
      this.endTime, 
      this.name, 
      this.description, 
      this.type, 
      this.imgId,});

  ProjectStateModel.fromJson(dynamic json) {
    id = json['id'];
    projectId = json['projectId'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    name = json['name'];
    description = json['description'];
    type = json['type'];
    imgId = json['imgId'];
  }
  int? id;
  int? projectId;
  String? startTime;
  String? endTime;
  String? name;
  String? description;
  int? type;
  int? imgId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['projectId'] = projectId;
    map['startTime'] = startTime;
    map['endTime'] = endTime;
    map['name'] = name;
    map['description'] = description;
    map['type'] = type;
    map['imgId'] = imgId;
    return map;
  }

}