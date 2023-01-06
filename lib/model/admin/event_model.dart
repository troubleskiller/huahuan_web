/// created : 1672889931163
/// description : "123"
/// location : "123"
/// name : "123"
/// parentProjectId : 123
/// projectTypeId : 123
/// status : 123
/// userId : 123

class EventModel {
  EventModel({
      this.created, 
      this.description, 
      this.location, 
      this.name, 
      this.parentProjectId, 
      this.projectTypeId, 
      this.status, 
      this.userId,});

  EventModel.fromJson(dynamic json) {
    created = json['created'];
    description = json['description'];
    location = json['location'];
    name = json['name'];
    parentProjectId = json['parentProjectId'];
    projectTypeId = json['projectTypeId'];
    status = json['status'];
    userId = json['userId'];
  }
  int? created;
  String? description;
  String? location;
  String? name;
  int? parentProjectId;
  int? projectTypeId;
  int? status;
  int? userId;
EventModel copyWith({  int? created,
  String? description,
  String? location,
  String? name,
  int? parentProjectId,
  int? projectTypeId,
  int? status,
  int? userId,
}) => EventModel(  created: created ?? this.created,
  description: description ?? this.description,
  location: location ?? this.location,
  name: name ?? this.name,
  parentProjectId: parentProjectId ?? this.parentProjectId,
  projectTypeId: projectTypeId ?? this.projectTypeId,
  status: status ?? this.status,
  userId: userId ?? this.userId,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['created'] = created;
    map['description'] = description;
    map['location'] = location;
    map['name'] = name;
    map['parentProjectId'] = parentProjectId;
    map['projectTypeId'] = projectTypeId;
    map['status'] = status;
    map['userId'] = userId;
    return map;
  }

}