import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:image_enhancer_app/create_category/view/widget/medium_heading_widget.dart';
import 'package:image_enhancer_app/explore/view/widget/toggle_btn_widget.dart';
import 'package:image_enhancer_app/history/view/widget/history_grid_view_widget.dart';
import 'package:image_enhancer_app/history/view_model/bloc/fun_preset_bloc/fun_preset_history_bloc.dart';
import 'package:image_enhancer_app/history/view_model/bloc/img_utils_bloc/img_utils_history_bloc.dart';
import 'package:image_enhancer_app/history/view_model/bloc/magic_remover_bloc/img_utils_history_bloc.dart';
import 'package:image_enhancer_app/splash/view/widget/circular_progress_indicator_widget.dart';
import 'package:image_enhancer_app/splash/view/widget/text_widget.dart';
import 'package:image_enhancer_app/utils/constant/color.dart';
import 'package:image_enhancer_app/utils/constant/font_weight.dart';
import 'package:image_enhancer_app/utils/constant/image_path.dart';
import 'package:image_enhancer_app/utils/enum/img_type.dart';
import 'package:image_enhancer_app/utils/extension/common_extension.dart';
import 'package:image_enhancer_app/utils/extension/navigator_extension.dart';
import 'package:image_enhancer_app/utils/extension/widget_extension.dart';
import 'package:share_plus/share_plus.dart';

class HistoryScreen extends StatefulWidget {
  final PageController? pageController;
  final ValueNotifier<bool>? isChangeNotifier;
  const HistoryScreen({super.key, this.pageController, this.isChangeNotifier});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> with AutomaticKeepAliveClientMixin{

  final ValueNotifier<int> _categoryNotifier = ValueNotifier(0);

  // void _deleteBtnFunction(int index, ValueNotifier<({bool isLoading, double? progress})> btnNotifier) async {
  //
  //   context.read<VideoHistoryBloc>().state.dataList[index].printResponse(title: "history index value");
  //
  //   btnNotifier.value = (isLoading: true, progress: null);
  //
  //   await context.read<VideoHistoryBloc>().removeValue(index: index);
  //
  //   btnNotifier.value = (isLoading: false, progress: null);
  // }
  //
  // void _shareBtnFunction(int index, ValueNotifier<({bool isLoading, double? progress})> btnNotifier) async {
  //   try {
  //     btnNotifier.value = (isLoading: true, progress: null);
  //
  //     final file = File(context.read<VideoHistoryBloc>().state.dataList[index]["video"] ?? "");
  //
  //     if(await file.exists()) {
  //
  //           await SharePlus.instance.share(ShareParams(
  //             title: "AI Video Generator",
  //             files: <XFile>[
  //               XFile(file.path)
  //             ]
  //           ));
  //
  //     } else {
  //       context.showSnackBar(msg: "File not found or lost");
  //     }
  //
  //   } catch (e) {
  //     e.printResponse(title: "share history video exception");
  //   } finally {
  //     btnNotifier.value = (isLoading: false, progress: null);
  //   }
  // }
  //
  // void _downloadBtnFunction(int index, ValueNotifier<({bool isLoading, double? progress})> btnNotifier) async {
  //
  //   try {
  //     btnNotifier.value = (isLoading: true, progress: null);
  //
  //     await 1.second.wait();
  //
  //     final file = File(context.read<VideoHistoryBloc>().state.dataList[index]["video"] ?? "");
  //
  //     if(await file.exists()) {
  //
  //       await Future.wait([
  //         GallerySaver.saveVideo(file.path, albumName: "AI Video Generator"),
  //         Future(() async {
  //           for(int x = 0; x <= 100; x++) {
  //             btnNotifier.value = (isLoading: true, progress: x / 100);
  //             await 50.millisecond.wait();
  //           }
  //         })
  //       ]);
  //       await 100.millisecond.wait();
  //       btnNotifier.value = (isLoading: true, progress: null);
  //       await 1.second.wait();
  //       context.showSnackBar(msg: "Video saved successfully!");
  //     } else {
  //       context.showSnackBar(msg: "File not found or lost");
  //     }
  //   } catch (e) {
  //     e.printResponse(title: "download history video exception");
  //   } finally {
  //     btnNotifier.value = (isLoading: false, progress: null);
  //   }
  // }
  //

  void _initFunction() {
    context.read<ImgUtilsHistoryBloc>().loadInitialHistory();
    context.read<MagicRemoverHistoryBloc>().loadInitialHistory();
    context.read<FunPresetHistoryBloc>().loadInitialHistory();
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            context.height(16.0).hMargin,
            ToggleBtnWidget(
                optionList: <Map<String, dynamic>>[
                  {"img": kImgIcnPath, "title": "Image Utilities"},
                  {"img": kEraseIcnPath, "title": "Magic Remover"},
                  {"img": kFunPresetIcnPath, "title": "Fun Presets"}
                ],
                onPressed: (index) {
                  _categoryNotifier.value = index;
                }
            ),
            context.height(16.0).hMargin,
            IndexedStack(
              index: 0,
              children: [
                BlocBuilder<ImgUtilsHistoryBloc, ImgUtilsHistoryState>(
                  builder: (context, videoHistoryState) {
                    if (videoHistoryState.isLoading) {
                      return const Center(child: CircularProgressIndicatorWidget());
                    } else if (!videoHistoryState.success || videoHistoryState.dataList.isEmpty || videoHistoryState.msg.isNotEmpty) {
                      return _buildEmptyScreen(title: "You currently don’t have any\n", gradientTitle: "Image.");
                    } else {
                      return NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification notification) {
                          if (notification.metrics.pixels >= notification.metrics.maxScrollExtent - 106 && !videoHistoryState.isLoading
                              && videoHistoryState.hasMore) {
                            context.read<ImgUtilsHistoryBloc>().loadMoreHistory();
                          }
                          return false;
                        },
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              context.height(16.0).hMargin,
                              MediumHeadingWidget(title: "Your recent history"),
                              context.height(8.0).hMargin,
                              HistoryGridViewWidget(
                                data: videoHistoryState.dataList,
                                imgType: ImgType.file,
                                // onDeletePressed: _deleteBtnFunction,
                                // onSharePressed: _shareBtnFunction,
                                // onDownloadPressed: _downloadBtnFunction,
                                // onPressed: (index) => context.push(widget: ViewHistoryItemScreen(dbDataModel: DBDataModel.fromJson(json: videoHistoryState.dataList[index]))),
                              ),
                              if (videoHistoryState.isLoading)
                                Center(child: CircularProgressIndicatorWidget()).padding(padding: context.height(16.0).verticalEdgeInsets),
                              context.height(16.0).hMargin,
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
                BlocBuilder<MagicRemoverHistoryBloc, MagicRemoverHistoryState>(
                  builder: (context, videoHistoryState) {
                    if (videoHistoryState.isLoading) {
                      return const Center(child: CircularProgressIndicatorWidget());
                    } else if (!videoHistoryState.success || videoHistoryState.dataList.isEmpty || videoHistoryState.msg.isNotEmpty) {
                      return _buildEmptyScreen(title: "You currently don’t have any\n", gradientTitle: "Image.");
                    } else {
                      return NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification notification) {
                          if (notification.metrics.pixels >= notification.metrics.maxScrollExtent - 106 && !videoHistoryState.isLoading
                              && videoHistoryState.hasMore) {
                            context.read<ImgUtilsHistoryBloc>().loadMoreHistory();
                          }
                          return false;
                        },
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              context.height(16.0).hMargin,
                              MediumHeadingWidget(title: "Your recent history"),
                              context.height(8.0).hMargin,
                              HistoryGridViewWidget(
                                data: videoHistoryState.dataList,
                                imgType: ImgType.file,
                                // onDeletePressed: _deleteBtnFunction,
                                // onSharePressed: _shareBtnFunction,
                                // onDownloadPressed: _downloadBtnFunction,
                                // onPressed: (index) => context.push(widget: ViewHistoryItemScreen(dbDataModel: DBDataModel.fromJson(json: videoHistoryState.dataList[index]))),
                              ),
                              if (videoHistoryState.isLoading)
                                Center(child: CircularProgressIndicatorWidget()).padding(padding: context.height(16.0).verticalEdgeInsets),
                              context.height(16.0).hMargin,
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
                BlocBuilder<FunPresetHistoryBloc, FunPresetHistoryState>(
                  builder: (context, videoHistoryState) {
                    if (videoHistoryState.isLoading) {
                      return const Center(child: CircularProgressIndicatorWidget());
                    } else if (!videoHistoryState.success || videoHistoryState.dataList.isEmpty || videoHistoryState.msg.isNotEmpty) {
                      return _buildEmptyScreen(title: "You currently don’t have any\n", gradientTitle: "Image.");
                    } else {
                      return NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification notification) {
                          if (notification.metrics.pixels >= notification.metrics.maxScrollExtent - 106 && !videoHistoryState.isLoading
                              && videoHistoryState.hasMore) {
                            context.read<ImgUtilsHistoryBloc>().loadMoreHistory();
                          }
                          return false;
                        },
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              context.height(16.0).hMargin,
                              MediumHeadingWidget(title: "Your recent history"),
                              context.height(8.0).hMargin,
                              HistoryGridViewWidget(
                                data: videoHistoryState.dataList,
                                imgType: ImgType.file,
                                // onDeletePressed: _deleteBtnFunction,
                                // onSharePressed: _shareBtnFunction,
                                // onDownloadPressed: _downloadBtnFunction,
                                // onPressed: (index) => context.push(widget: ViewHistoryItemScreen(dbDataModel: DBDataModel.fromJson(json: videoHistoryState.dataList[index]))),
                              ),
                              if (videoHistoryState.isLoading)
                                Center(child: CircularProgressIndicatorWidget()).padding(padding: context.height(16.0).verticalEdgeInsets),
                              context.height(16.0).hMargin,
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ).padding(padding: context.width(16.0).horizontalEdgeInsets),
      ),
    );
  }

  Widget _buildEmptyScreen({required String title, String? gradientTitle, VoidCallback? onGradientTextTap}) {
    return Center(
      child: Column(
        children: [
          context.height(156.0).hMargin,
          Icon(Icons.history_outlined, size: context.width(44.0), color: kWhiteColor),
          context.height(16.0).hMargin,
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: title,
                  style: TextStyle(
                    fontWeight: k500FontWeight,
                    color: kWhiteColor,
                    fontSize: context.width(16.0),
                  ),
                ),
                if (gradientTitle != null)
                  WidgetSpan(
                    child: ShaderMask(
                      shaderCallback: (bounds) => kBlueGradient.createShader(
                        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                      ),
                      child: TextWidget(
                        text: gradientTitle,
                          fontWeight: k500FontWeight,
                          fontSize: 16.0,
                          color: kWhiteColor, // Needed for ShaderMask to work
                          height: 1.0,
                        onTap: onGradientTextTap
                      ),
                    ),
                  ),
              ],
            ),
          )

        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
