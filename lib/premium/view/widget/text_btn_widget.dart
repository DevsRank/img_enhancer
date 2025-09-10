import 'package:flutter/material.dart';
import 'package:image_enhancer_app/splash/view/widget/text_widget.dart';
import 'package:image_enhancer_app/utils/constant/color.dart';
import 'package:image_enhancer_app/utils/extension/common_extension.dart';
import 'package:image_enhancer_app/utils/extension/widget_extension.dart';

class TextBtnWidget extends StatelessWidget {
  final String tooltip;
  final String text;
  final double fontSize;
  final Color textColor;
  final Color bkgColor;
  final TextDecoration? decoration;
  final VoidCallback? onPressed;
  const TextBtnWidget({super.key, required this.tooltip, required this.text, this.fontSize = 14.0, this.onPressed, this.textColor = kWhiteColor, this.bkgColor = kTransparentColor, this.decoration});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> hoverNotifier = ValueNotifier<bool>(false);
    return Container(
      decoration: BoxDecoration(
        color: bkgColor
      ),
      child: Tooltip(
        message: tooltip,
        child: Material(
          color: kTransparentColor,
          borderRadius: context.width(100.0).borderRadius,
          child: InkWell(
            borderRadius: context.width(100.0).borderRadius,
            splashColor: kSplashColor,
            onHover: (value) => hoverNotifier.value = value,
           onTap: onPressed,
           child: ValueListenableBuilder<bool>(
             valueListenable: hoverNotifier,
             builder: (context, value, _) {
               return TextWidget(text: text, color: value ? kBlueColor : textColor,
               decoration: decoration,
               fontSize: fontSize,
               ).padding(padding: EdgeInsets.symmetric(horizontal: context.width(4.0), vertical: context.width(2.0)));
             }
           ),
          )
        ),
      ),
    );
  }
}
