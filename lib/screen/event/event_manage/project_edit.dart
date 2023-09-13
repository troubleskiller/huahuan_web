import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:huahuan_web/api/project_api.dart';
import 'package:huahuan_web/constant/constant.dart';
import 'package:huahuan_web/model/admin/project_model.dart';
import 'package:huahuan_web/model/admin/role_model.dart';
import 'package:huahuan_web/model/mall/Image.dart';
import 'package:huahuan_web/util/store_util.dart';
import 'package:huahuan_web/util/tro_util.dart';
import 'package:huahuan_web/widget/button/icon_button.dart';
import 'package:huahuan_web/widget/common/common_card.dart';
import 'package:huahuan_web/widget/input/TroInput.dart';
import 'package:image_picker/image_picker.dart';

class ProjectEdit extends StatefulWidget {
  final ProjectModel? curProject;
  final Uint8List? bytes;

  const ProjectEdit({Key? key, this.curProject, this.bytes}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ProjectEditState();
  }
}

class ProjectEditState extends State<ProjectEdit> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ProjectModel? _curProject = ProjectModel();
  List<Role> roles = [];
  XFile? pickedFile;
  final ImagePicker imagePicker = ImagePicker();
  ImageDataModel imageModel = ImageDataModel();
  Uint8List? imageBytes;

  @override
  void initState() {
    super.initState();
    if (widget.curProject != null) {
      _curProject = widget.curProject;
    }
    imageBytes = widget.bytes;
  }

  pickImage(ImageSource source, Function(void Function()) sst) async {
    pickedFile = await imagePicker.pickImage(source: source);
    if (pickedFile == null) {
      return;
    }
    imageBytes = await pickedFile!.readAsBytes();

    sst(() {});
  }

  @override
  Widget build(BuildContext context) {
    var form = Form(
      key: formKey,
      child: Row(
        children: [
          StatefulBuilder(builder: (context, sst) {
            return GestureDetector(
              onTap: () {
                pickImage(ImageSource.gallery, sst);
              },
              child: CommonCard(
                backgroundColor: Colors.white,
                child: Stack(
                  children: [
                    imageBytes != null
                        ? Image.memory(
                            imageBytes!,
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
            );
          }),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TroInput(
                value: _curProject!.name,
                label: '项目名称',
                onSaved: (v) {
                  _curProject!.name = v;
                },
                validator: (v) {
                  return v!.isEmpty ? 'required' : null;
                },
              ),
              TroInput(
                value: _curProject!.location,
                label: '地理位置',
                onSaved: (v) {
                  _curProject!.location = v;
                },
              ),
              TroInput(
                value: _curProject!.description,
                label: '项目概述',
                maxLines: 5,
                onSaved: (v) {
                  _curProject!.description = v;
                },
              ),
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
          onPressed: () async {
            FormState form = formKey.currentState!;
            if (!form.validate()) {
              return;
            }
            form.save();
            widget.curProject == null
                ? {
                    _curProject!.userId = StoreUtil.getCurrentUserInfo().id,
                    ProjectApi.addProject(_curProject!.toJson()).then((res) {
                      Navigator.pop(context, true);
                      TroUtils.message('saved');
                    })
                  }
                : ProjectApi.updateProject(_curProject!.toJson()).then((res) {
                    Navigator.pop(context, true);
                    TroUtils.message('saved');
                  });
            var mediaType = MediaType.parse(pickedFile?.mimeType ?? '');
            String filename = 'test.${mediaType.subtype}';
            var file = MultipartFile.fromBytes(imageBytes!,
                contentType: mediaType, filename: filename);

            if (imageBytes != widget.bytes) {
              final formData = FormData.fromMap({
                'thisId': _curProject?.id,
                'type': 5,
                'file': file,
                "name": filename,
              });

              BaseOptions options = BaseOptions(
                baseUrl: 'http://huahuan.f3322.net:14500',
                connectTimeout: 200000,
                receiveTimeout: 200000,
                sendTimeout: 200000,
                headers: {
                  'USERNAME': 'SANDBOX',
                  'token': StoreUtil.read(Constant.KEY_TOKEN),
                  // "Content-Type": "multipart/form-data",
                },
              );

              Dio dio = Dio(options);

              //测试上传图片
              final response = await dio.post('/config/addImage',
                  data: formData, onSendProgress: (sent, total) {
                // do something
              });
            }
            setState(() {
              pickedFile = null;
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
        title: Text(widget.curProject == null ? '添加新项目' : '修改项目信息'),
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
      width: 700,
      height: 400,
      child: result,
    );
  }
}
