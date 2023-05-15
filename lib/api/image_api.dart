import 'package:huahuan_web/model/api/response_api.dart';
import 'package:huahuan_web/util/api/http_util.dart';

class ImageApi {
  static Future<ResponseBodyApi> getImage(data) async {
    ResponseBodyApi responseBodyApi =
        await HttpUtil.post('/config/findImageById', data: data);
    return responseBodyApi;
  }

  static Future<ResponseBodyApi> addFile(data) async {
    ResponseBodyApi responseBodyApi =
        await HttpUtil.post('/config/addFile', data: data);
    return responseBodyApi;
  }

  static Future<ResponseBodyApi> getImageByIdAndType(data) async {
    ResponseBodyApi responseBodyApi =
        await HttpUtil.post('/config/findByIdAndType', data: data);
    return responseBodyApi;
  }
}
