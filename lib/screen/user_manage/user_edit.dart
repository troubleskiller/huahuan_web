import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:huahuan_web/api/customer_api.dart';
import 'package:huahuan_web/api/role_api.dart';
import 'package:huahuan_web/api/user_api.dart';
import 'package:huahuan_web/model/admin/Customer_model.dart';
import 'package:huahuan_web/model/admin/role_model.dart';
import 'package:huahuan_web/model/admin/user_info.dart';
import 'package:huahuan_web/model/api/response_api.dart';
import 'package:huahuan_web/util/store_util.dart';
import 'package:huahuan_web/util/tro_util.dart';
import 'package:huahuan_web/widget/button/icon_button.dart';
import 'package:huahuan_web/widget/input/TroInput.dart';
import 'package:huahuan_web/widget/input/TroSelect.dart';

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
  List<Role> curRoles = [];
  List<CustomerModel> curCustomers = [];
  String? selectedValue;
  String? selectedValue2;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.userInfo != null) {
      _userInfo = widget.userInfo;
    }
    init();
  }

  void init() async {
    await getAllRolesAccessible();
    await getAllCustomersAccessible();
    _userInfo?.creatorId = StoreUtil.getCurrentUserInfo().id;
    _userInfo?.isEnable = 1;
    _userInfo?.isDel = 0;

    selectedValue= _userInfo?.customerModel?.name;

    setState(() {
      isLoading = false;
    });
  }

  ///得到所有可用的角色权限
  Future getAllRolesAccessible() async {
    ResponseBodyApi responseBodyApi = await RoleApi.selectAllRole();
    if (responseBodyApi.code == 200) {
      curRoles = List.from(responseBodyApi.data)
          .map((e) => Role.fromJson(e))
          .toList();
      selectedValue2 = _userInfo?.role?.name;
      // if (StoreUtil.getCurrentUserInfo().roleId != 1) {
      //   curRoles.removeWhere((element) =>
      //       element.id == StoreUtil.getCurrentUserInfo().role!.id!);
      //
      // }
    }
  }

  ///得到所有所属的公司
  Future getAllCustomersAccessible() async {
    ResponseBodyApi responseBodyApi =
        await CustomerApi.list('{"id":${StoreUtil.getCurrentUserInfo().id}}');
    if (responseBodyApi.code == 200) {
      curCustomers = List.from(responseBodyApi.data)
          .map((e) => CustomerModel.fromJson(e))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    var form = Form(
      key: formKey,
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            TroSelect(
              value:selectedValue ,
              dataList: curCustomers
                  .map((e) => SelectOptionVO(value: e.name, label: e.name))
                  .toList(),
              label: '所属客户',
              onChange: (newList) {
                selectedValue = newList;
                _userInfo?.customerId = curCustomers
                    .singleWhere(
                        (element) => element.name == newList)
                    .id;
              },
            ),
            TroSelect(
              value:selectedValue2 ,
              dataList: curRoles
                  .map((e) => SelectOptionVO(value: e.name, label: e.name))
                  .toList(),
              label: '所拥有权限',
              onChange: (newList) {
                selectedValue2 = newList;
                _userInfo?.roleId = curRoles
                    .singleWhere(
                        (element) => element.name == newList?.title)
                    .id;
              },
            ),
            // //todo：所拥有权限
          ],
        ),
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
            print(_userInfo!.toJson());
            widget.userInfo == null
                ? UserApi.addUser(_userInfo!.toJson())
                : UserApi.update(_userInfo!.toJson());
            Navigator.pop(context, true);
            TroUtils.message('保存成功');
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
    return isLoading
        ? Container()
        : SizedBox(
            width: 650,
            height: isDisplayDesktop(context) ? 350 : 500,
            child: result,
          );
  }
}
