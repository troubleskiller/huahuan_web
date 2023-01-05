import 'package:flutter/material.dart';
import 'package:huahuan_web/route/route_delegate.dart';

class TroRoute {
  TroRoute._();

  static TroRoute? _instance;

  static TroRoute get instance => _getInstance();

  static TroRoute _getInstance() {
    if (_instance == null) {
      _instance = TroRoute._();
    }
    return _instance!;
  }

  late TroRouterDelegate _TroRouterDelegate;

  init(TroRouterDelegate TroRouterDelegate) {
    _TroRouterDelegate = TroRouterDelegate;
  }

  push(Widget widget) => _TroRouterDelegate.push(widget);

  pushNamed(String name) => _TroRouterDelegate.pushNamed(name);

  pushNamedAndRemove(String name) =>
      _TroRouterDelegate.pushNamedAndRemove(name);

  popAndPushNamed(String name) => _TroRouterDelegate.popAndPushNamed(name);

  pop() => _TroRouterDelegate.pop();
}
