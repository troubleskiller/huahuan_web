import 'dart:io';

import 'package:dio/dio.dart';

void main() async {
  final file = File(
      '/Users/xuhui/troubleskiller_tech/huahuan_web/upload_files/1679665419642.jpg');
  MultipartFile multipartFile = await MultipartFile.fromFile(file.path);
  print(multipartFile);
  final formData = FormData.fromMap({
    // 'thisId': 1,
    // 'type': 1,
    'file': multipartFile,
    // "name": '111.jpg'
  });

  BaseOptions options = BaseOptions(
    baseUrl: 'https://5d0373l953.zicp.fun',
    connectTimeout: 200000,
    receiveTimeout: 200000,
    sendTimeout: 200000,
    headers: {
      'User-Agent': 'Mozilla 5.10',
      'USERNAME': 'SANDBOX',
      "Content-Type": "multipart/form-data",
      'token':
          'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxIiwiZXhwIjoxNjgxNzAwNjM1fQ.APVJVA7s-Om44SH968FJDrfjF710TK7oR1hp95R3Xd0',
    },
  );

  Dio dio = Dio(options);
  // dio.options.responseType = ResponseType.bytes;

  ///测试上传图片
  final response = await dio.post('/config/addImg', data: formData,
      onSendProgress: (sent, total) {
    // do something
  });
  print(response.data);

  ///测试拉取图片集合
  // final response1 =
  //     await dio.post('/config/findByIdAndType', data: {"thisId": 4, "type": 1});
  // print(response1);

  // final formData1 = FormData.fromMap({
  //   'name': '123.jpg',
  // });
  // final response2 = await dio.get('/config/findImageById', queryParameters: {
  //   'name': '123.jpg',
  // });
  // 将字符串转换为字节流
  // print(response2.data);
  // Uint8List uint8list = Uint8List.fromList(utf8.encode(response2.data));
  // print(uint8list);

  // 读取响应流
  // final bytes = await consolidateHttpClientResponseBytes(response1.data);

  // 将字节数组转换为图像
  // final image = Image.memory(bytes);

  // 在屏幕上显示图像
  // runApp(MaterialApp(
  //   home: Scaffold(
  //     body: Center(
  //       child: image,
  //     ),
  //   ),
  // ));
}
