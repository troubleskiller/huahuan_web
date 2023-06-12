import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:huahuan_web/api/collector_api.dart';
import 'package:huahuan_web/constant/common_constant.dart';
import 'package:huahuan_web/model/admin/CollectorModel.dart';
import 'package:huahuan_web/util/store_util.dart';
import 'package:huahuan_web/util/tro_util.dart';
import 'package:huahuan_web/widget/button/icon_button.dart';
import 'package:huahuan_web/widget/input/TroInput.dart';
import 'package:huahuan_web/widget/input/TroSelect.dart';

class CollectorEdit extends StatefulWidget {
  final CollectorModel? collectorModel;

  const CollectorEdit({Key? key, this.collectorModel}) : super(key: key);

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
  @override
  void initState() {
    if (widget.collectorModel != null) {
      _collectorData = widget.collectorModel;

      initValue = collectorType[_collectorData?.collectorTypeId];

    }
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
            enable: widget.collectorModel==null,
            value: _collectorData!.projectId.toString(),
            label: '所属测项id',
            onSaved: (v) {
              _collectorData!.projectId = int.tryParse(v);
            },
            validator: (v) {
              return! v!.isNumericOnly ? '请输入数字' : null;
            },
          ),
          TroInput(
            value: _collectorData!.name,
            label: '设备名称',
            onSaved: (v) {
              _collectorData!.name = v;
            },
            validator: (v) {
              return v!.isEmpty ? 'required' : null;
            },
          ),
          TroInput(
            value: _collectorData!.sn,
            label: '设备编号',
            onSaved: (v) {
              _collectorData!.sn = v;
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
              _collectorData?.collectorTypeId =
              collectorTypeF[selectedValue];
            },
          ),
          TroInput(
            value: _collectorData!.cycle.toString(),
            label: '采样周期',
            onSaved: (v) {
              _collectorData!.cycle = int.parse(v);
            },
          ),
          TroInput(
            value: _collectorData!.port.toString(),
            label: '设备端口',
            onSaved: (v) {
              _collectorData!.port = int.parse(v);
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
            widget.collectorModel == null
                ? {
                    _collectorData!.userId =
                        StoreUtil.getCurrentUserInfo().id.toString(),
                    CollectorApi.add(_collectorData!.toJson()).then((res) {
                      Navigator.pop(context, true);
                      TroUtils.message('saved');
                    })
                  }
                : CollectorApi.update(_collectorData!.toJson()).then((res) {
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
      width: 650,
      height: 500,
      child: result,
    );
  }
}
