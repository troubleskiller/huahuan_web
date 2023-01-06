import 'package:huahuan_web/model/api/response_api.dart';
import 'package:huahuan_web/util/api/http_util.dart';

class RoleApi {
  static Future<ResponseBodyApi> selectAllRole(data) async {
    ResponseBodyApi responseBodyApi =
        await HttpUtil.post('/role/selectAll', data: data, requestToken: true);
    return responseBodyApi;
  }

  static Future<ResponseBodyApi> removeByIds(data) async {
    ResponseBodyApi responseBodyApi =
        await HttpUtil.post('/role/delete', data: data, requestToken: true);
    return responseBodyApi;
  }
}
