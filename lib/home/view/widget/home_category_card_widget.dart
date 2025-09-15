
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_enhancer_app/create_category/view/widget/img_widget.dart';
import 'package:image_enhancer_app/splash/view/widget/text_widget.dart';
import 'package:image_enhancer_app/utils/constant/alignment.dart';
import 'package:image_enhancer_app/utils/constant/color.dart';
import 'package:image_enhancer_app/utils/constant/font_weight.dart';
import 'package:image_enhancer_app/utils/enum/img_type.dart';
import 'package:image_enhancer_app/utils/extension/common_extension.dart';
import 'package:image_enhancer_app/utils/extension/widget_extension.dart';

class HomeCategoryCardWidget extends StatelessWidget {
  final String img;
  final String title;
  final String subTitle;
  final VoidCallback? onPressed;
  const HomeCategoryCardWidget({super.key, required this.img, required this.title, required this.subTitle, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<double> scaleNotifier = ValueNotifier(1.0);
    return ValueListenableBuilder<double>(
      valueListenable: scaleNotifier,
      builder: (context, value, child) {
        return AnimatedScale(
          scale: value,
          duration: 100.millisecond,
          child: Container(
            decoration: BoxDecoration(
              color: kGrey3Color,
              borderRadius: context.width(32.0).borderRadius
            ),
            child: Material(
              color: kTransparentColor,
                borderRadius: context.width(32.0).borderRadius,
                child: InkWell(
            borderRadius: context.width(32.0).borderRadius,
                  onTapDown: (details) => scaleNotifier.value = 0.98,
                  onTapUp: (details) {
                    scaleNotifier.value = 1.0;
                  },
                  onTapCancel: () => scaleNotifier.value = 1.0,
                  onTap: () {
                    if(onPressed != null) onPressed!();
                  },
                child: Column(
                  crossAxisAlignment: kStartCrossAxisAlignment,
                  children: [
                    Container(
                      padding: context.width(2.6).bottomEdgeInsets,
                      decoration: BoxDecoration(
                        gradient: kBlueGradient,
                        borderRadius: context.width(32.0).borderRadius.copyWith(
                            bottomLeft: context.width(26.0).radius,
                            bottomRight: context.width(26.0).radius
                        )
                      ),
                        child: ImgWidget(imgType: ImgType.asset, img: img, width: double.maxFinite, borderRadius: context.width(32.0).borderRadius.copyWith(
                          bottomLeft: context.width(24.0).radius,
                          bottomRight: context.width(24.0).radius
                        ))),
                    context.width(8.0).hMargin,
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: kStartCrossAxisAlignment,
                            children: [
                              TextWidget(text: title, gradient: kBlueGradient, fontSize: 18.0, fontWeight: k500FontWeight),
                              TextWidget(text: subTitle, fontSize: 12.0)
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: kBlueGradient
                          ),
                          child: Material(
                            color: kTransparentColor,
                            borderRadius: context.width(100.0).borderRadius,
                            child: InkWell(
                              borderRadius: context.width(100.0).borderRadius,
                              onTap: () {
                                if(onPressed != null) onPressed!();
                              },
                              child: Icon(CupertinoIcons.arrow_up_right, color: kWhiteColor, size: context.width(26.0)).padding(padding: context.width(12.0).allEdgeInsets),
                            ),
                          ),
                        )
                      ],
                    ).padding(padding: context.width(16.0).horizontalEdgeInsets),
                    context.width(10.0).hMargin
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}
