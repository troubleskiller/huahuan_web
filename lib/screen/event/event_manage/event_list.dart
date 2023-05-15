import 'package:flutter/material.dart';
import 'package:huahuan_web/constant/common_constant.dart';
import 'package:huahuan_web/model/admin/project_model.dart';

class EventLine extends StatelessWidget {
  const EventLine(
      {Key? key,
      required this.event,
      required this.curProject,
      required this.onClick})
      : super(key: key);
  final ProjectModel event;
  final int curProject;
  final Function onClick;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          color: CommonConstant.backgroundColor),
      child: GestureDetector(
        onTap: () {
          onClick();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                event.name ?? '--',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Icon(Icons.arrow_right)
          ],
        ),
      ),
    );
  }
}
