import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:huahuan_web/api/collector_api.dart';
import 'package:huahuan_web/api/project_api.dart';
import 'package:huahuan_web/constant/common_constant.dart';
import 'package:huahuan_web/model/admin/CollectorModel.dart';
import 'package:huahuan_web/model/admin/project_model.dart';
import 'package:huahuan_web/model/api/response_api.dart';
import 'package:huahuan_web/util/store_util.dart';
import 'package:huahuan_web/util/tro_util.dart';
import 'package:huahuan_web/widget/button/icon_button.dart';
import 'package:huahuan_web/widget/input/TroInput.dart';
import 'package:huahuan_web/widget/input/TroSelect.dart';
import 'package:huahuan_web/widget/input/tro_cascade_select.dart';

class CollectorEdit extends StatefulWidget {
  final CollectorModel? collectorModel;
  final String? projectName;
  final bool isUpdate;

  const CollectorEdit(
      {Key? key, this.collectorModel, this.projectName, required this.isUpdate})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CollectorEditState();
  }
}

class CollectorEditState extends State<CollectorEdit> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  CollectorModel? _collectorData = CollectorModel();
  String? selectedValue;
  String? initValue;
  late BrnPickerEntity brnPickerEntity;
  bool a = true;

  @override
  void initState() {
    if (widget.collectorModel != null) {
      _collectorData = widget.collectorModel;

      initValue = collectorType[_collectorData?.collectorTypeId];
    }
    _collectorData?.collectorTypeId ??= 1;
    getAllEvents();
    super.initState();
  }

  Future getAllEvents() async {
    List<ProjectModel> allProjects = [];
    ResponseBodyApi responseBodyApi = await ProjectApi.findAll();
    allProjects = List.from(responseBodyApi.data)
        .map((e) => ProjectModel.fromJson(e))
        .toList();

    brnPickerEntity = BrnPickerEntity(
        key: '1',
        name: "标题0",
        value: '标题0',
        defaultValue: '',
        type: 'radio',
        extMap: {"isHighFrequency": false},
        children: allProjects
            .map((e) => BrnPickerEntity(
                type: 'radio',
                value: '${e.id ?? 123}',
                key: e.name ?? '',
                defaultValue: '',
                name: e.name ?? '',
                children: getBrnPickerEntity(e.events ?? [])))
            .toList());
    brnPickerEntity.configRelationship();
    brnPickerEntity.configDefaultValue();
    setState(() {
      a = false;
    });
  }

  List<BrnPickerEntity> getBrnPickerEntity(List<ProjectModel> projects) {
    return projects
        .map((e) => BrnPickerEntity(
              defaultValue: '',
              type: 'radio',
              value: '${e.id}',
              isSelected: false,
              key: e.name ?? '',
              name: e.name ?? '',
              children: [],
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    var form = Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          a
              ? Container()
              : TroCascadeSelect(
                  context: context,
                  value: '${_collectorData!.projectId ?? '暂未选择'}',
                  label: '所属测项',
                  onConfirm: (int value) {
                    _collectorData!.projectId = value;
                  },
                  entity: brnPickerEntity),
          TroInput(
            value: _collectorData!.name,
            label: '设备名称',
            onSaved: (v) {
              _collectorData!.name = v;
            },
            validator: (v) {
              return v!.isEmpty ? '不能为空' : null;
            },
          ),
          TroInput(
            value: _collectorData!.simNum ?? '',
            label: '电话SIM',
            onSaved: (v) {
              _collectorData!.simNum = v;
            },
            validator: (v) {
              return !v!.isNumericOnly ? '只能为数字' : null;
            },
          ),
          TroInput(
            value: _collectorData!.sn,
            label: '设备编号',
            onSaved: (v) {
              _collectorData!.sn = v;
            },
            validator: (v) {
              return v!.isEmpty ? '不能为空' : null;
            },
          ),
          TroSelect(
            value: initValue ?? 'HD-CJY2021-电池版',
            dataList: collectorType.values
                .map((e) => SelectOptionVO(value: e, label: e))
                .toList(),
            label: '采集仪类型',
            onChange: (newList) {
              selectedValue = newList;
              _collectorData?.collectorTypeId = collectorTypeF[selectedValue];
            },
          ),
          TroInput(
            value: '${_collectorData!.cycle ?? ''}',
            label: '采样周期',
            onSaved: (v) {
              _collectorData!.cycle = int.parse(v);
            },
            validator: (v) {
              return !v!.isNumericOnly ? '只能为数字' : null;
            },
          ),
          TroInput(
            value: '${_collectorData!.port ?? ''}',
            label: '设备端口',
            onSaved: (v) {
              _collectorData!.port = int.parse(v);
            },
            validator: (v) {
              return !v!.isNumericOnly ? '只能为数字' : null;
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
            !widget.isUpdate
                ? {
                    _collectorData!.userId =
                        StoreUtil.getCurrentUserInfo().id.toString(),
                    CollectorApi.add(_collectorData!.toJson()).then((res) {
                      Navigator.pop(context, true);
                      TroUtils.message('保存成功');
                    })
                  }
                : CollectorApi.update(_collectorData!.toJson()).then((res) {
                    Navigator.pop(context, true);
                    TroUtils.message('保存成功');
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
        title: Text(widget.collectorModel == null ? '添加新采集仪' : '修改采集仪信息'),
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
