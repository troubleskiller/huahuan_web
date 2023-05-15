import 'package:huahuan_web/model/api/response_api.dart';
import 'package:huahuan_web/util/api/http_util.dart';

class EventApi {
  static Future<ResponseBodyApi> getData(data) async {
    ResponseBodyApi responseBodyApi =
        await HttpUtil.post('/sensor/findSZByIdAndDate', data: data);
    return responseBodyApi;
  }

  static Future<ResponseBodyApi> getCeXie(data) async {
    ResponseBodyApi responseBodyApi =
        await HttpUtil.post('/sensor/findCXByIdAndDate', data: data);
    return responseBodyApi;
  }
}
