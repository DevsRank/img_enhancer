import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_enhancer_app/create_category/view/widget/img_widget.dart';
import 'package:image_enhancer_app/splash/view/widget/text_widget.dart';
import 'package:image_enhancer_app/utils/constant/alignment.dart';
import 'package:image_enhancer_app/utils/constant/color.dart';
import 'package:image_enhancer_app/utils/constant/font_weight.dart';
import 'package:image_enhancer_app/utils/constant/padding.dart';
import 'package:image_enhancer_app/utils/enum/img_type.dart';
import 'package:image_enhancer_app/utils/extension/common_extension.dart';
import 'package:image_enhancer_app/utils/extension/widget_extension.dart';

class SubCategoryGridViewWidget extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final Function(int index)? onPressed;
  const SubCategoryGridViewWidget({super.key, required this.data, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: data.length,
      shrinkWrap: true,
      padding: kZeroEdgeInsets,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        mainAxisSpacing: context.width(16.0),
        crossAxisSpacing: context.width(16.0),
        childAspectRatio: .77
      ),
      itemBuilder: (context, index) {
        final ValueNotifier<double> scaleNotifier = ValueNotifier(1.0);
        return ValueListenableBuilder<double>(
          valueListenable: scaleNotifier,
          builder: (context, value, child) {
            return AnimatedScale(
              scale: value,
              duration: 100.millisecond,
              child: Card(
                margin: kZeroEdgeInsets,
                shape: RoundedRectangleBorder(
                    borderRadius: context.width(24.0).borderRadius
                ),
                child: Container(
                  decoration: BoxDecoration(
                      color: kGrey3Color,
                      borderRadius: context.width(24.0).borderRadius
                  ),
                  child: Material(
                    color: kTransparentColor,
                    borderRadius: context.width(24.0).borderRadius,
                    child: InkWell(
                      borderRadius: context.width(24.0).borderRadius,
                      onTapDown: (details) => scaleNotifier.value = 0.98,
                      onTapUp: (details) {
                        scaleNotifier.value = 1.0;
                      },
                      onTapCancel: () => scaleNotifier.value = 1.0,
                      onTap: () {
                        if(onPressed != null) onPressed!(index);
                      },
                      child: Column(
                        crossAxisAlignment: kStartCrossAxisAlignment,
                        children: [
                          Container(
                              padding: context.width(2.6).bottomEdgeInsets,
                              decoration: BoxDecoration(
                                  gradient: kBlueGradient,
                                  borderRadius: context.width(24.0).borderRadius.copyWith(
                                      bottomLeft: context.width(26.0).radius,
                                      bottomRight: context.width(26.0).radius
                                  )
                              ),
                              child: ImgWidget(
                                  imgType: ImgType.asset,
                                  img: data[index]["img"] ?? "",
                                  width: double.maxFinite,
                                  height: context.width(126.0),
                                  fit: BoxFit.cover,
                                  borderRadius: context.width(24.0).borderRadius.copyWith(
                                  bottomLeft: context.width(24.0).radius,
                                  bottomRight: context.width(24.0).radius
                              ))),
                          context.width(8.0).hMargin,
                          Column(
                            crossAxisAlignment: kStartCrossAxisAlignment,
                            children: [
                              TextWidget(text: data[index]["title"] ?? "", gradient: kBlueGradient,
                                  maxLines: 1, overflow: TextOverflow.ellipsis,
                                  fontSize: 12.8, fontWeight: k500FontWeight),
                              TextWidget(text: data[index]["sub_title"] ?? "", fontSize: 10.0, maxLines: 2, overflow: TextOverflow.ellipsis)
                            ],
                          ).padding(padding: context.width(10.0).horizontalEdgeInsets),
                          context.width(8.0).hMargin
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        );
      }
    );
  }
}
