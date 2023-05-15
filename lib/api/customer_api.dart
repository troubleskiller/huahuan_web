import 'package:huahuan_web/model/api/response_api.dart';
import 'package:huahuan_web/util/api/http_util.dart';

class CustomerApi {
  static Future<ResponseBodyApi> list(data) async {
    ResponseBodyApi responseBodyApi =
        await HttpUtil.post('/customer/findByUserId', data: data);
    return responseBodyApi;
  }

  static Future<ResponseBodyApi> add(data) async {
    ResponseBodyApi responseBodyApi =
        await HttpUtil.post('/customer/add', data: data);
    return responseBodyApi;
  }

  static Future<ResponseBodyApi> update(data) async {
    ResponseBodyApi responseBodyApi =
        await HttpUtil.post('/customer/update', data: data);
    return responseBodyApi;
  }

  static removeByIds(data) {
    return HttpUtil.post('/customer/del', data: data);
  }
}
