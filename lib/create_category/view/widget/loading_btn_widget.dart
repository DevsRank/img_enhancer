import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_enhancer_app/create_category/view_model/bloc/loading_btn/loading_btn_bloc.dart';
import 'package:image_enhancer_app/main.dart';
import 'package:image_enhancer_app/splash/view/widget/circular_progress_indicator_widget.dart';
import 'package:image_enhancer_app/splash/view/widget/text_widget.dart';
import 'package:image_enhancer_app/utils/constant/alignment.dart';
import 'package:image_enhancer_app/utils/constant/color.dart';
import 'package:image_enhancer_app/utils/constant/font_weight.dart';
import 'package:image_enhancer_app/utils/constant/padding.dart';
import 'package:image_enhancer_app/utils/enum/loading_state.dart';
import 'package:image_enhancer_app/utils/extension/common_extension.dart';
import 'package:image_enhancer_app/utils/extension/widget_extension.dart';

class LoadingBtnWidget extends StatefulWidget {
  final String toolTip;
  final String text;
  final LoadingState? loadingState;
  final Color bkgColor;
  final Color circularProgressColor;
  final Gradient? bkgGradient;
  final Color textColor;
  final num? elevation;
  final String? img;
  final IconData? icn;
  final bool displayIcnRight;
  final BorderSide border;
  final BorderRadius borderRadius;
  final double fontSize;
  EdgeInsets? padding;
  final VoidCallback? onPressed;

  LoadingBtnWidget({
    super.key,
    this.loadingState,
    required this.text,
    this.onPressed,
    this.toolTip = "",
    this.circularProgressColor = kWhiteColor,
    this.bkgColor = kWhiteColor,
    this.bkgGradient = kBlueGradient,
    this.textColor = kWhiteColor,
    this.elevation = .0,
    this.icn,
    this.img,
    this.displayIcnRight = false,
    this.border = BorderSide.none,
    BorderRadius? borderRadius,
    this.fontSize = 14.0,
    this.padding,
  }) : borderRadius = borderRadius ?? 100.0.borderRadius;

  @override
  State<LoadingBtnWidget> createState() => _LoadingBtnWidgetState();
}

class _LoadingBtnWidgetState extends State<LoadingBtnWidget> {

  final GlobalKey key = GlobalKey();

  final ValueNotifier<double> _scaleNotifier = ValueNotifier(1.0);

  void _disposeFunction() {
    if (widget.loadingState != null) {
      materialAppKey.currentContext?.read<BtnLoadingBloc>().remove(widget.loadingState!);
      // if(widget.loadingState != null) FocusedWidgetKey.removeFocusedWidgetKey(widget.loadingState!);
    }
  }



  void _initFunction() {

    // if(widget.loadingState != null) FocusedWidgetKey.addFocusedWidgetKey(key, widget.loadingState!);
    if (widget.loadingState != null) {
      materialAppKey.currentContext?.read<BtnLoadingBloc>().holdKey(loadingState: widget.loadingState!, key: key);
      // if(widget.loadingState != null) FocusedWidgetKey.removeFocusedWidgetKey(widget.loadingState!);
    }
  }

  @override
  void dispose() {
    _disposeFunction();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initFunction();
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      key: key,
      message: widget.toolTip,
      child: ValueListenableBuilder<double>(
        valueListenable: _scaleNotifier,
        builder: (context, value, child) {
          return AnimatedScale(
            scale: value,
            duration: 100.millisecond,
            child: GestureDetector(
              onTapDown: (_) => _scaleNotifier.value = 0.98, // shrink
              onTapUp: (_) => _scaleNotifier.value = 1.0,   // back to normal
              onTapCancel: () => _scaleNotifier.value = 1.0, // cancel reset
              child: MaterialButton(
                  highlightElevation: 2.0,
                  minWidth: .0,
                  color: kTransparentColor,
                  textColor: kBlackColor,
                  padding: kZeroEdgeInsets,
                  elevation: widget.elevation?.toDouble(),
                  height: .0,
                  shape: RoundedRectangleBorder(borderRadius: widget.borderRadius, side: widget.border),
                  onPressed: () {
                    if(widget.loadingState != null && context.isActionRunning(loadingState: widget.loadingState!)) {
                      return;
                    } else if(widget.onPressed != null) {
                       widget.onPressed!();
                    }
                  },
                  child: BlocBuilder<BtnLoadingBloc, Map<LoadingState, BtnLoadingState>>(
                      buildWhen: (previous, current) =>
                         previous[widget.loadingState].hashCode != current[widget.loadingState].hashCode,
                      builder: (context, loadingBtnState) {
                        return Ink(
                          width: double.maxFinite,
                          padding: widget.padding ?? context.width(14.0).verticalEdgeInsets,
                          decoration: BoxDecoration(
                            color: (loadingBtnState[widget.loadingState] ?? BtnLoadingState()).enable ? widget.bkgColor : kShadowColor,
                            gradient: (loadingBtnState[widget.loadingState] ?? BtnLoadingState()).enable ? widget.bkgGradient : null,
                            borderRadius: widget.borderRadius,
                          ),
                          child: (loadingBtnState[widget.loadingState] ?? BtnLoadingState()).isLoading || (loadingBtnState[widget.loadingState] ?? BtnLoadingState()).progress != null
                              ? Center(
                            heightFactor: .7,
                                child: CircularProgressIndicatorWidget(
                                  // size: 14.0,
                                  padding: EdgeInsets.zero,
                                  value: (loadingBtnState[widget.loadingState] ?? BtnLoadingState()).progress,
                                  color: widget.circularProgressColor,
                                  strokeCap: StrokeCap.square
                                ),
                              )
                              : Row(
                            mainAxisSize: kMinMainAxisSize,
                            mainAxisAlignment: kCenterMainAxisAlignment,
                            children: [
                              if (!widget.displayIcnRight) ...[
                                if (widget.icn != null)
                                  Icon(widget.icn, color: (loadingBtnState[widget.loadingState] ?? BtnLoadingState()).enable ? widget.textColor : kWhiteColor.withOpacity(.8), size: context.width(21.0)).padding(padding: widget.text.isNotEmpty
                                      ? context.width(8.0).rightEdgeInsets : kZeroEdgeInsets)
                                else if (widget.img != null)
                                  Image.asset(
                                    widget.img!,
                                    width: context.width(20.0),
                                    height: context.width(20.0),
                                    color: (loadingBtnState[widget.loadingState] ?? BtnLoadingState()).enable ? widget.textColor : kWhiteColor.withOpacity(.8),                            ).padding(padding: widget.text.isNotEmpty
                                      ? context.width(8.0).rightEdgeInsets : kZeroEdgeInsets)
                              ],
                              if(widget.text.isNotEmpty) TextWidget(
                                  text: widget.text,
                                  color: (loadingBtnState[widget.loadingState] ?? BtnLoadingState()).enable ? widget.textColor : kWhiteColor.withOpacity(.8),
                                  fontWeight: kBoldFontWeight,
                                fontSize: widget.fontSize
                              ),
                              if (widget.displayIcnRight) ...[
                                if (widget.icn != null)
                                  Icon(widget.icn, color: (loadingBtnState[widget.loadingState] ?? BtnLoadingState()).enable ? widget.textColor : kWhiteColor.withOpacity(.8), size: context.width(21.0)).padding(padding: widget.text.isNotEmpty
                                      ? context.width(8.0).leftEdgeInsets : kZeroEdgeInsets)
                                else if (widget.img != null)
                                  Image.asset(
                                      widget.img!,
                                      width: context.width(20.0),
                                      height: context.width(20.0),
                                      color: (loadingBtnState[widget.loadingState] ?? BtnLoadingState()).enable ? widget.textColor : kWhiteColor.withOpacity(.8),
                                  ).padding(padding: widget.text.isNotEmpty
                                      ? context.width(8.0).leftEdgeInsets : kZeroEdgeInsets)
                              ],
                            ],
                          ),
                        );
                      }
                  )
              ),
            ),
          );
        }
      )
    );
  }
}