import 'package:flutter/material.dart';
import 'package:huahuan_web/util/tro_util.dart';
import 'package:huahuan_web/widget/button/icon_button.dart';

class SensorSingle extends StatelessWidget {
  const SensorSingle({Key? key, required this.sn}) : super(key: key);
  final String sn;

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
            showDialog(
              context: context,
              builder: (BuildContext context) => Dialog(),
            ).then((v) {
              if (v != null) {}
            });
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
