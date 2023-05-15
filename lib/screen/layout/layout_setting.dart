// import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:huahuan_web/constant/enum.dart';
import 'package:huahuan_web/screen/layout/layout_controller.dart';
import 'package:huahuan_web/widget/common/LangSwitch.dart';
import 'package:huahuan_web/widget/select_widget.dart';
import 'package:provider/provider.dart';

class LayoutSetting extends StatelessWidget {
  LayoutSetting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var layoutController = context.watch<LayoutController>();
    var menuDisplayType = TroToggleButtons(
      [
        SelectOption(value: MenuDisplayType.drawer, label: 'drawer'),
        SelectOption(value: MenuDisplayType.side, label: 'side'),
      ],
      defaultValue: layoutController.menuDisplayType,
      afterOnPress: (Object? v) {
        layoutController.updateMenuDisplayType(v);
      },
    );
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('mySettings'),
            decoration: BoxDecoration(
              color: Colors.cyanAccent,
            ),
          ),
          Divider(thickness: 1),
          ListTile(
            title: Text('menuDisplay'),
            trailing: menuDisplayType,
          ),
          Divider(thickness: 1),
          ListTile(
            // title: Text(tr('language')),
            title: Text('语言'),
            trailing: LangSwitch(),
          ),
        ],
      ),
    );
  }
}
