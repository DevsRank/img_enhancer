import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_enhancer_app/create_category/view/widget/app_bar_widget.dart';
import 'package:image_enhancer_app/create_category/view/widget/img_widget.dart';
import 'package:image_enhancer_app/create_category/view/widget/loading_btn_widget.dart';
import 'package:image_enhancer_app/create_category/view/widget/medium_heading_widget.dart';
import 'package:image_enhancer_app/create_category/view_model/model/create_category_model.dart';
import 'package:image_enhancer_app/utils/constant/alignment.dart';
import 'package:image_enhancer_app/utils/constant/color.dart';
import 'package:image_enhancer_app/utils/enum/img_type.dart';
import 'package:image_enhancer_app/utils/enum/loading_state.dart';
import 'package:image_enhancer_app/utils/enum/permission_type.dart';
import 'package:image_enhancer_app/utils/extension/common_extension.dart';
import 'package:image_enhancer_app/utils/extension/snackbar_extension.dart';
import 'package:image_enhancer_app/utils/extension/widget_extension.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart' as pp;
import 'package:path/path.dart' as path;

class ViewHistoryScreen extends StatefulWidget {
  final dynamic tag;
  final CreateCategoryModel categoryModel;

  const ViewHistoryScreen({super.key, this.tag, required this.categoryModel});

  @override
  State<ViewHistoryScreen> createState() => _ViewHistoryScreenState();
}

class _ViewHistoryScreenState extends State<ViewHistoryScreen> {

  Future<void> _saveImageToDownloads() async {

    try {
      if(context.isActionRunning(loadingState: LoadingState.explore_save)) {
        return;
      } else if (await PermissionType.storage.requestStoragePermission()) {

        context.setBtnLoading(loadingState: LoadingState.explore_save);

        if (await File(widget.categoryModel.img).exists()) {
          final result = await ImageGallerySaverPlus.saveImage(
              await File(widget.categoryModel.img).readAsBytes(),
              quality: 100,
              name: DateTime.now().microsecondsSinceEpoch.toString()
          );
          if(result != null && result["isSuccess"]) context.showSnackBar(msg: "Saved successfully");
        } else {
          context.showSnackBar(msg: "File lost or not found");
        }

      } else {
        context.showSnackBar(msg: "Storage permission is required");
      }
    } catch (e) {
      e.printResponse(title: "save img to download exception");
      context.showSnackBar(msg: e.parseException().msg);
    } finally {
      context.stopBtnLoading(loadingState: LoadingState.explore_save);
    }

  }

  void _shareBtnFunction() async {
    if (context.isActionRunning(loadingState: LoadingState.explore_share)) return;

    try {
      context.setBtnLoading(loadingState: LoadingState.explore_share);

      if (await File(widget.categoryModel.img).exists()) {
        final response = await SharePlus.instance.share(ShareParams(
                title: "PixeLift",
                files: [XFile(widget.categoryModel.img)]
              ));

        if(response.status == ShareResultStatus.unavailable) {
          context.showSnackBar(msg: "Share unavailable");
        }
      } else {
        throw "File not found";
      }

    } catch (e) {
      e.printResponse(title: "sharing exception");
      context.showSnackBar(msg: e.parseException().msg);
    } finally {
      context.stopBtnLoading(loadingState: LoadingState.explore_share);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBarWidget.build(context: context, title: "Finalize"),
      body: Column(
        crossAxisAlignment: kStartCrossAxisAlignment,
        children: [
          context.height(16.0).hMargin,
          MediumHeadingWidget(title: "Your Deign is Here"),
          context.height(8.0).hMargin,
          Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: kBlueColor,
                      width: context.width(1.0)
                  ),
                  borderRadius: context.width(14.0).borderRadius
              ),
              child: Hero(
                tag: widget.tag,
                child: ImgWidget(
                    imgType: ImgType.file,
                    img: widget.categoryModel.img,
                    width: double.maxFinite,
                    height: context.width(320.0),
                    isInTerActive: true,
                    borderRadius: context.width(12.0).borderRadius
                ),
              )
          ),
          // context.height(16.0).hMargin,
          // _buildAttributeTextWidget(title: "Room", subTitle: widget.categoryModel.attributeOption1 ?? ""),
          // context.height(6.0).hMargin,
          // _buildAttributeTextWidget(title: "Style", subTitle: widget.categoryModel.style ?? ""),
          // context.height(6.0).hMargin,
          // _buildAttributeTextWidget(title: "Color", subTitle: widget.categoryModel.color ?? ""),
          context.width(111.0).hMargin,
        ],
      ).padding(padding: context.width(16.0).horizontalEdgeInsets),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        padding: context
            .width(16.0)
            .allEdgeInsets,
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: kGreyColor, width: .1)),
        ),
        child: Row(
          children: [
            Expanded(
              child: LoadingBtnWidget(
                  loadingState: LoadingState.explore_save,
                  toolTip: "Save",
                  text: "Save",
                  icn: Icons.save_alt_outlined,
                  onPressed: _saveImageToDownloads
              ),
            ),
            context.width(12.0).wMargin,
            Expanded(
              child: LoadingBtnWidget(
                loadingState: LoadingState.explore_share,
                toolTip: "Share",
                text: "Share",
                icn: Icons.share_outlined,
                onPressed: _shareBtnFunction,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
