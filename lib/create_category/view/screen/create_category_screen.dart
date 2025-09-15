
import 'dart:io';
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_enhancer_app/create_category/view/widget/app_bar_widget.dart';
import 'package:image_enhancer_app/create_category/view/widget/attribute_option_grid_view_widget.dart';
import 'package:image_enhancer_app/create_category/view/widget/attribute_option_widget.dart';
import 'package:image_enhancer_app/create_category/view/widget/color_option_grid_view_widget.dart';
import 'package:image_enhancer_app/create_category/view/widget/color_option_widget.dart';
import 'package:image_enhancer_app/create_category/view/widget/icn_btn_widget.dart';
import 'package:image_enhancer_app/create_category/view/widget/img_object_painter_widget.dart';
import 'package:image_enhancer_app/create_category/view/widget/img_widget.dart';
import 'package:image_enhancer_app/create_category/view/widget/loading_btn_widget.dart';
import 'package:image_enhancer_app/create_category/view/widget/medium_heading_widget.dart';
import 'package:image_enhancer_app/create_category/view/widget/modal_bottom_sheet_heading_widget.dart';
import 'package:image_enhancer_app/create_category/view/widget/modal_bottom_sheet_widget.dart';
import 'package:image_enhancer_app/create_category/view/widget/option_btn_widget.dart';
import 'package:image_enhancer_app/create_category/view_model/bloc/img_picker/img_picker_bloc.dart';
import 'package:image_enhancer_app/create_category/view_model/bloc/loading_view/loading_view_bloc.dart';
import 'package:image_enhancer_app/create_category/view_model/model/api_request.dart';
import 'package:image_enhancer_app/create_category/view_model/model/create_category_model.dart';
import 'package:image_enhancer_app/create_category/view_model/model/stroke_model.dart';
import 'package:image_enhancer_app/premium/view/screen/premium_screen.dart';
import 'package:image_enhancer_app/result/view/screen/result_screen.dart';
import 'package:image_enhancer_app/service/in_app_purchase/in_app_purchase_subscription_bloc.dart';
import 'package:image_enhancer_app/splash/view/widget/circular_progress_indicator_widget.dart';
import 'package:image_enhancer_app/splash/view/widget/text_widget.dart';
import 'package:image_enhancer_app/utils/constant/alignment.dart';
import 'package:image_enhancer_app/utils/constant/color.dart';
import 'package:image_enhancer_app/utils/constant/font_weight.dart';
import 'package:image_enhancer_app/utils/constant/padding.dart';
import 'package:image_enhancer_app/utils/enum/img_type.dart';
import 'package:image_enhancer_app/utils/enum/in_app_purchase_subscription_status.dart';
import 'package:image_enhancer_app/utils/enum/loading_type.dart';
import 'package:image_enhancer_app/utils/enum/sub_category_type.dart';
import 'package:image_enhancer_app/utils/extension/common_extension.dart';
import 'package:image_enhancer_app/utils/extension/navigator_extension.dart';
import 'package:image_enhancer_app/utils/extension/snackbar_extension.dart';
import 'package:image_enhancer_app/utils/extension/widget_extension.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as pp;


class CreateCategoryScreen extends StatefulWidget {
  final SubCategoryType subCategoryType;
  const CreateCategoryScreen({super.key, required this.subCategoryType});

  @override
  State<CreateCategoryScreen> createState() => _CreateCategoryScreenState();
}

class _CreateCategoryScreenState extends State<CreateCategoryScreen> {

  final GlobalKey _imgObjectPainterKey = GlobalKey();
  final TextEditingController _promptController = TextEditingController();
  final ValueNotifier<int> _firstAttributeNotifier = ValueNotifier(0);
  final ValueNotifier<List<StrokeModel>> _strokesNotifier = ValueNotifier([]);
  final ValueNotifier<List<StrokeModel>> _undoneStrokesNotifier = ValueNotifier([]);
  final ValueNotifier<double> _brushSizeNotifier = ValueNotifier(20.0);

  late ImgPickerBloc _imgPickerCubit;

  void _imgGeneratorFunction() async {

    try {
      if(_imgPickerCubit.state.img == null) {
        context.showSnackBar(msg: "Select or upload your image");
        return;
      }
      else if((widget.subCategoryType == SubCategoryType.remove_object) && _promptController.text.isEmpty) {
        context.showSnackBar(msg: "Enter your prompt");
        return;
      } else if(context.read<InAppPurchaseSubscriptionBloc>().state.subscriptionStatus == InAppPurchaseSubscriptionStatus.none) {
        context.push(widget: PremiumScreen());
        return;
      } else if(context.read<InAppPurchaseSubscriptionBloc>().state.subscriptionStatus == InAppPurchaseSubscriptionStatus.daily_subscription_usage_limit_exceeded) {
        context.showSnackBar(msg: "Your daily limit of usage has been exceeded");
        return;
      }
      else {

        context.showLoadingView(loadingType: LoadingType.generating);

        String img = _imgPickerCubit.state.img ?? "";
        final prompt = _promptController.text.trim();
        final firstAttributeIndex = _firstAttributeNotifier.value;

        // if(widget.subCategoryType == SubCategoryType.remove_object) {
        //   RenderRepaintBoundary boundary = _imgObjectPainterKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
        //   ui.Image image = await boundary.toImage(pixelRatio: 3.0);
        //   ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        //   Uint8List pngBytes = byteData!.buffer.asUint8List();
        //   final directory = await pp.getTemporaryDirectory();
        //   img = await File(path.join(directory.path, "${DateTime.now().microsecondsSinceEpoch}.png")).writeAsBytes(pngBytes).then((value) => value.path);
        // }

        final urlResponse = await ApiRequest.generateImg(img: img, prompt: widget.subCategoryType.getPrompt(prompt, firstAttributeIndex));

        if(urlResponse.success) {

          await 3.second.wait();

          final imgResponse = await ApiRequest.getImgStatus(url: urlResponse.value);

          if(imgResponse.success) {

            if(context.read<InAppPurchaseSubscriptionBloc>().state.subscriptionStatus == InAppPurchaseSubscriptionStatus.freetrial) {
              context.read<InAppPurchaseSubscriptionBloc>().updateFreeTrialLimit();
            } else if(context.read<InAppPurchaseSubscriptionBloc>().state.subscriptionStatus == InAppPurchaseSubscriptionStatus.premium_subscription) {
              context.read<InAppPurchaseSubscriptionBloc>().updateDailySubscriptionUsageLimit();
            }

            context.push(
                widget: ResultScreen(
                    categoryType: widget.subCategoryType.getCategoryType(),
                  categoryModel: CreateCategoryModel(
                    img: imgResponse.value as String,
                    provideImg: img,
                    prompt: prompt,
                    firstOptionIndex: firstAttributeIndex
                  )
                )
            );

          } else {
            context.showSnackBar(msg: imgResponse.msg);
          }

        } else {
          context.showSnackBar(msg: urlResponse.msg);
        }

        context.stopLoadingView();
      }
   } catch (e) {
     context.showSnackBar(msg: e.parseException().msg);
     e.printResponse(title: "generate img exception");
   }
  }

  void _createBtnFunction() {
    _imgGeneratorFunction();
  }

  void _undo() {
    if (_strokesNotifier.value.isNotEmpty) {
      final updatedStrokes = List<StrokeModel>.from(_strokesNotifier.value);
      final removed = updatedStrokes.removeLast();

      _strokesNotifier.value = updatedStrokes;
      _undoneStrokesNotifier.value = [..._undoneStrokesNotifier.value, removed];
    }
  }

  void _redo() {
    if (_undoneStrokesNotifier.value.isNotEmpty) {
      final updatedUndone = List<StrokeModel>.from(_undoneStrokesNotifier.value);
      final restored = updatedUndone.removeLast();

      _undoneStrokesNotifier.value = updatedUndone;
      _strokesNotifier.value = [..._strokesNotifier.value, restored];
    }
  }

  String _appBarText() {
    switch(widget.subCategoryType) {
      case SubCategoryType.photo_enhancer:
        return "Photo Enhancer";
      case SubCategoryType.move_camera:
        return "Move Camera";
      case SubCategoryType.relight:
        return "Relight";
      case SubCategoryType.product_photo:
        return "Product Photo";
      case SubCategoryType.zoom:
        return "Zoom";
      case SubCategoryType.colorize:
        return "Colorize";
      case SubCategoryType.bkg_remover:
        return "Change Background";
      case SubCategoryType.remove_object:
        return "Remove Object";
      case SubCategoryType.remove_text:
        return "Remove Text";
      case SubCategoryType.cartoonify:
        return "Cartoonify";
      case SubCategoryType.movie_poster:
        return "Movie Poster";
      case SubCategoryType.hair_cut:
        return "Hair Cut";
      case SubCategoryType.turn_into_avatar:
        return "Turn Into Avatar";
      case SubCategoryType.body_builder:
        return "Body Builder";
      default:
        return "";
    }
  }

  String _textFieldPromptHint() {
    switch(widget.subCategoryType) {
      case SubCategoryType.photo_enhancer:
        return "";
      case SubCategoryType.move_camera:
        return "";
      case SubCategoryType.relight:
        return "";
      case SubCategoryType.product_photo:
        return "";
      case SubCategoryType.zoom:
        return "What should we zoom on? (Optional)";
      case SubCategoryType.colorize:
        return "";
      case SubCategoryType.bkg_remover:
        return "";
      case SubCategoryType.remove_object:
        return "What should we remove?";
      case SubCategoryType.remove_text:
        return "";
      case SubCategoryType.cartoonify:
        return "";
      case SubCategoryType.movie_poster:
        return "Title of the movie? (Optional)";
      case SubCategoryType.hair_cut:
        return "";
      case SubCategoryType.turn_into_avatar:
        return "";
      case SubCategoryType.body_builder:
        return "";
      default:
        return "";
    }
  }

  void _initFunction() {
    _imgPickerCubit = ImgPickerBloc();
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
    return WillPopScope(
      onWillPop: () async => context.read<LoadingViewBloc>().state.loadingType != LoadingType.generating,
      child: BlocProvider(
        create: (context) => _imgPickerCubit,
        child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBarWidget.build(context: context, title: _appBarText()),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              context.height(16.0).hMargin,
              CustomPaint(
                painter: DashedBorderPainter(color: kBlueColor, borderRadius: context.width(16.0)),
                child: Container(
                  width: double.maxFinite,
                  height: context.width(300.0),
                  decoration: BoxDecoration(
                      color: kGrey3Color,
                      gradient: kBlueGradient.withOpacity(.4),
                      borderRadius: context.width(16.0).borderRadius
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: double.maxFinite,
                        height: double.maxFinite,
                        decoration: BoxDecoration(
                            gradient: kBlueGradient.withOpacity(.2),
                            borderRadius: context.width(16.0).borderRadius
                        )
                      ),
                      BlocBuilder<ImgPickerBloc, ImgPickerState>(
                          builder: (context, imgPickerState) {
                            return imgPickerState.img != null
                                && !imgPickerState.loading ?
                            // widget.subCategoryType == SubCategoryType.remove_object
                            //     ? ImgObjectPainterWidget(
                            //     globalKey: _imgObjectPainterKey,
                            //     strokeNotifier: _strokesNotifier,
                            //     undoStrokeNotifier: _undoneStrokesNotifier,
                            //     brushSizeNotifier: _brushSizeNotifier,
                            //     imgType: _imgPickerCubit.state.imgType,
                            //     img: _imgPickerCubit.state.img ?? "")
                            //     :
                            ImgWidget(imgType: imgPickerState.imgType, img: imgPickerState.img!, fit: BoxFit.cover, isInTerActive: true,
                                borderRadius: context.width(16.0).borderRadius

                            )
                                : Container(
                              width: double.maxFinite,
                              height: double.maxFinite,
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: kCenterCrossAxisAlignment,
                                children: imgPickerState.loading ? [
                                  Center(child: CircularProgressIndicatorWidget())
                                ] : [
                                  TextWidget(text: "Snap It, See Magic", color: kGreyColor, fontSize: 12.0),
                                  context.height(16.0).hMargin,
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      OptionBtnWidget(
                                          tooltip: "Camera",
                                          text: "Take Photo",
                                          textSize: 14.0,
                                          icnImgSize: 16.0,
                                          icn: CupertinoIcons.camera_fill,
                                          padding: context.width(12.0).horizontalEdgeInsets,
                                          onPressed: () => _imgPickerCubit.pickImg(imgSource: ImageSource.camera)
                                      ),
                                      context.width(8.0).wMargin,
                                      OptionBtnWidget(
                                          tooltip: "Gallery",
                                          text: "Select Photo",
                                          textSize: 14.0,
                                          icnImgSize: 16.0,
                                          icn: Icons.image,
                                          padding: context.width(12.0).horizontalEdgeInsets,
                                          onPressed: () => _imgPickerCubit.pickImg(imgSource: ImageSource.gallery)
                                      )
                                    ],
                                  )
                                ],
                              ),
                            );
                          }
                      ),
                      BlocBuilder<ImgPickerBloc, ImgPickerState>(
                          builder: (context, imgPickerState) {
                            return imgPickerState.img != null ? Positioned(
                                top: 2.0,
                                right: 2.0,
                                child: IcnBtnWidget(
                                    tooltip: "Remove",
                                    icn: Icons.close,
                                    color: kWhiteColor,
                                    onPressed: () => _imgPickerCubit.clearState())) : SizedBox.shrink();
                          }
                      )
                    ],
                  ),
                ),
              ),
              if(widget.subCategoryType == SubCategoryType.zoom ||
                  widget.subCategoryType == SubCategoryType.remove_object || widget.subCategoryType == SubCategoryType.movie_poster) ...[
                context.height(16.0).hMargin,
                MediumHeadingWidget(title: "Prompt"),
                context.height(8.0).hMargin,
                Container(
                  padding: context.width(1.0).allEdgeInsets,
                  decoration: BoxDecoration(
                    gradient: kBlueGradient,
                    borderRadius: context.width(8.0).borderRadius
                  ),
                  child: TextFormField(
                    controller: _promptController,
                    cursorColor: kBlueColor,
                    style: TextStyle(
                      fontSize: context.width(16.0),
                      decoration: TextDecoration.none,
                      decorationColor: kTransparentColor
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: kBlack2Color,
                      hintText: _textFieldPromptHint(),
                      hintStyle: TextStyle(
                        color: kGreyColor,
                        fontSize: context.width(14.0)
                      ),
                      border: OutlineInputBorder(
                        borderRadius: context.width(8.0).borderRadius,
                        borderSide: BorderSide.none
                      ),
                        enabledBorder: OutlineInputBorder(
                        borderRadius: context.width(8.0).borderRadius,
                        borderSide: BorderSide.none
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: context.width(8.0).borderRadius,
                          borderSide: BorderSide.none
                      ),
                      disabledBorder: OutlineInputBorder(
                          borderRadius: context.width(8.0).borderRadius,
                          borderSide: BorderSide.none
                      ),
                    ),
                    onTapOutside: (event) => FocusScope.of(context).unfocus(),
                  ),
                )
            ],
              if(widget.subCategoryType == SubCategoryType.remove_object) ...[
                // BlocBuilder<ImgPickerBloc, ImgPickerState>(
                //     builder: (context, imgPickerState) {
                //       return imgPickerState.img != null ? Column(
                //         crossAxisAlignment: kStartCrossAxisAlignment,
                //         children: [
                //           context.height(16.0).hMargin,
                //           MediumHeadingWidget(
                //               title: "Brush Size",
                //               action: IcnBtnWidget(
                //                   tooltip: "Clear",
                //                   icn: CupertinoIcons.clear_circled,
                //                   onPressed: () {
                //                     _strokesNotifier.value = <StrokeModel>[];
                //                     _undoneStrokesNotifier.value = <StrokeModel>[];
                //           })),
                //           context.height(8.0).hMargin,
                //           Row(
                //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //             children: [
                //               IcnBtnWidget(
                //                   tooltip: "Decrease",
                //                   icn: Icons.exposure_minus_1,
                //                   onPressed: () {
                //                     if(_brushSizeNotifier.value > 1) {
                //                       _brushSizeNotifier.value--;
                //                     }
                //                   }),
                //               ValueListenableBuilder<double>(
                //                 valueListenable: _brushSizeNotifier,
                //                 builder: (context, value, child) {
                //                   return TextWidget(text: value.toStringAsFixed(0));
                //                 }
                //               ),
                //               IcnBtnWidget(
                //                   tooltip: "Increase",
                //                   icn: Icons.exposure_plus_1,
                //                   onPressed: () {
                //                     if(_brushSizeNotifier.value < 100) {
                //                       _brushSizeNotifier.value++;
                //                     }
                //                   })
                //             ],
                //           ),
                //           ValueListenableBuilder<double>(
                //               valueListenable: _brushSizeNotifier,
                //               builder: (context, value, child) {
                //                 return Slider(
                //                   value: value,
                //                   min: 1.0,
                //                   max: 100.0,
                //                   divisions: 99,
                //                   thumbColor: kBlueColor,
                //                   activeColor: kBlueColor,
                //                   label: value.toStringAsFixed(0),
                //                   padding: kZeroEdgeInsets,
                //                   onChanged: (value) {
                //                     _brushSizeNotifier.value = value;
                //                   },
                //                 );
                //               }
                //           ),
                //           Row(
                //             children: [
                //               IcnBtnWidget(
                //                   tooltip: "Undo",
                //                   icn: Icons.undo_outlined,
                //                   onPressed: _undo),
                //               TextWidget(text: "Undo"),
                //               Spacer(),
                //               TextWidget(text: "Redo"),
                //               IcnBtnWidget(
                //                   tooltip: "Redo",
                //                   icn: Icons.redo_outlined,
                //                   onPressed: _redo)
                //             ],
                //           ),
                //         ],
                //       ) : SizedBox.shrink();
                //     }
                // )
              ]
              else if(widget.subCategoryType == SubCategoryType.bkg_remover
                  && widget.subCategoryType.option().firstAttributeList.isNotEmpty) ...[
                context.height(16.0).hMargin,
                MediumHeadingWidget(
                    title: "Select Background Color",
                    onPressed: () {
                  ModalBottomSheetWidget.show(
                      context: context,
                      child: SingleChildScrollView(
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ModalBottomSheetHeadingWidget(title: "Choose Option"),
                              context.height(8.0).hMargin,
                              ColorOptionGridViewWidget(
                                valueNotifier: _firstAttributeNotifier,
                                  data: widget.subCategoryType.option().firstAttributeList
                              ),
                            ]
                        ).padding(padding: context.width(16.0).allEdgeInsets),
                      )
                  );
                }),
                context.height(8.0).hMargin,
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ColorOptionWidget(
                        valueNotifier: _firstAttributeNotifier,
                        data: widget.subCategoryType.option().firstAttributeList))
              ]
              else if(widget.subCategoryType == SubCategoryType.turn_into_avatar && widget.subCategoryType.option().firstAttributeList.isNotEmpty) ...[
                context.height(16.0).hMargin,
                MediumHeadingWidget(
                    title: "Select Style",
                    onPressed: () {
                      ModalBottomSheetWidget.show(
                          context: context,
                          child: SingleChildScrollView(
                            child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ModalBottomSheetHeadingWidget(title: "Choose Option"),
                              context.height(8.0).hMargin,
                              AttributeOptionGridViewWidget(
                                  skipIndex: 0,
                                  valueNotifier: _firstAttributeNotifier,
                                  imgType: ImgType.asset,
                                  data: widget.subCategoryType.option().firstAttributeList
                              ),
                            ]
                        ).padding(padding: context.width(16.0).allEdgeInsets),
                      )
                  );

                }),
                  AttributeOptionWidget(
                      skipIndex: 0,
                      valueNotifier: _firstAttributeNotifier,
                      data: widget.subCategoryType.option().firstAttributeList,
                      imgType: ImgType.asset),
                context.height(16.0).hMargin,
              ],
              context.width(111.0).hMargin,
            ],
          ).padding(padding: context.width(16.0).horizontalEdgeInsets),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          padding: EdgeInsets.symmetric(vertical: context.width(12.0), horizontal: context.width(16.0)),
          decoration: BoxDecoration(
            color: kBlack2Color,
            border: Border(top: BorderSide(color: kWhiteColor.withOpacity(.15), width: context.width(.5)))
          ),
          child: LoadingBtnWidget(
            // loadingState: widget.categoryType.btnLoading().loadingState,
            toolTip: "Enhance With AI",
            text: "ENHANCE WITH AI",
            displayIcnRight: true,
            icn: Icons.auto_awesome_outlined,
            onPressed: _createBtnFunction
          )
        ),
      ),
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final double borderRadius;

  DashedBorderPainter({
    required this.color,
    this.strokeWidth = 1.0,
    this.dashWidth = 4.0,
    this.dashSpace = 4.0,
    this.borderRadius = 8.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Offset.zero & size,
        Radius.circular(borderRadius),
      ));

    final dashPath = _createDashedPath(path);
    canvas.drawPath(dashPath, paint);
  }

  Path _createDashedPath(Path source) {
    final dashPath = Path();
    final pathMetrics = source.computeMetrics();

    for (final metric in pathMetrics) {
      double distance = 0.0;
      while (distance < metric.length) {
        final length = dashWidth;
        dashPath.addPath(
          metric.extractPath(distance, distance + length),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }

    return dashPath;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}


// class ImageColoringPage extends StatefulWidget {
//   const ImageColoringPage({super.key});
//
//   @override
//   _ImageColoringPageState createState() => _ImageColoringPageState();
// }
//
// class _ImageColoringPageState extends State<ImageColoringPage> {
//   final GlobalKey _globalKey = GlobalKey();
//
//   final ValueNotifier<List<Stroke>> strokes = ValueNotifier([]);
//   final ValueNotifier<List<Stroke>> undoneStrokes = ValueNotifier([]);
//
//   double brushSize = 30.0;
//
//   void undo() {
//     if (strokes.value.isNotEmpty) {
//       final updatedStrokes = List<Stroke>.from(strokes.value);
//       final removed = updatedStrokes.removeLast();
//
//       strokes.value = updatedStrokes;
//       undoneStrokes.value = [...undoneStrokes.value, removed];
//     }
//   }
//
//   void redo() {
//     if (undoneStrokes.value.isNotEmpty) {
//       final updatedUndone = List<Stroke>.from(undoneStrokes.value);
//       final restored = updatedUndone.removeLast();
//
//       undoneStrokes.value = updatedUndone;
//       strokes.value = [...strokes.value, restored];
//     }
//   }
//
//   Future<void> saveImage() async {
//     try {
//       RenderRepaintBoundary boundary =
//       _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
//
//       ui.Image image = await boundary.toImage(pixelRatio: 3.0);
//       ByteData? byteData =
//       await image.toByteData(format: ui.ImageByteFormat.png);
//       Uint8List pngBytes = byteData!.buffer.asUint8List();
//
//       // Save to temporary file
//       final directory = await getTemporaryDirectory();
//       final filePath = '${directory.path}/colored_image.png';
//       File file = File(filePath);
//       await file.writeAsBytes(pngBytes);
//
//       // Save to gallery
//       await GallerySaver.saveImage(file.path);
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Image saved to gallery ✅")),
//       );
//     } catch (e) {
//       print("Error saving image: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Wrap in RepaintBoundary
//           RepaintBoundary(
//             key: _globalKey,
//             child: GestureDetector(
//               onPanStart: (details) {
//                 final newStroke = Stroke([details.localPosition], brushSize);
//                 strokes.value = [...strokes.value, newStroke];
//                 undoneStrokes.value = []; // clear redo history
//               },
//               onPanUpdate: (details) {
//                 final updatedStrokes = List<Stroke>.from(strokes.value);
//                 updatedStrokes.last.points =
//                 [...updatedStrokes.last.points, details.localPosition];
//                 strokes.value = updatedStrokes;
//               },
//               onPanEnd: (details) {
//                 final updatedStrokes = List<Stroke>.from(strokes.value);
//                 updatedStrokes.last.points =
//                 [...updatedStrokes.last.points, Offset.infinite];
//                 strokes.value = updatedStrokes;
//               },
//               child: Stack(
//                 children: [
//                   Positioned.fill(
//                     child: Image.asset("assets/sample.jpg", fit: BoxFit.cover),
//                   ),
//                   Positioned.fill(
//                     child: ValueListenableBuilder<List<Stroke>>(
//                       valueListenable: strokes,
//                       builder: (context, value, child) {
//                         return CustomPaint(
//                           painter: ColorPainter(value),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//           // Bottom controls
//           Positioned(
//             bottom: 30,
//             left: 20,
//             right: 20,
//             child: Card(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               elevation: 4,
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text("Brush Size: ${brushSize.toStringAsFixed(0)}"),
//                     Slider(
//                       value: brushSize,
//                       min: 5,
//                       max: 100,
//                       divisions: 19,
//                       label: brushSize.toStringAsFixed(0),
//                       onChanged: (value) {
//                         setState(() {
//                           brushSize = value;
//                         });
//                       },
//                     ),
//                     const SizedBox(height: 10),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         ElevatedButton.icon(
//                           onPressed: undo,
//                           icon: const Icon(Icons.undo),
//                           label: const Text("Undo"),
//                         ),
//                         ElevatedButton.icon(
//                           onPressed: redo,
//                           icon: const Icon(Icons.redo),
//                           label: const Text("Redo"),
//                         ),
//                         ElevatedButton.icon(
//                           onPressed: saveImage,
//                           icon: const Icon(Icons.save),
//                           label: const Text("Save"),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // Stroke model
// class Stroke {
//   List<Offset> points;
//   double size;
//   Stroke(this.points, this.size);
// }
//
// // Painter
// class ColorPainter extends CustomPainter {
//   final List<Stroke> strokes;
//   ColorPainter(this.strokes);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     for (var stroke in strokes) {
//       final paint = Paint()
//         ..color = Colors.red.withOpacity(0.4)
//         ..style = PaintingStyle.stroke
//         ..strokeWidth = stroke.size
//         ..strokeCap = StrokeCap.round;
//
//       for (int i = 0; i < stroke.points.length - 1; i++) {
//         if (stroke.points[i] != Offset.infinite &&
//             stroke.points[i + 1] != Offset.infinite) {
//           canvas.drawLine(stroke.points[i], stroke.points[i + 1], paint);
//         }
//       }
//     }
//   }
//
//   @override
//   bool shouldRepaint(ColorPainter oldDelegate) => true;
// }




// class ImageColoringPage extends StatefulWidget {
//   @override
//   _ImageColoringPageState createState() => _ImageColoringPageState();
// }
//
// class _ImageColoringPageState extends State<ImageColoringPage> {
//   List<Offset> points = [];
//   double brushSize = 30.0; // default brush size
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Gesture area for painting
//           GestureDetector(
//             onPanUpdate: (details) {
//               setState(() {
//                 points.add(details.localPosition);
//               });
//             },
//             onPanEnd: (details) {
//               points.add(Offset.infinite); // mark stroke end
//             },
//             child: Stack(
//               children: [
//                 Positioned.fill(
//                   child: Image.asset("assets/sample.jpg", fit: BoxFit.cover),
//                 ),
//                 Positioned.fill(
//                   child: CustomPaint(
//                     painter: ColorPainter(points, brushSize),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           // Brush size slider
//           Positioned(
//             bottom: 30,
//             left: 20,
//             right: 20,
//             child: Card(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               elevation: 4,
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text("Brush Size: ${brushSize.toStringAsFixed(0)}"),
//                     Slider(
//                       value: brushSize,
//                       min: 5,
//                       max: 100,
//                       divisions: 19,
//                       label: brushSize.toStringAsFixed(0),
//                       onChanged: (value) {
//                         setState(() {
//                           brushSize = value;
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class ColorPainter extends CustomPainter {
//   final List<Offset> points;
//   final double brushSize;
//
//   ColorPainter(this.points, this.brushSize);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.red.withOpacity(0.4)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = brushSize
//       ..strokeCap = StrokeCap.round;
//
//     for (int i = 0; i < points.length - 1; i++) {
//       if (points[i] != Offset.infinite && points[i + 1] != Offset.infinite) {
//         canvas.drawLine(points[i], points[i + 1], paint);
//       }
//     }
//   }
//
//   @override
//   bool shouldRepaint(ColorPainter oldDelegate) => true;
// }



//
// class ObjectSelectionScreen extends StatefulWidget {
//   const ObjectSelectionScreen({super.key});
//
//   @override
//   State<ObjectSelectionScreen> createState() => _ObjectSelectionScreenState();
// }
//
// class _ObjectSelectionScreenState extends State<ObjectSelectionScreen> {
//   Rect? rect; // stores selected rectangle
//   Offset? startDrag;
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: GestureDetector(
//         onPanStart: (details) {
//           setState(() {
//             startDrag = details.localPosition;
//             rect = null;
//           });
//         },
//         onPanUpdate: (details) {
//           setState(() {
//             final current = details.localPosition;
//             rect = Rect.fromPoints(startDrag!, current);
//           });
//         },
//         onPanEnd: (_) {
//           // TODO: send `rect` + image to AI model for object removal
//           debugPrint("Selected Rect: $rect");
//         },
//         child: Stack(
//           children: [
//             Image.asset(ExploreOption.img_utils[0]["img"]), // your image
//             if (rect != null)
//               Positioned.fill(
//                 child: CustomPaint(
//                   painter: RectPainter(rect!),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class RectPainter extends CustomPainter {
//   final Rect rect;
//   RectPainter(this.rect);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.blue.withOpacity(0.3)
//       ..style = PaintingStyle.fill;
//
//     final border = Paint()
//       ..color = Colors.blue
//       ..strokeWidth = 2
//       ..style = PaintingStyle.stroke;
//
//     canvas.drawRect(rect, paint);
//     canvas.drawRect(rect, border);
//   }
//
//   @override
//   bool shouldRepaint(covariant RectPainter oldDelegate) {
//     return oldDelegate.rect != rect;
//   }
// }




