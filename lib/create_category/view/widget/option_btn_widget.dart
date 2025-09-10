import 'package:flutter/material.dart';
import 'package:image_enhancer_app/splash/view/widget/text_widget.dart';
import 'package:image_enhancer_app/utils/constant/color.dart';
import 'package:image_enhancer_app/utils/constant/padding.dart';
import 'package:image_enhancer_app/utils/extension/common_extension.dart';
import 'package:image_enhancer_app/utils/extension/widget_extension.dart';

class OptionBtnWidget extends StatelessWidget {
  final String tooltip;
  final String text;
  final IconData? icn;
  final String? img;
  final Color? bkgColor;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final double? textSize;
  final double? icnImgSize;
  final VoidCallback? onPressed;
  const OptionBtnWidget({super.key, this.tooltip = "", required this.text, this.icn, this.img, this.bkgColor, this.borderRadius, this.padding, this.textSize, this.icnImgSize, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.width(30.0),
      child: Tooltip(
        message: tooltip,
        child: MaterialButton(
            padding: kZeroEdgeInsets,
            color: bkgColor ?? kBlackColor,
            elevation: .0,
            minWidth: .0,
            shape: RoundedRectangleBorder(
                borderRadius: context.width(100.0).borderRadius,
                side: BorderSide(color: kWhiteColor, width: context.width(.16))
            ),
            onPressed: onPressed,
            child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if(img != null) Image.asset(img!, width: context.width(icnImgSize ?? 12.0), height: context.width(icnImgSize ?? 12.0), color: kWhiteColor)
                  else if(icn != null) Icon(icn!, size: context.width(icnImgSize ?? 12.0), color: kWhiteColor),
                  if(text.isNotEmpty && icn != null || img != null) context.width(6.0).wMargin,
                  TextWidget(text: text, fontSize: textSize ?? 12.0)
                ]).padding(padding: padding ?? context.width(8.0).horizontalEdgeInsets)),
      ),
    );
  }
}
