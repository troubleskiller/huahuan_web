import 'package:huahuan_web/model/api/response_api.dart';
import 'package:huahuan_web/util/api/http_util.dart';

class RoleApi {
  static Future<ResponseBodyApi> selectAllRole() async {
    ResponseBodyApi responseBodyApi =
        await HttpUtil.post('/role/selectAll', requestToken: true);
    return responseBodyApi;
  }

  static Future<ResponseBodyApi> deleteRole(data) async {
    ResponseBodyApi responseBodyApi =
        await HttpUtil.post('/role/delete', data: data, requestToken: true);
    return responseBodyApi;
  }

  static Future<ResponseBodyApi> addMenu(data) async {
    ResponseBodyApi responseBodyApi =
        await HttpUtil.post('/role/addTitle', data: data, requestToken: true);
    return responseBodyApi;
  }

  static Future<ResponseBodyApi> deleteMenu(data) async {
    ResponseBodyApi responseBodyApi = await HttpUtil.post('/role/deleteTitle',
        data: data, requestToken: true);
    return responseBodyApi;
  }

  static Future<ResponseBodyApi> addRole(data) async {
    ResponseBodyApi responseBodyApi =
        await HttpUtil.post('/role/add', data: data, requestToken: true);
    return responseBodyApi;
  }

  static Future<ResponseBodyApi> selectOne(data) async {
    ResponseBodyApi responseBodyApi =
        await HttpUtil.post('/role/selectOne', data: data, requestToken: true);
    return responseBodyApi;
  }

  static Future<ResponseBodyApi> recoveryRole(data) async {
    ResponseBodyApi responseBodyApi =
        await HttpUtil.post('/role/recovery', data: data, requestToken: true);
    return responseBodyApi;
  }
}
