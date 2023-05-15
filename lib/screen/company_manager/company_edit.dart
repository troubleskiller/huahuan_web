import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:huahuan_web/api/customer_api.dart';
import 'package:huahuan_web/model/admin/Customer_model.dart';
import 'package:huahuan_web/model/admin/role_model.dart';
import 'package:huahuan_web/util/store_util.dart';
import 'package:huahuan_web/util/tro_util.dart';
import 'package:huahuan_web/widget/button/icon_button.dart';
import 'package:huahuan_web/widget/input/TroInput.dart';

class CompanyEdit extends StatefulWidget {
  final CustomerModel? customerModel;

  const CompanyEdit({Key? key, this.customerModel}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CompanyEditState();
  }
}

class CompanyEditState extends State<CompanyEdit> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  CustomerModel? _customerModel = CustomerModel();
  List<Role> curRoles = [];
  List<CustomerModel> curCustomers = [];
  BrnPortraitRadioGroupOption? selectedValue;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.customerModel != null) {
      _customerModel = widget.customerModel;
    }
    init();
  }

  void init() async {
    _customerModel?.userId = StoreUtil.getCurrentUserInfo().id;

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var form = Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TroInput(
            value: _customerModel!.name,
            label: '客户名',
            onSaved: (v) {
              _customerModel!.name = v;
            },
            validator: (v) {
              return v!.isEmpty ? 'required' : null;
            },
          ),
          // TroInput(
          //   value: _customerModel!.loginName,
          //   label: '账号',
          //   onSaved: (v) {
          //     _customerModel!.loginName = v;
          //   },
          // ),
          TroInput(
            value: _customerModel!.address,
            label: '地址',
            onSaved: (v) {
              _customerModel!.address = v;
            },
          ),
          TroInput(
            value: _customerModel!.tel,
            label: '联系方式',
            onSaved: (v) {
              _customerModel!.tel = v;
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
            print(_customerModel!.toJson());
            widget.customerModel == null
                ? CustomerApi.add(_customerModel!.toJson())
                : CustomerApi.update(_customerModel!.toJson());
            Navigator.pop(context, true);
            TroUtils.message('保存成功');
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
        title: Text(widget.customerModel == null ? '添加新客户' : '修改客户信息'),
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
