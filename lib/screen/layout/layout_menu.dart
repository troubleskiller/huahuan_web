import 'package:flutter/material.dart';
import 'package:huahuan_web/extension/context_extension.dart';
import 'package:huahuan_web/model/admin/menu_model.dart';
import 'package:huahuan_web/model/admin/treeVo.dart';
import 'package:huahuan_web/util/store_util.dart';
import 'package:huahuan_web/util/tro_util.dart';
import 'package:huahuan_web/util/utils.dart';

class LayoutMenu extends StatefulWidget {
  const LayoutMenu({
    Key? key,
    this.onClick,
  }) : super(key: key);
  final Function? onClick;

  @override
  _LayoutMenuState createState() => _LayoutMenuState();
}

class _LayoutMenuState extends State<LayoutMenu> {
  final double headerHeight = 48;
  bool? expandMenu;
  bool expandAll = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    expandMenu ??=
        isDisplayDesktop(context) || Utils.isMenuDisplayTypeDrawer(context);
    var menuHeaderExpand = Row(
      children: [
        if (!Utils.isMenuDisplayTypeDrawer(context))
          IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: () {
              expandMenu = !expandMenu!;
              setState(() {});
            },
          ),
        Expanded(
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    expandAll = true;
                  });
                },
                icon: Icon(
                  Icons.expand,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.vertical_align_center,
                ),
                onPressed: () {
                  setState(() {
                    expandAll = false;
                  });
                },
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.end,
          ),
        ),
      ],
    );

    var menuHeaderCollapse = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(
            Icons.chevron_right,
          ),
          onPressed: () {
            expandMenu = !expandMenu!;
            setState(() {});
          },
        ),
      ],
    );
    var menuHeader = Material(
      type: MaterialType.transparency,
      child: Container(
        color: Colors.white,
        height: headerHeight,
        child: expandMenu! ? menuHeaderExpand : menuHeaderCollapse,
      ),
    );
    var menuBody = ListView(
      key: Key('builder ${expandAll.toString()}'),
      children: [
        SizedBox(height: headerHeight),
        ..._getMenuListTile(TreeUtil.toTreeVOList(StoreUtil.getMenuList()),
            StoreUtil.readCurrentOpenedTabPageId()),
      ],
    );
    var menuStack = Stack(
      alignment: Alignment.topCenter,
      children: [
        menuBody,
        menuHeader,
        Divider(
          thickness: 1,
          color: Colors.black26,
          height: headerHeight * 2 - 1,
        ),
      ],
    );
    var result = Utils.isMenuDisplayTypeDrawer(context)
        ? Drawer(child: menuStack)
        : SizedBox(
            width: expandMenu! ? 200 : 60,
            child: menuStack,
          );
    return result;
  }

  List<Widget> _getMenuListTile(
      List<TreeVO<MenuModel>> data, int? currentOpenedTabPageId) {
    List<Widget> listTileList = data.map<Widget>((TreeVO<MenuModel> treeVO) {
      IconData iconData = Utils.toIconData(treeVO.data!.icon);
      String name = treeVO.data!.name ?? '';
      Text title = Text(expandMenu! ? name : '');
      if (treeVO.children.length > 0) {
        bool hasChildrenOpened = treeVO.children
            .any((element) => currentOpenedTabPageId == element.data!.id);
        return ExpansionTile(
          key: Key(treeVO.data!.id!.toString()),
          initiallyExpanded: hasChildrenOpened || expandAll,
          leading: expandMenu! ? Icon(iconData) : null,
          onExpansionChanged: (a) {
            if (a) {
              if (currentOpenedTabPageId != treeVO.data!.id &&
                  widget.onClick != null) {
                widget.onClick!(treeVO.data);
              }
            }
          },
          title: title,
          childrenPadding: EdgeInsets.only(left: expandMenu! ? 30 : 0),
          children: _getMenuListTile(treeVO.children, currentOpenedTabPageId),
        );
      } else {
        return ListTile(
          tileColor: currentOpenedTabPageId == treeVO.data!.id
              ? Colors.blue.shade100
              : null,
          leading: Icon(iconData, color: context.theme.primaryColor),
          title: title,
          onTap: () {
            if (currentOpenedTabPageId != treeVO.data!.id &&
                widget.onClick != null) {
              widget.onClick!(treeVO.data);
            }
          },
        );
      }
    }).toList();
    return listTileList;
  }
}
