import 'package:flutter/material.dart';
import 'package:huahuan_web/api/category_api.dart';
import 'package:huahuan_web/model/admin/treeVo.dart';
import 'package:huahuan_web/model/api/page_model.dart';
import 'package:huahuan_web/model/api/response_api.dart';
import 'package:huahuan_web/model/mall/category_model.dart';
import 'package:huahuan_web/widget/dialog/dialog_content.dart';
import 'package:huahuan_web/widget/dialog/rename_dialog.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({Key? key}) : super(key: key);

  @override
  State<CategoryList> createState() => CategoryListState();
}

class CategoryListState extends State<CategoryList> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController describeController = TextEditingController();
  List<CategoryModel> dataList = [];
  bool a = true;

  @override
  void initState() {
    super.initState();
    init();
    // WidgetsBinding.instance.addPostFrameCallback((c) {
    //   _query();
    // });
  }

  void init() async {
    await loadData();
    setState(() {
      a = false;
    });
  }

  Future loadData() async {
    ResponseBodyApi responseBodyApi = await CategoryApi.list();
    dataList =
        List.from(PageModel.fromJson(responseBodyApi.data).data).map((v) {
      CategoryModel categoryModel = CategoryModel.fromJson(v);
      categoryModel.selected = false;
      return categoryModel;
    }).toList();
  }

  List<Widget> _getMenuListTile(
      Function? onClick, List<TreeVO<CategoryModel>> data) {
    List<Widget> listTileList =
        data.map<Widget>((TreeVO<CategoryModel> treeVO) {
      String name = treeVO.data!.name ?? '';
      Text title = Text(name);
      if (treeVO.children.isNotEmpty) {
        return ExpansionTile(
          subtitle: Row(
            children: [
              GestureDetector(
                  onTap: () {
                    CategoryModel categoryModel = CategoryModel();
                    categoryModel.pid = treeVO.data?.id;
                    categoryModel.catLevel = (treeVO.data!.catLevel! + 1);
                    categoryModel.showStatus = 1;
                    categoryModel.sort = 0;
                    categoryModel.productCount = 0;
                    addNewCat(categoryModel);
                  },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.grab,
                    child: Container(
                      child: Text('添加'),
                    ),
                  )),
            ],
          ),
          key: Key(treeVO.data!.id!.toString()),
          initiallyExpanded: false,
          onExpansionChanged: (a) {
            if (a) {
              if (onClick != null) {
                onClick();
              }
            }
          },
          title: title,
          childrenPadding: EdgeInsets.only(left: 10),
          children: _getMenuListTile(
            () {
              setState(() {});
            },
            treeVO.children,
          ),
        );
      } else {
        return ListTile(
          title: title,
          subtitle: Row(
            children: [
              GestureDetector(
                onTap: () {
                  deleteCurCat(treeVO.data?.id);
                },
                child: MouseRegion(
                    cursor: SystemMouseCursors.grab,
                    child: Container(
                      child: Text('删除'),
                    )),
              ),
            ],
          ),
        );
      }
    }).toList();
    return listTileList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 10),
          a
              ? Container(
                  height: 100,
                  width: 100,
                  color: Colors.blue,
                )
              : Expanded(
                  child: ListView(
                    children: _getMenuListTile(
                      () {},
                      TreeUtil.toTreeVOList(dataList),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Future deleteCurCat(int? index) async {
    ResponseBodyApi response = await CategoryApi.removeByIds([index!]);
    if (response.code == 200) {
      dataList.removeWhere((element) => element.id == index);
      setState(() {});
    }
  }

  Future addNewCat(CategoryModel categoryModel) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return RenameDialog(
            contentWidget: RenameDialogContent(
              title: "新建一个分类",
              okBtnTap: () async {
                print(
                  "输入框中的文字为:${nameController.text}",
                );
                categoryModel.name = nameController.text;
                ResponseBodyApi responseBodyApi =
                    await CategoryApi.saveOrUpdate(categoryModel.toJson());
                if (responseBodyApi.code == 200) {
                  Navigator.of(context).pop();
                  dataList.add(categoryModel);
                  setState(() {});
                } else {
                  Navigator.of(context).pop();
                }
              },
              nameController: nameController,
              describeController: describeController,
              cancelBtnTap: () {},
            ),
          );
        });
  }
}
