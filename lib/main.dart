import 'package:flutter/material.dart';
import 'package:huahuan_web/screen/layout/layout_controller.dart';
import 'package:huahuan_web/screen/login.dart';
import 'package:provider/provider.dart';

import 'context/application_context.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(MyApp());
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
        home: Login(),
      ),
    );
  }
}
