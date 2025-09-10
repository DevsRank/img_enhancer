import 'package:flutter/material.dart';
import 'package:image_enhancer_app/utils/constant/color.dart';
import 'package:image_enhancer_app/utils/constant/font_weight.dart';
import 'package:image_enhancer_app/utils/extension/common_extension.dart';
import 'package:image_enhancer_app/utils/extension/widget_extension.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final Color color;
  final Gradient? gradient;
  final double fontSize;
  final FontWeight fontWeight;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final double? height;
  final TextDecoration? decoration;
  final FontStyle? fontStyle;
  final VoidCallback? onTap;
  
  const TextWidget({
    super.key,
    required this.text,
    this.color = kWhiteColor,
    this.gradient,
    this.fontSize = 14.0,
    this.fontWeight = k400FontWeight,
    this.maxLines,
    this.overflow,
    this.height,
    this.textAlign,
    this.decoration,
    this.fontStyle,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: gradient != null ? Text(
          text,
          maxLines: maxLines,
          overflow: overflow,
          textAlign: textAlign,
          style: TextStyle(
        color: color,
        height: height,
        fontSize: context.fontSize(fontSize.toDouble()),
        fontWeight: fontWeight,
            decoration: decoration,
            fontStyle: fontStyle,
            decorationColor: color
      )).gradient(gradient: gradient!) : Text(
          text,
          maxLines: maxLines,
          overflow: overflow,
          textAlign: textAlign,
          style: TextStyle(
              color: color,
              height: height,
              fontSize: context.fontSize(fontSize.toDouble()),
              fontWeight: fontWeight,
              decoration: decoration,
              fontStyle: fontStyle,
              decorationColor: color
          )),
    );
  }
}
