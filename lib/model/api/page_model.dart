import 'dart:convert';

PageModel pageModelFromJson(String str) => PageModel.fromJson(json.decode(str));
String pageModelToJson(PageModel data) => json.encode(data.toJson());

class PageModel {
  PageModel({
    int? sum,
    int? pageSize,
    int? currentPage,
    dynamic data,
    List<OrderItemModel>? orders,
    List<Map<String, dynamic>>? records,
  }) {
    _orders = orders;
    _sum = sum;
    _pageSize = pageSize;
    _currentPage = currentPage;
    _data = data;
    _records = records;
  }

  PageModel.fromJson(dynamic json) {
    _sum = json['sum'];
    _pageSize = json['pageSize'];
    _currentPage = json['currentPage'];
    _data = json['data'];
  }
  List<OrderItemModel>? _orders;
  List<Map<String, dynamic>>? _records;
  int? _sum;
  int? _pageSize;
  int? _currentPage;
  dynamic _data;
  PageModel copyWith({
    int? sum,
    int? pageSize,
    int? currentPage,
    dynamic data,
  }) =>
      PageModel(
        sum: sum ?? _sum,
        pageSize: pageSize ?? _pageSize,
        currentPage: currentPage ?? _currentPage,
        data: data ?? _data,
      );
  int? get sum => _sum;
  int? get pageSize => _pageSize;
  int? get currentPage => _currentPage;
  dynamic get data => _data;
  List<Map<String, dynamic>>? get records => _records;

  set sum(int? value) {
    _sum = value;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['sum'] = _sum;
    map['pageSize'] = _pageSize;
    map['currentPage'] = _currentPage;
    map['data'] = _data;
    return map;
  }

  @override
  String toString() {
    return 'PageModel{_orders: $_orders, _records: $_records, _sum: $_sum, _pageSize: $_pageSize, _currentPage: $_currentPage, _list: $_data}';
  }

  set pageSize(int? value) {
    _pageSize = value;
  }

  set currentPage(int? value) {
    _currentPage = value;
  }

  set data(dynamic value) {
    _data = value;
  }

  List<OrderItemModel>? get orders => _orders;

  set orders(List<OrderItemModel>? value) {
    _orders = value;
  }
}

class OrderItemModel {
  String? column;
  bool? asc;
  OrderItemModel({
    this.column,
    this.asc,
  });

  OrderItemModel copyWith({
    String? column,
    bool? asc,
  }) {
    return OrderItemModel(
      column: column ?? this.column,
      asc: asc ?? this.asc,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'column': column,
      'asc': asc,
    };
  }

  factory OrderItemModel.fromMap(Map<String, dynamic> map) {
    return OrderItemModel(
      column: map['column'],
      asc: map['asc'],
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderItemModel.fromJson(String source) =>
      OrderItemModel.fromMap(json.decode(source));

  @override
  String toString() => 'OrderItemModel(column: $column, asc: $asc)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is OrderItemModel && o.column == column && o.asc == asc;
  }

  @override
  int get hashCode => column.hashCode ^ asc.hashCode;
}
