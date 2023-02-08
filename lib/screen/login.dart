import 'package:flutter/material.dart';
import 'package:huahuan_web/api/user_api.dart';
import 'package:huahuan_web/constant/constant.dart';
// import 'package:huahuan_web/context/application_context.dart';
import 'package:huahuan_web/model/admin/user_model.dart';
import 'package:huahuan_web/model/api/response_api.dart';
import 'package:huahuan_web/screen/layout/layout.dart';
import 'package:huahuan_web/util/store_util.dart';
// import 'package:huahuan_web/util/store_util.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  User user = User();
  String error = "";
  FocusNode focusNodeUserName = FocusNode();
  FocusNode focusNodePassword = FocusNode();
  bool isFaceRecognition = false;

  @override
  void initState() {
    super.initState();
    focusNodeUserName.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(),
      child: Scaffold(
        body: _buildPageContent(),
      ),
    );
  }

  Widget _buildPageContent() {
    var appName = Text(
      "FLUTTER_ADMIN",
      style: TextStyle(fontSize: 16, color: Colors.blue),
      textScaleFactor: 3.2,
    );
    return Container(
      color: Colors.cyan.shade100,
      child: ListView(
        children: <Widget>[
          Center(child: appName),
          SizedBox(height: 20.0),
          _buildLoginForm(),
          SizedBox(height: 20.0),
          // Column(
          //   children: [
          //     Text('admin'),
          //     Text('pwd'),
          //   ],
          // )
        ],
      ),
    );
  }

  Container _buildLoginForm() {
    return Container(
      child: Stack(
        children: <Widget>[
          Center(
            child: Container(
              width: 500,
              height: 360,
              margin: EdgeInsets.only(top: 40),
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(40.0)),
                color: Colors.white,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: TextFormField(
                        focusNode: focusNodeUserName,
                        initialValue: user.userName,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: '用户名',
                          icon: Icon(
                            Icons.people,
                            color: Colors.blue,
                          ),
                        ),
                        onSaved: (v) {
                          user.userName = v;
                        },
                        validator: (v) {
                          return v!.isEmpty ? '请填写密码' : null;
                        },
                        onFieldSubmitted: (v) {
                          focusNodePassword.requestFocus();
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: TextFormField(
                        focusNode: focusNodePassword,
                        obscureText: true,
                        initialValue: user.passWord,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: '密码',
                          icon: Icon(
                            Icons.lock,
                            color: Colors.blue,
                          ),
                        ),
                        onSaved: (v) {
                          user.passWord = v;
                        },
                        validator: (v) {
                          return v!.isEmpty ? '请输入密码' : null;
                        },
                        onFieldSubmitted: (v) {
                          _login();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 40.0,
                backgroundColor: Colors.blue.shade600,
                child: Icon(Icons.person),
              ),
            ],
          ),
          Container(
            height: 360,
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: 420,
              child: ElevatedButton(
                onPressed: _login,
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0))),
                ),
                child: Text('登陆',
                    style: TextStyle(color: Colors.white70, fontSize: 20)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _register() {
    // Cry.pushNamed('/register');
  }

  _login() async {
    var form = formKey.currentState!;
    if (!form.validate()) {
      return;
    }
    form.save();
    ResponseBodyApi responseBodyApi = await UserApi.login(user.toMap());

    if (responseBodyApi.code == 200) {
      _loginSuccess(responseBodyApi);
      return;
    }
    focusNodePassword.requestFocus();
    return;
  }

  _loginSuccess(ResponseBodyApi responseBodyApi) async {
    StoreUtil.write(
        Constant.KEY_TOKEN, responseBodyApi.data[Constant.KEY_TOKEN]);
    StoreUtil.write(Constant.KEY_CURRENT_USER_INFO,
        responseBodyApi.data[Constant.KEY_CURRENT_USER_INFO]);

    ///todo: 改为后端数据
    // StoreUtil.write(
    //     Constant.KEY_MENU_LIST, responseBodyApi.data[Constant.KEY_MENU_LIST]);

    StoreUtil.write(Constant.KEY_MENU_LIST, [
      {
        "id": 1,
        "name": "test",
        "thisName": "TEST",
        "type": 1,
        "url": "/test",
        "icon": null,
        "parentId": null,
        "isDel": 1
      },
      {
        "id": 2,
        "name": "test1",
        "thisName": "TEST_1",
        "type": 1,
        "url": "/test/1",
        "icon": null,
        "parentId": 1,
        "isDel": 1
      },
      {
        "id": 3,
        "name": "用户管理",
        "thisName": "User Manage",
        "type": 1,
        "url": "",
        "icon": "people",
        "parentId": null,
        "isDel": 1
      },
      {
        "id": 4,
        "name": "用户管理",
        "thisName": "User Manage",
        "type": 1,
        "url": "/user",
        "icon": "person",
        "parentId": 3,
        "isDel": 1
      },    {
        "id": 9,
        "name": "项目授权",
        "thisName": "User Manage",
        "type": 1,
        "url": "/eventAuth",
        "icon": "dashboard",
        "parentId": 3,
        "isDel": 1
      },   {
        "id": 5,
        "name": "角色授权",
        "thisName": "Role Manage",
        "type": 1,
        "url": "/role",
        "icon": "role",
        "parentId": 3,
        "isDel": 1
      },      {
        "id": 6,
        "name": "项目管理",
        "thisName": "Event Manage",
        "type": 1,
        "url": "",
        "icon": "menu",
        "parentId": null,
        "isDel": 1
      },      {
        "id": 7,
        "name": "项目管理",
        "thisName": "Event Manage",
        "type": 1,
        "url": "/event",
        "icon": "dashboard",
        "parentId": 6,
        "isDel": 1
      },      {
        "id": 8,
        "name": "项目管理",
        "thisName": "Event Manage",
        "type": 1,
        "url": "/event",
        "icon": "dashboard",
        "parentId": 6,
        "isDel": 1
      }
    ]);
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => Layout()));
    // await StoreUtil.loadDefaultTabs();
    StoreUtil.init();
  }
}
