
import 'package:flutter/material.dart';
import 'package:image_enhancer_app/create_category/view/widget/img_widget.dart';
import 'package:image_enhancer_app/explore/view/widget/pop_up_menu_item_widget.dart';
import 'package:image_enhancer_app/splash/view/widget/circular_progress_indicator_widget.dart';
import 'package:image_enhancer_app/utils/constant/color.dart';
import 'package:image_enhancer_app/utils/constant/padding.dart';
import 'package:image_enhancer_app/utils/enum/img_type.dart';
import 'package:image_enhancer_app/utils/extension/common_extension.dart';
import 'package:image_enhancer_app/utils/typedef/typedef.dart';

class HistoryGridViewWidget extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  final ImgType imgType;
  final Function(int index, dynamic tag)? onPressed;
  final Function(int index, ValueNotifier<({bool isLoading, double? progress})> valueNotifier)? onDeletePressed;
  final Function(int index, ValueNotifier<({bool isLoading, double? progress})> valueNotifier)? onSharePressed;
  final Function(int index, ValueNotifier<({bool isLoading, double? progress})> valueNotifier)? onDownloadPressed;

  const HistoryGridViewWidget({
    super.key,
    required this.data,
    required this.imgType,
    this.onPressed,
    this.onDeletePressed,
    this.onSharePressed,
    this.onDownloadPressed
  });

  @override
  State<HistoryGridViewWidget> createState() => _HistoryGridViewWidgetState();
}

class _HistoryGridViewWidgetState extends State<HistoryGridViewWidget> {

  final ValueNotifier<int> valueNotifier = ValueNotifier(-1);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: widget.data.length,
        padding: kZeroEdgeInsets,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Adjust as needed
            mainAxisSpacing: context.width(16.0),
            crossAxisSpacing: context.width(16.0),
            childAspectRatio: 1
        ),
        itemBuilder: (context, index) {
          final ValueNotifier<double> scaleNotifier = ValueNotifier(1.0);
          final ValueNotifier<LoadingBtnRecord> btnNotifier = ValueNotifier((isLoading: false, progress: null));
          final tag = DateTime.now().microsecondsSinceEpoch;
          return ValueListenableBuilder<double>(
              valueListenable: scaleNotifier,
              builder: (context, value, child) {
                return AnimatedScale(
                    scale: value,
                    duration: 100.millisecond,
                    child: ValueListenableBuilder<int>(
                      valueListenable: valueNotifier,
                      builder: (context, selectedIndex, child) {
                        return Card(
                            surfaceTintColor: kWhiteColor,
                            margin: kZeroEdgeInsets,
                            color: kWhiteColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: context.width(16.0).borderRadius,
                                side: BorderSide.none
                                // side: index != selectedIndex
                                //     ? BorderSide.none
                                //     : BorderSide(color: kBlueColor, width: context.width(1.2))
                            ),
                            child: AnimatedContainer(
                              duration: 200.millisecond,
                              padding: index != selectedIndex ? kZeroEdgeInsets : context.width(1.2).allEdgeInsets,
                              decoration: BoxDecoration(
                                gradient: kBlueGradient,
                                borderRadius: context.width(16.0).borderRadius
                              ),
                              child: Stack(
                                children: [
                                  Material(
                                      color: kTransparentColor,
                                      borderRadius: context.width(16.0).borderRadius,
                                      child: InkWell(
                                          borderRadius: context.width(16.0).borderRadius,
                                          onTapDown: (details) => scaleNotifier.value = 0.98,
                                          onTapUp: (details) {
                                            scaleNotifier.value = 1.0;
                                            valueNotifier.value = index;
                                          },
                                          onTapCancel: () => scaleNotifier.value = 1.0,
                                          onTap: () {
                                            valueNotifier.value = index;
                                            if(widget.onPressed != null) widget.onPressed!(index, tag);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: kGrey2Color,
                                              borderRadius: context.width(16.0).borderRadius,
                                            ),
                                            alignment: Alignment.center,
                                            child: widget.imgType != ImgType.none
                                                ? Hero(
                                                tag: tag,
                                                child: ImgWidget(imgType: widget.imgType, img: widget.data[index]["img"] ?? "",
                                                    width: double.maxFinite, height: double.maxFinite,
                                                    borderRadius: context.width(16.0).borderRadius)
                                            )
                                                : Icon(Icons.image_not_supported_outlined,
                                                size: context.width(24.0)),
                                          )
                                      )
                                  ),
                                  Positioned(
                                      top: 8.0,
                                      right: 8.0,
                                      child: Container(
                                        height: context.width(28.0),
                                        width: context.width(28.0),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: kBlackColor.withOpacity(.2),
                                        ),
                                        child: ValueListenableBuilder(
                                          valueListenable: btnNotifier,
                                          builder: (context, value, child) {
                                            return value.isLoading ? CircularProgressIndicatorWidget(
                                              value: value.progress
                                            ) : PopupMenuButton<int>(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: context.width(8.0).borderRadius
                                              ),
                                              color: Colors.grey[850],
                                              iconSize: context.width(22.0),
                                              padding: kZeroEdgeInsets,
                                              icon: Icon(Icons.more_vert, color: kWhiteColor, size: context.width(22.0)),
                                              tooltip: "More",
                                              onSelected: (int value) async {
                                                switch (value) {
                                                  case 0:
                                                    if(widget.onDeletePressed != null) widget.onDeletePressed!(index, btnNotifier);
                                                    break;
                                                    case 1:
                                                      if(widget.onSharePressed != null) widget.onSharePressed!(index, btnNotifier);
                                                      break;
                                                      case 2:
                                                      if(widget.onDownloadPressed != null) widget.onDownloadPressed!(index, btnNotifier);
                                                      break;
                                                }
                                              },
                                              itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                                                PopUpMenuItemWidget.build(context: context, value: 0, title: "Delete", icn: Icons.delete_forever_outlined, color: Colors.red, displayDivider: true),
                                                PopUpMenuItemWidget.build(context: context, value: 1, title: "Share", icn: Icons.share_outlined, displayDivider: true),
                                                PopUpMenuItemWidget.build(context: context, value: 2, title: "Download", icn: Icons.save_alt_outlined)
                                              ],
                                            );
                                          }
                                        ),
                                      ))
                                ],
                              ),
                            )
                        );
                      }
                    )
                );
              }
          );
        }
    );
  }
}