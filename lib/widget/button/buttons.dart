/// @author: cairuoyu
/// @homepage: http://cairuoyu.com
/// @github: https://github.com/cairuoyu/cry、https://github.com/cairuoyu/flutter_admin
/// @date: 2021/6/21
/// @version: 1.0
/// @description:
import 'package:flutter/material.dart';

import 'icon_button.dart';

class ButtonWithIcons {
  ButtonWithIcons._();

  static add(context, onPressed, {showLabel = true}) => ButtonWithIcon(
      label: showLabel ? 'add' : null,
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
      label: showLabel ? 'delete' : null,
      iconData: Icons.delete,
      onPressed: onPressed);

  static edit(context, onPressed, {showLabel = true}) => ButtonWithIcon(
      label: showLabel ? 'edit' : null,
      iconData: Icons.edit,
      onPressed: onPressed);

  static query(context, onPressed, {showLabel = true}) => ButtonWithIcon(
      label: showLabel ? 'query' : null,
      iconData: Icons.search,
      onPressed: onPressed);

  static reset(context, onPressed, {showLabel = true}) => ButtonWithIcon(
      label: showLabel ? 'reset' : null,
      iconData: Icons.refresh,
      onPressed: onPressed);

  static save(context, onPressed, {showLabel = true}) => ButtonWithIcon(
      label: showLabel ? 'save' : null,
      iconData: Icons.save,
      onPressed: onPressed);

  static cancel(context, onPressed, {showLabel = true}) => ButtonWithIcon(
      label: showLabel ? 'cancel' : null,
      iconData: Icons.cancel,
      onPressed: onPressed);

  static commit(context, onPressed, {showLabel = true}) => ButtonWithIcon(
      label: showLabel ? 'commit' : null,
      iconData: Icons.done,
      onPressed: onPressed);

  static sensor(context, onPressed, {showLabel = true}) => ButtonWithIcon(
      label: showLabel ? 'sensor' : null,
      iconData: Icons.sensors,
      onPressed: onPressed);

  static data(context, onPressed, {showLabel = true}) => ButtonWithIcon(
      label: showLabel ? 'data' : null,
      iconData: Icons.data_exploration_outlined,
      onPressed: onPressed);
}
