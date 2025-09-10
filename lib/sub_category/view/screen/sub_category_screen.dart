import 'package:flutter/material.dart';
import 'package:image_enhancer_app/create_category/view/screen/create_category_screen.dart';
import 'package:image_enhancer_app/create_category/view/widget/app_bar_widget.dart';
import 'package:image_enhancer_app/sub_category/view/widget/sub_category_grid_view_widget.dart';
import 'package:image_enhancer_app/utils/enum/category_type.dart';
import 'package:image_enhancer_app/utils/extension/common_extension.dart';
import 'package:image_enhancer_app/utils/extension/navigator_extension.dart';
import 'package:image_enhancer_app/utils/extension/widget_extension.dart';

class SubCategoryScreen extends StatefulWidget {
  final CategoryType categoryType;
  const SubCategoryScreen({super.key, required this.categoryType});

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> with AutomaticKeepAliveClientMixin {

  String _appBarText() {
    switch(widget.categoryType) {
      case CategoryType.img_utils:
        return "Image Utilities";
      case CategoryType.magic_remover:
        return "Magic Remover";
      case CategoryType.fun_preset:
        return "Fun Presets";
      default:
        return "";
    }
  }

  void _initFunction() {

  }

  void _disposeFunction() {
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _disposeFunction();
  }

  @override
  void initState() {
    super.initState();
    _initFunction();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBarWidget.build(context: context, title: _appBarText()),
        body: SingleChildScrollView(
          child: SubCategoryGridViewWidget(
              data: widget.categoryType.option().subCategoryList,
            onPressed: (index) {
                context.push(widget: CreateCategoryScreen(subCategoryType: widget.categoryType.option().subCategoryList[index]["sub_category_type"]));
            }
          ).padding(padding: context.width(16.0).allEdgeInsets),
        )
    );
  }

  @override
  bool get wantKeepAlive => true;
}
