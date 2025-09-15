import 'package:flutter/material.dart';
import 'package:image_enhancer_app/splash/view/widget/text_widget.dart';
import 'package:image_enhancer_app/utils/constant/color.dart';
import 'package:image_enhancer_app/utils/constant/font_weight.dart';
import 'package:image_enhancer_app/utils/constant/padding.dart';
import 'package:image_enhancer_app/utils/extension/common_extension.dart';
import 'package:image_enhancer_app/utils/extension/widget_extension.dart';

class MediumHeadingWidget extends StatelessWidget {
  final String title;
  final Widget? action;
  final VoidCallback? onPressed;
  const MediumHeadingWidget({
    super.key,
    required this.title,
     this.action,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: TextWidget(text: title,
            fontSize: 20.0,
          fontWeight: k500FontWeight)),
        if(action != null) action!
          else if(onPressed != null) MaterialButton(
            padding: kZeroEdgeInsets,
            shape: RoundedRectangleBorder(
                borderRadius: context.width(100.0).borderRadius
            ),
            height: 10.0,
            minWidth: .0,
            onPressed: onPressed,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                2.0.wMargin,
                TextWidget(text: "See All", color: kWhiteColor, fontSize: 12.0, fontWeight: k300FontWeight, gradient: kBlueGradient),
                4.0.wMargin,
                Icon(Icons.arrow_forward_ios_sharp, size: context.width(14.0), color: kWhiteColor).gradient(gradient: kBlueGradient)
              ],
            )
        )
      ],
    );
  }
}
