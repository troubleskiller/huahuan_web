import 'package:huahuan_web/model/api/response_api.dart';
import 'package:huahuan_web/util/api/http_util.dart';

class UserApi {
  static Future<ResponseBodyApi> addUser(data) async {
    ResponseBodyApi responseBodyApi =
        await HttpUtil.post('/user/addUser', data: data, requestToken: true);
    return responseBodyApi;
  }

  static Future<ResponseBodyApi> login(data) async {
    ResponseBodyApi responseBodyApi =
        await HttpUtil.post('/login', data: data, requestToken: false);
    return responseBodyApi;
  }

  static Future<ResponseBodyApi> findByCreatedId(data) async {
    ResponseBodyApi responseBodyApi = await HttpUtil.post(
        '/user/findByCreatedId',
        data: data,
        requestToken: true);
    return responseBodyApi;
  }

  static Future<ResponseBodyApi> deleteUserById(data) async {
    ResponseBodyApi responseBodyApi =
        await HttpUtil.post('/user/deleteUser', data: data, requestToken: true);
    return responseBodyApi;
  }
}
