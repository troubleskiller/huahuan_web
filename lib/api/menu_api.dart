import 'package:huahuan_web/model/api/response_api.dart';
import 'package:huahuan_web/util/api/http_util.dart';

class MenuApi {
  static Future<ResponseBodyApi> listAuth(data) async {
    return await HttpUtil.post('/admin/menu/listAuth', data: data);
  }

  static Future<ResponseBodyApi> list() async {
    ResponseBodyApi responseBodyApi = await HttpUtil.post(
      '/title/select',
    );
    return responseBodyApi;
  }

  ///查询所有标题
  static Future<ResponseBodyApi> listAll() async {
    ResponseBodyApi responseBodyApi = await HttpUtil.post(
      '/title/findAll',
    );
    return responseBodyApi;
  }

  ///查询当前用户所拥有的标题
  static Future<ResponseBodyApi> listByUid(data) async {
    ResponseBodyApi responseBodyApi =
        await HttpUtil.post('/title/select', data: data);
    return responseBodyApi;
  }

  static Future<ResponseBodyApi> saveOrUpdate(data) async {
    ResponseBodyApi responseBodyApi =
        await HttpUtil.post('/admin/menu/saveOrUpdate', data: data);
    return responseBodyApi;
  }

  static removeByIds(data) {
    return HttpUtil.post('/admin/menu/removeByIds', data: data);
  }
}
