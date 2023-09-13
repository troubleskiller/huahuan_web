import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:huahuan_web/api/role_api.dart';
import 'package:huahuan_web/api/user_api.dart';
import 'package:huahuan_web/model/admin/role_model.dart';
import 'package:huahuan_web/model/admin/user_info.dart';
import 'package:huahuan_web/model/api/response_api.dart';
import 'package:huahuan_web/util/tro_util.dart';
import 'package:huahuan_web/widget/button/icon_button.dart';

class RoleEditInUserScreen extends StatefulWidget {
  final UserInfo? userInfo;

  const RoleEditInUserScreen({Key? key, this.userInfo}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return RoleEditInUserScreenState();
  }
}

class RoleEditInUserScreenState extends State<RoleEditInUserScreen> {
  List<Role> roles = [];
  BrnPortraitRadioGroupOption? selectedValue;
  String? initValue;
  UserInfo? _userInfo;

  @override
  void initState() {
    getAllRolesAccessible();
    if (widget.userInfo != null) {
      _userInfo = widget.userInfo;
      initValue = _userInfo?.role?.name;
    }
    super.initState();
  }

  ///得到所有可用的角色权限
  Future getAllRolesAccessible() async {
    ResponseBodyApi responseBodyApi = await RoleApi.selectAllRole();
    roles =
        List.from(responseBodyApi.data).map((e) => Role.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    var buttonBar = ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        ButtonWithIcon(
          label: '保存',
          iconData: Icons.save,
          onPressed: () {
            UserApi.update(_userInfo!.toJson()).then((res) {
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
        title: Text(widget.userInfo == null ? '添加新用户' : '修改用户权限'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            FutureBuilder(
              future: getAllRolesAccessible(),
              builder: (context, sy) {
                return BrnExpandableGroup(
                  initiallyExpanded: true,
                  title: '所拥有权限',
                  children: [
                    BrnPortraitRadioGroup.withSimpleList(
                      selectedOption: initValue ?? '',
                      options: roles.map((e) => e.name ?? '').toList(),
                      onChanged: (BrnPortraitRadioGroupOption? old,
                          BrnPortraitRadioGroupOption? newList) {
                        BrnToast.show(newList?.title ?? '', context);
                        selectedValue = newList;
                        _userInfo?.roleId = roles
                            .singleWhere(
                                (element) => element.name == newList?.title)
                            .id;
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: buttonBar,
    );
    return SizedBox(
      width: 200,
      height: isDisplayDesktop(context) ? 350 : 500,
      child: result,
    );
  }
}
