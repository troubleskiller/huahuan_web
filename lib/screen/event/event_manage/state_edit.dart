import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:huahuan_web/api/project_api.dart';
import 'package:huahuan_web/model/admin/project_model.dart';
import 'package:huahuan_web/model/admin/project_state_model.dart';
import 'package:huahuan_web/model/admin/role_model.dart';
import 'package:huahuan_web/util/store_util.dart';
import 'package:huahuan_web/util/tro_util.dart';
import 'package:huahuan_web/widget/button/icon_button.dart';
import 'package:huahuan_web/widget/input/TroInput.dart';
import 'package:huahuan_web/widget/input/TroSelect.dart';

class StateEdit extends StatefulWidget {
  final ProjectStateModel? curState;

  const StateEdit({Key? key, this.curState}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return StateEditState();
  }
}

class StateEditState extends State<StateEdit> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ProjectStateModel? _curState = ProjectStateModel();
  List<Role> roles = [];
  int? _singleSelectedIndex;

  @override
  void initState() {
    super.initState();
    if (widget.curState != null) {
      _curState = widget.curState;
      _singleSelectedIndex = _curState!.type;
    }
  }


  @override
  Widget build(BuildContext context) {
    var form = Form(
      key: formKey,
      child: Wrap(
        children: <Widget>[

          Row(
            children: [
              TroInput(
                value: _curState!.name,
                label: '项目名称',
                onSaved: (v) {
                  _curState!.name = v;
                },
                validator: (v) {
                  return v!.isEmpty ? 'required' : null;
                },
              ),
              BrnRadioButton(
                disable: widget.curState != null,
                radioIndex: 1,
                isSelected: _singleSelectedIndex == 1,
                child:  const Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Text(
                    "工况",
                  ),
                ),
                onValueChangedAtIndex: (index, value) {
                  setState(() {
                    _singleSelectedIndex = index;
                    BrnToast.show("单选，选中第$index个", context);
                  });
                },
              ),
              const SizedBox(
                width: 20,
              ),
              BrnRadioButton(
                disable: widget.curState != null,
                radioIndex: 2,
                isSelected: _singleSelectedIndex == 2,
                child: const Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Text(
                    "灾害",
                  ),
                ),
                onValueChangedAtIndex: (index, value) {
                  setState(() {
                    _singleSelectedIndex = index;
                    BrnToast.show("单选，选中第$index个", context);
                  });
                },
              ),
            ],
          ),
          TroInput(
            value: _curState!.description,
            label: '项目概述',
            onSaved: (v) {
              _curState!.description = v;
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
            // UserApi.saveOrUpdate(_curState!.toMap()).then((res) {
            //   Navigator.pop(context, true);
            //   TroUtils.message('saved');
            // });
            widget.curState == null
                ? {
                    // _curState!.userId = StoreUtil.getCurrentUserInfo().id,
                    ProjectApi.addProject(_curState!.toJson()).then((res) {
                      Navigator.pop(context, true);
                      TroUtils.message('saved');
                    })
                  }
                : ProjectApi.updateProject(_curState!.toJson()).then((res) {
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
        title: Text(widget.curState == null ? '添加新项目' : '修改项目信息'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
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
