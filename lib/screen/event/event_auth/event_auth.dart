import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:huahuan_web/api/project_api.dart';
import 'package:huahuan_web/api/user_api.dart';
import 'package:huahuan_web/model/admin/project_model.dart';
import 'package:huahuan_web/model/admin/user_info.dart';
import 'package:huahuan_web/model/api/page_model.dart';
import 'package:huahuan_web/model/api/response_api.dart';
import 'package:huahuan_web/screen/user_manage/role_edit_in_user_list.dart';
import 'package:huahuan_web/screen/user_manage/user_edit.dart';
import 'package:huahuan_web/util/store_util.dart';

class ProjectAuth extends StatefulWidget {
  const ProjectAuth({Key? key}) : super(key: key);

  @override
  State<ProjectAuth> createState() => _ProjectAuthState();
}

class _ProjectAuthState extends State<ProjectAuth> {
  List<Widget> tiles = [];
  List<UserInfo> users = [];

  UserInfo? curUser;

  ///可供选择的访问页面
  List<ProjectModel> baseProjects = [];

  ///当前选择的访问页面
  List<ProjectModel> curProjects = [];

  ///获取所有用户信息
  Future selectAllUsers() async {
    ///只属于admin的页面
    ResponseBodyApi responseBodyApi = await UserApi.findByCreatedId(
        '{"data": {"id": ${StoreUtil.getCurrentUserInfo().id}},"pageVO": {"currentPage": 0,"pageSize": 9999}}');
    PageModel page = PageModel.fromJson(responseBodyApi.data);
    if (responseBodyApi.code == 200) {
      setState(() {
        users = List.from(page.data).map((e) => UserInfo.fromJson(e)).toList();
        curUser = users[0];
      });
    }
  }

  ///获取所有可供选择的项目
  Future getAllProjects() async {
    ResponseBodyApi responseBodyApi = await ProjectApi.findAllById({"id": 1});
    if (responseBodyApi.code == 200) {
      setState(() {
        baseProjects = List.from(responseBodyApi.data)
            .map((e) => ProjectModel.fromJson(e))
            .toList();
      });
    }
  }

  ///获取当前已选择可以访问的页面
  void getCurProjects(int i) async {
    ResponseBodyApi responseBodyApi = await ProjectApi.findAllById('{"id":$i}');
    print(responseBodyApi.data);
    if (responseBodyApi.code == 200) {
      setState(() {
        curProjects = List.from(responseBodyApi.data)
            .map((e) => ProjectModel.fromJson(e))
            .toList();
        tiles = _getMenuListTile(baseProjects);
      });
    }
  }

  List<Widget> _getMenuListTile(List<ProjectModel> data) {
    List<Widget> listTileList = data.map<Widget>((ProjectModel project) {
      String name = project.name ?? '';
      Text title = Text(name);
      return BrnCheckbox(
        isSelected:
            curProjects.where((element) => element.id == project.id).isNotEmpty,
        radioIndex: project.id ?? 0,

        ///限制有部分是无法选择查看的
        // disable: index == 2,
        childOnRight: false,
        child: Expanded(
          child: ListTile(
            // leading: Icon(Utils.toIconData(project.icon)),
            title: title,
          ),
        ),
        onValueChangedAtIndex: (index, value) async {
          if (value) {
            ResponseBodyApi responseBodyApi = await ProjectApi.empowerProject(
                '{"userId":${curUser!.id},"projectId":${project.id}}');
            if (responseBodyApi.code == 200) {
              getCurProjects(curUser!.id!);
              BrnToast.show(
                  "成功为用户${curUser!.name}添加${project.name}页面的权限", context);
            } else {
              BrnToast.show("未添加成功，请检查网络或稍后重试", context);
            }
          } else {
            ResponseBodyApi responseBodyApi = await ProjectApi.cancelProject(
                '{"roleId":${curUser!.id},"titleId":${project.id}}');
            if (responseBodyApi.code == 200) {
              getCurProjects(curUser!.id!);
              BrnToast.show(
                  "成功为用户${curUser!.name}删除${project.name}页面的权限", context);
            } else {
              BrnToast.show("未删除成功，请检查网络或稍后重试", context);
            }
          }
        },
      );
    }).toList();
    return listTileList;
  }

  @override
  void initState() {
    // TODO: implement initState
    init();
    super.initState();
  }

  void init() async {
    await selectAllUsers();
    await getAllProjects();
    getCurProjects(curUser!.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Flex(
        direction: Axis.horizontal,
        children: [
          Spacer(
            flex: 1,
          ),
          Expanded(
            flex: 16,
            child: Column(
              children: [
                Expanded(
                  flex: 7,
                  child: ListView(
                      children: users
                          .map(
                            (e) => UserLine(
                                user: e,
                                onTap: () {
                                  setState(() {
                                    curUser = e;
                                    getCurProjects(e.id!);
                                  });
                                },
                                curUser: curUser!),
                          )
                          .toList()),
                ),
                Spacer(),
                BrnNormalButton(
                  text: '添加新的用户',
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => Dialog(
                        child: UserEdit(),
                      ),
                    ).then((v) {
                      if (v != null) {
                        setState(() {});
                      }
                    });
                  },
                ),
                Spacer(),
              ],
            ),
          ),
          Spacer(
            flex: 1,
          ),
          Expanded(
              flex: 9,
              child: Column(
                children: [
                  Text(
                    '${curUser?.name}的可访问的项目',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Expanded(
                      child: ListView(
                    children: tiles,
                  ))
                ],
              )),
          Spacer(
            flex: 1,
          ),
        ],
      ),
    );
  }
}

///用户管理下对应的每一行
class UserLine extends StatefulWidget {
  final UserInfo user;
  final UserInfo curUser;
  final Function onTap;

  const UserLine(
      {Key? key,
      required this.user,
      required this.onTap,
      required this.curUser})
      : super(key: key);

  @override
  State<UserLine> createState() => _UserLineState();
}

class _UserLineState extends State<UserLine> {
  _roles({UserInfo? userInfo}) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: RoleEditInUserScreen(
          userInfo: userInfo,
        ),
      ),
    ).then((v) {
      setState(() {});
    });
  }

  //todo: 编辑页面
  _edit({UserInfo? userInfo}) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: UserEdit(
          userInfo: userInfo,
        ),
      ),
    ).then((v) {
      if (v != null) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 2),
        color: widget.curUser.id == widget.user.id
            ? Colors.amberAccent
            : Colors.white,
      ),
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: GestureDetector(
        onTap: () {
          widget.onTap();
          BrnToast.show("进入该用户管理", context);
        },
        child: Flex(
          direction: Axis.horizontal,
          children: [
            Spacer(
              flex: 1,
            ),
            Expanded(
              flex: 1,
              child: Text(widget.user.id.toString()),
            ),
            Spacer(
              flex: 1,
            ),
            Expanded(
              flex: 3,
              child: Text(widget.user.name.toString()),
            ),
            Spacer(
              flex: 1,
            ),
            Expanded(
              flex: 2,
              child: Text(widget.user.loginName.toString()),
            ),
            Spacer(
              flex: 1,
            ),
            Expanded(
              flex: 4,
              child: Text(widget.user.tel.toString()),
            ),
            Spacer(
              flex: 1,
            ),
            Expanded(
              flex: 6,
              child: Text(widget.user.customerModel?.name ?? '--'),
            ),
            Spacer(
              flex: 1,
            ),
            Expanded(
              flex: 4,
              child: Text(DateTime.parse(widget.user.created ?? '')
                  .toString()
                  .split('.')[0]),
            ),
            Spacer(
              flex: 1,
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {
                  _roles(userInfo: widget.user);
                },
              ),
            ),
            Spacer(
              flex: 1,
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  _edit(userInfo: widget.user);
                },
              ),
            ),
            Spacer(
              flex: 1,
            ),
            Expanded(
              flex: 1,
              child: widget.user.isDel == 0
                  ? IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        ResponseBodyApi responseBodyApi =
                            await UserApi.deleteUser(
                                '{"id":${widget.user.id}}');
                        if (responseBodyApi.code == 200) {
                          BrnToast.show("删除当前用户${widget.user.name}", context);
                          setState(() {
                            widget.user.isDel = 1;
                          });
                        } else {
                          BrnToast.show("未成功删除用户，请检查网络或稍后重试", context);
                        }
                      },
                    )
                  : IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () async {
                        ResponseBodyApi responseBodyApi =
                            await UserApi.recoveryUser(
                                '{"id":${widget.user.id}}');
                        if (responseBodyApi.code == 200) {
                          BrnToast.show("恢复当前用户${widget.user.name}", context);
                          setState(() {
                            widget.user.isDel = 0;
                          });
                        } else {
                          BrnToast.show("未成功恢复用户，请检查网络或稍后重试", context);
                        }
                      },
                    ),
            ),
            Spacer(
              flex: 1,
            ),
          ],
        ),
      ),
    );
  }
}
