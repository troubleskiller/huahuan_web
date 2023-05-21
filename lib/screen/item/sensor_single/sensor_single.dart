import 'package:flutter/material.dart';
import 'package:huahuan_web/screen/item/date_model.dart';
import 'package:huahuan_web/util/tro_util.dart';
import 'package:huahuan_web/widget/button/icon_button.dart';

class SensorSingle extends StatefulWidget {
  const SensorSingle({Key? key, required this.curSensor}) : super(key: key);
  final DateModel curSensor;

  @override
  State<SensorSingle> createState() => _SensorSingleState();
}

class _SensorSingleState extends State<SensorSingle> {
  @override
  Widget build(BuildContext context) {
    var table = Column(
      children: [
        Row(
          children: [],
        ),
        Row(
          children: [
            Text('本期数据'),
          ],
        ),
        Row(
          children: [
            Text('参考数据'),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Text('初始值时间'),
          ],
        ),
        Row(
          children: [
            Text('初始值'),
          ],
        ),
      ],
    );
    var buttonBar = ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        ButtonWithIcon(
          label: '将本期数据设为初始数据',
          iconData: Icons.swipe_right,
          onPressed: () {
            TroUtils.message('saved');
          },
        ),
        ButtonWithIcon(
          label: '历史数据',
          iconData: Icons.history,
          onPressed: () {
            Navigator.pop(context);
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
      width: 650,
      height: 400,
      child: result,
    );
  }
}
