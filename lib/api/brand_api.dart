import 'package:huahuan_web/model/api/response_api.dart';
import 'package:huahuan_web/util/api/http_util.dart';

class BrandApi {
  static Future<ResponseBodyApi> list(data) async {
    ResponseBodyApi responseBodyApi =
        await HttpUtil.post('/product/brand/list', data: data);
    return responseBodyApi;
  }

  static Future<ResponseBodyApi> save(data) async {
    ResponseBodyApi responseBodyApi =
        await HttpUtil.post('/product/brand/save', data: data);
    return responseBodyApi;
  }

  static Future<ResponseBodyApi> update(data) async {
    ResponseBodyApi responseBodyApi =
        await HttpUtil.post('/product/brand/update', data: data);
    return responseBodyApi;
  }

  static removeByIds(data) {
    return HttpUtil.post('/product/brand/delete', data: data);
  }
}
