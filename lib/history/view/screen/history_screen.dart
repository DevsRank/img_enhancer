import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:image_enhancer_app/create_category/view/widget/medium_heading_widget.dart';
import 'package:image_enhancer_app/create_category/view_model/model/create_category_model.dart';
import 'package:image_enhancer_app/explore/view/widget/toggle_btn_widget.dart';
import 'package:image_enhancer_app/history/view/widget/history_grid_view_widget.dart';
import 'package:image_enhancer_app/history/view_model/bloc/fun_preset_bloc/fun_preset_history_bloc.dart';
import 'package:image_enhancer_app/history/view_model/bloc/img_utils_bloc/img_utils_history_bloc.dart';
import 'package:image_enhancer_app/history/view_model/bloc/magic_remover_bloc/magic_remover_history_bloc.dart';
import 'package:image_enhancer_app/splash/view/widget/circular_progress_indicator_widget.dart';
import 'package:image_enhancer_app/splash/view/widget/text_widget.dart';
import 'package:image_enhancer_app/utils/constant/color.dart';
import 'package:image_enhancer_app/utils/constant/font_weight.dart';
import 'package:image_enhancer_app/utils/constant/image_path.dart';
import 'package:image_enhancer_app/utils/enum/img_type.dart';
import 'package:image_enhancer_app/utils/enum/permission_type.dart';
import 'package:image_enhancer_app/utils/extension/common_extension.dart';
import 'package:image_enhancer_app/utils/extension/navigator_extension.dart';
import 'package:image_enhancer_app/utils/extension/snackbar_extension.dart';
import 'package:image_enhancer_app/utils/extension/widget_extension.dart';
import 'package:image_enhancer_app/utils/typedef/typedef.dart';
import 'package:image_enhancer_app/view_history/view/screen/view_history_screen.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
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

  void _deleteBtnFunction(int index, ValueNotifier<LoadingBtnRecord> btnNotifier) async {

    btnNotifier.value = (isLoading: true, progress: null);

    late List<Map<String, dynamic>> mapList;

    if(_categoryNotifier.value == 0) {
      mapList = [
        ...context.read<ImgUtilsHistoryBloc>().state.dataList,
        ...context.read<MagicRemoverHistoryBloc>().state.dataList,
        ...context.read<FunPresetHistoryBloc>().state.dataList
      ];

    } else if(_categoryNotifier.value == 1) {

      mapList = context.read<ImgUtilsHistoryBloc>().state.dataList;

    } else if(_categoryNotifier.value == 2) {

      mapList = context.read<MagicRemoverHistoryBloc>().state.dataList;

    } else if(_categoryNotifier.value == 3) {

      mapList = context.read<FunPresetHistoryBloc>().state.dataList;

    } else {
      mapList = [];
    }

    if(mapList.isNotEmpty) {

      if(index < context.read<ImgUtilsHistoryBloc>().state.dataList.length) {

        await context.read<ImgUtilsHistoryBloc>().removeValue(index: index);

      } else if(index <= (context.read<ImgUtilsHistoryBloc>().state.dataList.length + context.read<MagicRemoverHistoryBloc>().state.dataList.length) -2) {

        await context.read<MagicRemoverHistoryBloc>().removeValue(index: index);
      } else if(index <= (context.read<ImgUtilsHistoryBloc>().state.dataList.length
          + context.read<MagicRemoverHistoryBloc>().state.dataList.length + context.read<FunPresetHistoryBloc>().state.dataList.length) - 3) {

        await context.read<FunPresetHistoryBloc>().removeValue(index: index);
      }
    }

    btnNotifier.value = (isLoading: false, progress: null);
  }

  void _shareBtnFunction(int index, ValueNotifier<LoadingBtnRecord> btnNotifier) async {
    try {

      btnNotifier.value = (isLoading: true, progress: null);

      late List<Map<String, dynamic>> mapList;

      if(_categoryNotifier.value == 0) {
        mapList = [
          ...context.read<ImgUtilsHistoryBloc>().state.dataList,
          ...context.read<MagicRemoverHistoryBloc>().state.dataList,
          ...context.read<FunPresetHistoryBloc>().state.dataList
        ];
      } else if(_categoryNotifier.value == 1) {

        mapList = context.read<ImgUtilsHistoryBloc>().state.dataList;

      } else if(_categoryNotifier.value == 2) {

        mapList = context.read<MagicRemoverHistoryBloc>().state.dataList;

      } else if(_categoryNotifier.value == 3) {

        mapList = context.read<FunPresetHistoryBloc>().state.dataList;

      } else {
        mapList = [];
      }

      if(await File(mapList[index]["img"] ?? "").exists()) {
        final shareResponse = await SharePlus.instance.share(ShareParams(
            title: "AI Video Generator",
            files: <XFile>[
              XFile(mapList[index]["img"] ?? "")
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

        late List<Map<String, dynamic>> mapList;

        if(_categoryNotifier.value == 0) {
          mapList = [
            ...context.read<ImgUtilsHistoryBloc>().state.dataList,
            ...context.read<MagicRemoverHistoryBloc>().state.dataList,
            ...context.read<FunPresetHistoryBloc>().state.dataList
          ];
        } else if(_categoryNotifier.value == 1) {

          mapList = context.read<ImgUtilsHistoryBloc>().state.dataList;

        } else if(_categoryNotifier.value == 2) {

          mapList = context.read<MagicRemoverHistoryBloc>().state.dataList;

        } else if(_categoryNotifier.value == 3) {

          mapList = context.read<FunPresetHistoryBloc>().state.dataList;

        } else {
          mapList = [];
        }

        if(await File(mapList[index]["img"] ?? "").exists()) {

          final result = await ImageGallerySaverPlus.saveImage(
            await File(mapList[index]["img"] ?? "").readAsBytes(),
            quality: 100,
            name: DateTime.now().microsecondsSinceEpoch.toString(),
          );
          if (result != null && result["isSuccess"]) {
            context.showSnackBar(msg: "Saved successfully");
          } else {
            context.showSnackBar(msg: "Saved unsuccessfully!");
          }

        } else {
          context.showSnackBar(msg: "File lost or not found");
        }

      } else {
        context.showSnackBar(msg: "Storage permission is required");
      }

    } catch (e) {
      e.printResponse(title: "download explore video exception");
    } finally {
      btnNotifier.value = (isLoading: false, progress: null);
    }
  }


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
            ValueListenableBuilder<int>(
              valueListenable: _categoryNotifier,
              builder: (context, value, child) {
                return IndexedStack(
                  index: value,
                  children: [
                    BlocBuilder<ImgUtilsHistoryBloc, ImgUtilsHistoryState>(
                      builder: (context, imgUtilsHistoryState) {
                        return BlocBuilder<MagicRemoverHistoryBloc, MagicRemoverHistoryState>(
                          builder: (context, magicRemoverHistoryState) {
                            return BlocBuilder<FunPresetHistoryBloc, FunPresetHistoryState>(
                              builder: (context, funPresetHistoryState) {
                                if (imgUtilsHistoryState.isLoading || magicRemoverHistoryState.isLoading || funPresetHistoryState.isLoading) {
                                  return const Center(child: CircularProgressIndicatorWidget());
                                } else if (!imgUtilsHistoryState.success || imgUtilsHistoryState.msg.isNotEmpty
                                    || !magicRemoverHistoryState.success || magicRemoverHistoryState.msg.isNotEmpty
                                || !funPresetHistoryState.success || funPresetHistoryState.msg.isNotEmpty || (imgUtilsHistoryState.dataList.isEmpty && magicRemoverHistoryState.dataList.isEmpty && funPresetHistoryState.dataList.isEmpty)) {
                                  return _buildEmptyScreen(title: "You currently don’t have any\n", gradientTitle: "Image.");
                                } else {
                                  return NotificationListener<ScrollNotification>(
                                    onNotification: (ScrollNotification notification) {
                                      if (notification.metrics.pixels >= notification.metrics.maxScrollExtent - 106 && !imgUtilsHistoryState.isLoading
                                          && imgUtilsHistoryState.hasMore) {
                                        context.read<ImgUtilsHistoryBloc>().loadMoreHistory(limit: 5);
                                      }

                                      if (notification.metrics.pixels >= notification.metrics.maxScrollExtent - 106 && !magicRemoverHistoryState.isLoading
                                          && magicRemoverHistoryState.hasMore) {
                                        context.read<MagicRemoverHistoryBloc>().loadMoreHistory(limit: 5);
                                      }

                                      if (notification.metrics.pixels >= notification.metrics.maxScrollExtent - 106 && !funPresetHistoryState.isLoading
                                          && funPresetHistoryState.hasMore) {
                                        context.read<FunPresetHistoryBloc>().loadMoreHistory(limit: 5);
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
                                            data: [
                                              ...imgUtilsHistoryState.dataList,
                                              ...magicRemoverHistoryState.dataList,
                                              ...funPresetHistoryState.dataList,
                                            ],
                                            imgType: ImgType.file,
                                            onDeletePressed: _deleteBtnFunction,
                                            onSharePressed: _shareBtnFunction,
                                            onDownloadPressed: _downloadBtnFunction,
                                            onPressed: (index, tag) => context.push(widget: ViewHistoryScreen(
                                                tag: tag,
                                                categoryModel: CreateCategoryModel(
                                                    img: [
                                                      ...imgUtilsHistoryState.dataList,
                                                      ...magicRemoverHistoryState.dataList,
                                                      ...funPresetHistoryState.dataList,
                                                    ][index]["img"],
                                                    provideImg: [
                                                      ...imgUtilsHistoryState.dataList,
                                                      ...magicRemoverHistoryState.dataList,
                                                      ...funPresetHistoryState.dataList,
                                                    ][index]["provide_img"],
                                                    prompt: [
                                                      ...imgUtilsHistoryState.dataList,
                                                      ...magicRemoverHistoryState.dataList,
                                                      ...funPresetHistoryState.dataList,
                                                    ][index]["prompt"],
                                                    firstOptionIndex: [
                                                      ...imgUtilsHistoryState.dataList,
                                                      ...magicRemoverHistoryState.dataList,
                                                      ...funPresetHistoryState.dataList,
                                                    ][index]["first_attribute_index"]
                                                )
                                            )
                                            ),
                                          ),
                                          if (imgUtilsHistoryState.isLoading)
                                            Center(child: CircularProgressIndicatorWidget()).padding(padding: context.height(16.0).verticalEdgeInsets),
                                          context.height(16.0).hMargin,
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              },
                            );
                          },
                        );
                      },
                    ),
                    BlocBuilder<ImgUtilsHistoryBloc, ImgUtilsHistoryState>(
                      builder: (context, imgUtilsHistoryState) {
                        if (imgUtilsHistoryState.isLoading) {
                          return const Center(child: CircularProgressIndicatorWidget());
                        } else if (!imgUtilsHistoryState.success || imgUtilsHistoryState.dataList.isEmpty || imgUtilsHistoryState.msg.isNotEmpty) {
                          return _buildEmptyScreen(title: "You currently don’t have any\n", gradientTitle: "Image.");
                        } else {
                          return NotificationListener<ScrollNotification>(
                            onNotification: (ScrollNotification notification) {
                              if (notification.metrics.pixels >= notification.metrics.maxScrollExtent - 106 && !imgUtilsHistoryState.isLoading
                                  && imgUtilsHistoryState.hasMore) {
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
                                    data: imgUtilsHistoryState.dataList,
                                    imgType: ImgType.file,
                                    onDeletePressed: _deleteBtnFunction,
                                    onSharePressed: _shareBtnFunction,
                                    onDownloadPressed: _downloadBtnFunction,
                                    onPressed: (index, tag) => context.push(widget: ViewHistoryScreen(
                                        tag: tag,
                                        categoryModel: CreateCategoryModel(
                                            img: imgUtilsHistoryState.dataList[index]["img"],
                                            provideImg: imgUtilsHistoryState.dataList[index]["provide_img"],
                                          prompt: imgUtilsHistoryState.dataList[index]["prompt"],
                                          firstOptionIndex: imgUtilsHistoryState.dataList[index]["first_attribute_index"]
                                        )
                                    )
                                    ),
                                  ),
                                  if (imgUtilsHistoryState.isLoading)
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
                      builder: (context, magicRemoverHistoryState) {
                        if (magicRemoverHistoryState.isLoading) {
                          return const Center(child: CircularProgressIndicatorWidget());
                        } else if (!magicRemoverHistoryState.success || magicRemoverHistoryState.dataList.isEmpty || magicRemoverHistoryState.msg.isNotEmpty) {
                          return _buildEmptyScreen(title: "You currently don’t have any\n", gradientTitle: "Image.");
                        } else {
                          return NotificationListener<ScrollNotification>(
                            onNotification: (ScrollNotification notification) {
                              if (notification.metrics.pixels >= notification.metrics.maxScrollExtent - 106 && !magicRemoverHistoryState.isLoading
                                  && magicRemoverHistoryState.hasMore) {
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
                                    data: magicRemoverHistoryState.dataList,
                                    imgType: ImgType.file,
                                    onDeletePressed: _deleteBtnFunction,
                                    onSharePressed: _shareBtnFunction,
                                    onDownloadPressed: _downloadBtnFunction,
                                    onPressed: (index, tag) => context.push(widget: ViewHistoryScreen(
                                        tag: tag,
                                        categoryModel: CreateCategoryModel(
                                            img: magicRemoverHistoryState.dataList[index]["img"],
                                            provideImg: magicRemoverHistoryState.dataList[index]["provide_img"],
                                            prompt: magicRemoverHistoryState.dataList[index]["prompt"],
                                            firstOptionIndex: magicRemoverHistoryState.dataList[index]["first_attribute_index"]
                                        )
                                    )
                                    ),                              ),
                                  if (magicRemoverHistoryState.isLoading)
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
                      builder: (context, funPresetHistoryState) {
                        if (funPresetHistoryState.isLoading) {
                          return const Center(child: CircularProgressIndicatorWidget());
                        } else if (!funPresetHistoryState.success || funPresetHistoryState.dataList.isEmpty || funPresetHistoryState.msg.isNotEmpty) {
                          return _buildEmptyScreen(title: "You currently don’t have any\n", gradientTitle: "Image.");
                        } else {
                          return NotificationListener<ScrollNotification>(
                            onNotification: (ScrollNotification notification) {
                              if (notification.metrics.pixels >= notification.metrics.maxScrollExtent - 106 && !funPresetHistoryState.isLoading
                                  && funPresetHistoryState.hasMore) {
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
                                    data: funPresetHistoryState.dataList,
                                    imgType: ImgType.file,
                                    onDeletePressed: _deleteBtnFunction,
                                    onSharePressed: _shareBtnFunction,
                                    onDownloadPressed: _downloadBtnFunction,
                                    onPressed: (index, tag) => context.push(widget: ViewHistoryScreen(
                                        tag: tag,
                                        categoryModel: CreateCategoryModel(
                                            img: funPresetHistoryState.dataList[index]["img"],
                                            provideImg: funPresetHistoryState.dataList[index]["provide_img"],
                                            prompt: funPresetHistoryState.dataList[index]["prompt"],
                                            firstOptionIndex: funPresetHistoryState.dataList[index]["first_attribute_index"]
                                        )
                                    )
                                    ),                              ),
                                  if (funPresetHistoryState.isLoading)
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
                );
              }
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
