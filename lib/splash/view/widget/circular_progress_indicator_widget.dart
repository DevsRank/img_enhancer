import 'package:flutter/material.dart';
import 'package:image_enhancer_app/utils/constant/color.dart';
import 'package:image_enhancer_app/utils/extension/common_extension.dart';
import 'package:image_enhancer_app/utils/extension/widget_extension.dart';

class CircularProgressIndicatorWidget extends StatelessWidget {
  final double? value;
  final double size;
  final double strokeWidth;
  final Color? color;
  final StrokeCap strokeCap;
  final EdgeInsets? padding;

  const CircularProgressIndicatorWidget({
    super.key,
    this.value,
    this.size = 28.0,
    this.strokeWidth = 2.2,
    this.color,
    this.strokeCap = StrokeCap.round,
    this.padding
  });

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      value: value,
      color: color ?? kWhiteColor,
      backgroundColor: kTransparentColor,
      strokeCap: strokeCap,
      padding: padding ?? context.width(6.0).allEdgeInsets,
      strokeWidth: context.width(strokeWidth),
      // strokeAlign: context.width(size),
      constraints: BoxConstraints(
        minWidth: context.width(size),
        minHeight: context.width(size),
        maxWidth: context.width(size),
        maxHeight: context.width(size)
      ),
    ).gradient(
      gradient: color != null
          ? LinearGradient(colors: [color!, color!])
          : kBlueGradient,
    );
  }
}
