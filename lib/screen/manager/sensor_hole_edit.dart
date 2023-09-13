import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:huahuan_web/constant/common_constant.dart';
import 'package:huahuan_web/model/admin/SensorHoleModel.dart';
import 'package:huahuan_web/model/admin/SensorType.dart';
import 'package:huahuan_web/model/api/response_api.dart';
import 'package:huahuan_web/util/store_util.dart';
import 'package:huahuan_web/util/tro_util.dart';
import 'package:huahuan_web/widget/button/icon_button.dart';
import 'package:huahuan_web/widget/input/TroInput.dart';
import 'package:huahuan_web/widget/input/TroSelect.dart';

import '../../api/sensor_api.dart';

class SensorHoleEdit extends StatefulWidget {
  final SensorHoleModel? sensorData;
  final List<RefSensor>? refSensors;
  final int? projectId;
  final int? projectTypeId;

  const SensorHoleEdit(
      {Key? key,
      this.sensorData,
      this.refSensors,
      this.projectId,
      this.projectTypeId})
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
  Map<String, String> extraMap = {};
  List<SensorType> sensorTypes = [];
  String? selectedValue;
  String? selectedValue2;
  String? selectedValue3;
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
    _sensorData.sensorTypeId = 1000;
    _sensorData.unitId = 2;
    refSensors = widget.refSensors ?? [];
    refSensors.add(RefSensor(name: '没有参考点', id: null));
    super.initState();
  }

  Future getSensorType() async {
    ResponseBodyApi responseBodyApi =
        await SensorApi.getSensorType('{"id": ${widget.projectTypeId}}');
    sensorTypes = List.from(responseBodyApi.data)
        .map((e) => SensorType.fromJson(e))
        .toList();
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
            validator: (v) {
              return v!.isEmpty ? 'required' : null;
            },
          ),
          TroInput(
            value: _sensorData.initValue,
            label: '初始值',
            onSaved: (v) {
              _sensorData.initValue = v;
            },
            validator: (v) {
              return v!.isEmpty ? 'required' : null;
            },
          ),
          TroSelect(
            value: initValue ?? '静力水准',
            dataList: sensorMap.values
                .map((e) => SelectOptionVO(value: e, label: e))
                .toList(),
            label: '传感器类型',
            onChange: (newList) {
              selectedValue = newList;
              _sensorData.sensorTypeId = sensorMapF[selectedValue];
            },
          ),
          TroSelect(
            value: initValue2 ?? 'cm',
            dataList: paramsEx.values
                .map((e) => SelectOptionVO(value: e, label: e))
                .toList(),
            label: '单位',
            onChange: (newList) {
              selectedValue2 = newList;
              _sensorData.unitId = paramsExF[selectedValue2];
            },
          ),
          TroInput(
            value: '${_sensorData.addr ?? ''}',
            label: '位置',
            onSaved: (v) {
              _sensorData.addr = int.parse(v);
            },
            validator: (v) {
              return !v!.isNumericOnly ? '只能为数字' : null;
            },
          ),
          TroInput(
            value: _sensorData.initValue,
            label: '零位值',
            onSaved: (v) {
              _sensorData.sensorZero = v;
            },
            validator: (v) {
              return v!.isEmpty ? 'required' : null;
            },
          ),
          TroInput(
            value: _sensorData.initValue,
            label: '偏移值',
            onSaved: (v) {
              _sensorData.sensorOffset = v;
            },
            validator: (v) {
              return v!.isEmpty ? 'required' : null;
            },
          ),
          TroSelect(
            value: initValue3 ?? '没有参考点',
            dataList: refSensors
                .map((e) => SelectOptionVO(value: e.name, label: e.name))
                .toList(),
            label: '参考点',
            onChange: (newList) {
              selectedValue3 = newList;
              _sensorData.refSensorId = refSensors.singleWhere(
                  (element) => element.name == selectedValue3, orElse: () {
                return RefSensor();
              }).id;
            },
          ),
          FutureBuilder(
              future: getSensorType(),
              builder: (_, __) {
                return Column(
                  children: [
                    ...sensorTypes.map((e) {
                      if (e.type == 'double') {
                        return TroInput(
                          label: e.title,
                          onChange: (v) {
                            if (extraMap.containsKey(e.name)) {
                              extraMap[e.name!] = v;
                            } else {
                              Map<String, String> entry = {e.name!: v};
                              extraMap.addAll(entry);
                            }
                          },
                          validator: (v) {
                            return !v!.isNum ? '请输入数字' : null;
                          },
                        );
                      }
                      if (e.type == 'String') {
                        return TroInput(
                          label: e.title,
                          onChange: (v) {
                            if (extraMap.containsKey(e.name)) {
                              extraMap[e.name!] = v;
                            } else {
                              Map<String, String> entry = {e.name!: v};
                              extraMap.addAll(entry);
                            }
                          },
                        );
                      }
                      String? selectedValue =
                          Map.from(jsonDecode(e.type ?? '')).keys.toList()[0];
                      return TroSelect(
                        value: selectedValue,
                        label: e.title?.split('，')[0],
                        dataList: Map.from(jsonDecode(e.type ?? ''))
                            .entries
                            .map((e) =>
                                SelectOptionVO(label: e.key, value: e.key))
                            .toList(),
                        onChange: (newList) {
                          selectedValue = newList;
                          if (extraMap.containsKey(e.name)) {
                            extraMap[e.name!] = Map.from(
                                    jsonDecode(e.type ?? ''))
                                .entries
                                .singleWhere((element) => element.key == e.name)
                                .value;
                          } else {
                            Map<String, String> entry = {
                              e.name!: Map.from(jsonDecode(e.type ?? ''))
                                  .entries
                                  .singleWhere(
                                      (element) => element.key == e.name)
                                  .value
                            };
                            extraMap.addAll(entry);
                          }
                        },
                      );
                    }),
                  ],
                );
              })
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
              TroUtils.message('请查看是否输入有误');
              return;
            }
            form.save();
            _sensorData.paramsEx = extraMap.toString();
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
      width: 400,
      height: 500,
      child: result,
    );
  }
}
