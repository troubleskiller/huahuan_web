import 'package:flutter/material.dart';
import 'package:huahuan_web/model/admin/user_info.dart';
import 'package:huahuan_web/util/tro_util.dart';
import 'package:huahuan_web/widget/button/icon_button.dart';
import 'package:huahuan_web/widget/input/TroInput.dart';

class UserEdit extends StatefulWidget {
  final UserInfo? userInfo;

  const UserEdit({Key? key, this.userInfo}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return UserEditState();
  }
}

class UserEditState extends State<UserEdit> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  UserInfo? _userInfo = UserInfo();

  @override
  void initState() {
    super.initState();
    if (widget.userInfo != null) {
      _userInfo = widget.userInfo;
    }
  }

  @override
  Widget build(BuildContext context) {
    var form = Form(
      key: formKey,
      child: Wrap(
        children: <Widget>[
          TroInput(
            value: _userInfo!.name,
            label: '用户名',
            onSaved: (v) {
              _userInfo!.name = v;
            },
            validator: (v) {
              return v!.isEmpty ? 'required' : null;
            },
          ),
          TroInput(
            value: _userInfo!.id.toString(),
            label: '账号',
            onSaved: (v) {
              _userInfo!.id = int.parse(v);
            },
          ),
          TroInput(
            value: '',
            label: '密码',
            onSaved: (v) {
              _userInfo!.password = v;
            },
          ),
          TroInput(
            value: _userInfo!.tel,
            label: '联系方式',
            onSaved: (v) {
              _userInfo!.tel = v;
            },
          ),
          // //todo：所属客户
          // TroSelect(
          //   label: S.of(context).personGender,
          //   value: _userInfo!.gender,
          //   dataList: DictUtil.getDictSelectOptionList(ConstantDict.CODE_GENDER),
          //   onSaved: (v) {
          //     _userInfo!.gender = v;
          //   },
          // ),
          // //todo：所拥有权限
          // TroSelect(
          //   label: S.of(context).personDepartment,
          //   value: _userInfo!.deptId,
          //   dataList: DictUtil.getDictSelectOptionList(ConstantDict.CODE_DEPT),
          //   onSaved: (v) {
          //     _userInfo!.deptId = v;
          //   },
          // ),
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
            // UserApi.saveOrUpdate(_userInfo!.toMap()).then((res) {
            //   Navigator.pop(context, true);
            //   TroUtils.message('saved');
            // });
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
        title: Text(widget.userInfo == null ? 'add' : 'modify'),
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
