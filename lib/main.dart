import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:huahuan_web/screen/event_manage/event_manager.dart';
import 'package:huahuan_web/screen/layout/layout_controller.dart';
import 'package:huahuan_web/screen/login.dart';
import 'package:provider/provider.dart';
import 'package:flutter_2d_amap/flutter_2d_amap.dart';
import 'context/application_context.dart';
import 'model/application/LocaleController.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await init();
  Flutter2dAMap.updatePrivacy(true);
  Flutter2dAMap.setApiKey(
    // iOSKey: '1a8f6a489483534a9f2ca96e4eeeb9b3',
    webKey: '6a6e238f54d5ce96ed6691ea3880caac',
  ).then((_) => runApp(MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LayoutController()),
          ChangeNotifierProvider(create: (_) => LocaleController()),
        ],
        child: EasyLocalization(
            supportedLocales: [
              const Locale('en', 'US'),
              const Locale('zh', 'CN'),
            ],
            path: 'translations',
            fallbackLocale: Locale('zh', 'CN'),
            child: MyApp()
            // ProjectManager()
            ),
      )));
}

init() async {
  await ApplicationContext.instance.init();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale locale = Locale('zh','CN');
  LocaleController _localeController = LocaleController();
  // This widget is the root of your application.
  void initLocaleListener() {
    _localeController = Provider.of<LocaleController>(context, listen: false);
    _localeController.addListener(localeUpdated);
    // init the locale variable with context.locale
    WidgetsBinding.instance.addPostFrameCallback((_) {
      locale = context.locale;
    });
  }

  void localeUpdated() async {
    // Only update context locale if the newLocale is not same as current context locale
    if (_localeController.locale != locale) {
      locale = _localeController.locale;
      // Update context locale
      await context.setLocale(locale);

      setState(() {});
    }
  }
  @override
  void initState() {
    // Init locale listener to listen for locale changes
    initLocaleListener();
    // TODO: implement initState
    super.initState();

  }
  @override
  void dispose() {
    // Remove locale controller listener
    _localeController.removeListener(localeUpdated);

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      locale: context.locale,
      supportedLocales: [
        const Locale('en','US'),
        const Locale('zh','CN'),
      ],
      home: Login(),
    );
  }
}
