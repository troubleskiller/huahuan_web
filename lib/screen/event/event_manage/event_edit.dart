import 'package:flutter/material.dart';
import 'package:huahuan_web/api/project_api.dart';
import 'package:huahuan_web/constant/common_constant.dart';
import 'package:huahuan_web/model/admin/project_model.dart';
import 'package:huahuan_web/model/admin/role_model.dart';
import 'package:huahuan_web/util/store_util.dart';
import 'package:huahuan_web/util/tro_util.dart';
import 'package:huahuan_web/widget/button/icon_button.dart';
import 'package:huahuan_web/widget/input/TroInput.dart';
import 'package:huahuan_web/widget/input/TroSelect.dart';

class EventEdit extends StatefulWidget {
  final ProjectModel? curProject;
  final int? pId;

  const EventEdit({Key? key, this.curProject, this.pId}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return EventEditState();
  }
}

class EventEditState extends State<EventEdit> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ProjectModel? _curProject = ProjectModel();
  List<Role> roles = [];

  String? initValue;

  String? selectedValue;

  @override
  void initState() {
    super.initState();
    if (widget.curProject != null) {
      _curProject = widget.curProject;
      initValue = eventType[widget.curProject?.projectTypeId];
    }
  }

  @override
  Widget build(BuildContext context) {
    var form = Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TroInput(
            value: _curProject!.name,
            label: '测项名称',
            onSaved: (v) {
              _curProject!.name = v;
            },
            validator: (v) {
              return v!.isEmpty ? 'required' : null;
            },
          ),
          TroInput(
            value: _curProject!.description,
            label: '测项概述',
            onSaved: (v) {
              _curProject!.description = v;
            },
          ),
          TroSelect(
            value: initValue ?? '其它',
            dataList: eventType.values
                .map((e) => SelectOptionVO(value: e, label: e))
                .toList(),
            label: '测项类型',
            onChange: (newList) {
              selectedValue = newList;
              _curProject?.projectTypeId = eventTypeF[selectedValue];
            },
          ),
        ],
      ),
    );
    var buttonBar = ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        ButtonWithIcon(
          label: '保存',
          iconData: Icons.save,
          onPressed: () {
            FormState form = formKey.currentState!;
            if (!form.validate()) {
              return;
            }
            form.save();
            widget.curProject == null
                ? {
                    _curProject!.userId = StoreUtil.getCurrentUserInfo().id,
                    _curProject!.parentProjectId = widget.pId,
                    ProjectApi.addProject(_curProject!.toJson()).then((res) {
                      Navigator.pop(context, true);
                      TroUtils.message('saved');
                    })
                  }
                : ProjectApi.updateProject(_curProject!.toJson()).then((res) {
                    Navigator.pop(context, true);
                    TroUtils.message('saved');
                  });
          },
        ),
        ButtonWithIcon(
          label: '取消',
          iconData: Icons.cancel,
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
    var result = Scaffold(
      appBar: AppBar(
        title: Text(widget.curProject == null ? '添加测项' : '修改测项信息'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            form,
          ],
        ),
      ),
      bottomNavigationBar: buttonBar,
    );
    return SizedBox(
      width: 400,
      height: 400,
      child: result,
    );
  }
}
