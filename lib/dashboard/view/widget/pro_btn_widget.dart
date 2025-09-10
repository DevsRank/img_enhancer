import 'package:flutter/material.dart';
import 'package:image_enhancer_app/create_category/view/widget/img_widget.dart';
import 'package:image_enhancer_app/splash/view/widget/text_widget.dart';
import 'package:image_enhancer_app/utils/constant/alignment.dart';
import 'package:image_enhancer_app/utils/constant/color.dart';
import 'package:image_enhancer_app/utils/constant/font_weight.dart';
import 'package:image_enhancer_app/utils/constant/image_path.dart';
import 'package:image_enhancer_app/utils/constant/padding.dart';
import 'package:image_enhancer_app/utils/enum/img_type.dart';
import 'package:image_enhancer_app/utils/extension/common_extension.dart';
import 'package:image_enhancer_app/utils/extension/widget_extension.dart';
import 'package:zo_animated_border/widget/zo_glow_edge_border.dart';

class ProBtnWidget extends StatelessWidget {
  final VoidCallback onPressed;
  const ProBtnWidget({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: "Premium Subscription",
      child: ZoGlowingEdgeBorder(
        gradientColors: kBlueGradient.colors,
        borderWidth: context.width(2.0),
        borderRadius: context.width(100.0),
        edgeLength: context.width(46.0),
        child: MaterialButton(
          color: kWhiteColor,
          height: .0,
          padding: kZeroEdgeInsets,
          elevation: .2,
          minWidth: .0,
          shape: RoundedRectangleBorder(
            borderRadius: context.width(100.0).borderRadius
          ),
          onPressed: onPressed,
          child: Ink(
            padding: EdgeInsets.symmetric(horizontal: context.width(14.0), vertical: context.width(10.0)),
            decoration: BoxDecoration(
              color: kWhiteColor,
              gradient: kBlueGradient,
              borderRadius: context.width(100.0).borderRadius
            ),
            child: Row(
              mainAxisSize: kMinMainAxisSize,
              mainAxisAlignment: kCenterMainAxisAlignment,
              children: [
                ImgWidget(imgType: ImgType.asset, img: kCrownIcnPath, width: context.width(16.0)),
                context.width(6.0).wMargin,
                Flexible(
                  child: TextWidget(
                    text:
                    "PRO",
                        fontSize: 12.0,
                        fontWeight: kBoldFontWeight,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis
                  ),
                )
              ],
            ),
          ),
            ),
      ),
    );
  }
}
