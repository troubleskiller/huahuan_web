// import 'package:easy_localization/easy_localization.dart';
import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:flutter_2d_amap/flutter_2d_amap.dart';
import 'package:get/get.dart';
import 'package:huahuan_web/model/application/event_model.dart';
import 'package:huahuan_web/route/Tro.dart';
import 'package:huahuan_web/route/main_route_delegate.dart';
import 'package:huahuan_web/route/route_information_parser.dart';
import 'package:huahuan_web/screen/layout/layout.dart';
import 'package:huahuan_web/screen/layout/layout_controller.dart';
import 'package:huahuan_web/screen/login.dart';
import 'package:provider/provider.dart';

import 'context/application_context.dart';
import 'model/application/LocaleController.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await EasyLocalization.ensureInitialized();
  await init();
  Flutter2dAMap.updatePrivacy(true);
  Flutter2dAMap.setApiKey(
    // iOSKey: '1a8f6a489483534a9f2ca96e4eeeb9b3',
    webKey: '6a6e238f54d5ce96ed6691ea3880caac',
  ).then((_) => runApp(MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => LayoutController()),
            ChangeNotifierProvider(create: (_) => LocaleController()),
            ChangeNotifierProvider(create: (_) => EventModel()),
          ],
          child:
              // EasyLocalization(
              //     supportedLocales: [
              //       const Locale('en', 'US'),
              //       const Locale('zh', 'CN'),
              //     ],
              //     path: 'translations',
              //     fallbackLocale: Locale('zh', 'CN'),
              //     child: MyApp()
              //     // ProjectManager()
              //     ),
              MyApp())));
}

init() async {
  // await GetStorage.init();
  await ApplicationContext.instance.init();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, Widget> pageMap = {
      '/': Layout(),
      '/login': Login(),
    };
    return GetMaterialApp.router(
      key: UniqueKey(),
      builder: Tro.init,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        BrnLocalizationDelegate.delegate,
      ],
      title: 'FLUTTER_ADMIN',
      enableLog: false,
      routerDelegate: MainRouterDelegate(pageMap: pageMap),
      routeInformationParser: TroRouteInformationParser(),
    );
  }
}
