import 'package:flutter/material.dart';
import 'package:huahuan_web/widget/input/tro_text_field.dart';

class TroSelect extends TroFormField {
  TroSelect({
    Key? key,
    String? label,
    String? value,
    ValueChanged? onChange,
    FormFieldSetter? onSaved,
    List<SelectOptionVO> dataList = const [],
  }) : super(
          key: key,
          label: label,
          builder: (TroFormFieldState state) {
            return DropdownButtonFormField<String>(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                border: OutlineInputBorder(),
              ),
              value: value,
              items: dataList.map((v) {
                return DropdownMenuItem<String>(
                  value: v.value as String?,
                  child: Text(v.label!),
                );
              }).toList(),
              onChanged: (v) {
                value = v;
                if (onChange != null) {
                  onChange(v);
                }
                state.didChange();
              },
              onSaved: (v) {
                if (onSaved != null) {
                  onSaved(v);
                }
              },
            );
          },
        );
}

class SelectOptionVO {
  SelectOptionVO({this.value, this.label});

  Object? value;
  String? label;
}
