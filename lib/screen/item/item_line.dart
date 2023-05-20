import 'package:flutter/material.dart';

import 'DateModel2.dart';
import 'date_model.dart';

class ItemLine extends StatelessWidget {
  const ItemLine({Key? key, required this.dateModel}) : super(key: key);
  final DateModel dateModel;

  @override
  Widget build(BuildContext context) {
    DateTime? refTime = DateTime.tryParse(dateModel.refTime ?? '');
    DateTime? curTime = DateTime.tryParse(dateModel.curTime ?? '');
    String ref ='${refTime?.year??'/'}-${refTime?.month??'/'}-${refTime?.day??'/'}';
    String cur ='${curTime?.year??'/'}-${curTime?.month??'/'}-${curTime?.day??'/'}';
    return Flex(
      direction: Axis.horizontal,
      children: [
        Expanded(
          child: Container(
            decoration:
                BoxDecoration(border: Border.all(color: Colors.blueAccent)),
            child: Center(
              child: Text(
                dateModel.name ?? '-',
                style: TextStyle(fontSize: 10),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            decoration:
                BoxDecoration(border: Border.all(color: Colors.blueAccent)),
            child: Center(
              child: Text(
                ref ?? '-',
                style: TextStyle(fontSize: 10),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            decoration:
                BoxDecoration(border: Border.all(color: Colors.blueAccent)),
            child: Center(
              child: Text(
                cur??'',
                style: TextStyle(fontSize: 10),
              ),
            ),
          ),
        ),
        // Expanded(
        //     child: Container(
        //   decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
        //   child: Text(dateModel.sn ?? '-'),
        // )),
        Expanded(
            child: Container(
          decoration:
              BoxDecoration(border: Border.all(color: Colors.blueAccent)),
          child: Center(
              child: Text(
            dateModel.curValue?.toStringAsFixed(2) ?? '-',
            style: TextStyle(fontSize: 10),
          )),
        )),
        Expanded(
            child: Container(
          decoration:
              BoxDecoration(border: Border.all(color: Colors.blueAccent)),
          child: Center(
              child: Text(
            dateModel.refValue?.toStringAsFixed(2) ?? '-',
            style: TextStyle(fontSize: 10),
          )),
        )),
        Expanded(
            child: Container(
          decoration:
              BoxDecoration(border: Border.all(color: Colors.blueAccent)),
          child: Center(
              child: Text(
            dateModel.curOffset?.toStringAsFixed(2) ?? '-',
            style: TextStyle(fontSize: 10),
          )),
        )),
        Expanded(
            child: Container(
          decoration:
              BoxDecoration(border: Border.all(color: Colors.blueAccent)),
          child: Center(
              child: Text(
            dateModel.totalOffset?.toStringAsFixed(2) ?? '-',
            style: TextStyle(fontSize: 10),
          )),
        )),
        Spacer()
      ],
    );
  }
}

class CeXieLine extends StatelessWidget {
  const CeXieLine({Key? key, required this.dateModel}) : super(key: key);
  final DateModel2 dateModel;

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      children: [
        Expanded(
            child: Container(
          decoration:
              BoxDecoration(border: Border.all(color: Colors.blueAccent)),
          child: Center(
              child: Text(
            dateModel.name ?? '-',
            style: TextStyle(fontSize: 10),
          )),
        )),
        Expanded(
            child: Container(
          decoration:
              BoxDecoration(border: Border.all(color: Colors.blueAccent)),
          child: Center(
              child: Text(
            dateModel.location.toString() ?? '-',
            style: TextStyle(fontSize: 10),
          )),
        )),
        // Expanded(
        //     child: Container(
        //   decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
        //   child: Text(dateModel.sn ?? '-'),
        // )),

        Expanded(
            child: Container(
          decoration:
              BoxDecoration(border: Border.all(color: Colors.blueAccent)),
          child: Center(
              child: Text(
            dateModel.curShapeX?.toStringAsFixed(2) ?? '-',
            style: TextStyle(fontSize: 10),
          )),
        )),
        Expanded(
            child: Container(
          decoration:
              BoxDecoration(border: Border.all(color: Colors.blueAccent)),
          child: Center(
              child: Text(
            dateModel.curShapeY?.toStringAsFixed(2) ?? '-',
            style: TextStyle(fontSize: 10),
          )),
        )),
        Expanded(
            child: Container(
          decoration:
              BoxDecoration(border: Border.all(color: Colors.blueAccent)),
          child: Center(
              child: Text(
            dateModel.refShapeX?.toStringAsFixed(2) ?? '-',
            style: TextStyle(fontSize: 10),
          )),
        )),
        Expanded(
            child: Container(
          decoration:
              BoxDecoration(border: Border.all(color: Colors.blueAccent)),
          child: Center(
              child: Text(
            dateModel.refShapeY?.toStringAsFixed(2) ?? '-',
            style: TextStyle(fontSize: 10),
          )),
        )),
        Expanded(
            child: Container(
          decoration:
              BoxDecoration(border: Border.all(color: Colors.blueAccent)),
          child: Center(
              child: Text(
            dateModel.curShapeOffsetX?.toStringAsFixed(2) ?? '-',
            style: TextStyle(fontSize: 10),
          )),
        )),
        Expanded(
            child: Container(
          decoration:
              BoxDecoration(border: Border.all(color: Colors.blueAccent)),
          child: Center(
              child: Text(
            dateModel.curShapeOffsetY?.toStringAsFixed(2) ?? '-',
            style: TextStyle(fontSize: 10),
          )),
        )),
        Expanded(
            child: Container(
          decoration:
              BoxDecoration(border: Border.all(color: Colors.blueAccent)),
          child: Center(
              child: Text(
            dateModel.curValueX?.toStringAsFixed(2) ?? '-',
            style: TextStyle(fontSize: 10),
          )),
        )),
        Expanded(
            child: Container(
          decoration:
              BoxDecoration(border: Border.all(color: Colors.blueAccent)),
          child: Center(
              child: Text(
            dateModel.curValueY?.toStringAsFixed(2) ?? '-',
            style: TextStyle(fontSize: 10),
          )),
        )),
        Spacer(),
      ],
    );
  }
}
