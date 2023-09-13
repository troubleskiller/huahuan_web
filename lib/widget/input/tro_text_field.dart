import 'package:flutter/material.dart';

class TroFormField extends StatefulWidget {
  final String? label;
  final double? width;
  final double? labelWidth;
  final TextStyle? labelStyle;
  final Function(TroFormFieldState)? builder;

  TroFormField({
    Key? key,
    this.label,
    this.builder,
    this.width,
    this.labelWidth,
    this.labelStyle,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => TroFormFieldState();
}

class TroFormFieldState extends State<TroFormField> {
  didChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var displayDesktop = MediaQuery.of(context).size.width > 1000;
    if (!displayDesktop) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: widget.labelWidth ?? 120,
              child: Padding(
                padding: EdgeInsets.only(right: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.label!,
                    style: widget.labelStyle ??
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ),
            ),
            Expanded(
              child: widget.builder!(this),
            )
          ],
        ),
      );
    } else {
      double boxWidth = (widget.width ?? 300) - (widget.labelWidth ?? 100);
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: UnconstrainedBox(
          child: Row(
            children: <Widget>[
              SizedBox(
                width: widget.labelWidth ?? 120,
                child: Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Align(
                    child: Text(widget.label!,
                        style: widget.labelStyle ??
                            TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                        textDirection: TextDirection.ltr),
                    alignment: Alignment.centerRight,
                  ),
                ),
              ),
              SizedBox(
                width: boxWidth,
                child: widget.builder!(this),
              ),
            ],
          ),
        ),
      );
    }
  }
}
