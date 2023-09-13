import 'dart:typed_data';

import 'package:bruno/bruno.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:huahuan_web/api/customer_api.dart';
import 'package:huahuan_web/api/image_api.dart';
import 'package:huahuan_web/constant/constant.dart';
import 'package:huahuan_web/model/admin/Customer_model.dart';
import 'package:huahuan_web/model/admin/role_model.dart';
import 'package:huahuan_web/model/api/response_api.dart';
import 'package:huahuan_web/model/mall/Image.dart';
import 'package:huahuan_web/util/store_util.dart';
import 'package:huahuan_web/util/tro_util.dart';
import 'package:huahuan_web/widget/button/icon_button.dart';
import 'package:huahuan_web/widget/common/common_card.dart';
import 'package:huahuan_web/widget/input/TroInput.dart';
import 'package:image_picker/image_picker.dart';

class CompanyEdit extends StatefulWidget {
  final CustomerModel? customerModel;

  const CompanyEdit({Key? key, this.customerModel}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CompanyEditState();
  }
}

class CompanyEditState extends State<CompanyEdit> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  CustomerModel? _customerModel = CustomerModel();
  List<Role> curRoles = [];
  List<CustomerModel> curCustomers = [];
  BrnPortraitRadioGroupOption? selectedValue;
  bool isLoading = true;
  List<ImageDataModel> images = [];
  XFile? pickedFile;
  final ImagePicker imagePicker = ImagePicker();
  ImageDataModel imageModel = ImageDataModel();
  Uint8List? imageBytes;

  @override
  void initState() {
    super.initState();
    if (widget.customerModel != null) {
      _customerModel = widget.customerModel;
    }

    init();
  }

  Future getCurImage() async {
    ResponseBodyApi responseBodyApi = await ImageApi.getImageByIdAndType(
        '{"thisId":${_customerModel?.id},"type": 6}');
    if (responseBodyApi.code == 200) {
      images = List.from(responseBodyApi.data)
          .map((e) => ImageDataModel.fromJson(e))
          .toList();
    }
    BaseOptions options = BaseOptions(
      baseUrl: 'http://huahuan.f3322.net:14500',
      connectTimeout: 20000,
      receiveTimeout: 20000,
      sendTimeout: 20000,
      headers: {
        'User-Agent': 'Mozilla 5.10',
        'USERNAME': 'SANDBOX',
        'token': StoreUtil.read(Constant.KEY_TOKEN),
      },
    );

    Dio dio = Dio(options);
    dio.options.responseType = ResponseType.bytes;
    if (images.isEmpty) {
      imageBytes = null;
    } else {
      final response2 =
          await dio.get('/config/findImageById', queryParameters: {
        'name': images.last.url,
      });

      imageBytes = response2.data;
    }
    setState(() {});
  }

  pickImage(ImageSource source, Function(void Function()) sst) async {
    pickedFile = await imagePicker.pickImage(source: source);
    if (pickedFile == null) {
      return;
    }
    imageBytes = await pickedFile!.readAsBytes();

    sst(() {});
  }

  void init() async {
    _customerModel?.userId = StoreUtil.getCurrentUserInfo().id;
    await getCurImage();
    setState(() {
      isLoading = false;
    });
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
                value: _customerModel!.name,
                label: '客户名',
                onSaved: (v) {
                  _customerModel!.name = v;
                },
                validator: (v) {
                  return v!.isEmpty ? 'required' : null;
                },
              ),
              TroInput(
                value: _customerModel!.address,
                label: '地址',
                onSaved: (v) {
                  _customerModel!.address = v;
                },
              ),
              TroInput(
                value: _customerModel!.tel,
                label: '联系方式',
                onSaved: (v) {
                  _customerModel!.tel = v;
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
            widget.customerModel == null
                ? CustomerApi.add(_customerModel!.toJson())
                : CustomerApi.update(_customerModel!.toJson());
            var mediaType = MediaType.parse(pickedFile?.mimeType ?? '');
            String filename = 'test.${mediaType.subtype}';
            var file = MultipartFile.fromBytes(imageBytes!,
                contentType: mediaType, filename: filename);

            if (imageBytes != null) {
              final formData = FormData.fromMap({
                'thisId': _customerModel?.id,
                'type': 6,
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
            Navigator.pop(context, true);
            TroUtils.message('保存成功');
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
        title: Text(widget.customerModel == null ? '添加新客户' : '修改客户信息'),
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
      child: isLoading ? BrnPageLoading() : result,
    );
  }
}
