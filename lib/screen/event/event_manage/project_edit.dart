import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:huahuan_web/api/project_api.dart';
import 'package:huahuan_web/model/admin/project_model.dart';
import 'package:huahuan_web/model/admin/role_model.dart';
import 'package:huahuan_web/util/store_util.dart';
import 'package:huahuan_web/util/tro_util.dart';
import 'package:huahuan_web/widget/button/icon_button.dart';
import 'package:huahuan_web/widget/common/image_upload.dart';
import 'package:huahuan_web/widget/input/TroInput.dart';

class ProjectEdit extends StatefulWidget {
  final ProjectModel? curProject;
  final Uint8List? bytes;
  const ProjectEdit({Key? key, this.curProject, this.bytes}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ProjectEditState();
  }
}

class ProjectEditState extends State<ProjectEdit> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ProjectModel? _curProject = ProjectModel();
  List<Role> roles = [];

  @override
  void initState() {
    super.initState();
    if (widget.curProject != null) {
      _curProject = widget.curProject;
    }
  }

  _upload({ProjectModel? projectModel}) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: ImageUpload(
          id: projectModel?.id,
          type: 5,
        ),
      ),
    );
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
            label: '项目名称',
            onSaved: (v) {
              _curProject!.name = v;
            },
            validator: (v) {
              return v!.isEmpty ? 'required' : null;
            },
          ),
          TroInput(
            value: _curProject!.location,
            label: '地理位置（经纬度）',
            onSaved: (v) {
              _curProject!.location = v;
            },
          ),
          TroInput(
            value: _curProject!.description,
            label: '项目概述',
            onSaved: (v) {
              _curProject!.description = v;
            },
          ),
          GestureDetector(
            child: widget.bytes != null
                ? Image.memory(widget.bytes!)
                : Image.network(
                    'https://t7.baidu.com/it/u=1595072465,3644073269&fm=193&f=GIF',
                    fit: BoxFit.cover,
                  ),
            onTap: () {
              _upload(projectModel: widget.curProject);
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
        title: Text(widget.curProject == null ? '添加新项目' : '修改项目信息'),
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
      width: 650,
      height: 400,
      child: result,
    );
  }
}
