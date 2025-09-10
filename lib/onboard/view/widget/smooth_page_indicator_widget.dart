import 'package:flutter/material.dart';

import 'dart:math';
import 'dart:ui' as ui show lerpDouble;

/// Paints user-customizable transition effect between active
/// and non-active dots
///
/// Live demos at
/// https://github.com/Milad-Akarie/smooth_page_indicator/blob/f7ee92e7413a31de77bfb487755d64a385d52a52/demo/custimizable-1.gif
/// https://github.com/Milad-Akarie/smooth_page_indicator/blob/f7ee92e7413a31de77bfb487755d64a385d52a52/demo/customizable-2.gif
/// https://github.com/Milad-Akarie/smooth_page_indicator/blob/f7ee92e7413a31de77bfb487755d64a385d52a52/demo/customizable-3.gif
/// https://github.com/Milad-Akarie/smooth_page_indicator/blob/f7ee92e7413a31de77bfb487755d64a385d52a52/demo/customizable-4.gif
class CustomizablePainter extends IndicatorPainter {
  /// The painting configuration
  final CustomizableEffect effect;

  /// The number of pages
  final int count;

  /// Default constructor
  CustomizablePainter({
    required double offset,
    required this.effect,
    required this.count,
  }) : super(offset);

  @override
  void paint(Canvas canvas, Size size) {
    var activeDotDecoration = effect.activeDotDecoration;
    var dotDecoration = effect.dotDecoration;
    final current = offset.floor();

    final dotOffset = offset - current;
    final maxVerticalOffset = max(
      activeDotDecoration.verticalOffset,
      dotDecoration.verticalOffset,
    );

    var yTranslation = 0.0;
    if (activeDotDecoration.verticalOffset >= dotDecoration.verticalOffset) {
      yTranslation =
          activeDotDecoration.verticalOffset - dotDecoration.verticalOffset;
    } else {
      yTranslation =
          dotDecoration.verticalOffset - activeDotDecoration.verticalOffset;
    }
    canvas.translate(0, -maxVerticalOffset + yTranslation / 2);

    var drawingOffset = effect.spacing / 2;

    for (var i = 0; i < count; i++) {
      if (effect.inActiveColorOverride != null) {
        dotDecoration = dotDecoration.copyWith(
            color: effect.inActiveColorOverride!.call(i));
      }
      if (effect.activeColorOverride != null) {
        activeDotDecoration = activeDotDecoration.copyWith(
            color: effect.activeColorOverride!.call(i));
      }
      var decoration = dotDecoration;
      if (i == current) {
        decoration =
            DotDecoration.lerp(activeDotDecoration, dotDecoration, dotOffset);
      } else if (i - 1 == current || (i == 0 && offset > count - 1)) {
        decoration =
            DotDecoration.lerp(dotDecoration, activeDotDecoration, dotOffset);
      }

      final xPos = drawingOffset + decoration.dotBorder.neededSpace / 2;
      final yPos = (size.height / 2) + decoration.verticalOffset;

      final rRect = RRect.fromLTRBAndCorners(
        xPos,
        yPos - decoration.height / 2,
        xPos + decoration.width,
        yPos + decoration.height / 2,
        topLeft: decoration.borderRadius.topLeft,
        topRight: decoration.borderRadius.topRight,
        bottomLeft: decoration.borderRadius.bottomLeft,
        bottomRight: decoration.borderRadius.bottomRight,
      );

      var scaledRect = rRect.outerRect.inflate(decoration.dotBorder.padding);
      final scaleRatioX = scaledRect.width / rRect.width;
      final scaleRatioY = scaledRect.height / rRect.height;

      final scaledRRect = RRect.fromRectAndCorners(
        scaledRect,
        topLeft: Radius.elliptical(
            rRect.tlRadiusX * scaleRatioX, rRect.tlRadiusY * scaleRatioY),
        topRight: Radius.elliptical(
            rRect.trRadiusX * scaleRatioX, rRect.trRadiusY * scaleRatioY),
        bottomRight: Radius.elliptical(
            rRect.brRadiusX * scaleRatioX, rRect.brRadiusY * scaleRatioY),
        bottomLeft: Radius.elliptical(
            rRect.blRadiusX * scaleRatioX, rRect.blRadiusY * scaleRatioY),
      );

      drawingOffset = scaledRRect.right + effect.spacing;

      var path = Path()..addRRect(rRect);

      final matrix4 = Matrix4.identity();
      if (decoration.rotationAngle != 0) {
        matrix4.rotateAngle(
          decoration.rotationAngle,
          origin: Offset(rRect.right - (rRect.width / 2), yPos),
        );
      }

      canvas.drawPath(
        path.transform(matrix4.storage),
        Paint()..color = decoration.color,
      );

      final borderPaint = Paint()
        ..strokeWidth = decoration.dotBorder.width
        ..style = PaintingStyle.stroke
        ..color = decoration.dotBorder.color;

      final borderPath = Path()..addRRect(scaledRRect);

      canvas.drawPath(
        borderPath.transform(matrix4.storage),
        borderPaint,
      );
    }
  }
}

/// Adds [rotateAngle] functionality to [Matrix4]
extension Matrix4X on Matrix4 {
  /// Rotates teh matrix by given [angle]
  Matrix4 rotateAngle(double angle, {Offset? origin}) {
    final angleRadians = angle * pi / 180;

    if (angleRadians == 0.0) {
      return this;
    } else if ((origin == null) || (origin.dx == 0.0 && origin.dy == 0.0)) {
      return this..rotateZ(angleRadians);
    } else {
      return this
        ..translate(origin.dx, origin.dy)
        ..multiply(Matrix4.rotationZ(angleRadians))
        ..translate(-origin.dx, -origin.dy);
    }
  }
}


/// Signature for a function that returns color
/// for each [index]
typedef ColorBuilder = Color Function(int index);

/// Holds painting configuration to be used by [CustomizablePainter]
class CustomizableEffect extends IndicatorEffect {
  /// Holds painting decoration for inactive dots
  final DotDecoration dotDecoration;

  /// Holds painting decoration for active dots
  final DotDecoration activeDotDecoration;

  /// Builds dynamic colors for active dot
  final ColorBuilder? activeColorOverride;

  /// Builds dynamic colors for inactive dots
  final ColorBuilder? inActiveColorOverride;

  /// The space between two dots
  final double spacing;

  /// Default constructor
  const CustomizableEffect({
    required this.dotDecoration,
    required this.activeDotDecoration,
    this.activeColorOverride,
    this.spacing = 8,
    this.inActiveColorOverride,
  });

  @override
  Size calculateSize(int count) {
    final activeDotWidth =
        activeDotDecoration.width + activeDotDecoration.dotBorder.neededSpace;
    final dotWidth = dotDecoration.width + dotDecoration.dotBorder.neededSpace;

    final maxWidth =
        dotWidth * (count - 1) + (spacing * count) + activeDotWidth;

    final offsetSpace =
    (dotDecoration.verticalOffset - activeDotDecoration.verticalOffset)
        .abs();
    final maxHeight = max(
      dotDecoration.height + offsetSpace + dotDecoration.dotBorder.neededSpace,
      activeDotDecoration.height +
          offsetSpace +
          activeDotDecoration.dotBorder.neededSpace,
    );
    return Size(maxWidth, maxHeight);
  }

  @override
  IndicatorPainter buildPainter(int count, double offset) {
    return CustomizablePainter(count: count, offset: offset, effect: this);
  }

  @override
  int hitTestDots(double dx, int count, double current) {
    var anchor = -spacing / 2;
    for (var index = 0; index < count; index++) {
      var dotWidth = dotDecoration.width + dotDecoration.dotBorder.neededSpace;
      if (index == current) {
        dotWidth = activeDotDecoration.width +
            activeDotDecoration.dotBorder.neededSpace;
      }

      var widthBound = dotWidth + spacing;
      if (dx <= (anchor += widthBound)) {
        return index;
      }
    }
    return -1;
  }
}

/// Holds dot painting specs
class DotDecoration {
  /// The border radius of the dot
  final BorderRadius borderRadius;

  /// The color of the dot
  final Color color;

  /// The dotBorder configuration of the dot
  final DotBorder dotBorder;

  /// The vertical offset of the dot
  final double verticalOffset;

  /// The rotation angle of the dot
  final double rotationAngle;

  /// The width of the dot
  final double width;

  /// the height of the dot
  final double height;

  /// Default constructor
  const DotDecoration(
      {this.borderRadius = BorderRadius.zero,
        this.color = Colors.white,
        this.dotBorder = DotBorder.none,
        this.verticalOffset = 0.0,
        this.rotationAngle = 0.0,
        this.width = 8,
        this.height = 8});

  /// Lerps the value between active dot and prev-active dot
  static DotDecoration lerp(DotDecoration a, DotDecoration b, double t) {
    return DotDecoration(
        borderRadius: BorderRadius.lerp(a.borderRadius, b.borderRadius, t)!,
        width: ui.lerpDouble(a.width, b.width, t) ?? 0.0,
        height: ui.lerpDouble(a.height, b.height, t) ?? 0.0,
        color: Color.lerp(a.color, b.color, t)!,
        dotBorder: DotBorder.lerp(a.dotBorder, b.dotBorder, t),
        verticalOffset:
        ui.lerpDouble(a.verticalOffset, b.verticalOffset, t) ?? 0.0,
        rotationAngle:
        ui.lerpDouble(a.rotationAngle, b.rotationAngle, t) ?? 0.0);
  }

  /// Builds a new instance with the given
  /// override values
  DotDecoration copyWith({
    BorderRadius? borderRadius,
    double? width,
    double? height,
    Color? color,
    DotBorder? dotBorder,
    double? verticalOffset,
    double? rotationAngle,
  }) {
    return DotDecoration(
      borderRadius: borderRadius ?? this.borderRadius,
      width: width ?? this.width,
      height: height ?? this.height,
      color: color ?? this.color,
      dotBorder: dotBorder ?? this.dotBorder,
      verticalOffset: verticalOffset ?? this.verticalOffset,
      rotationAngle: rotationAngle ?? this.rotationAngle,
    );
  }
}

/// The variants of dot borders
enum DotBorderType {
  /// Draw a sold border
  solid,

  /// Draw nothing
  none
}

/// Holds dot-border painting specs
class DotBorder {
  /// The thinness of the border line
  final double width;

  /// The color of the border
  final Color color;

  /// The padding between the dot and the border
  final double padding;

  /// The border variant
  final DotBorderType type;

  /// Default constructor
  const DotBorder({
    this.width = 1.0,
    this.color = Colors.black87,
    this.padding = 0.0,
    this.type = DotBorderType.solid,
  });

  /// Calculates the needed gap based on [type]
  double get neededSpace =>
      type == DotBorderType.none ? 0.0 : (width / 2 + (padding * 2));

  /// Builds an instance with type [DotBorderType.none]
  static const none = DotBorder._none();

  const DotBorder._none()
      : width = 0.0,
        color = Colors.transparent,
        padding = 0.0,
        type = DotBorderType.none;

  /// Lerps the value between active dot border and prev-active dot's border
  static DotBorder lerp(DotBorder a, DotBorder b, double t) {
    if (t == 0.0) {
      return a;
    }
    if (t == 1.0) {
      return b;
    }
    return DotBorder(
        color: Color.lerp(a.color, b.color, t)!,
        width: ui.lerpDouble(a.width, b.width, t)!,
        padding: ui.lerpDouble(a.padding, b.padding, t)!);
  }
}


/// Paints an expanding dot transition effect between active
/// and non-active dot
///
/// Live demo at
/// https://github.com/Milad-Akarie/smooth_page_indicator/blob/f7ee92e7413a31de77bfb487755d64a385d52a52/demo/expanding-dot.gif
class ExpandingDotsPainter extends BasicIndicatorPainter {
  /// The painting configuration
  final ExpandingDotsEffect effect;

  /// Default constructor
  ExpandingDotsPainter({
    required double offset,
    required this.effect,
    required int count,
  }) : super(offset, count, effect);

  @override
  void paint(Canvas canvas, Size size) {
    final current = offset.floor();
    var drawingOffset = -effect.spacing;
    final dotOffset = offset - current;

    for (var i = 0; i < count; i++) {
      var color = effect.dotColor;
      final activeDotWidth = effect.dotWidth * effect.expansionFactor;
      final expansion =
      (dotOffset / 2 * ((activeDotWidth - effect.dotWidth) / .5));
      final xPos = drawingOffset + effect.spacing;
      var width = effect.dotWidth;
      if (i == current) {
        // ! Both a and b are non nullable
        color = Color.lerp(effect.activeDotColor, effect.dotColor, dotOffset)!;
        width = activeDotWidth - expansion;
      } else if (i - 1 == current || (i == 0 && offset > count - 1)) {
        width = effect.dotWidth + expansion;
        // ! Both a and b are non nullable
        color = Color.lerp(
            effect.activeDotColor, effect.dotColor, 1.0 - dotOffset)!;
      }
      final yPos = size.height / 2;
      final rRect = RRect.fromLTRBR(
        xPos,
        yPos - effect.dotHeight / 2,
        xPos + width,
        yPos + effect.dotHeight / 2,
        dotRadius,
      );
      drawingOffset = rRect.right;
      canvas.drawRRect(rRect, dotPaint..color = color);
    }
  }
}

/// Holds painting configuration to be used by [ExpandingDotsPainter]
class ExpandingDotsEffect extends BasicIndicatorEffect {
  /// This is multiplied by [dotWidth] to calculate
  /// the width of the expanded dot.
  final double expansionFactor;

  /// Default constructor
  const ExpandingDotsEffect({
    this.expansionFactor = 3,
    double offset = 16.0,
    double dotWidth = 16.0,
    double dotHeight = 16.0,
    double spacing = 8.0,
    double radius = 16.0,
    Color activeDotColor = Colors.indigo,
    Color dotColor = Colors.grey,
    double strokeWidth = 1.0,
    PaintingStyle paintStyle = PaintingStyle.fill,
  })  : assert(expansionFactor > 1),
        super(
          dotWidth: dotWidth,
          dotHeight: dotHeight,
          spacing: spacing,
          radius: radius,
          strokeWidth: strokeWidth,
          paintStyle: paintStyle,
          dotColor: dotColor,
          activeDotColor: activeDotColor);

  @override
  Size calculateSize(int count) {
    /// Add the expanded dot width to our size calculation
    return Size(
        ((dotWidth + spacing) * (count - 1)) + (expansionFactor * dotWidth),
        dotHeight);
  }

  @override
  IndicatorPainter buildPainter(int count, double offset) {
    return ExpandingDotsPainter(count: count, offset: offset, effect: this);
  }

  @override
  int hitTestDots(double dx, int count, double current) {
    var anchor = -spacing / 2;
    for (var index = 0; index < count; index++) {
      var widthBound =
          (index == current ? (dotWidth * expansionFactor) : dotWidth) +
              spacing;
      if (dx <= (anchor += widthBound)) {
        return index;
      }
    }
    return -1;
  }
}


/// Paints a warm-like transition effect between active
/// and non-active dots
///
/// Live demo at
/// https://github.com/Milad-Akarie/smooth_page_indicator/blob/f7ee92e7413a31de77bfb487755d64a385d52a52/demo/worm.gif
class WormPainter extends BasicIndicatorPainter {
  /// The painting configuration
  final WormEffect effect;

  /// Default constructor
  WormPainter({
    required this.effect,
    required int count,
    required double offset,
  }) : super(offset, count, effect);

  @override
  void paint(Canvas canvas, Size size) {
    // paint still dots
    paintStillDots(canvas, size);

    final activeDotPaint = Paint()..color = effect.activeDotColor;
    final dotOffset = (offset - offset.toInt());

    // handle dot travel from end to start (for infinite pager support)
    if (offset > count - 1) {
      final startDot = calcPortalTravel(size, effect.dotWidth / 2, dotOffset);
      canvas.drawRRect(startDot, activeDotPaint);

      final endDot = calcPortalTravel(
        size,
        ((count - 1) * distance) + (effect.dotWidth / 2),
        1 - dotOffset,
      );
      canvas.drawRRect(endDot, activeDotPaint);
      return;
    }

    final wormOffset = dotOffset * 2;
    final xPos = (offset.floor() * distance);
    final yPos = size.height / 2;
    var head = xPos;
    var tail = xPos + effect.dotWidth + (wormOffset * distance);
    var halfHeight = effect.dotHeight / 2;
    final thinWorm =
        effect.type == WormType.thin || effect.type == WormType.thinUnderground;
    var dotHeight = thinWorm
        ? halfHeight + (halfHeight * (1 - wormOffset))
        : effect.dotHeight;

    if (wormOffset > 1) {
      tail = xPos + effect.dotWidth + (1 * distance);
      head = xPos + distance * (wormOffset - 1);
      if (thinWorm) {
        dotHeight = halfHeight + (halfHeight * (wormOffset - 1));
      }
    }
    final worm = RRect.fromLTRBR(
      head,
      yPos - dotHeight / 2,
      tail,
      yPos + dotHeight / 2,
      dotRadius,
    );
    if (effect.type == WormType.underground ||
        effect.type == WormType.thinUnderground) {
      canvas.saveLayer(Rect.largest, Paint());
      canvas.drawRRect(worm, activeDotPaint);
      maskStillDots(size, canvas);
      canvas.restore();
    } else {
      canvas.drawRRect(worm, activeDotPaint);
    }
  }
}

/// Holds painting configuration to be used by [WormPainter]
class WormEffect extends BasicIndicatorEffect {
  /// The effect variant
  ///
  /// defaults to [WormType.normal]
  final WormType type;

  /// Default constructor
  const WormEffect({
    double offset = 16.0,
    super.dotWidth = 16.0,
    super.dotHeight = 16.0,
    super.spacing = 8.0,
    super.radius = 16,
    super.dotColor = Colors.grey,
    super.activeDotColor = Colors.indigo,
    super.strokeWidth = 1.0,
    super.paintStyle = PaintingStyle.fill,
    this.type = WormType.normal,
  });

  @override
  IndicatorPainter buildPainter(int count, double offset) {
    return WormPainter(count: count, offset: offset, effect: this);
  }
}

/// The Worm effect variants
enum WormType {
  /// Draws normal worm animation
  normal,

  /// Draws a thin worm animation
  thin,

  /// Draws normal worm animation that looks like
  /// it's under the background
  underground,

  /// Draws a thing worm animation that looks like
  /// it's under the background
  thinUnderground,
}

/// Signature for a callback function used to report
/// dot tap-events
typedef OnDotClicked = void Function(int index);

/// A widget that draws a representation of pages count
/// Inside of a  [PageView]
///
/// Uses the [PageController.offset] to animate the active dot
class SmoothPageIndicatorWidget extends StatefulWidget {
  /// The page view controller
  final PageController controller;

  /// Holds effect configuration to be used in the [BasicIndicatorPainter]
  final IndicatorEffect effect;

  /// Layout direction vertical || horizontal
  ///
  /// This will only rotate the canvas in which the dots are drawn.
  ///
  /// It will not affect [effect.dotWidth] and [effect.dotHeight]
  final Axis axisDirection;

  /// The number of pages
  final int count;

  /// If [textDirection] is [TextDirection.rtl], page direction will be flipped
  final TextDirection? textDirection;

  /// Reports dot taps
  final OnDotClicked? onDotClicked;

  /// Default constructor
  const SmoothPageIndicatorWidget({
    super.key,
    required this.controller,
    required this.count,
    this.axisDirection = Axis.horizontal,
    this.textDirection,
    this.onDotClicked,
    this.effect = const WormEffect(),
  });

  @override
  State<SmoothPageIndicatorWidget> createState() => _SmoothPageIndicatorWidgetState();
}

mixin _SizeAndRotationCalculatorMixin {
  /// The size of canvas
  late Size size;

  /// Rotation quarters of canvas
  int quarterTurns = 0;

  BuildContext get context;

  TextDirection? get textDirection;

  Axis get axisDirection;

  int get count;

  IndicatorEffect get effect;

  void updateSizeAndRotation() {
    size = effect.calculateSize(count);

    /// if textDirection is not provided use the nearest directionality up the widgets tree;
    final isRTL = (textDirection ?? _getDirectionality()) == TextDirection.rtl;
    if (axisDirection == Axis.vertical) {
      quarterTurns = 1;
    } else {
      quarterTurns = isRTL ? 2 : 0;
    }
  }

  TextDirection? _getDirectionality() {
    return context
        .findAncestorWidgetOfExactType<Directionality>()
        ?.textDirection;
  }
}

class _SmoothPageIndicatorWidgetState extends State<SmoothPageIndicatorWidget>
    with _SizeAndRotationCalculatorMixin {
  @override
  void initState() {
    super.initState();
    updateSizeAndRotation();
  }

  @override
  void didUpdateWidget(covariant SmoothPageIndicatorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    updateSizeAndRotation();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) => SmoothIndicator(
        offset: _offset,
        count: count,
        effect: effect,
        onDotClicked: widget.onDotClicked,
        size: size,
        quarterTurns: quarterTurns,
      ),
    );
  }

  double get _offset {
    try {
      var offset =
          widget.controller.page ?? widget.controller.initialPage.toDouble();
      return offset % widget.count;
    } catch (_) {
      return widget.controller.initialPage.toDouble();
    }
  }

  @override
  int get count => widget.count;

  @override
  IndicatorEffect get effect => widget.effect;

  @override
  Axis get axisDirection => widget.axisDirection;

  @override
  TextDirection? get textDirection => widget.textDirection;
}

/// Draws dot-ish representation of pages by
/// the number of [count] and animates the active
/// page using [offset]
class SmoothIndicator extends StatelessWidget {
  /// The active page offset
  final double offset;

  /// Holds effect configuration to be used in the [BasicIndicatorPainter]
  final IndicatorEffect effect;

  /// The number of pages
  final int count;

  /// Reports dot-taps
  final OnDotClicked? onDotClicked;

  /// The size of canvas
  final Size size;

  /// The rotation of cans based on
  /// text directionality and [axisDirection]
  final int quarterTurns;

  /// Default constructor
  const SmoothIndicator({
    super.key,
    required this.offset,
    required this.count,
    required this.size,
    this.quarterTurns = 0,
    this.effect = const WormEffect(),
    this.onDotClicked,
  });

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: quarterTurns,
      child: GestureDetector(
        onTapUp: _onTap,
        child: CustomPaint(
          size: size,
          // rebuild the painter with the new offset every time it updates
          painter: effect.buildPainter(count, offset),
        ),
      ),
    );
  }

  void _onTap(details) {
    if (onDotClicked != null) {
      var index = effect.hitTestDots(details.localPosition.dx, count, offset);
      if (index != -1 && index != offset.toInt()) {
        onDotClicked?.call(index);
      }
    }
  }
}

/// Unlike [SmoothPageIndicatorWidget] this indicator is self-animated
/// and it only needs to know active index
///
/// Useful for paging widgets that does not use [PageController]
class AnimatedSmoothIndicatorWidget extends ImplicitlyAnimatedWidget {
  /// The index of active page
  final int activeIndex;

  /// Holds effect configuration to be used in the [BasicIndicatorPainter]
  final IndicatorEffect effect;

  /// layout direction vertical || horizontal
  final Axis axisDirection;

  /// The number of children in [PageView]
  final int count;

  /// If [textDirection] is [TextDirection.rtl], page direction will be flipped
  final TextDirection? textDirection;

  /// Reports dot-taps
  final Function(int index)? onDotClicked;

  /// Default constructor
  const AnimatedSmoothIndicatorWidget({
    super.key,
    required this.activeIndex,
    required this.count,
    this.axisDirection = Axis.horizontal,
    this.textDirection,
    this.onDotClicked,
    this.effect = const WormEffect(),
    super.curve = Curves.easeInOut,
    super.duration = const Duration(milliseconds: 300),
    super.onEnd,
  });

  @override
  AnimatedWidgetBaseState<AnimatedSmoothIndicatorWidget> createState() =>
      _AnimatedSmoothIndicatorState();
}

class _AnimatedSmoothIndicatorState
    extends AnimatedWidgetBaseState<AnimatedSmoothIndicatorWidget>
    with _SizeAndRotationCalculatorMixin {
  Tween<double>? _offset;

  @override
  void initState() {
    super.initState();
    updateSizeAndRotation();
  }

  @override
  void didUpdateWidget(covariant AnimatedSmoothIndicatorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    updateSizeAndRotation();
  }

  @override
  void forEachTween(visitor) {
    _offset = visitor(
      _offset,
      widget.activeIndex.toDouble(),
          (dynamic value) => Tween<double>(begin: value as double),
    ) as Tween<double>;
  }

  @override
  int get count => widget.count;

  @override
  IndicatorEffect get effect => widget.effect;

  @override
  Axis get axisDirection => widget.axisDirection;

  @override
  TextDirection? get textDirection => widget.textDirection;

  @override
  Widget build(BuildContext context) {
    final offset = _offset;
    if (offset == null) {
      throw 'Offset has not been initialized';
    }
    return SmoothIndicator(
      offset: offset.evaluate(animation) % count,
      count: widget.count,
      effect: widget.effect,
      onDotClicked: widget.onDotClicked,
      size: size,
      quarterTurns: quarterTurns,
    );
  }
}

/// Basic implementation of [IndicatorPainter] that holds some shared
/// properties and behaviors between different painters
abstract class BasicIndicatorPainter extends IndicatorPainter {
  /// The count of pages
  final int count;

  /// The provided effect is passed to this super class
  /// to make some calculations and paint still dots
  final BasicIndicatorEffect _effect;

  /// Inactive dot paint or base paint in one-color effects.
  final Paint dotPaint;

  /// The Radius of all dots
  final Radius dotRadius;

  /// Default constructor
  BasicIndicatorPainter(
      super.offset,
      this.count,
      this._effect,
      )   : dotRadius = Radius.circular(_effect.radius),
        dotPaint = Paint()
          ..color = _effect.dotColor
          ..style = _effect.paintStyle
          ..strokeWidth = _effect.strokeWidth;

  /// The distance between dot lefts
  double get distance => _effect.dotWidth + _effect.spacing;

  /// Paints [count] number of dots with no animation
  ///
  /// Meant to be used by  effects that only
  /// animate the active dot
  void paintStillDots(Canvas canvas, Size size) {
    for (var i = 0; i < count; i++) {
      final rect = buildStillDot(i, size);
      canvas.drawRRect(rect, dotPaint);
    }
  }

  /// Builds a single still dot
  RRect buildStillDot(int i, Size size) {
    final xPos = (i * distance);
    final yPos = size.height / 2;
    final bounds = Rect.fromLTRB(
      xPos,
      yPos - _effect.dotHeight / 2,
      xPos + _effect.dotWidth,
      yPos + _effect.dotHeight / 2,
    );
    var rect = RRect.fromRectAndRadius(bounds, dotRadius);
    return rect;
  }

  /// Masks spaces between dots
  ///
  /// used by under-layer effects like WormType.underground
  void maskStillDots(Size size, Canvas canvas) {
    var path = Path()..addRect((const Offset(0, 0) & size));
    for (var i = 0; i < count; i++) {
      path = Path.combine(PathOperation.difference, path,
          Path()..addRRect(buildStillDot(i, size)));
    }
    canvas.drawPath(path, Paint()..blendMode = BlendMode.clear);
  }

  /// Calculates the shape of a dot while portal-traveling
  /// form last-to-first dot or form first-to-last dot
  RRect calcPortalTravel(Size size, double offset, double dotOffset) {
    final yPos = size.height / 2;
    var width = dotOffset * (_effect.dotHeight / 2);
    var height = dotOffset * (_effect.dotWidth / 2);
    var xPos = offset;
    return RRect.fromLTRBR(
      xPos - height,
      yPos - width,
      xPos + height,
      yPos + width,
      Radius.circular(dotRadius.x * dotOffset),
    );
  }
}

/// A basic abstract implementation of [customPainter]
/// to avoid overriding [shouldRepaint] in every painter
abstract class IndicatorPainter extends CustomPainter {
  /// The raw offset from the [PageController].page
  final double offset;

  /// Default constructor
  const IndicatorPainter(this.offset);

  @override
  bool shouldRepaint(IndicatorPainter oldDelegate) {
    /// only repaint if the offset changes
    return oldDelegate.offset != offset;
  }
}


abstract class IndicatorEffect {
  /// Const constructor
  const IndicatorEffect();

  /// Builds a new painter every time the page offset changes
  IndicatorPainter buildPainter(int count, double offset);

  /// Calculates the size of canvas based on
  /// dots count, size and spacing
  ///
  /// Implementers can override this function
  /// to calculate their own size
  Size calculateSize(int count);

  /// Returns the index of the section that contains [dx].
  ///
  /// Sections or hit-targets are calculated differently
  /// in some effects
  int hitTestDots(double dx, int count, double current);
}

/// Basic implementation of [IndicatorEffect] that holds some shared
/// properties and behaviors between different effects
abstract class BasicIndicatorEffect extends IndicatorEffect {
  /// Singe dot width
  final double dotWidth;

  /// Singe dot height
  final double dotHeight;

  /// The horizontal space between dots
  final double spacing;

  /// Single dot radius
  final double radius;

  /// Inactive dots color or all dots in some effects
  final Color dotColor;

  /// The active dot color
  final Color activeDotColor;

  /// Inactive dots paint style (fill|stroke) defaults to fill.
  final PaintingStyle paintStyle;

  /// This is ignored if [paintStyle] is PaintStyle.fill
  final double strokeWidth;

  /// Default construe
  const BasicIndicatorEffect({
    required this.strokeWidth,
    required this.dotWidth,
    required this.dotHeight,
    required this.spacing,
    required this.radius,
    required this.dotColor,
    required this.paintStyle,
    required this.activeDotColor,
  }) : assert(dotWidth >= 0 &&
      dotHeight >= 0 &&
      spacing >= 0 &&
      strokeWidth >= 0);

  @override
  Size calculateSize(int count) {
    return Size(dotWidth * count + (spacing * (count - 1)), dotHeight);
  }

  @override
  int hitTestDots(double dx, int count, double current) {
    var offset = -spacing / 2;
    for (var index = 0; index < count; index++) {
      if (dx <= (offset += dotWidth + spacing)) {
        return index;
      }
    }
    return -1;
  }
}