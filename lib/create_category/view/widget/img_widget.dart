

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_enhancer_app/splash/view/widget/circular_progress_indicator_widget.dart';
import 'package:image_enhancer_app/splash/view/widget/text_widget.dart';
import 'package:image_enhancer_app/utils/constant/color.dart';
import 'package:image_enhancer_app/utils/enum/img_type.dart';
import 'package:image_enhancer_app/utils/extension/common_extension.dart';
import 'package:image_enhancer_app/utils/extension/widget_extension.dart';

class ImgWidget extends StatefulWidget {
  final ImgType imgType;
  final String img;
  final Color? color;
  final BorderRadius borderRadius;
  final BoxFit fit;
  final double? width;
  final double? height;
  final bool isInTerActive;
  const ImgWidget({super.key, required this.imgType, required this.img, this.color, this.borderRadius = BorderRadius.zero, this.fit = BoxFit.cover, this.width, this.height, this.isInTerActive = false});

  @override
  State<ImgWidget> createState() => _ImgWidgetState();
}

class _ImgWidgetState extends State<ImgWidget> {

  final ValueNotifier<Uint8List?> _valueNotifier = ValueNotifier(null);

  void _initFunction() {
    if (widget.imgType == ImgType.memory) {
      try {
            if (widget.img.trim().isNotEmpty) {
              _valueNotifier.value = base64Decode(widget.img);
            } else {
              _valueNotifier.value = null;
            }
          } catch (e) {
            debugPrint("MemoryImgWidget decode error: $e");
            _valueNotifier.value = null;
          }
    }
  }

  @override
  void initState() {
    super.initState();
    _initFunction();
  }

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      scaleEnabled: widget.isInTerActive,
      child: _buildImgWidget()
    ).clipRRect(
        borderRadius: widget.borderRadius
    );
  }

  Widget _buildImgWidget() {
    return switch (widget.imgType) {
      ImgType.asset => Image.asset(
        widget.img,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        color: widget.color,
        errorBuilder: (context, error, stackTrace) => Center(child: Icon(Icons.image_not_supported_outlined, color: kGreyColor, size: context.width(34.0))),
      ),
    ImgType.file => Image.file(
    width: widget.width,
    height: widget.height,
    File(widget.img),
    fit: widget.fit,
      color: widget.color,
    errorBuilder: (context, error, stackTrace) => Center(child: Icon(Icons.image_not_supported_outlined, color: kGreyColor, size: context.width(34.0))),
    ),
    ImgType.memory => ValueListenableBuilder<Uint8List?>(
      valueListenable: _valueNotifier,
      builder: (context, value, child) {
        if (value == null) {
          return Center(
            child: Icon(Icons.image_not_supported_outlined, color: kGreyColor, size: context.width(34.0)),
          ).clipRRect(borderRadius: widget.borderRadius);
        }

        return Image.memory(
          value,
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
          color: widget.color,
          errorBuilder: (context, error, stackTrace) => Center(
            child: Icon(Icons.image_not_supported_outlined, color: kGreyColor, size: context.width(34.0)),
          ),
        );
      },
    ),
    ImgType.network => Image.network(
      width: widget.width,
      height: widget.height,
      widget.img,
      fit: widget.fit,
      color: widget.color,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress != null) {
          final loaded = loadingProgress.cumulativeBytesLoaded;
          final total = loadingProgress.expectedTotalBytes ?? 1; // avoid null
          final progress = loaded / total;

        return Center(
          child: CircularProgressIndicatorWidget(
              value: progress,
              strokeWidth: context.width(2.0)
          ),
        );
        } else {
          return child;
        }
      },
      errorBuilder: (context, error, stackTrace) => Center(child: Icon(Icons.image_not_supported_outlined, color: kGreyColor, size: context.width(34.0))),
    ),
    ImgType.cached_network => TextWidget(text: "No package found!"),
      _ => Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
              border: Border.all(color: kGreyColor),
              borderRadius: widget.borderRadius
          ),
          child: Icon(Icons.image_not_supported_outlined,
              color: kGreyColor, size: context.width(20.0)
          )), // or any fallback widget
    };
  }
}
