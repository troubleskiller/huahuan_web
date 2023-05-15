import 'package:flutter/material.dart';
import 'package:huahuan_web/model/admin/project_model.dart';

class EventModel extends ChangeNotifier {
  ProjectModel? nowEvent;
  ProjectModel? nowProject;
  List<ProjectModel>? nowEvents;
  List<ProjectModel>? nowProjects;

  updateEventModel(
      {ProjectModel? nE,
      ProjectModel? nP,
      List<ProjectModel>? nEs,
      List<ProjectModel>? nPs}) {
    if (nE != null) nowEvent = nE;
    if (nP != null) nowProject = nP;
    if (nEs != null) nowEvents = nEs;
    if (nPs != null) nowProjects = nPs;
    print('更新了项目 provider');
    notifyListeners();
  }
}
