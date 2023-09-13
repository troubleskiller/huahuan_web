import 'package:flutter/material.dart';

import 'icon_button.dart';

class ButtonWithIcons {
  ButtonWithIcons._();

  static add(context, onPressed, {showLabel = true}) => ButtonWithIcon(
      label: showLabel ? '添加' : null,
      iconData: Icons.add,
      onPressed: onPressed);
  static collect(context, onPressed, {showLabel = true}) => ButtonWithIcon(
      label: showLabel ? '采集仪' : null,
      iconData: Icons.sensors,
      onPressed: onPressed);
  static detect(context, onPressed, {showLabel = true}) => ButtonWithIcon(
      label: showLabel ? '测点' : null,
      iconData: Icons.watch,
      onPressed: onPressed);

  static delete(context, onPressed, {showLabel = true}) => ButtonWithIcon(
      label: showLabel ? '删除' : null,
      iconData: Icons.delete,
      onPressed: onPressed);

  static edit(context, onPressed, {showLabel = true}) => ButtonWithIcon(
      label: showLabel ? '编辑' : null,
      iconData: Icons.edit,
      onPressed: onPressed);

  static query(context, onPressed, {showLabel = true}) => ButtonWithIcon(
      label: showLabel ? '搜索' : null,
      iconData: Icons.search,
      onPressed: onPressed);

  static reset(context, onPressed, {showLabel = true}) => ButtonWithIcon(
      label: showLabel ? '刷新' : null,
      iconData: Icons.refresh,
      onPressed: onPressed);

  static save(context, onPressed, {showLabel = true}) => ButtonWithIcon(
      label: showLabel ? '保存' : null,
      iconData: Icons.save,
      onPressed: onPressed);

  static cancel(context, onPressed, {showLabel = true}) => ButtonWithIcon(
      label: showLabel ? '取消' : null,
      iconData: Icons.cancel,
      onPressed: onPressed);

  static commit(context, onPressed, {showLabel = true}) => ButtonWithIcon(
      label: showLabel ? '提交' : null,
      iconData: Icons.done,
      onPressed: onPressed);

  static sensor(context, onPressed, {showLabel = true}) => ButtonWithIcon(
      label: showLabel ? '传感器' : null,
      iconData: Icons.sensors,
      onPressed: onPressed);

  static data(context, onPressed, {showLabel = true}) => ButtonWithIcon(
      label: showLabel ? '数据' : null,
      iconData: Icons.data_exploration_outlined,
      onPressed: onPressed);
}
