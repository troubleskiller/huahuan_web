import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:huahuan_web/api/project_api.dart';
import 'package:huahuan_web/model/admin/project_model.dart';
import 'package:huahuan_web/model/admin/role_model.dart';
import 'package:huahuan_web/util/store_util.dart';
import 'package:huahuan_web/util/tro_util.dart';
import 'package:huahuan_web/widget/button/icon_button.dart';
import 'package:huahuan_web/widget/input/TroInput.dart';

class ProjectEdit extends StatefulWidget {
  final ProjectModel? curProject;

  const ProjectEdit({Key? key, this.curProject}) : super(key: key);

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

  ///得到所有可用的角色权限
  void getAllRolesAccessible() async {
    // roles = await RoleApi.selectAllRole(widget.userInfo.id)
  }

  @override
  Widget build(BuildContext context) {
    var form = Form(
      key: formKey,
      child: Wrap(
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

          ///todo：上传图片
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
            // UserApi.saveOrUpdate(_curProject!.toMap()).then((res) {
            //   Navigator.pop(context, true);
            //   TroUtils.message('saved');
            // });
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
      height: isDisplayDesktop(context) ? 350 : 500,
      child: result,
    );
  }
}
