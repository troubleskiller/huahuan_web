import 'package:dio/dio.dart';
import 'package:huahuan_web/constant/constant.dart';
import 'package:huahuan_web/model/api/response_api.dart';
import 'package:huahuan_web/model/application/properties.dart';
import 'package:huahuan_web/util/store_util.dart';
import 'package:huahuan_web/util/tro_util.dart';

class HttpUtil {
  static Dio? dio;
  static const String POST = 'post';
  static const String GET = 'get';

  static Future<ResponseBodyApi> get(String url,
      {data, requestToken = true}) async {
    return await request(url,
        data: data, requestToken: requestToken, method: GET);
  }

  static Future<ResponseBodyApi> post(String url,
      {data, requestToken = true}) async {
    return await request(url, data: data, requestToken: requestToken);
  }

  static Future<ResponseBodyApi> request(String url,
      {data, method, requestToken = true}) async {
    data = data ?? {};
    method = method ?? POST;

    Dio dio = createInstance(requestToken: requestToken)!;
    dio.options.method = method;

    ResponseBodyApi responseBodyApi;
    try {
      Response res = await dio.request(url, data: data);
      responseBodyApi = ResponseBodyApi.fromJson(res.data);
    } catch (e) {
      responseBodyApi = ResponseBodyApi();
    }

    return responseBodyApi;
  }

  static Dio? createInstance({requestToken = true}) {
    // if (dio == null) {
    TroProperties troProperties = TroUtils.getTroProperties();
    var apiProperties = troProperties.apiProperties;
    late BaseOptions options;
    if (requestToken) {
      print('1111');
      print(
        StoreUtil.read(Constant.KEY_TOKEN),
      );
      options = BaseOptions(
          baseUrl: apiProperties.baseUrl!,
          connectTimeout: apiProperties.connectTimeout,
          receiveTimeout: apiProperties.receiveTimeout,
          headers: {
            "Content-Type": "application/json",
            "User-Agent": "Mozilla 5.10", // 这里的设置是必须的必
            "USERNAME": "SANDBOX",
            "token": StoreUtil.read(Constant.KEY_TOKEN),
          });
    } else {
      options = BaseOptions(
          baseUrl: apiProperties.baseUrl!,
          connectTimeout: apiProperties.connectTimeout,
          receiveTimeout: apiProperties.receiveTimeout,
          headers: {
            "Content-Type": "application/json",
            "User-Agent": "Mozilla 5.10", // 这里的设置是必须的必
            "USERNAME": "SANDBOX",
          });
    }

    dio = Dio(options);
    // List<Interceptor>? list =
    //     ApplicationContext.instance.getBean(TroConstant.KEY_DIO_INTERCEPTORS);
    // if (list != null && list.isNotEmpty) {
    //   dio!.interceptors.addAll(list);
    // }
    // }

    return dio;
  }

  static clear() {
    dio = null;
  }
}
