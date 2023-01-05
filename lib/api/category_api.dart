import 'package:huahuan_web/model/api/response_api.dart';
import 'package:huahuan_web/util/api/http_util.dart';

class CategoryApi {
  static Future<ResponseBodyApi> listTree() async {
    ResponseBodyApi responseBodyApi = await HttpUtil.post(
      '/product/category/list/tree',
    );
    return responseBodyApi;
  }

  static Future<ResponseBodyApi> list() async {
    ResponseBodyApi responseBodyApi = await HttpUtil.post(
      '/product/category/list',
    );
    return responseBodyApi;
  }

  static Future<ResponseBodyApi> saveOrUpdate(data) async {
    ResponseBodyApi responseBodyApi =
        await HttpUtil.post('/product/category/save', data: data);
    return responseBodyApi;
  }

  static removeByIds(data) {
    return HttpUtil.post('/product/category/delete', data: data);
  }
}
