import 'package:huahuan_web/model/api/response_api.dart';
import 'package:huahuan_web/util/api/http_util.dart';

class SensorApi {
  static Future<ResponseBodyApi> selectByProjectId(data) async {
    ResponseBodyApi responseBodyApi = await HttpUtil.post(
        '/sensor/selectByProjectId',
        data: data,
        requestToken: true);
    return responseBodyApi;
  }

  static Future<ResponseBodyApi> update(data) async {
    ResponseBodyApi responseBodyApi =
        await HttpUtil.post('/sensor/update', data: data, requestToken: true);
    return responseBodyApi;
  }

  static Future<ResponseBodyApi> add(data) async {
    ResponseBodyApi responseBodyApi =
        await HttpUtil.post('/sensor/add', data: data, requestToken: true);
    return responseBodyApi;
  }

  static Future<ResponseBodyApi> delete(data) async {
    ResponseBodyApi responseBodyApi =
        await HttpUtil.post('/sensor/delete', data: data, requestToken: true);
    return responseBodyApi;
  }
}
