import 'package:huahuan_web/model/api/response_api.dart';
import 'package:huahuan_web/util/api/http_util.dart';

class ProjectApi {
  static Future<ResponseBodyApi> addProject(data) async {
    ResponseBodyApi responseBodyApi =
        await HttpUtil.post('/project/add', data: data, requestToken: true);
    return responseBodyApi;
  }

  static Future<ResponseBodyApi> updateProject(data) async {
    ResponseBodyApi responseBodyApi =
        await HttpUtil.post('/project/update', data: data, requestToken: true);
    return responseBodyApi;
  }

  static Future<ResponseBodyApi> findAllById(data) async {
    ResponseBodyApi responseBodyApi = await HttpUtil.post(
        '/project/findListById',
        data: data,
        requestToken: true);
    return responseBodyApi;
  }

  static Future<ResponseBodyApi> findAll() async {
    ResponseBodyApi responseBodyApi =
        await HttpUtil.post('/project/findAll', requestToken: true);
    return responseBodyApi;
  }

  static Future<ResponseBodyApi> deleteProjectById(data) async {
    ResponseBodyApi responseBodyApi =
        await HttpUtil.post('/project/delete', data: data, requestToken: true);
    return responseBodyApi;
  }

  static Future<ResponseBodyApi> cancelProject(data) async {
    ResponseBodyApi responseBodyApi =
        await HttpUtil.post('/project/cancel', data: data, requestToken: true);
    return responseBodyApi;
  }

  static Future<ResponseBodyApi> empowerProject(data) async {
    ResponseBodyApi responseBodyApi =
        await HttpUtil.post('/project/empower', data: data, requestToken: true);
    return responseBodyApi;
  }

  ///查询当前项目的所有测项
  static Future<ResponseBodyApi> getCurEvents(data) async {
    ResponseBodyApi responseBodyApi = await HttpUtil.post(
        '/surveyItem/findListById',
        data: data,
        requestToken: true);
    return responseBodyApi;
  }

  ///查询所有病害和工况
  static Future<ResponseBodyApi> getAllStates(data) async {
    ResponseBodyApi responseBodyApi = await HttpUtil.post(
        '/projectState/findByProjectId',
        data: data,
        requestToken: true);
    return responseBodyApi;
  }

  static Future<ResponseBodyApi> updateState(data) async {
    ResponseBodyApi responseBodyApi = await HttpUtil.post(
        '/projectState/update',
        data: data,
        requestToken: true);
    return responseBodyApi;
  }

  static Future<ResponseBodyApi> addState(data) async {
    ResponseBodyApi responseBodyApi = await HttpUtil.post('/projectState/add',
        data: data, requestToken: true);
    return responseBodyApi;
  }
}
