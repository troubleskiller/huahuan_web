import 'dart:typed_data';

import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:huahuan_web/api/project_api.dart';
import 'package:huahuan_web/model/admin/project_state_model.dart';
import 'package:huahuan_web/model/admin/role_model.dart';
import 'package:huahuan_web/util/tro_util.dart';
import 'package:huahuan_web/widget/button/icon_button.dart';
import 'package:huahuan_web/widget/common/image_upload.dart';
import 'package:huahuan_web/widget/input/TroInput.dart';

class StateEdit extends StatefulWidget {
  final ProjectStateModel? curState;
  final Uint8List? bytes;
  final int? pid;

  const StateEdit({Key? key, this.curState, this.bytes, this.pid})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return StateEditState();
  }
}

class StateEditState extends State<StateEdit> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ProjectStateModel? _curState = ProjectStateModel();
  ProjectStateModelDto _dTo = ProjectStateModelDto();
  List<Role> roles = [];
  int? _singleSelectedIndex;
  String? statDate;
  String? endDate;

  @override
  void initState() {
    super.initState();
    if (widget.curState != null) {
      _curState = widget.curState;
      _singleSelectedIndex = _curState!.type;
      _dTo.name = _curState!.name;
      _dTo.type = _curState!.type;
      _dTo.id = _curState!.id;
      _dTo.description = _curState!.description;
      _dTo.projectId = _curState!.projectId;
      _dTo.imgId = _curState!.imgId;
      _dTo.startTime =
          DateTime.parse(_curState!.startTime ?? '').millisecondsSinceEpoch;
      _dTo.endTime =
          DateTime.parse(_curState!.endTime ?? '').millisecondsSinceEpoch;
      statDate = _curState!.startTime ?? '';
      endDate = _curState!.endTime ?? '';
    }
    _dTo.projectId = widget.pid;
  }

  _upload({ProjectStateModel? stateModel}) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: ImageUpload(
          id: stateModel?.id,
          type: stateModel?.type,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var form = Form(
      key: formKey,
      child: Row(
        children: [
          GestureDetector(
            child: widget.bytes != null
                ? Image.memory(
                    widget.bytes!,
                    width: 300,
                    height: 300,
                  )
                : Image.network(
                    'https://t7.baidu.com/it/u=1595072465,3644073269&fm=193&f=GIF',
                    fit: BoxFit.cover,
                    width: 300,
                    height: 300,
                  ),
            onTap: () {
              _upload(stateModel: widget.curState);
            },
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TroInput(
                value: _dTo.name,
                label: '工况名称',
                onSaved: (v) {
                  _dTo.name = v;
                },
                validator: (v) {
                  return v!.isEmpty ? 'required' : null;
                },
              ),
              TroInput(
                value: _dTo.description,
                label: '描述',
                onSaved: (v) {
                  _dTo.description = v;
                },
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Text(
                      '开始时间',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    StatefulBuilder(builder: (context, a) {
                      return Column(
                        children: [
                          InkWell(
                            child: Container(
                              height: 50,
                              width: 150,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: const [
                                      Icon(
                                        Icons.calendar_month,
                                        size: 16,
                                        color: Colors.blueAccent,
                                      ),
                                    ],
                                  ),
                                  Text(statDate.toString().split('.')[0]),
                                ],
                              ),
                            ),
                            onTap: () {
                              BrnDatePicker.showDatePicker(context,
                                  maxDateTime:
                                      DateTime.parse('2024-01-01 00:00:00'),
                                  minDateTime:
                                      DateTime.parse('2019-01-01 00:00:00'),
                                  initialDateTime:
                                      DateTime.parse('2023-03-14 15:43:48'),
                                  // 支持DateTimePickerMode.date、DateTimePickerMode.datetime、DateTimePickerMode.time
                                  pickerMode: BrnDateTimePickerMode.datetime,
                                  minuteDivider: 1,
                                  pickerTitleConfig:
                                      BrnPickerTitleConfig.Default,
                                  dateFormat: 'yyyy年,MM月,dd日,HH时:mm分:ss秒',
                                  onConfirm: (dateTime, list) {
                                a(() {
                                  statDate = dateTime.toString();
                                  BrnToast.show(
                                      "onConfirm:  $dateTime ", context);
                                  _dTo.startTime =
                                      dateTime.millisecondsSinceEpoch;
                                });
                              });
                            },
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Text(
                      '结束时间',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    StatefulBuilder(builder: (context, a) {
                      return Column(
                        children: [
                          InkWell(
                            child: Container(
                              height: 50,
                              width: 150,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: const [
                                      Icon(
                                        Icons.calendar_month,
                                        size: 16,
                                        color: Colors.blueAccent,
                                      ),
                                    ],
                                  ),
                                  Text(endDate.toString().split('.')[0]),
                                ],
                              ),
                            ),
                            onTap: () {
                              BrnDatePicker.showDatePicker(
                                context,
                                maxDateTime:
                                    DateTime.parse('2024-01-01 00:00:00'),
                                minDateTime:
                                    DateTime.parse('2019-01-01 00:00:00'),
                                initialDateTime:
                                    DateTime.parse('2023-03-14 15:43:48'),
                                // 支持DateTimePickerMode.date、DateTimePickerMode.datetime、DateTimePickerMode.time
                                pickerMode: BrnDateTimePickerMode.datetime,
                                minuteDivider: 1,
                                pickerTitleConfig: BrnPickerTitleConfig.Default,
                                dateFormat: 'yyyy年,MM月,dd日,HH时:mm分:ss秒',
                                onConfirm: (dateTime, list) {
                                  a(() {
                                    endDate = dateTime.toString();
                                    BrnToast.show(
                                        "onConfirm:  $dateTime ", context);
                                    _dTo.endTime =
                                        dateTime.millisecondsSinceEpoch;
                                  });
                                },
                              );
                            },
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
              StatefulBuilder(builder: (context, set) {
                return Column(
                  children: [
                    BrnRadioButton(
                      disable: widget.curState != null,
                      radioIndex: 1,
                      isSelected: _singleSelectedIndex == 1,
                      child: const Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Text(
                          "工况",
                        ),
                      ),
                      onValueChangedAtIndex: (index, value) {
                        set(() {
                          _singleSelectedIndex = index;
                          _dTo.type = index;
                          BrnToast.show("单选，选中第$index个", context);
                        });
                      },
                    ),
                    BrnRadioButton(
                      disable: widget.curState != null,
                      radioIndex: 2,
                      isSelected: _singleSelectedIndex == 2,
                      child: const Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Text(
                          "灾害",
                        ),
                      ),
                      onValueChangedAtIndex: (index, value) {
                        set(() {
                          _singleSelectedIndex = index;
                          _dTo.type = index;
                          BrnToast.show("单选，选中第$index个", context);
                        });
                      },
                    ),
                  ],
                );
              }),
            ],
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
            widget.curState == null
                ? {
                    ProjectApi.addState(_dTo.toJson()).then((res) {
                      Navigator.pop(context, true);
                      TroUtils.message('saved');
                    })
                  }
                : ProjectApi.updateState(_dTo.toJson()).then((res) {
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
        title: Text(widget.curState == null ? '添加新工况' : '修改信息 '),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            form,
          ],
        ),
      ),
      bottomNavigationBar: buttonBar,
    );
    return SizedBox(
      width: 700,
      height: 450,
      child: result,
    );
  }
}
