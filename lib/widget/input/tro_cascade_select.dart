import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:huahuan_web/widget/input/tro_text_field.dart';

class TroCascadeSelect extends TroFormField {
  TroCascadeSelect({
    required BuildContext context,
    Key? key,
    double? width,
    String? label,
    double? labelWidth,
    String? value,
    ValueChanged? onChange,
    Function(int value)? onConfirm,
    FormFieldSetter? onSaved,
    FormFieldValidator<String>? validator,
    required BrnPickerEntity? entity,
    bool? enable,
  }) : super(
          key: key,
          width: width,
          label: label,
          labelWidth: labelWidth,
          builder: (TroFormFieldState state) {
            return StatefulBuilder(builder: (context, sst) {
              return TextFormField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  border: OutlineInputBorder(),
                  enabled: true,
                ),
                controller: TextEditingController(text: value),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (_) {
                        return Dialog(
                          child: BrnMultiColumnPicker(
                            pickerTitleConfig:
                                BrnPickerTitleConfig.Default.copyWith(
                                    titleContent: '选择所属测项'),
                            themeData: BrnPickerConfig(),
                            entity: entity ?? BrnPickerEntity(),
                            defaultFocusedIndexes: [
                              0,
                              0,
                            ],
                            onConfirm:
                                (Map<String, List<BrnPickerEntity>> result,
                                    int? firstIndex,
                                    int? secondIndex,
                                    int? thirdIndex) {
                              sst(() {
                                value = result[result['1']?[0].name]?[0].name;
                              });
                              onConfirm?.call(int.parse(
                                  '${result[result['1']?[0].name]?[0].value}'));
                            },
                          ),
                        );
                      });
                },
              );
            });
          },
        );
}
