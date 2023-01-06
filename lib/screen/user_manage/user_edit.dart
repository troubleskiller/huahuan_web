import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:huahuan_web/model/admin/role_model.dart';
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
  List<Role> roles = [];

  @override
  void initState() {
    super.initState();
    if (widget.userInfo != null) {
      _userInfo = widget.userInfo;
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
            value: _userInfo!.loginName,
            label: '账号',
            onSaved: (v) {
              _userInfo!.loginName = v;
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
          //   label: '所属客户',
          //   value: _userInfo!.customerModel!.name,
          //   dataList:
          //       DictUtil.getDictSelectOptionList(ConstantDict.CODE_GENDER),
          //   onSaved: (v) {
          //     _userInfo!.gender = v;
          //   },
          // ),
          // //todo：所拥有权限
          Container(
            height: 130,
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) {
                return BrnCheckbox(
                  radioIndex: index,
                  disable: index == 2,
                  childOnRight: false,
                  child: Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text(
                      "选项$index",
                    ),
                  ),
                  onValueChangedAtIndex: (index, value) {
                    if (value) {
                      BrnToast.show("第$index项被选中", context);
                    } else {
                      BrnToast.show("第$index项取消选中", context);
                    }
                  },
                );
              },
            ),
          )
          // TroSelect(
          //   label: '用户角色',
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
        title: Text(widget.userInfo == null ? '添加新用户' : '修改用户信息'),
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
