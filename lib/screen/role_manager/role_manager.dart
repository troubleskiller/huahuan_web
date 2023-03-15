import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:huahuan_web/api/menu_api.dart';
import 'package:huahuan_web/api/role_api.dart';
import 'package:huahuan_web/model/admin/menu_model.dart';
import 'package:huahuan_web/model/admin/role_model.dart';
import 'package:huahuan_web/model/admin/treeVo.dart';
import 'package:huahuan_web/model/api/response_api.dart';
import 'package:huahuan_web/widget/dialog/rename_dialog.dart';
import 'package:huahuan_web/widget/dialog/tro_dialog.dart';
import 'package:huahuan_web/widget/input/TroInput.dart';

import '../../util/utils.dart';

class RoleManager extends StatefulWidget {
  const RoleManager({Key? key}) : super(key: key);

  @override
  State<RoleManager> createState() => _RoleManagerState();
}

class _RoleManagerState extends State<RoleManager> {
  List<Widget> tiles = [];
  List<Role> roles = [];

  Role? curRole;

  ///可供选择的访问页面
  List<MenuModel> baseMenus = [];

  ///当前选择的访问页面
  List<MenuModel> curMenus = [];

  ///获取所有角色信息
  void selectAllRoles() async {
    ///只属于admin的页面
    ResponseBodyApi responseBodyApi = await RoleApi.selectAllRole();
    print(responseBodyApi.data);
    if (responseBodyApi.code == 200) {
      setState(() {
        roles = List.from(responseBodyApi.data)
            .map((e) => Role.fromJson(e))
            .toList();
        curRole = roles[0];
      });
    }
  }

  ///获取所有可供选择访问的页面
  Future getAllTitles() async {
    ResponseBodyApi responseBodyApi = await MenuApi.listAll();
    print(responseBodyApi.data);
    if (responseBodyApi.code == 200) {
      setState(() {
        baseMenus = List.from(responseBodyApi.data)
            .map((e) => MenuModel.fromJson(e))
            .toList();
      });
    }
  }

  ///获取当前已选择可以访问的页面
  void getCurTitles(int i) async {
    ResponseBodyApi responseBodyApi = await MenuApi.listByUid('{"id":$i}');
    print(responseBodyApi.data);
    if (responseBodyApi.code == 200) {
      setState(() {
        curMenus = List.from(responseBodyApi.data)
            .map((e) => MenuModel.fromJson(e))
            .toList();
        tiles = _getMenuListTile(TreeUtil.toTreeVOList(baseMenus));
      });
    }
  }

  List<Widget> _getMenuListTile(List<TreeVO<MenuModel>> data) {
    List<Widget> listTileList = data.map<Widget>((TreeVO<MenuModel> treeVO) {
      String name = treeVO.data!.name ?? '';
      Text title = Text(name);
      if (treeVO.children.isNotEmpty) {
        return ExpansionTile(
          key: Key(treeVO.data!.id!.toString()),
          initiallyExpanded: false,
          title: title,
          childrenPadding: const EdgeInsets.only(left: 10),
          children: _getMenuListTile(
            treeVO.children,
          ),
        );
      } else {
        return BrnCheckbox(
          isSelected: curMenus
              .where((element) => element.id == treeVO.data!.id)
              .isNotEmpty,
          radioIndex: treeVO.data?.id ?? 0,

          ///限制有部分是无法选择查看的
          // disable: index == 2,
          childOnRight: false,
          child: Expanded(
            child: ListTile(
              leading: Icon(Utils.toIconData(treeVO.data!.icon)),
              title: title,
            ),
          ),
          onValueChangedAtIndex: (index, value) async {
            if (value) {
              ResponseBodyApi responseBodyApi = await RoleApi.addMenu(
                  '{"roleId":${curRole!.id},"titleId":${treeVO.data!.id}}');
              if (responseBodyApi.code == 200) {
                getCurTitles(curRole!.id!);
                BrnToast.show(
                    "成功为角色${curRole!.name}添加${treeVO.data!.name}页面的权限",
                    context);
              } else {
                BrnToast.show("未添加成功，请检查网络或稍后重试", context);
              }
            } else {
              ResponseBodyApi responseBodyApi = await RoleApi.deleteMenu(
                  '{"roleId":${curRole!.id},"titleId":${treeVO.data!.id}}');
              if (responseBodyApi.code == 200) {
                getCurTitles(curRole!.id!);
                BrnToast.show(
                    "成功为角色${curRole!.name}删除${treeVO.data!.name}页面的权限",
                    context);
              } else {
                BrnToast.show("未删除成功，请检查网络或稍后重试", context);
              }
            }
          },
        );
      }
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
    selectAllRoles();
    await getAllTitles();
    getCurTitles(1);
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
            flex: 8,
            child: Column(
              children: [
                Column(
                    children: roles
                        .map(
                          (e) => RoleLine(
                              role: e,
                              onTap: () {
                                setState(() {
                                  curRole = e;
                                  getCurTitles(e.id ?? 1);
                                });
                              },
                              curRole: curRole!),
                        )
                        .toList()),
                Spacer(),
                BrnNormalButton(
                  text: '添加新的角色',
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          String newName = '';
                          return RenameDialog(
                            contentWidget: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TroInput(
                                  label: '添加新角色',
                                  value: '',
                                  onChange: (value) {
                                    newName = value;
                                  },
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                      child: Text('关闭'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text('确定'),
                                      onPressed: () async {
                                        ResponseBodyApi responseBodyApi =
                                            await RoleApi.addRole(
                                                '{"isDel":1,"name":"$newName"}');
                                        if (responseBodyApi.code == 200) {
                                          selectAllRoles();
                                          BrnToast.show(
                                              "成功添加新角色$newName", context);
                                        } else {
                                          BrnToast.show(
                                              "未成功添加角色，请检查网络或稍后重试", context);
                                        }
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
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
                    '${curRole?.name}的可访问页面',
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

///角色管理下对应的每一行
class RoleLine extends StatefulWidget {
  final Role role;
  final Role curRole;
  final Function onTap;

  const RoleLine(
      {Key? key,
      required this.role,
      required this.onTap,
      required this.curRole})
      : super(key: key);

  @override
  State<RoleLine> createState() => _RoleLineState();
}

class _RoleLineState extends State<RoleLine> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 2),
        color: widget.curRole.id == widget.role.id
            ? Colors.amberAccent
            : Colors.white,
      ),
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: GestureDetector(
        onTap: () {
          widget.onTap();
          BrnToast.show("进入该角色管理", context);
        },
        child: Flex(
          direction: Axis.horizontal,
          children: [
            Spacer(
              flex: 1,
            ),
            Expanded(
              child: Text(widget.role.id.toString()),
              flex: 1,
            ),
            Spacer(
              flex: 1,
            ),
            Expanded(
              child: Text(widget.role.name.toString()),
              flex: 8,
            ),
            Spacer(
              flex: 1,
            ),
            Expanded(
              flex: 10,
              child: widget.role.isDel == 1
                  ? GestureDetector(
                      onTap: () async {
                        ResponseBodyApi responseBodyApi =
                            await RoleApi.deleteRole(
                                '{"id":${widget.role.id}}');
                        if (responseBodyApi.code == 200) {
                          BrnToast.show("删除当前角色${widget.role.name}", context);
                          setState(() {
                            widget.role.isDel=0;
                          });
                        } else {
                          BrnToast.show("未成功删除角色，请检查网络或稍后重试", context);
                        }
                      },
                      child: Text('删除当前角色'),
                    )
                  : GestureDetector(
                      onTap: () async {
                        ResponseBodyApi responseBodyApi =
                            await RoleApi.recoveryRole(
                                '{"id":${widget.role.id}}');
                        if (responseBodyApi.code == 200) {
                          BrnToast.show("重新使用当前角色${widget.role.name}", context);
                          setState(() {
                            widget.role.isDel=1;
                          });
                        } else {
                          BrnToast.show("未成功恢复角色，请检查网络或稍后重试", context);
                        }
                      },
                      child: Text('重新使用当前角色'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
