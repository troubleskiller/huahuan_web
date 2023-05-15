import 'package:huahuan_web/model/api/response_api.dart';
import 'package:huahuan_web/util/api/http_util.dart';

class CollectorApi {
  static Future<ResponseBodyApi> selectByProjectId(data) async {
    ResponseBodyApi responseBodyApi = await HttpUtil.post(
        '/collector/selectByProjectId',
        data: data,
        requestToken: true);
    return responseBodyApi;
  }

  static Future<ResponseBodyApi> update(data) async {
    ResponseBodyApi responseBodyApi = await HttpUtil.post('/collector/update',
        data: data, requestToken: true);
    return responseBodyApi;
  }

  static Future<ResponseBodyApi> add(data) async {
    ResponseBodyApi responseBodyApi =
        await HttpUtil.post('/collector/add', data: data, requestToken: true);
    return responseBodyApi;
  }

  static Future<ResponseBodyApi> delete(data) async {
    ResponseBodyApi responseBodyApi = await HttpUtil.post('/collector/delete',
        data: data, requestToken: true);
    return responseBodyApi;
  }

  static Future<ResponseBodyApi> getAll() async {
    ResponseBodyApi responseBodyApi =
        await HttpUtil.post('/collector/findAll', requestToken: true);
    return responseBodyApi;
  }

  static Future<ResponseBodyApi> getData(data) async {
    ResponseBodyApi responseBodyApi = await HttpUtil.post(
        '/collector/findDataBySn',
        data: data,
        requestToken: true);
    return responseBodyApi;
  }

  static Future<ResponseBodyApi> getStatus(data) async {
    ResponseBodyApi responseBodyApi = await HttpUtil.post(
        '/collector/findOnlineBySn',
        data: data,
        requestToken: true);
    return responseBodyApi;
  }
}
