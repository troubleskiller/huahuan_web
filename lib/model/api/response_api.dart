class ResponseBodyApi<T> {
  ResponseBodyApi({
    this.code,
    this.data,
    this.success,
    this.msg,
  });

  ResponseBodyApi.fromJson(dynamic json) {
    code = json['code'];
    data = json['data'];
    success = json['success'];
    msg = json['msg'];
  }
  int? code;
  T? data;
  bool? success;
  String? msg;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = code;
    map['data'] = data;
    map['success'] = success;
    map['msg'] = msg;
    return map;
  }

  @override
  String toString() {
    return 'ResponseBodyApi{code: $code, data: $data, success: $success, msg: $msg}';
  }
}
