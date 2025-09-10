import 'package:flutter/material.dart';

extension SizedBoxExtension on num {
  SizedBox get hMargin => SizedBox(height: toDouble());
  SizedBox get wMargin => SizedBox(width: toDouble());
}

extension PadddingExtension on Widget {
  Widget padding({Key? key, required EdgeInsets padding}) => Padding(key: key, padding: padding, child: this);
}

extension ShadderedMaskExtension on Widget {
  Widget gradient({required Gradient gradient}) => ShaderMask(shaderCallback: (bounds) => gradient.createShader(bounds), child: this);
}

extension ClipRRectExtension on Widget {
  Widget clipRRect({required BorderRadius borderRadius}) => ClipRRect(borderRadius: borderRadius, child: this);
}

extension SizedWidgetExtension on Widget {
  Widget sized({double? width, double? height, double maxWidth = double.maxFinite, double maxHeight = double.maxFinite}) => Container(width: width, height: height, constraints: BoxConstraints(maxWidth: maxWidth, maxHeight: maxHeight), child: this);
}