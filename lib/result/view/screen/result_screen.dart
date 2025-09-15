import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_enhancer_app/config/sqfl/model/db_model.dart';
import 'package:image_enhancer_app/config/sqfl/singleton/sqfl_db.dart';
import 'package:image_enhancer_app/create_category/view/widget/app_bar_widget.dart';
import 'package:image_enhancer_app/create_category/view/widget/img_widget.dart';
import 'package:image_enhancer_app/create_category/view/widget/loading_btn_widget.dart';
import 'package:image_enhancer_app/create_category/view/widget/medium_heading_widget.dart';
import 'package:image_enhancer_app/create_category/view_model/model/create_category_model.dart';
import 'package:image_enhancer_app/result/view/widget/compare_img_widget.dart';
import 'package:image_enhancer_app/splash/view/widget/circular_progress_indicator_widget.dart';
import 'package:image_enhancer_app/sub_category/view_model/model/sub_category_option.dart';
import 'package:image_enhancer_app/utils/constant/alignment.dart';
import 'package:image_enhancer_app/utils/constant/color.dart';
import 'package:image_enhancer_app/utils/constant/padding.dart';
import 'package:image_enhancer_app/utils/enum/category_type.dart';
import 'package:image_enhancer_app/utils/enum/img_type.dart';
import 'package:image_enhancer_app/utils/enum/loading_state.dart';
import 'package:image_enhancer_app/utils/enum/permission_type.dart';
import 'package:image_enhancer_app/utils/extension/common_extension.dart';
import 'package:image_enhancer_app/utils/extension/snackbar_extension.dart';
import 'package:image_enhancer_app/utils/extension/widget_extension.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:path_provider/path_provider.dart' as pp;
import 'package:path/path.dart' as path;
import 'package:share_plus/share_plus.dart';

class ResultScreen extends StatefulWidget {
  final CategoryType categoryType;
  final CreateCategoryModel categoryModel;
  const ResultScreen({super.key, required this.categoryType, required this.categoryModel});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final ValueNotifier<({bool isProcessing, double? progress})> _processingNotifier = ValueNotifier((isProcessing: false, progress: null));

  String img = "";

  final ValueNotifier<double?> _compareImgNotifier = ValueNotifier(null);

  Future<({bool success, String msg, String img})> _saveImgToLocalDB() async {
    try {
      _processingNotifier.value = (isProcessing: true, progress: null);

      // Get app's document directory
      final directory = await pp.getApplicationDocumentsDirectory();

      // Create a hidden folder `.ai_images` inside documents directory
      final hiddenFolder = Directory('${directory.path}/.img_enhancer');
      if (!await hiddenFolder.exists()) {
        await hiddenFolder.create(recursive: true);
      }

      // Extract filename from the image URL
      final fileName = "${DateTime.now().microsecondsSinceEpoch}.png";

      // Full file path in hidden folder
      final filePath = '${hiddenFolder.path}/$fileName';

      // Decode base64 and write to file
      // final bytes = base64Decode("categoryModel.img");
      // final file = File(filePath);
      // await file.writeAsBytes(bytes);

      await 1.second.wait();

      widget.categoryModel.img.printResponse(title: "img url");

      // Download and save the image
      final response = await Dio().download(
          widget.categoryModel.img,
          filePath,
          onReceiveProgress: (count, total) {
            if(total != 0) {
              (count / total * 100).printResponse(title: "img downloading %");
              _processingNotifier.value = (isProcessing: true, progress: count / total);
            }
            if(count == total) _processingNotifier.value = (isProcessing: true, progress: null);
          }
      );

      // Check download success
      if (response.statusCode == 200) {

      if (await File(filePath).exists()) {

        await File(widget.categoryModel.provideImg).copy(path.join(hiddenFolder.path, DateTime.now().microsecondsSinceEpoch.toString()+path.extension(widget.categoryModel.provideImg)));

        img = filePath;

        final dbModel = DbModel(
            img: filePath,
            provideImg: widget.categoryModel.provideImg,
            prompt: widget.categoryModel.prompt,
            firstAttributeIndex: widget.categoryModel.firstOptionIndex,
            createAt: DateTime.now()
        );

        // Save path to local Hive DB
        final dbResponse = await SqflDB.instance.insertData(
            tableName: widget.categoryType.tableName(),
            dbModel: dbModel
        );

        if(dbResponse) {
          context.setDbModelIndex(categoryType: widget.categoryType, dbModel: dbModel);
        }
        return (success: true, msg: "Image saved successfully", img: filePath);
      } else {
        return (success: false, msg: "File was not saved", img: "");
      }
      } else {
        return (success: false, msg: response.handleRequestStatusCodeException().msg, img: "");
      }
    } catch (e) {
      e.printResponse(title: "download & Save img to local DB exception");
      return (success: false, msg: e.parseException().msg, img: "");
    } finally {
      _processingNotifier.value = (isProcessing: false, progress: null);
    }
  }

  Future<void> _saveImageToDownloads() async {
    try {
      if (context.isActionRunning(loadingState: LoadingState.result_save)) {
        return;
      } else if (await PermissionType.storage.requestStoragePermission()) {
        context.setBtnLoading(loadingState: LoadingState.result_save);

        File privateFile = File(img);

        if (await privateFile.exists()) {

          final result = await ImageGallerySaverPlus.saveImage(
            await privateFile.readAsBytes(),
            quality: 100,
            name: DateTime.now().microsecondsSinceEpoch.toString(),
          );
          if (result != null && result["isSuccess"]) {
            context.showSnackBar(msg: "Saved successfully");
          }

        } else {

          final directory = await pp.getTemporaryDirectory();
          final file = "${directory.path}/${DateTime.now().microsecondsSinceEpoch}${path.extension(widget.categoryModel.img)}";

          final response = await Dio().download(
              widget.categoryModel.img,
              // "https://ss0.baidu.com/94o3dSag_xI4khGko9WTAnF6hhy/image/h%3D300/sign=a62e824376d98d1069d40a31113eb807/838ba61ea8d3fd1fc9c7b6853a4e251f94ca5f46.jpg",
              file,
              onReceiveProgress: (count, total) {
                if(total != 0) {
                  context.setBtnLoading(loadingState: LoadingState.result_save, progress: (count / total));
                }
                if(count == total) context.setBtnLoading(loadingState: LoadingState.result_save);
              }
          );

          if(response.statusCode == 200) {

            if (await File(file).exists()) {
              final result = await ImageGallerySaverPlus.saveImage(
                await File(file).readAsBytes(),
                quality: 100,
                name: DateTime.now().microsecondsSinceEpoch.toString(),
              );
              if (result != null && result["isSuccess"]) {
                context.showSnackBar(msg: "Saved successfully");
              }
            } else {
              context.showSnackBar(msg: "File not found");
            }

          } else {
            context.showSnackBar(msg: response.handleRequestStatusCodeException().msg);
          }
        }
      } else {
        context.showSnackBar(msg: "Storage permission is required");
      }
    } catch (e) {
      e.printResponse(title: "save img to download exception");
      context.showSnackBar(msg: e.parseException().msg);
    } finally {
      context.stopBtnLoading(loadingState: LoadingState.result_save);
    }
  }

  void _shareBtnFunction() async {

    try {
      if (context.isActionRunning(loadingState: LoadingState.result_share)) {
        return;
      } else {
        context.setBtnLoading(loadingState: LoadingState.result_share);

        late String imagePath;

        if (img.isNotEmpty && await File(img).exists()) {
          // Use local file path directly
          imagePath = img;

        } else {

          final directory = await pp.getTemporaryDirectory();
          final file = "${directory.path}/${DateTime.now().microsecondsSinceEpoch}.png";

          // Download from network
          final response = await Dio().download(
            widget.categoryModel.img,
              file,
            onReceiveProgress: (count, total) {
              if (total != 0) {
                context.setBtnLoading(
                    loadingState: LoadingState.result_share,
                    progress: count / total
                );
              }
              if(count == total) context.setBtnLoading(loadingState: LoadingState.result_share);
            },
          );

          if(response.statusCode == 200) {

            if(await File(file).exists()) {

              imagePath = file;

            } else {
              throw "File not found";
            }
          } else {
            throw response.handleRequestStatusCodeException().msg;
          }

        }

        // Share the file using Share.shareXFiles
        final response = await SharePlus.instance.share(
          ShareParams(title: "PixeLift", files: [XFile(imagePath)]),
        );

        if(response.status == ShareResultStatus.unavailable) {
          context.showSnackBar(msg: "Share unavailable");
        }
      }
    } catch (e) {
      e.printResponse(title: "sharing exception");
      context.showSnackBar(msg: e.parseException().msg);
    } finally {
      context.stopBtnLoading(loadingState: LoadingState.result_share);
    }
  }

  void _initFunction() async {
    final response = await _saveImgToLocalDB();
    if (response.success) {
    } else {
      context.showSnackBar(msg: response.msg);
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await 3.second.wait();
      if (await InAppReview.instance.isAvailable()) {
        await InAppReview.instance.requestReview();
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initFunction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBarWidget.build(context: context, title: "Result"),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: kStartCrossAxisAlignment,
          children: [
            context.height(16.0).hMargin,
            MediumHeadingWidget(title: "Your Deign is Here"),
            context.height(8.0).hMargin,
            Stack(
              alignment: Alignment.center,
              children: [
                ValueListenableBuilder<double?>(
                  valueListenable: _compareImgNotifier,
                  builder: (context, value, child) {
                    return CompareImgWidget(
                      value: value ?? .0,
                        hideThumb: value == null,
                        onValueChanged: value != null ? (value) {
                          _compareImgNotifier.value = value;
                        } : null,
                      before: ImgWidget(
                        imgType: ImgType.network,
                        img: widget.categoryModel.img,
                          isInTerActive: true,
                          borderRadius: context.width(16.0).borderRadius
                      ),
                      after: ImgWidget(
                        imgType: ImgType.file,
                        img: widget.categoryModel.provideImg,
                        isInTerActive: true,
                          borderRadius: context.width(16.0).borderRadius,
                      ),
                      thumbColor: value != null ? kBlueColor : kTransparentColor,
                      trackWidth: context.width(4.0),
                        trackColor: value != null ? kBlueColor : kTransparentColor,
                      thumbWidth: context.width(16.0),
                      thumbHeight: context.width(16.0)
                    ).clipRRect(borderRadius: context.width(16.0).borderRadius);
                  }
                ),
                ValueListenableBuilder<({bool isProcessing, double? progress})>(
                  valueListenable: _processingNotifier,
                  builder: (context, value, child) {
                    return value.isProcessing
                        ? Positioned.fill(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Positioned.fill(
                                  child:
                                      BackdropFilter(
                                        filter: ImageFilter.blur(
                                          sigmaX: 16.0,
                                          sigmaY: 16.0,
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: kWhiteColor.withOpacity(.2),
                                            border: Border.all(
                                              color: kWhiteColor,
                                              width: context.width(1.0),
                                            ),
                                            borderRadius: context
                                                .width(14.0)
                                                .borderRadius,
                                          ),
                                          child: SizedBox.shrink(),
                                        ),
                                      ).clipRRect(
                                        borderRadius: context
                                            .width(14.0)
                                            .borderRadius,
                                      ),
                                ),
                                CircularProgressIndicatorWidget(
                                  value: value.progress
                                ),
                              ],
                            ),
                          )
                        : SizedBox.shrink();
                  },
                ),
                Positioned(
                    bottom: 10.0,
                    right: 10.0,
                    child: LoadingBtnWidget(
                        toolTip: "Compare",
                        text: "",
                        borderRadius: context.width(6.0).borderRadius,
                        icn: Icons.compare,
                        padding: context.width(10.0).verticalEdgeInsets,
                        onPressed: () {
                          if(_compareImgNotifier.value != null) {
                            _compareImgNotifier.value = null;
                          } else {
                          _compareImgNotifier.value = .5;
                          }
                        }).sized(
                      width: context.width(46.0)
                    )
                ),
              ],
            ),
            context.width(111.0).hMargin,
          ],
        ).padding(padding: context.width(16.0).horizontalEdgeInsets),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        padding: context.width(16.0).allEdgeInsets,
        decoration: BoxDecoration(
          color: kBlack2Color,
          border: Border(top: BorderSide(color: kGreyColor, width: .1)),
        ),
        child: Row(
          children: [
            Expanded(
              child: LoadingBtnWidget(
                loadingState: LoadingState.result_save,
                toolTip: "Save",
                text: "Save",
                icn: Icons.save_alt_outlined,
                onPressed: _saveImageToDownloads,
              ),
            ),
            context.width(12.0).wMargin,
            Expanded(
              child: LoadingBtnWidget(
                loadingState: LoadingState.result_share,
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
