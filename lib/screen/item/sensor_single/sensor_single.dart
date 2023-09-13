import 'package:flutter/material.dart';
import 'package:huahuan_web/api/sensor_api.dart';
import 'package:huahuan_web/model/admin/Sensor_initial.dart';
import 'package:huahuan_web/screen/item/sensor_single/sensor_history_data.dart';
import 'package:huahuan_web/util/tro_util.dart';
import 'package:huahuan_web/widget/button/icon_button.dart';
import 'package:huahuan_web/widget/input/TroInput.dart';

class SensorSingle extends StatelessWidget {
  const SensorSingle(
      {Key? key,
      required this.sn,
      required this.curTime,
      required this.curData,
      required this.refData,
      required this.initTime,
      required this.initData})
      : super(key: key);
  final String sn;
  final String curData;
  final String refData;
  final String curTime;
  final String initTime;
  final String initData;

  @override
  Widget build(BuildContext context) {
    DateTime? refTime = DateTime.tryParse(initTime ?? '');
    String init = refTime.toString().split('.')[0];
    DateTime? curDate = DateTime.tryParse(curTime ?? '');
    String cur = curDate.toString().split('.')[0];

    var table = Column(
      children: [
        TroInput(
          labelWidth: 150,
          label: '本期数据',
          value: curData,
          onChange: (data) {},
        ),
        TroInput(
          labelWidth: 150,
          label: '参考数据',
          value: refData,
          onChange: (data) {},
        ),
        TroInput(
          labelWidth: 150,
          label: '初始值时间',
          value: init,
        ),
        TroInput(
          labelWidth: 150,
          label: '初始值',
          value: initData,
        ),
      ],
    );
    var buttonBar = ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        ButtonWithIcon(
          label: '将本期数据设为初始数据',
          iconData: Icons.swipe_right,
          onPressed: () async {
            SensorInitial init = SensorInitial(
              sn: sn,
              value: curData,
              date: cur,
            );
            await SensorApi.setInit(init.toJson());
            TroUtils.message('保存成功');
          },
        ),
        ButtonWithIcon(
          label: '历史数据',
          iconData: Icons.history,
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => Dialog(
                child: SensorHistoryData(
                  sn: sn,
                ),
              ),
            ).then((v) {
              if (v != null) {}
            });
          },
        )
      ],
    );
    var result = Scaffold(
      appBar: AppBar(
        title: Text('测点原始数据'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            table,
          ],
        ),
      ),
      bottomNavigationBar: buttonBar,
    );
    return SizedBox(
      width: 400,
      height: 400,
      child: result,
    );
  }
}

class SensorMulti extends StatelessWidget {
  const SensorMulti(
      {Key? key,
      required this.sn,
      required this.curTime,
      required this.curDataX,
      required this.curDataY,
      required this.refDataX,
      required this.refDataY,
      required this.initTime,
      required this.initData})
      : super(key: key);
  final String sn;
  final String curDataX;
  final String curDataY;
  final String refDataX;
  final String refDataY;
  final String initTime;
  final String curTime;
  final String initData;

  @override
  Widget build(BuildContext context) {
    DateTime? refTime = DateTime.tryParse(initTime ?? '');
    String init = refTime.toString().split('.')[0];
    var table = Column(
      children: [
        TroInput(
          labelWidth: 150,
          label: '本期数据(X轴)',
          value: curDataX,
          onChange: (data) {},
        ),
        TroInput(
          labelWidth: 150,
          label: '本期数据(Y轴)',
          value: curDataY,
          onChange: (data) {},
        ),
        TroInput(
          labelWidth: 150,
          label: '参考数据(X轴)',
          value: refDataX,
          onChange: (data) {},
        ),
        TroInput(
          labelWidth: 150,
          label: '参考数据(Y轴)',
          value: refDataY,
          onChange: (data) {},
        ),
        TroInput(
          labelWidth: 150,
          label: '初始值时间',
          value: init,
        ),
        TroInput(
          labelWidth: 150,
          label: '初始值',
          value: initData,
        ),
      ],
    );
    var buttonBar = ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        ButtonWithIcon(
          label: '将本期数据设为初始数据',
          iconData: Icons.swipe_right,
          onPressed: () async {
            SensorInitial init = SensorInitial(
              sn: sn,
              value: '$curDataX,$curDataY',
              date: curTime,
            );
            await SensorApi.setInit(init.toJson());
            TroUtils.message('saved');
          },
        ),
        ButtonWithIcon(
          label: '历史数据',
          iconData: Icons.history,
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => Dialog(
                child: SensorHistoryData(
                  sn: sn,
                ),
              ),
            ).then((v) {
              if (v != null) {}
            });
          },
        )
      ],
    );
    var result = Scaffold(
      appBar: AppBar(
        title: Text('测点原始数据'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            table,
          ],
        ),
      ),
      bottomNavigationBar: buttonBar,
    );
    return SizedBox(
      width: 400,
      height: 600,
      child: result,
    );
  }
}
