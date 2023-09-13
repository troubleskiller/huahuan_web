import 'dart:typed_data';

import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:huahuan_web/api/project_api.dart';
import 'package:huahuan_web/model/admin/project_state_model.dart';
import 'package:huahuan_web/model/admin/role_model.dart';
import 'package:huahuan_web/util/tro_util.dart';
import 'package:huahuan_web/widget/button/icon_button.dart';
import 'package:huahuan_web/widget/common/common_card.dart';
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
  DateTime curTime = DateTime.now().copyWith(hour: 15, minute: 0, second: 0);
  DateTime endTime = DateTime.now()
      .copyWith(day: DateTime.now().day + 1, hour: 15, minute: 0, second: 0);
  String? statDate;
  String? endDate;
  DateTime? curDto;
  DateTime? endDto;
  List<Role> roles = [];
  int? _singleSelectedIndex;

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
    statDate = curTime.toString();
    endDate = endTime.toString();
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

  Future<void> _selectDate(DateTime dateTime) async {
    final DateTime? date = await showDatePicker(
      cancelText: '取消',
      confirmText: '确定',
      helpText: '选择时间',
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    ).then((value) async {
      if (value != null) {
        endDto = value;
        await _selectTime(dateTime);
      }
    });

    if (date == null) return;
  }

  Future<void> _selectTime(DateTime dateTime) async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(dateTime),
    );

    if (time == null) return;

    endDto = endDto?.copyWith(hour: time.hour, minute: time.minute);

    _dTo.endTime = endDto?.millisecondsSinceEpoch;
  }

  Future<void> _selectCurDate(DateTime dateTime) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: dateTime,
      cancelText: '取消',
      confirmText: '确定',
      helpText: '选择时间',
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    ).then((value) async {
      if (value != null) {
        curDto = value;
        await _selectCurTime(dateTime);
      }
    });

    if (date == null) return;
  }

  Future<void> _selectCurTime(DateTime dateTime) async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      cancelText: '取消',
      confirmText: '确定',
      helpText: '选择时间',
      initialTime: TimeOfDay.fromDateTime(dateTime),
    );

    if (time == null) return;

    curDto = curDto?.copyWith(hour: time.hour, minute: time.minute);

    _dTo.startTime = curDto?.millisecondsSinceEpoch;
  }

  @override
  Widget build(BuildContext context) {
    var form = Form(
      key: formKey,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              _upload(stateModel: widget.curState);
            },
            child: CommonCard(
              backgroundColor: Colors.white,
              child: Stack(
                children: [
                  widget.bytes != null
                      ? Image.memory(
                          widget.bytes!,
                          width: 250,
                          height: 250,
                        )
                      : Image.network(
                          'https://t7.baidu.com/it/u=1595072465,3644073269&fm=193&f=GIF',
                          fit: BoxFit.cover,
                          width: 250,
                          height: 250,
                        ),
                  Positioned(
                      top: 80,
                      left: 80,
                      child: Icon(
                        Icons.add,
                        size: 100,
                        color: Colors.white54,
                      )),
                ],
              ),
            ),
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
                label: '工况描述',
                maxLines: 4,
                onSaved: (v) {
                  _dTo.description = v;
                },
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 25),
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
                                  Text(DateTime.parse(statDate ?? '')
                                      .toString()
                                      .split('.')[0]),
                                ],
                              ),
                            ),
                            onTap: () {
                              _selectCurDate(curTime).then((value) => a(() {
                                    statDate = curDto.toString();
                                    curTime = curDto!;
                                  }));
                            },
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 25),
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
                                  Text(DateTime.parse(endDate ?? '')
                                      .toString()
                                      .split('.')[0]),
                                ],
                              ),
                            ),
                            onTap: () {
                              _selectDate(endTime).then((value) => a(() {
                                    endDate = endDto.toString();
                                    endTime = endDto!;
                                  }));

                              // BrnDatePicker.showDatePicker(
                              //   context,
                              //   maxDateTime:
                              //       DateTime.parse('2024-01-01 00:00:00'),
                              //   minDateTime:
                              //       DateTime.parse('2019-01-01 00:00:00'),
                              //   initialDateTime:
                              //       DateTime.parse('2023-03-14 15:43:48'),
                              //   // 支持DateTimePickerMode.date、DateTimePickerMode.datetime、DateTimePickerMode.time
                              //   pickerMode: BrnDateTimePickerMode.datetime,
                              //   minuteDivider: 1,
                              //   pickerTitleConfig: BrnPickerTitleConfig.Default,
                              //   dateFormat: 'yyyy年,MM月,dd日,HH时:mm分:ss秒',
                              //   onConfirm: (dateTime, list) {
                              //     a(() {
                              //       endDate = dateTime.toString();
                              //       BrnToast.show(
                              //           "onConfirm:  $dateTime ", context);
                              //       _dTo.endTime =
                              //           dateTime.millisecondsSinceEpoch;
                              //     });
                              //   },
                              // );
                            },
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              StatefulBuilder(builder: (context, set) {
                return Column(
                  children: [
                    BrnRadioButton(
                      childOnRight: false,
                      disable: widget.curState != null,
                      radioIndex: 1,
                      isSelected: _singleSelectedIndex == 1,
                      child: const Padding(
                        padding: EdgeInsets.only(left: 25, right: 60),
                        child: Text("工况",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)),
                      ),
                      onValueChangedAtIndex: (index, value) {
                        set(() {
                          _singleSelectedIndex = index;
                          _dTo.type = index;
                        });
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    BrnRadioButton(
                      childOnRight: false,
                      disable: widget.curState != null,
                      radioIndex: 2,
                      isSelected: _singleSelectedIndex == 2,
                      child: const Padding(
                        padding: EdgeInsets.only(left: 25, right: 60),
                        child: Text("病害",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)),
                      ),
                      onValueChangedAtIndex: (index, value) {
                        set(() {
                          _singleSelectedIndex = index;
                          _dTo.type = index;
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
      backgroundColor: Colors.white10,
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
