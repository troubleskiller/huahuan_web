import 'package:flutter/cupertino.dart';


class LocaleController with ChangeNotifier {

  Locale _locale =  Locale('zh','CN');

  Locale get locale => _locale;

  // Update the locale locally based on the user's newly set locale
  void updateLocale({
    String? newLocaleStr,
    Locale? newLocale,
  }) {
    if (newLocale != null) {
      _assignLocaleLocally(newLocale);
    }
  }

  void _assignLocaleLocally(Locale newLocale) {
    _locale = newLocale;
    notifyListeners();
  }

  // Future<UserLocalesModel> getUserLocales() async {
  //   UserLocalesModel userLocales = UserLocalesModel();
  //   dynamic response = await _localeService.getUserLocales();
  //
  //   try {
  //     if (response['statusCode'] == 200) {
  //       userLocales = UserLocalesModel.fromJson(response);
  //     }
  //   } catch (e) {
  //     print('Failed to decode userLocales with error: $e');
  //   }
  //
  //   return userLocales;
  // }

  // Future<UserLocalesModel> getUserLocalesByIp(String ipAddress) async {
  //   UserLocalesModel userLocales = UserLocalesModel();
  //   dynamic response = await _localeService.getUserLocalesByIp(ipAddress);
  //
  //   try {
  //     if (response['statusCode'] == 200) {
  //       userLocales = UserLocalesModel.fromJson(response);
  //     }
  //   } catch (e) {
  //     print('Failed to decode userLocales with error: $e');
  //   }
  //
  //   return userLocales;
  // }

}
