import 'package:flutter/material.dart';

class CommonCard extends StatelessWidget {
  final Color? backgroundColor;
  final double? radius;
  final EdgeInsetsGeometry? padding;
  final Widget child;

  const CommonCard(
      {Key? key,
      this.backgroundColor,
      this.radius,
      this.padding,
      required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(radius ?? 12),
      ),
      child: child,
    );
  }
}
