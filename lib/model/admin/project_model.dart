/// id : 69
/// name : "新节点测试"
/// projectTypeId : 1
/// created : "2023-01-13T09:49:12.000+00:00"
/// userId : 1
/// status : 1
/// description : ""
/// parentProjectId : 1
/// location : null
/// warningId : null

class ProjectModel {
  ProjectModel({
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
    this.events,
  });

  ProjectModel.fromJson(dynamic json) {
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
    events = json['list'] == null
        ? []
        : List.from(json['list']).map((e) => ProjectModel.fromJson(e)).toList();
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
  List<ProjectModel>? events;
  ProjectModel copyWith({
    int? id,
    String? name,
    int? projectTypeId,
    String? created,
    int? userId,
    int? status,
    String? description,
    int? parentProjectId,
    String? location,
    dynamic warningId,
  }) =>
      ProjectModel(
        id: id ?? this.id,
        name: name ?? this.name,
        projectTypeId: projectTypeId ?? this.projectTypeId,
        created: created ?? this.created,
        userId: userId ?? this.userId,
        status: status ?? this.status,
        description: description ?? this.description,
        parentProjectId: parentProjectId ?? this.parentProjectId,
        location: location ?? this.location,
        warningId: warningId ?? this.warningId,
      );
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
    return map;
  }
}
