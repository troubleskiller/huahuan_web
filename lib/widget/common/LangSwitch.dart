import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:huahuan_web/model/application/LocaleController.dart';
import 'package:huahuan_web/widget/select_widget.dart';
import 'package:provider/provider.dart';

class LangSwitch extends StatefulWidget {
  LangSwitch({Key? key}) : super(key: key);

  @override
  LangSwitchState createState() => LangSwitchState();
}

class LangSwitchState extends State<LangSwitch> {
  @override
  Widget build(BuildContext context) {
    Locale locale = context.read<LocaleController>().locale;
    return TroToggleButtons(
      [
        SelectOption(value: const Locale('en', 'US'), label: 'english'),
        SelectOption(value: const Locale('zh', 'CN'),label: '中文'),
      ],
      defaultValue: locale,
      afterOnPress: (v) {
        context.read<LocaleController>().updateLocale(newLocale: v);
        // Get.updateLocale(Locale(v));
      },
    );
  }
}
