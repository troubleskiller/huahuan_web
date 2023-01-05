import 'package:flutter/services.dart';
import 'package:huahuan_web/model/application/properties.dart';
import 'package:yaml/yaml.dart';

class ApplicationContext {
  ApplicationContext._();

  static ApplicationContext? _instance;

  static ApplicationContext get instance => _getInstance();

  static ApplicationContext _getInstance() {
    _instance ??= ApplicationContext._();
    return _instance!;
  }

  Map beanMap = Map();
  late YamlMap yamlMap;
  late Map variableMap;
  late String privacy;

  init() async {
    await loadApplication();
    loadPrivacy();
  }

  MapEntry convertVariable(key, value) {
    var match = RegExp(r'\$\{(.*)\}').firstMatch(value.toString());
    if (match != null) {
      var value2 = variableMap[match.group(1)];
      return MapEntry(key, value2);
    }
    return MapEntry(key, value);
  }

  parseCryProperties() async {
    YamlMap tro = yamlMap.nodes['mall']!.value;
    Map profiles = tro['profiles'].value;
    String? profilesActive = profiles['active'];
    if (profilesActive != null) {
      var profilesStr = await rootBundle
          .loadString('config/application-$profilesActive.yaml');
      variableMap = await loadYaml(profilesStr);
      print('profile-$profilesActive');
      print(variableMap);
    }

    TroProperties troProperties = TroProperties();
    troProperties.loggerProperties =
        LoggerProperties.fromMap(tro['logger'].value.map(convertVariable));
    troProperties.apiProperties =
        ApiProperties.fromMap(tro['api'].value.map(convertVariable));
    addBean('troProperties', troProperties);
  }

  loadApplication() async {
    var yamlStr = await rootBundle.loadString('config/application.yaml');
    yamlMap = loadYaml(yamlStr);
    print("application:");
    print(yamlMap.nodes);
    await parseCryProperties();
  }

  loadPrivacy() async {
    privacy = await rootBundle.loadString('PRIVACY');
    print(privacy);
  }

  addBean(String key, object) {
    beanMap[key] = object;
  }

  getBean(String key) {
    return beanMap[key];
  }
}
