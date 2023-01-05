import 'package:huahuan_web/util/tro_util.dart';

class TroLogger {
  static error(_) {
    if ([
      TroConstant.LOGGEER_LEVEL_ERROR,
      TroConstant.LOGGEER_LEVEL_INFO,
      TroConstant.LOGGEER_LEVEL_DEBUG
    ].contains(TroUtils.getTroProperties().loggerProperties.level)) {
      print(_);
    }
  }

  static info(_) {
    if ([TroConstant.LOGGEER_LEVEL_INFO, TroConstant.LOGGEER_LEVEL_DEBUG]
        .contains(TroUtils.getTroProperties().loggerProperties.level)) {
      print(_);
    }
  }

  static debug(_) {
    if ([TroConstant.LOGGEER_LEVEL_DEBUG]
        .contains(TroUtils.getTroProperties().loggerProperties.level)) {
      print(_);
    }
  }
}

class TroConstant {
  static const String KEY_DIO_INTERCEPTORS = "dioInterceptors";

  static const String LOGGEER_LEVEL_ERROR = "error";
  static const String LOGGEER_LEVEL_INFO = "info";
  static const String LOGGEER_LEVEL_DEBUG = "debug";
}
