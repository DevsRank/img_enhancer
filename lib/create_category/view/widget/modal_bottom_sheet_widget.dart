
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_enhancer_app/utils/constant/color.dart';
import 'package:image_enhancer_app/utils/extension/common_extension.dart';

class ModalBottomSheetWidget {
  static Future<void> show({
    required BuildContext context,
    required Widget child,
    bool isDismissible = true}) async {
    await showModalBottomSheet(
      context: context,
      isDismissible: isDismissible,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: kTransparentColor,
      isScrollControlled: true,
      constraints: BoxConstraints(
        minWidth: double.maxFinite
      ),
      builder: (_) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
            child: Container(
              margin: context.height(100.0).topEdgeInsets,
              padding: context.width(2.2).topEdgeInsets,
              decoration: BoxDecoration(
                  gradient: kBlueGradient,
                  borderRadius: context.width(18.0).borderRadius.copyWith(
                      bottomLeft: Radius.zero,
                      bottomRight: Radius.zero
                  )
              ),
              child: Container(
                  decoration: BoxDecoration(
                    color: kBlack2Color,
                    borderRadius: context.width(16.0).borderRadius.copyWith(bottomLeft: Radius.zero, bottomRight: Radius.zero)
                  ),
                  child: child),
            ),
        );
      },
    );
  }
}