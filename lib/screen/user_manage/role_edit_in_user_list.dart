import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:huahuan_web/api/role_api.dart';
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

  @override
  void initState() {
    super.initState();
  }

  ///得到所有可用的角色权限
  void getAllRolesAccessible() async {
    ResponseBodyApi  responseBodyApi= await RoleApi.selectAllRole();
    roles = List.from(responseBodyApi.data).map((e) => Role.fromJson(e)).toList();
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
            ),
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
