import 'package:flutter/material.dart';
import 'package:huahuan_web/model/admin/project_model.dart';
class EventList extends StatefulWidget {
  const EventList({Key? key, required this.events}) : super(key: key);
  final List<ProjectModel> events;

  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children:
        widget.events.map((e) => Text(e.name??'')).toList(),
    );
  }
}
