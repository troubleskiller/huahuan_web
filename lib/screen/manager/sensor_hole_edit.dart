import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:huahuan_web/constant/common_constant.dart';
import 'package:huahuan_web/model/admin/SensorHoleModel.dart';
import 'package:huahuan_web/util/store_util.dart';
import 'package:huahuan_web/util/tro_util.dart';
import 'package:huahuan_web/widget/button/icon_button.dart';
import 'package:huahuan_web/widget/input/TroInput.dart';

import '../../api/sensor_api.dart';

class SensorHoleEdit extends StatefulWidget {
  final SensorHoleModel? sensorData;
  final List<RefSensor>? refSensors;
  final int? projectId;

  const SensorHoleEdit(
      {Key? key, this.sensorData, this.refSensors, this.projectId})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SensorHoleEditState();
  }
}

class RefSensor {
  int? id;
  String? name;

  RefSensor({this.name, this.id});
}

class SensorHoleEditState extends State<SensorHoleEdit> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  SensorHoleModel _sensorData = SensorHoleModel();
  BrnPortraitRadioGroupOption? selectedValue;
  BrnPortraitRadioGroupOption? selectedValue2;
  BrnPortraitRadioGroupOption? selectedValue3;
  String? initValue;
  String? initValue2;
  String? initValue3;
  List<RefSensor> refSensors = [];

  @override
  void initState() {
    if (widget.sensorData != null) {
      _sensorData = widget.sensorData!;

      initValue = sensorMap[_sensorData.sensorTypeId];
      initValue2 = paramsEx[_sensorData.unitId];
    }
    _sensorData.projectId = widget.projectId;
    refSensors = widget.refSensors ?? [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var form = Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TroInput(
            value: _sensorData.name,
            label: '设备名称',
            onSaved: (v) {
              _sensorData.name = v;
            },
            validator: (v) {
              return v!.isEmpty ? 'required' : null;
            },
          ),
          TroInput(
            value: _sensorData.sn,
            label: '设备编号',
            onSaved: (v) {
              _sensorData.sn = v;
            },
          ),
          BrnExpandableGroup(
            title: '传感器类型',
            children: [
              BrnPortraitRadioGroup.withSimpleList(
                selectedOption: initValue ?? '',
                options: sensorMap.values.toList(),
                onChanged: (BrnPortraitRadioGroupOption? old,
                    BrnPortraitRadioGroupOption? newList) {
                  BrnToast.show(newList?.title ?? '', context);
                  selectedValue = newList;
                  _sensorData.sensorTypeId = sensorMapF[selectedValue?.title];
                },
              ),
            ],
            onExpansionChanged: (a) async {
              // await getAllCustomersAccessible();
            },
          ),
          TroInput(
            value: _sensorData.addr.toString(),
            label: '位置',
            onSaved: (v) {
              _sensorData.addr = int.parse(v);
            },
          ),
          TroInput(
            value: _sensorData.initValue,
            label: '初始值',
            onSaved: (v) {
              _sensorData.initValue = v;
            },
          ),
          TroInput(
            value: _sensorData.initValue,
            label: '零位值',
            onSaved: (v) {
              _sensorData.sensorZero = v;
            },
          ),
          TroInput(
            value: _sensorData.initValue,
            label: '偏移值',
            onSaved: (v) {
              _sensorData.sensorOffset = v;
            },
          ),
          BrnExpandableGroup(
            title: '单位',
            children: [
              BrnPortraitRadioGroup.withSimpleList(
                selectedOption: initValue2 ?? '',
                options: paramsEx.values.toList(),
                onChanged: (BrnPortraitRadioGroupOption? old,
                    BrnPortraitRadioGroupOption? newList) {
                  BrnToast.show(newList?.title ?? '', context);
                  selectedValue2 = newList;
                  _sensorData.unitId = paramsExF[selectedValue2?.title];
                },
              ),
            ],
            onExpansionChanged: (a) async {
              // await getAllCustomersAccessible();
            },
          ),
          BrnExpandableGroup(
            title: '参考点',
            children: [
              BrnPortraitRadioGroup.withSimpleList(
                selectedOption: initValue3 ?? '',
                options: refSensors.map((e) => e.name!).toList(),
                onChanged: (BrnPortraitRadioGroupOption? old,
                    BrnPortraitRadioGroupOption? newList) {
                  BrnToast.show(newList?.title ?? '', context);
                  selectedValue3 = newList;
                  _sensorData.refSensorId = refSensors.singleWhere(
                      (element) => element.name == selectedValue3?.title,
                      orElse: () {
                    return RefSensor();
                  }).id;
                },
              ),
            ],
            onExpansionChanged: (a) async {
              // await getAllCustomersAccessible();
            },
          ),
        ],
      ),
    );
    var buttonBar = ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        ButtonWithIcon(
          label: '保存',
          iconData: Icons.save,
          onPressed: () {
            FormState form = formKey.currentState!;
            if (!form.validate()) {
              return;
            }
            form.save();
            widget.sensorData == null
                ? {
                    _sensorData.userId = StoreUtil.getCurrentUserInfo().id,
                    SensorApi.add(_sensorData.toJson()).then((res) {
                      Navigator.pop(context, true);
                      TroUtils.message('saved');
                    })
                  }
                : SensorApi.update(_sensorData.toJson()).then((res) {
                    Navigator.pop(context, true);
                    TroUtils.message('saved');
                  });
          },
        ),
        ButtonWithIcon(
          label: '取消',
          iconData: Icons.cancel,
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
    var result = Scaffold(
      appBar: AppBar(
        title: Text(widget.sensorData == null ? '添加新测点' : '修改测点信息'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            form,
          ],
        ),
      ),
      bottomNavigationBar: buttonBar,
    );
    return SizedBox(
      width: 650,
      height: 500,
      child: result,
    );
  }
}
