import 'package:flutter/material.dart';
import 'package:image_enhancer_app/utils/constant/color.dart';
import 'package:image_enhancer_app/utils/extension/common_extension.dart';

class IcnBtnWidget extends StatelessWidget {
  final String tooltip;
  final VoidCallback onPressed;
  final IconData? icn;
  final String? img;
  final Color color;
  final double size;
  const IcnBtnWidget({super.key, required this.tooltip, this.icn, this.img, required this.onPressed, this.color = kWhiteColor, this.size = 22.0});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        surfaceTintColor: kTransparentColor,
        shape: CircleBorder(),
        color: kTransparentColor,
        child: InkWell(
          onTap: onPressed,
          customBorder: CircleBorder(),
          child: Container(
            margin: context.width(8.0).allEdgeInsets,
            child: icn != null ? Icon(icn, size: context.width(size), color: color) : img != null ? Image.asset(img!, width: context.width(20.0), height: context.width(20.0), color: color) : SizedBox.shrink()
          )
        ),
      ),
    );
  }
}
