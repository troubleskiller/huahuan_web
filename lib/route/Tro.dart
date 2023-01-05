import 'package:flutter/material.dart';
import 'package:huahuan_web/route/route.dart';

class Tro {
  static GlobalKey<NavigatorState>? navigatorKey;

  static get context {
    if (navigatorKey == null) {
      throw FlutterError('未初始化NavigatorKey');
    }
    return navigatorKey!.currentContext;
  }

  static Widget init(BuildContext context, Widget? child) {
    return Material(
      child: Overlay(
        initialEntries: [
          OverlayEntry(builder: (c) => child ?? Container()),
        ],
      ),
    );
  }

  static pushNamedAndRemove(String name) {
    TroRoute.instance.pushNamedAndRemove(name);
  }

  static popAndPushNamed(String name) {
    TroRoute.instance.popAndPushNamed(name);
  }

  static pushNamed(String name) {
    TroRoute.instance.pushNamed(name);
  }

  static push(Widget widget) {
    TroRoute.instance.push(widget);
  }

  static pop() => TroRoute.instance.pop();
}
