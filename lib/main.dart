import 'package:flutter/material.dart';
import 'package:huahuan_web/screen/event_manage/event_manager.dart';
import 'package:huahuan_web/screen/layout/layout_controller.dart';
import 'package:huahuan_web/screen/login.dart';
import 'package:provider/provider.dart';
import 'package:flutter_2d_amap/flutter_2d_amap.dart';
import 'context/application_context.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  Flutter2dAMap.updatePrivacy(true);
  Flutter2dAMap.setApiKey(
    // iOSKey: '1a8f6a489483534a9f2ca96e4eeeb9b3',
    webKey: '6a6e238f54d5ce96ed6691ea3880caac',
  ).then((_)=>runApp(MyApp()));
}

init() async {
  await ApplicationContext.instance.init();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => (LayoutController())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        //主题
        home:
        // ProjectManager()
        Login(),
      ),
    );
  }
}
