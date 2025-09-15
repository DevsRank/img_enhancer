import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:image_enhancer_app/create_category/view/widget/medium_heading_widget.dart';
import 'package:image_enhancer_app/create_category/view_model/model/create_category_model.dart';
import 'package:image_enhancer_app/explore/view/widget/explore_grid_view_widget.dart';
import 'package:image_enhancer_app/explore/view/widget/toggle_btn_widget.dart';
import 'package:image_enhancer_app/history/view_model/model/explore_option.dart';
import 'package:image_enhancer_app/splash/view/widget/text_widget.dart';
import 'package:image_enhancer_app/sub_category/view_model/model/sub_category_option.dart';
import 'package:image_enhancer_app/utils/constant/color.dart';
import 'package:image_enhancer_app/utils/constant/image_path.dart';
import 'package:image_enhancer_app/utils/enum/img_type.dart';
import 'package:image_enhancer_app/utils/enum/permission_type.dart';
import 'package:image_enhancer_app/utils/extension/common_extension.dart';
import 'package:image_enhancer_app/utils/extension/navigator_extension.dart';
import 'package:image_enhancer_app/utils/extension/snackbar_extension.dart';
import 'package:image_enhancer_app/utils/extension/widget_extension.dart';
import 'package:image_enhancer_app/utils/typedef/typedef.dart';
import 'package:image_enhancer_app/view_explore/view/screen/view_explore_screen.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart' as pp;
import 'package:path/path.dart' as path;
class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> with AutomaticKeepAliveClientMixin{

  final ValueNotifier<int> _categoryNotifier = ValueNotifier(0);
  final _exploreList = <List<Map<String, dynamic>>>[
    [...ExploreOption.img_utils, ...ExploreOption.magic_remover, ...ExploreOption.fun_preset],
    ExploreOption.img_utils, ExploreOption.magic_remover, ExploreOption.fun_preset];

  void _shareBtnFunction(int index, ValueNotifier<LoadingBtnRecord> btnNotifier) async {
    try {
      btnNotifier.value = (isLoading: true, progress: null);

      final asset = _exploreList[_categoryNotifier.value][index]["img"]?.toString() ?? "";

      final byteData = await rootBundle.load(asset);
      final tempDir = await pp.getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/${DateTime.now().microsecondsSinceEpoch}${path.extension(asset)}');
      if(!await tempFile.exists()) await tempFile.writeAsBytes(byteData.buffer.asUint8List());

      if(await tempFile.exists()) {
            final shareResponse = await SharePlus.instance.share(ShareParams(
                title: "AI Video Generator",
                files: <XFile>[
                  XFile(tempFile.path)
                ]
            ));

            if(shareResponse.status == ShareResultStatus.unavailable) {
              context.showSnackBar(msg: "Share unavailable write now");
            }

      } else {
        context.showSnackBar(msg: "File lost or not found");
      }


    } catch (e) {
      e.printResponse(title: "share explore video exception");
    } finally {
      btnNotifier.value = (isLoading: false, progress: null);
    }
  }

  void _downloadBtnFunction(int index, ValueNotifier<LoadingBtnRecord> btnNotifier) async {

    try {

      btnNotifier.value = (isLoading: true, progress: null);

      if(await PermissionType.storage.requestStoragePermission()) {

        final asset = _exploreList[_categoryNotifier.value][index]["img"]?.toString() ?? "";

        asset.printResponse(title: "title");

        final byteData = await rootBundle.load(asset);
        // final tempDir = await pp.getTemporaryDirectory();
        // final tempFile = File('${tempDir.path}/${url.split('/').last}');
        // if(!await tempFile.exists()) await tempFile.writeAsBytes(byteData.buffer.asUint8List());

        if(asset.isNotEmpty) {

              final response = await ImageGallerySaverPlus.saveImage(
                  byteData.buffer.asUint8List(),
                  quality: 100,
                  name: DateTime.now().microsecondsSinceEpoch.toString()
              );

              if(response != null && response["isSuccess"]) {
                context.showSnackBar(msg: "Image saved successfully!");
              } else {
                context.showSnackBar(msg: "Image saved unsuccessfully!");
              }

        } else {
          context.showSnackBar(msg: "Something went wrong");
        }
      } else {
        context.showSnackBar(msg: "Storage permission is required");
      }

    } catch (e) {
      e.printResponse(title: "download explore img exception");
    } finally {
      btnNotifier.value = (isLoading: false, progress: null);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            context.height(16.0).hMargin,
            ToggleBtnWidget(
                optionList: <Map<String, dynamic>>[
                  {"img": kAllCategoryIcnPath, "title": "All"},
                  {"img": kImgIcnPath, "title": "Image Utilities"},
                  {"img": kEraseIcnPath, "title": "Magic Remover"},
                  {"img": kFunPresetIcnPath, "title": "Fun Presets"}
                ],
                onPressed: (index) {
                  _categoryNotifier.value = index;
                }
            ),
            context.height(16.0).hMargin,
            MediumHeadingWidget(title: "Inspiration"),
            context.height(8.0).hMargin,
            ValueListenableBuilder<int>(
              valueListenable: _categoryNotifier,
              builder: (context, value, child) {
                return ExploreGridViewWidget(
                    imgType: ImgType.asset,
                  data: _exploreList[value],
                  onPressed: (index, tag) {
                    context.push(widget: ViewExploreScreen(
                      tag: tag,
                      categoryModel: CreateCategoryModel(img: _exploreList[value][index]["img"], provideImg: ""),
                    ));
                  },
                  onSharePressed: _shareBtnFunction,
                  onDownloadPressed: _downloadBtnFunction
                );
              }
            ),
            context.height(16.0).hMargin,
          ],
        ).padding(padding: context.width(16.0).horizontalEdgeInsets),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
