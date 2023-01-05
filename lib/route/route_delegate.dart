/// @author: cairuoyu
/// @homepage: http://cairuoyu.com
/// @github: https://github.com/cairuoyu/cry、https://github.com/cairuoyu/flutter_admin
/// @date: 2021/6/21
/// @version: 1.0
/// @description:
import 'package:flutter/material.dart';
import 'package:huahuan_web/route/route.dart';

import 'Tro.dart';

class TroRouterDelegate extends RouterDelegate<RouteInformation>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RouteInformation> {
  List<Page> pages = [];
  Map pageMap;

  String? location;

  TroRouterDelegate({required this.pageMap}) {
    TroRoute.instance.init(this);
  }

  @override
  RouteInformation get currentConfiguration {
    return RouteInformation(location: location ?? '/');
  }

  @override
  Widget build(BuildContext context) {
    if (pages.length == 0) {
      return Container();
    }
    return Navigator(
      key: Tro.navigatorKey = navigatorKey,
      pages: pages,
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        pop();

        return true;
      },
    );
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => GlobalKey<NavigatorState>();

  @override
  Future<void> setNewRoutePath(RouteInformation routeInformation) async {
    popAndPushNamed(routeInformation.location ?? '/');
  }

  pushNamedAndRemove(String name) {
    if (pages.length > 0) {
      pages.clear();
    }
    pushNamed(name);
  }

  popAndPushNamed(String name) {
    if (pages.length > 0) {
      pages.removeLast();
    }
    pushNamed(name);
  }

  pushNamed(String name) {
    var widget = pageMap[name];
    location = name;
    if (widget == null) {
      widget = Container();
      location = '404';
    }

    pages.add(
      MaterialPage(
        key: UniqueKey(),
        child: widget,
      ),
    );

    notifyListeners();
  }

  push(Widget widget) {
    pages.add(
      MaterialPage(
        key: UniqueKey(),
        child: widget,
      ),
    );

    notifyListeners();
  }

  pop() {
    if (pages.length > 0) {
      pages.removeLast();
      notifyListeners();
    }
  }
}
