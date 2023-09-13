import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:huahuan_web/util/store_util.dart';
import 'package:huahuan_web/widget/button/buttons.dart';
import 'package:huahuan_web/widget/button/icon_button.dart';
import 'package:huahuan_web/widget/input/TroInput.dart';
import 'package:image_picker/image_picker.dart';

import '../../constant/constant.dart';
import '../../model/mall/Image.dart';

class ImageUpload extends StatefulWidget {
  final int? id;
  final int? type;
  // final BrandListState? brandListState;

  const ImageUpload({
    super.key,
    this.id,
    this.type,
    // this.brandListState
  });

  @override
  ImageUploadState createState() => ImageUploadState();
}

class ImageUploadState extends State<ImageUpload> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  XFile? pickedFile;
  final ImagePicker imagePicker = ImagePicker();
  ImageDataModel imageModel = ImageDataModel();
  Uint8List? imageBytes;

  @override
  void initState() {
    super.initState();
  }

  void update(MultipartFile file, String fileName) async {
    final formData = FormData.fromMap({
      'thisId': widget.id,
      'type': widget.type,
      'file': file,
      "name": fileName
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
    final response = await dio.post('/config/addImage', data: formData,
        onSendProgress: (sent, total) {
      // do something
    });
  }

  @override
  Widget build(BuildContext context) {
    var form = Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TroInput(
            label: '图片名称',
            value: imageModel.url,
            onSaved: (v) => {imageModel.url = v},
            validator: (v) {
              return v!.isEmpty ? 'required' : null;
            },
          ),
        ],
      ),
    );
    List<Widget> buttons = <Widget>[
      ButtonWithIcon(
        label: 'gallery',
        iconData: Icons.photo,
        onPressed: () => pickImage(ImageSource.gallery),
      ),
      ButtonWithIcons.save(context, pickedFile == null ? null : () => save()),
      Text(
        'sizeLimit',
        style: TextStyle(color: Colors.red),
      ),
    ];
    var bb = ButtonBar(children: buttons);
    var result = SizedBox(
      width: 650,
      height: 300,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            form,
            bb,
            previewImage(),
          ],
        ),
      ),
    );

    return result;
  }

  pickImage(ImageSource source) async {
    pickedFile = await imagePicker.pickImage(source: source);
    if (pickedFile == null) {
      return;
    }
    imageBytes = await pickedFile!.readAsBytes();
    if (imageBytes!.length > 1000 * 1000 * 10) {
      pickedFile = null;
      imageBytes = null;
      setState(() {});
      return;
    }

    setState(() {
      formKey.currentState!.save();
    });
  }

  save() async {
    FormState form = formKey.currentState!;
    form.save();
    var mediaType = MediaType.parse(pickedFile?.mimeType ?? '');
    String filename = '${imageModel.url}.${mediaType.subtype}';
    var file = MultipartFile.fromBytes(imageBytes!,
        contentType: mediaType, filename: filename);
    update(file, filename);
    setState(() {
      pickedFile = null;
    });
  }

  Widget previewImage() {
    if (pickedFile != null) {
      if (kIsWeb) {
        return Image.network(pickedFile!.path);
      } else {
        return Image.file(File(pickedFile!.path));
      }
    } else {
      return Container();
    }
  }
}
