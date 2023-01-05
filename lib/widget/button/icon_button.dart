import 'package:flutter/material.dart';

class ButtonWithIcon extends StatelessWidget {
  final String? label;
  final VoidCallback? onPressed;
  final IconData? iconData;
  final String? tip;
  final EdgeInsets? padding;
  final Color? iconColor;

  const ButtonWithIcon(
      {this.label,
      this.iconColor,
      this.iconData,
      this.onPressed,
      this.tip,
      this.padding});

  @override
  Widget build(BuildContext context) {
    Widget result;
    if (iconData != null) {
      if (label == null) {
        result = IconButton(
          icon: Icon(
            iconData,
            color: iconColor,
          ),
          onPressed: onPressed,
        );
      } else {
        result = ElevatedButton.icon(
          icon: Icon(
            iconData,
            color: iconColor,
          ),
          label: Text(label!),
          onPressed: onPressed,
        );
      }
    } else {
      result = ElevatedButton(
        onPressed: onPressed,
        child: Text(label ?? ''),
      );
    }
    if (padding != null) {
      result = Container(padding: padding, child: result);
    }

    if (tip != null) {
      result = Tooltip(
        message: tip!,
        child: result,
      );
    }
    return result;
  }
}
