import 'dart:convert';

import 'package:flutter/material.dart';

class TabPage {
  int? id;
  String? name;
  String? thisName;
  String? url;
  Widget? widget;

  TabPage({
    this.id,
    this.name,
    this.thisName,
    this.url,
    this.widget,
  });

  TabPage copyWith({
    int? id,
    String? name,
    String? thisName,
    String? url,
    Widget? widget,
  }) {
    return TabPage(
      id: id ?? this.id,
      name: name ?? this.name,
      thisName: thisName ?? this.thisName,
      url: url ?? this.url,
      widget: widget ?? this.widget,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'thisName': thisName,
      'url': url,
      'widget': widget?.toStringShort(),
    };
  }

  factory TabPage.fromMap(Map<String, dynamic> map) {
    return TabPage(
      id: map['id'],
      name: map['name'],
      thisName: map['thisName'],
      url: map['url'],
      // widget: Widget.fromMap(map['widget']),
    );
  }

  String toJson() => json.encode(toMap());

  factory TabPage.fromJson(String source) =>
      TabPage.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TabPage(id: $id, name: $name, thisName: $thisName, url: $url, widget: $widget)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is TabPage &&
        o.id == id &&
        o.name == name &&
        o.thisName == thisName &&
        o.url == url &&
        o.widget == widget;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        thisName.hashCode ^
        url.hashCode ^
        widget.hashCode;
  }
}
