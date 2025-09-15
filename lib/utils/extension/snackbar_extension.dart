import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_enhancer_app/splash/view/widget/text_widget.dart';
import 'package:image_enhancer_app/utils/constant/alignment.dart';
import 'package:image_enhancer_app/utils/constant/color.dart';
import 'package:image_enhancer_app/utils/constant/font_weight.dart';
import 'package:image_enhancer_app/utils/constant/padding.dart';
import 'package:image_enhancer_app/utils/extension/common_extension.dart';
import 'package:image_enhancer_app/utils/extension/widget_extension.dart';

extension SnackbarGlobalKeyExtension on GlobalKey<NavigatorState> {
  void showSnackBar({String title = "PixeLift", required String msg}) =>
      _SnackbarManager().showSnackbar(
        navigatorKey: this,
        title: title,
        subTitle: msg,
      );
}

extension SnackbarContextExtension on BuildContext {
  void showSnackBar({String title = "PixeLift", required String msg}) =>
      _SnackbarManager().showSnackbar(
        context: this,
        title: title,
        subTitle: msg,
      );
}

class _SnackbarManager {
  static final _SnackbarManager _instance = _SnackbarManager._internal();
  factory _SnackbarManager() => _instance;
  _SnackbarManager._internal();

  final List<_SnackbarEntry> _queue = [];
  bool _isShowing = false;

  void showSnackbar({
    BuildContext? context,
    GlobalKey<NavigatorState>? navigatorKey,
    required String title,
    required String subTitle,
    Duration duration = const Duration(seconds: 3)
  }) {
    final overlay = context != null ? Overlay.of(context, rootOverlay: true) : navigatorKey!.currentState!.overlay!;
    if(overlay == null) return;
    _queue.add(_SnackbarEntry(
      title: title,
      subTitle: subTitle,
      duration: duration,
    ));
    if (!_isShowing) {
      _showNext(context: context, navigatorStateKey: navigatorKey);
    }
  }

  void _showNext({BuildContext? context, GlobalKey<NavigatorState>? navigatorStateKey}) {
    if (_queue.isEmpty) {
      _isShowing = false;
      return;
    }

    _isShowing = true;
    final entry = _queue.removeAt(0);

    final overlay = context != null ? Overlay.of(context, rootOverlay: true) : navigatorStateKey!.currentState!.overlay!;
    if(overlay == null) return;
    late OverlayEntry overlayEntry;
    final animationController = AnimationController(
      vsync: Navigator.of(overlay.context),
      duration: 500.millisecond,
      reverseDuration: 500.millisecond
    );

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, -1.0),
            end: const Offset(0.0, 0.0),
          ).animate(
            CurvedAnimation(
              parent: animationController,
              curve: Curves.easeOut,
            ),
          ),
          child: _SnackbarWidget(
            title: entry.title,
            subTitle: entry.subTitle,
            onDismiss: () async {
              await animationController.reverse();
              overlayEntry.remove();
              animationController.dispose();
              _showNext(context: context, navigatorStateKey: navigatorStateKey);
            },
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    animationController.forward();

    Future.delayed(entry.duration, () async {
      if (animationController.isCompleted) {
        await animationController.reverse();
        overlayEntry.remove();
        animationController.dispose();
        _showNext(context: context, navigatorStateKey: navigatorStateKey);
      }
    });
  }
}

class _SnackbarEntry {
  final String title;
  final String subTitle;
  final Duration duration;

  _SnackbarEntry({
    required this.duration,
    required this.title,
    required this.subTitle,
  });
}

class _SnackbarWidget extends StatefulWidget {
  final String title;
  final String subTitle;
  final VoidCallback onDismiss;

  const _SnackbarWidget({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.onDismiss,
  }) : super(key: key);

  @override
  State<_SnackbarWidget> createState() => _SnackbarWidgetState();
}

class _SnackbarWidgetState extends State<_SnackbarWidget>
    with SingleTickerProviderStateMixin {
  final Completer<Size> _boxHeightCompleter = Completer<Size>();
  final GlobalKey _backgroundBoxKey = GlobalKey();

  late AnimationController _dragController;
  late Animation<double> _dragAnimation;

  double _dragOffset = 0.0;

  void _configureSize() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final keyContext = _backgroundBoxKey.currentContext;
      if (keyContext != null) {
        final box = keyContext.findRenderObject() as RenderBox;
        _boxHeightCompleter.complete(box.size);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _configureSize();
    _dragController = AnimationController(
      vsync: this,
      duration: 300.millisecond,
    );
    _dragAnimation = Tween<double>(begin: 0.0, end: 0.0).animate(
      CurvedAnimation(parent: _dragController, curve: Curves.easeOut),
    );
    _dragController.addListener(() {
      setState(() {
        _dragOffset = _dragAnimation.value;
      });
    });
  }

  void _animateBackToPosition() {
    _dragAnimation = Tween<double>(begin: _dragOffset, end: 0.0).animate(
      CurvedAnimation(parent: _dragController, curve: Curves.easeOut),
    );
    _dragController.forward(from: 0.0);
  }

  @override
  void dispose() {
    _dragController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kTransparentColor,
      child: SafeArea(
        child: Transform.translate(
          offset: Offset(0, _dragOffset),
          child: Stack(
            children: [
              FutureBuilder<Size>(
                future: _boxHeightCompleter.future,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ClipRRect(
                      borderRadius: 10.0.borderRadius,
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
                        child: Container(
                          height: snapshot.data!.height,
                          width: snapshot.data!.width,
                          color: kTransparentColor
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (_dragOffset < 2) {
                    setState(() {
                      _dragOffset += details.primaryDelta ?? 0;
                    });
                  }
                },
                onVerticalDragEnd: (details) {
                  if (_dragOffset < -50) {
                    widget.onDismiss(); // dismiss if dragged up enough
                  } else {
                    _animateBackToPosition(); // return to original
                  }
                },
                child: Container(
                  key: _backgroundBoxKey,
                  padding: EdgeInsets.symmetric(horizontal: context.width(14.0), vertical: context.height(12.0)),
                  decoration: BoxDecoration(
                    color: kGreyColor.withOpacity(.3),
                    borderRadius: 10.0.borderRadius,
                    border: Border.all(color: kWhiteColor.withOpacity(0.2)),
                  ),
                  child: Row(
                    crossAxisAlignment: kStartCrossAxisAlignment,
                    children: [
                      Icon(CupertinoIcons.info, size: context.width(18.0), color: kWhiteColor).padding(padding: widget.title.isNotEmpty
                          ? context.height(2.0).topEdgeInsets : kZeroEdgeInsets),
                      context.width(8.0).wMargin,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: kStartCrossAxisAlignment,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (widget.title.isNotEmpty)
                              TextWidget(
                                text: widget.title,
                                  fontWeight: kBoldFontWeight
                              ),
                            TextWidget(text: widget.subTitle),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ).padding(padding: EdgeInsets.symmetric(horizontal: context.width(16.0))),
      ),
    );
  }
}

