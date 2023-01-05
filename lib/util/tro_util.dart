import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:huahuan_web/context/application_context.dart';
import 'package:huahuan_web/model/application/properties.dart';
import 'package:huahuan_web/route/Tro.dart';

class TroUtils {
  static OverlayEntry? loadingOE;

  static TroProperties getTroProperties() {
    TroProperties troProperties =
        ApplicationContext.instance.getBean('troProperties');
    return troProperties;
  }

  static void message(String message, {int duration = 2}) {
    if (!kIsWeb && Platform.isWindows) {
      ScaffoldMessenger.of(Tro.context).hideCurrentSnackBar();
      ScaffoldMessenger.of(Tro.context).showSnackBar(SnackBar(
        content: Text(message),
      ));
    } else {
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  static void loading({bool tapClose = false}) {
    if (loadingOE != null) {
      return;
    }
    var child = Container(
        child: tapClose
            ? InkWell(
                child: Center(child: CircularProgressIndicator()),
                onTap: () => loaded(),
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
        decoration: new BoxDecoration(
          color: Colors.transparent,
        ));
    loadingOE = OverlayEntry(builder: (c) => child);

    Overlay.of(Tro.context)!.insert(loadingOE!);
  }

  static void loaded() {
    if (loadingOE == null) {
      return;
    }
    loadingOE!.remove();
    loadingOE = null;
  }
}

const desktopBreakpoint = 1000.0;

bool isDisplayDesktop(BuildContext context) {
  return MediaQuery.of(context).size.width > desktopBreakpoint;
}
