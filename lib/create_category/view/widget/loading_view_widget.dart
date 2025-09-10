import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_enhancer_app/create_category/view/widget/img_widget.dart';
import 'package:image_enhancer_app/splash/view/widget/circular_progress_indicator_widget.dart';
import 'package:image_enhancer_app/splash/view/widget/text_widget.dart';
import 'package:image_enhancer_app/utils/constant/alignment.dart';
import 'package:image_enhancer_app/utils/constant/color.dart';
import 'package:image_enhancer_app/utils/constant/font_weight.dart';
import 'package:image_enhancer_app/utils/constant/image_path.dart';
import 'package:image_enhancer_app/utils/constant/padding.dart';
import 'package:image_enhancer_app/utils/enum/img_type.dart';
import 'package:image_enhancer_app/utils/extension/common_extension.dart';
import 'package:image_enhancer_app/utils/extension/widget_extension.dart';

class LoadingViewWidget extends StatelessWidget {
  final String? title;
  const LoadingViewWidget({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Dialog(
        shadowColor: kTransparentColor,
        surfaceTintColor: kTransparentColor,
        backgroundColor: kTransparentColor,
        insetPadding: kZeroEdgeInsets,
        alignment: Alignment.center,
        shape: const RoundedRectangleBorder(),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
          child: Container(
            width: double.maxFinite,
            height: double.maxFinite,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: kCenterMainAxisAlignment,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    const Center(
                      child: CircularProgressIndicatorWidget(
                        size: 80.0,
                        strokeWidth: 4.4
                      ),
                    ),
                    Center(
                      child: ImgWidget(
                        imgType: ImgType.asset,
                        img: kAppIcnPath,
                        width: context.width(46.0),
                        height: context.width(46.0),
                        borderRadius: context.width(100.0).borderRadius
                      ),
                    ),
                  ],
                ),
                context.height(16.0).hMargin,
                _AnimatedDotsText(
                  baseText: title ?? "Generating Video",
                  fontWeight: kBoldFontWeight,
                  fontSize: 16.0,
                  color: kWhiteColor,
                )
                    .gradient(gradient: kBlueGradient)
              ]
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedDotsText extends StatefulWidget {
  final String baseText;
  final FontWeight fontWeight;
  final double fontSize;
  final Color color;

  const _AnimatedDotsText({
    required this.baseText,
    required this.fontWeight,
    required this.fontSize,
    required this.color,
  });

  @override
  State<_AnimatedDotsText> createState() => _AnimatedDotsTextState();
}

class _AnimatedDotsTextState extends State<_AnimatedDotsText>
    with SingleTickerProviderStateMixin {
  late final Timer _timer;
  int _dotCount = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      setState(() {
        _dotCount = (_dotCount + 1) % 4; // cycles 0 → 1 → 2 → 3 → 0
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextWidget(
      text: "${widget.baseText}${"." * _dotCount}",
      fontWeight: widget.fontWeight,
      fontSize: widget.fontSize,
      color: widget.color,
    );
  }
}
