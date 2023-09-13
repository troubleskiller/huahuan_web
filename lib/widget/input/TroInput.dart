import 'package:flutter/material.dart';
import 'package:huahuan_web/widget/input/tro_text_field.dart';

class TroInput extends TroFormField {
  TroInput({
    Key? key,
    double? width,
    String? label,
    double? labelWidth,
    String? value,
    int? maxLines,
    ValueChanged? onChange,
    FormFieldSetter? onSaved,
    FormFieldValidator<String>? validator,
    bool? enable,
  }) : super(
          key: key,
          width: width,
          label: label,
          labelWidth: labelWidth,
          builder: (state) {
            return TextFormField(
              maxLines: maxLines,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                border: OutlineInputBorder(),
                enabled: enable ?? true,
              ),
              controller: TextEditingController(text: value),
              onChanged: (v) {
                if (onChange != null) {
                  onChange(v);
                }
              },
              onSaved: (v) {
                if (onSaved != null) {
                  onSaved(v);
                }
              },
              validator: validator,
            );
          },
        );
}
