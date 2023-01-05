import 'package:flutter/material.dart';

class TroToggleButtons extends StatefulWidget {
  final List<SelectOption> options;
  final Object? defaultValue;
  final double? fontSize;
  final ValueChanged? afterOnPress;
  TroToggleButtons(this.options,
      {this.defaultValue, this.fontSize, this.afterOnPress});
  @override
  TroToggleButtonsState createState() => TroToggleButtonsState();
}

class TroToggleButtonsState extends State<TroToggleButtons> {
  late List<bool> isSelected;
  @override
  void initState() {
    super.initState();
    isSelected =
        widget.options.map((e) => widget.defaultValue == e.value).toList();
  }

  @override
  Widget build(BuildContext context) {
    var list = widget.options
        .map((e) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                e.label!,
                style: TextStyle(fontSize: widget.fontSize),
              ),
            ))
        .toList();
    return ToggleButtons(
      onPressed: (index) {
        setState(() {
          for (int i = 0; i < isSelected.length; i++) {
            setState(() {
              isSelected[i] = i == index;
            });
          }
          widget.afterOnPress!(widget.options[index].value);
        });
      },
      isSelected: isSelected,
      children: list,
    );
  }
}

class SelectOption {
  SelectOption({this.value, this.label});

  Object? value;
  String? label;
}
