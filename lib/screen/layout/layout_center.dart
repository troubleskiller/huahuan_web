import 'package:flutter/material.dart';
import 'package:huahuan_web/constant/enum.dart';
import 'package:huahuan_web/index_stack_lazy.dart';
import 'package:huahuan_web/model/admin/tabPage_model.dart';
import 'package:huahuan_web/route/routes.dart';
import 'package:huahuan_web/screen/layout/layout_controller.dart';
import 'package:huahuan_web/util/store_util.dart';
import 'package:huahuan_web/util/utils.dart';
import 'package:huahuan_web/widget/menu_widget.dart';
import 'package:provider/provider.dart';

class LayoutCenter extends StatefulWidget {
  LayoutCenter({Key? key}) : super(key: key);

  @override
  LayoutCenterState createState() => LayoutCenterState();
}

class LayoutCenterState extends State<LayoutCenter>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var isMaximize = context.watch<LayoutController>().isMaximize;
    var openedTabPageList = StoreUtil.readOpenedTabPageList();
    if (openedTabPageList.isEmpty) {
      return Container();
    }
    var currentOpenedTabPageId = StoreUtil.readCurrentOpenedTabPageId();
    int currentIndex = openedTabPageList
        .indexWhere((note) => note!.id == currentOpenedTabPageId);
    var tabController = TabController(
        vsync: this,
        length: openedTabPageList.length,
        initialIndex: currentIndex);
    var defaultTabs = StoreUtil.getDefaultTabs();

    tabController.addListener(() {
      if (tabController.indexIsChanging) {
        StoreUtil.writeCurrentOpenedTabPageId(
            openedTabPageList[tabController.index]!.id);
        setState(() {});
      }
    });

    TabBar tabBar = TabBar(
      controller: tabController,
      isScrollable: true,

      ///tabBar 自定义边框
      indicator: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      tabs: openedTabPageList.map<Tab>((TabPage? tabPage) {
        var tabContent = Row(
          children: <Widget>[
            Text(
              tabPage!.name ?? '',
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(
              width: 20,
            ),
            if (!defaultTabs.contains(tabPage))
              Material(
                type: MaterialType.transparency,
                child: SizedBox(
                  width: 25,
                  child: IconButton(
                    iconSize: 10,
                    splashRadius: 10,
                    onPressed: () {
                      Utils.closeTab(tabPage);
                      setState(() {});
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                  ),
                ),
              )
          ],
        );
        return Tab(
          child: Menu(
            child: tabContent,
            onSelected: (dynamic v) {
              switch (v) {
                case TabMenuOption.close:
                  Utils.closeTab(tabPage);
                  break;
                case TabMenuOption.closeAll:
                  Utils.closeAllTab();
                  break;
                case TabMenuOption.closeOthers:
                  Utils.closeOtherTab(tabPage);
                  break;
                case TabMenuOption.closeAllToTheRight:
                  Utils.closeAllToTheRightTab(tabPage);
                  break;
                case TabMenuOption.closeAllToTheLeft:
                  Utils.closeAllToTheLeftTab(tabPage);
                  break;
              }
              setState(() {});
            },
            itemBuilder: (context) => <PopupMenuEntry<TabMenuOption>>[
              if (!defaultTabs.contains(tabPage))
                const PopupMenuItem(
                  value: TabMenuOption.close,
                  child: ListTile(
                    title: Text('关闭当前窗口'),
                  ),
                ),
              const PopupMenuItem(
                value: TabMenuOption.closeAll,
                child: ListTile(
                  title: Text('关闭所有窗口'),
                ),
              ),
              const PopupMenuItem(
                value: TabMenuOption.closeOthers,
                child: ListTile(
                  title: Text('关闭其他窗口'),
                ),
              ),
              const PopupMenuItem(
                value: TabMenuOption.closeAllToTheRight,
                child: ListTile(
                  title: Text('关闭右侧所有窗口'),
                ),
              ),
              const PopupMenuItem(
                value: TabMenuOption.closeAllToTheLeft,
                child: ListTile(
                  title: Text('关闭左侧所有窗口'),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );

    var content = Container(
      child: Expanded(
        child: IndexedStackLazy(
          index: currentIndex,
          children: openedTabPageList.map((TabPage? tabPage) {
            var page = tabPage!.url != null
                ? Routes.layoutPagesMap[tabPage.url!] ?? Container()
                : tabPage.widget ?? Container();
            return KeyedSubtree(
              child: page,
              key: Key('page-${tabPage.id}'),
            );
          }).toList(),
        ),
      ),
    );

    var result = Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            color: Colors.transparent,
            child: Row(
              children: <Widget>[
                Expanded(child: tabBar),
                IconButton(
                    onPressed: () {
                      context.read<LayoutController>().toggleMaximize();
                    },
                    icon: Icon(isMaximize
                        ? Icons.close_fullscreen
                        : Icons.open_in_full),
                    iconSize: 20,
                    color: Colors.black)
              ],
            ),
          ),
          content,
        ],
      ),
    );
    return result;
  }
}
