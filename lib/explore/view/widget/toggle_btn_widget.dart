
import 'package:flutter/material.dart';
import 'package:image_enhancer_app/create_category/view/widget/img_widget.dart';
import 'package:image_enhancer_app/splash/view/widget/text_widget.dart';
import 'package:image_enhancer_app/utils/constant/color.dart';
import 'package:image_enhancer_app/utils/constant/font_weight.dart';
import 'package:image_enhancer_app/utils/constant/padding.dart';
import 'package:image_enhancer_app/utils/enum/img_type.dart';
import 'package:image_enhancer_app/utils/extension/common_extension.dart';
import 'package:image_enhancer_app/utils/extension/widget_extension.dart';

class ToggleBtnWidget extends StatelessWidget {
  const ToggleBtnWidget({
    super.key,
    required this.optionList,
    this.scrollController,
    required this.onPressed
  });

  final void Function(int index) onPressed;
  final List<Map<String, dynamic>> optionList;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<int> valueNotifier = ValueNotifier(0);
    return Container(
      padding: context.width(4.0).allEdgeInsets,
      height: context.width(46.0),
      decoration: BoxDecoration(
        color: kGrey2Color,
        border: Border.all(
          color: kWhiteColor,
          width: context.width(.4)
        ),
        borderRadius: context.width(100.0).borderRadius
      ),
      child: ClipRRect(
        borderRadius: context.width(100.0).borderRadius,
        child: SingleChildScrollView(
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          child: ValueListenableBuilder(
            valueListenable: valueNotifier,
            builder: (context, value, child) {
              return ListView.separated(
                shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: optionList.length,
                  separatorBuilder: (context, index) => SizedBox.shrink(),
                  itemBuilder: (context, index) {
                    return Tooltip(
                      message: optionList[index]["title"],
                      child: AnimatedContainer(
                        duration: 200.millisecond,
                        curve: Curves.decelerate,
                        decoration: BoxDecoration(
                            color: index != value
                                ? kTransparentColor
                                : kWhiteColor,
                            gradient: kBlueGradient,
                            // border: Border.all(color: selectedIndex == index ? Colors.blueAccent : Colors.transparent, width: .7),
                            borderRadius: context.width(100.0).borderRadius
                        ),
                        alignment: Alignment.center,
                        child: Material(
                          color: kTransparentColor,
                          borderRadius: context.width(100.0).borderRadius,
                          child: InkWell(
                            borderRadius: context.width(100.0).borderRadius,
                            onTap: () {
                              valueNotifier.value = index;
                              onPressed(index);
                              },
                            child: AnimatedContainer(
                              duration: 200.millisecond,
                              height: double.maxFinite,
                              padding: context.width(16.0).horizontalEdgeInsets,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ImgWidget(
                                      imgType: ImgType.asset, img: optionList[index]["img"] ?? "",
                                      width: context.width(18.0),
                                      height: context.width(18.0),
                                    color: index != value ? kGreyColor : kWhiteColor,
                                  ),
                                  context.width(6.0).wMargin,
                                  TextWidget(
                                    text: optionList[index]["title"],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    color: index != value ? kGreyColor : kWhiteColor,
                                    fontWeight: k500FontWeight,
                                    fontSize: 12.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),),
                    );
                  }
              );
            }
          ),
        ),
      ),
    );
  }
}
