import 'package:huahuan_web/model/api/response_api.dart';
import 'package:huahuan_web/util/api/http_util.dart';

class ProjectApi {
  static Future<ResponseBodyApi> addProject(data) async {
    ResponseBodyApi responseBodyApi =
    await HttpUtil.post('/project/add', data: data, requestToken: true);
    return responseBodyApi;
  }


  static Future<ResponseBodyApi> findAllById(data) async {
    ResponseBodyApi responseBodyApi = await HttpUtil.post(
        '/project/findListById',
        data: data,
        requestToken: true);
    return responseBodyApi;
  }

  static Future<ResponseBodyApi> deleteProjectById(data) async {
    ResponseBodyApi responseBodyApi =
    await HttpUtil.post('/project/delete', data: data, requestToken: true);
    return responseBodyApi;
  }
}
