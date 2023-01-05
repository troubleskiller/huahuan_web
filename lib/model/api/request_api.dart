import 'dart:convert';

import 'package:huahuan_web/model/api/page_model.dart';

/// data : {"id":1}
/// pageVO : {"currentPage":1,"pageSize":2}

RequestBodyApi RequestBodyApiFromJson(String str) =>
    RequestBodyApi.fromJson(json.decode(str));
String RequestBodyApiToJson(RequestBodyApi data) => json.encode(data.toJson());

class RequestBodyApi {
  RequestBodyApi({
    this.data,
    this.pageVO,
  });

  RequestBodyApi.fromJson(dynamic json) {
    data = json['data'];
    pageVO = PageModel.fromJson(json['pageVO']);
  }
  dynamic data;
  PageModel? pageVO;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.toJson();
    }
    if (pageVO != null) {
      map['pageVO'] = pageVO?.toJson();
    }
    return map;
  }

  @override
  String toString() {
    return 'RequestBodyApi{data: $data, pageVO: $pageVO}';
  }
}
