
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_enhancer_app/utils/enum/slider_position.dart';

const _defaultThumbElevation = 1.0;

/// An interactive widget that allows comparing two images using a before and after view.
///
/// The [CompareImgWidget] widget displays two images, [before] and [after], with a draggable slider in between.
/// The slider can be used to reveal or hide portions of the images, providing a comparison effect.
///
/// The [direction] determines the direction of the slider and can be either [SliderDirection.horizontal] or [SliderDirection.vertical].
/// The [value] specifies the initial position of the slider, ranging from 0.0 (fully hidden) to 1.0 (fully visible).
/// The [onValueChanged] callback is called when the value of the slider changes, providing the updated value.
///
/// The appearance of the slider can be customized using various properties:
///   - [thumbColor]: The color of the slider thumb.
///   - [thumbRadius]: The radius of the slider thumb.
///   - [overlayColor]: The color of the overlay when the images are revealed.
///   - [thumbImage]: The image to be displayed on the slider thumb.
///
/// The position of the slider thumb can be controlled using [thumbPosition].
/// The [onThumbPositionChanged] callback is called when the position of the thumb changes, providing the updated position.
///
/// Note: The [before] and [after] widgets should have the same size.
class CompareImgWidget extends StatefulWidget {
  /// Creates a [CompareImgWidget] widget with the specified before and after images.
  CompareImgWidget({
    super.key,
    required this.before,
    required this.after,
    this.height,
    this.width,
    this.trackWidth,
    this.trackColor,
    this.hideThumb = false,
    this.thumbHeight,
    this.thumbWidth,
    this.thumbColor,
    this.overlayColor,
    this.thumbDecoration,
    this.direction = SliderDirection.horizontal,
    this.value = 0.5,
    this.divisions,
    this.onValueChanged,
    this.thumbPosition = 0.5,
    this.thumbDivisions,
    this.onThumbPositionChanged,
    this.mouseCursor,
    this.focusNode,
    this.autofocus = false,
  })  : assert(thumbDecoration == null || thumbDecoration.debugAssertIsValid()),
        assert(
        thumbColor == null || thumbDecoration == null,
        'Cannot provide both a thumbColor and a thumbDecoration\n'
            'To provide both, use "thumbDecoration: BoxDecoration(color: thumbColor)".',
        );

  /// The widget to be displayed before the slider.
  final Widget before;

  /// The widget to be displayed after the slider.
  final Widget after;

  /// The drag direction of the slider.
  final SliderDirection direction;

  /// The height of the BeforeAfter widget.
  final double? height;

  /// The width of the BeforeAfter widget.
  final double? width;

  /// The width of the slider track.
  final double? trackWidth;

  /// The color of the slider track.
  final Color? trackColor;

  /// Whether to hide the slider thumb.
  final bool hideThumb;

  /// The height of the slider thumb.
  final double? thumbHeight;

  /// The width of the slider thumb.
  final double? thumbWidth;

  /// The color of the slider thumb.
  ///
  /// This property should be preferred when the background is a simple color.
  /// For other cases, such as gradients or images, use the [thumbDecoration]
  /// property.
  ///
  /// If the [thumbDecoration] is used, this property must be null. A background
  /// color may still be painted by the [thumbDecoration] even if this property
  /// is null.
  final Color? thumbColor;

  /// The highlight color that's typically used to indicate that
  /// the slider thumb is focused.
  final WidgetStateProperty<Color?>? overlayColor;

  /// The decoration of the slider thumb.
  ///
  /// Use the [thumbColor] property to specify a simple solid color.
  final BoxDecoration? thumbDecoration;

  /// The number of discrete divisions on the slider.
  final int? divisions;

  /// The position of the slider, ranging from 0.0 to 1.0.
  final double value;

  /// A callback function that is called when the value of the slider changes.
  final ValueChanged<double>? onValueChanged;

  /// The number of discrete divisions on the slider thumb.
  final int? thumbDivisions;

  /// The position of the slider thumb, ranging from 0.0 to 1.0.
  final double thumbPosition;

  /// A callback function that is called when the position of the thumb changes.
  final ValueChanged<double>? onThumbPositionChanged;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  /// {@template flutter.material.slider.mouseCursor}
  /// The cursor for a mouse pointer when it enters or is hovering over the
  /// widget.
  ///
  /// If [mouseCursor] is a [MaterialStateProperty<MouseCursor>],
  /// [WidgetStateProperty.resolve] is used for the following [WidgetState]s:
  ///
  ///  * [WidgetState.disabled].
  ///  * [WidgetState.dragged].
  ///  * [WidgetState.hovered].
  ///  * [WidgetState.focused].
  /// {@endtemplate}
  ///
  /// If null, then the value of [SliderThemeData.mouseCursor] is used. If that
  /// is also null, then [WidgetStateMouseCursor.clickable] is used.
  ///
  /// See also:
  ///
  ///  * [WidgetStateMouseCursor], which can be used to create a [MouseCursor]
  ///    that is also a [MaterialStateProperty<MouseCursor>].
  final MouseCursor? mouseCursor;

  @override
  State<CompareImgWidget> createState() => _CompareImgWidgetState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Widget>('before', before));
    properties.add(DiagnosticsProperty<Widget>('after', after));
    properties.add(DoubleProperty('height', height));
    properties.add(DoubleProperty('width', width));
    properties.add(DoubleProperty('trackWidth', trackWidth));
    properties.add(ColorProperty('trackColor', trackColor));
    properties.add(FlagProperty('hideThumb',
        value: hideThumb,
        ifTrue: 'thumb is hidden',
        ifFalse: 'thumb is shown',
        showName: true));
    properties.add(DoubleProperty('thumbHeight', thumbHeight));
    properties.add(DoubleProperty('thumbWidth', thumbWidth));
    properties.add(ColorProperty('thumbColor', thumbColor));
    properties.add(DiagnosticsProperty<WidgetStateProperty<Color?>>(
        'overlayColor', overlayColor));
    properties.add(DiagnosticsProperty<BoxDecoration>(
        'thumbDecoration', thumbDecoration,
        showName: false));
    properties.add(EnumProperty<SliderDirection>('direction', direction));
    properties.add(DoubleProperty('value', value));
    properties.add(IntProperty('divisions', divisions));
    properties.add(DoubleProperty('thumbPosition', thumbPosition));
    properties.add(IntProperty('thumbDivisions', thumbDivisions));
    properties.add(ObjectFlagProperty<ValueChanged<double>>.has(
        'onValueChanged', onValueChanged));
    properties.add(ObjectFlagProperty<ValueChanged<double>>.has(
        'onThumbPositionChanged', onThumbPositionChanged));
    properties
        .add(DiagnosticsProperty<MouseCursor>('mouseCursor', mouseCursor));
  }
}

class _CompareImgWidgetState extends State<CompareImgWidget>
    with SingleTickerProviderStateMixin {
  final GlobalKey _sliderKey = GlobalKey();

  // Action mapping for a focused slider.
  late Map<Type, Action<Intent>> _actionMap;

  // Keyboard mapping for a focused slider.
  static const Map<ShortcutActivator, Intent> _traditionalNavShortcutMap = {
    SingleActivator(LogicalKeyboardKey.arrowUp): _AdjustSliderIntent.up(),
    SingleActivator(LogicalKeyboardKey.arrowDown): _AdjustSliderIntent.down(),
    SingleActivator(LogicalKeyboardKey.arrowLeft): _AdjustSliderIntent.left(),
    SingleActivator(LogicalKeyboardKey.arrowRight): _AdjustSliderIntent.right(),
  };

  // Keyboard mapping for a focused slider when using directional navigation.
  // The vertical inputs are not handled to allow navigating out of the slider.
  static const Map<ShortcutActivator, Intent> _directionalNavShortcutMap = {
    SingleActivator(LogicalKeyboardKey.arrowLeft): _AdjustSliderIntent.left(),
    SingleActivator(LogicalKeyboardKey.arrowRight): _AdjustSliderIntent.right(),
  };

  // The focus node of the slider.
  late FocusNode _focusNode;

  // Handle a potential change in focusNode by properly disposing of the old one
  // and setting up the new one, if needed.
  void _updateFocusNode(FocusNode? old, FocusNode? current) {
    if ((old == null && current == null) || old == current) {
      return;
    }
    if (old == null) {
      _focusNode.dispose();
      _focusNode = current!;
    } else if (current == null) {
      _focusNode = FocusNode();
    } else {
      _focusNode = current;
    }
  }

  // Animation controller that is run when the overlay (a.k.a radial reaction)
  // is shown in response to user interaction.
  late AnimationController _overlayController;

  // The painter that draws the slider.
  late final SliderPainter _painter;

  bool get _enabled =>
      widget.onValueChanged != null || widget.onThumbPositionChanged != null;

  // The current rect of the thumb.
  //
  // This is used to determine if the thumb is getting hovered by the mouse.
  Rect? _thumbRect;

  void _onHover(PointerHoverEvent event) {
    final isThumbHovered = _thumbRect?.contains(event.localPosition);
    if (isThumbHovered == null) return;

    if (_enabled && isThumbHovered) {
      // Only show overlay when pointer is hovering the thumb.
      _overlayController.forward();
    } else {
      // Only remove overlay when Slider is unfocused.
      if (!_focused) {
        _overlayController.reverse();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _overlayController = AnimationController(
      duration: kRadialReactionDuration,
      vsync: this,
    );
    _painter = SliderPainter(
      overlayAnimation: CurvedAnimation(
        parent: _overlayController,
        curve: Curves.fastOutSlowIn,
      ),
      onThumbRectChanged: (thumbRect) {
        _thumbRect = thumbRect;
      },
    );
    _actionMap = <Type, Action<Intent>>{
      _AdjustSliderIntent: CallbackAction<_AdjustSliderIntent>(
        onInvoke: _actionHandler,
      ),
    };
    // Only create a new node if the widget doesn't have one.
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void didUpdateWidget(covariant CompareImgWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateFocusNode(oldWidget.focusNode, widget.focusNode);
  }

  @override
  void dispose() {
    _painter.dispose();
    _overlayController.dispose();
    super.dispose();
  }

  void _handleValueChanged(double value) {
    assert(widget.onValueChanged != null);
    if (value != widget.value) {
      widget.onValueChanged!(value);
      _focusNode.requestFocus();
    }
  }

  void _handleThumbPositionChanged(double value) {
    assert(widget.onThumbPositionChanged != null);
    if (value != widget.thumbPosition) {
      widget.onThumbPositionChanged!(value);
      _focusNode.requestFocus();
    }
  }

  void _actionHandler(_AdjustSliderIntent intent) {
    final slider = _sliderKey.currentState as _TwoDirectionalSliderState;
    final TextDirection textDirection = Directionality.of(context);
    switch (intent.type) {
      case _SliderAdjustmentType.right:
        switch (textDirection) {
          case TextDirection.rtl:
            return slider._decreaseHorizontalAction();
          case TextDirection.ltr:
            return slider._increaseHorizontalAction();
        }
      case _SliderAdjustmentType.left:
        switch (textDirection) {
          case TextDirection.rtl:
            return slider._increaseHorizontalAction();
          case TextDirection.ltr:
            return slider._decreaseHorizontalAction();
        }

      case _SliderAdjustmentType.up:
        return slider._decreaseVerticalAction();
      case _SliderAdjustmentType.down:
        return slider._increaseVerticalAction();
    }
  }

  bool _hovering = false;

  void _handleHoverChanged(bool hovering) {
    if (hovering != _hovering) {
      setState(() => _hovering = hovering);
    }
  }

  bool _focused = false;

  void _handleFocusHighlightChanged(bool focused) {
    if (focused != _focused) {
      setState(() => _focused = focused);
      if (focused) {
        _overlayController.forward();
      } else {
        _overlayController.reverse();
      }
    }
  }

  bool _dragging = false;

  void _handleDragStart(double _) {
    if (_dragging) return;
    setState(() => _dragging = true);
  }

  void _handleDragEnd(double _) {
    if (!_dragging) return;
    setState(() => _dragging = false);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final beforeAfterTheme = BeforeAfterTheme.of(context);
    final defaults = theme.useMaterial3
        ? _BeforeAfterDefaultsM3(context)
        : _BeforeAfterDefaultsM2(context);

    final effectiveTrackWidth = widget.trackWidth ??
        beforeAfterTheme.trackWidth ??
        defaults.trackWidth!;

    final effectiveTrackColor = widget.trackColor ??
        beforeAfterTheme.trackColor ??
        defaults.trackColor!;

    final effectiveThumbHeight = widget.thumbHeight ??
        beforeAfterTheme.thumbHeight ??
        defaults.thumbHeight!;

    final effectiveThumbWidth = widget.thumbWidth ??
        beforeAfterTheme.thumbWidth ??
        defaults.thumbWidth!;

    final effectiveThumbDecoration = (widget.thumbDecoration ??
        beforeAfterTheme.thumbDecoration ??
        defaults.thumbDecoration!)
        .copyWith(color: widget.thumbColor);

    final isXAxis = widget.direction == SliderDirection.horizontal;

    final onHorizontalChanged =
    widget.onValueChanged != null ? _handleValueChanged : null;

    final onVerticalChanged = widget.onThumbPositionChanged != null
        ? _handleThumbPositionChanged
        : null;

    final before = SizedBox(
        width: widget.width, height: widget.height, child: widget.before);

    final after = SizedBox(
        width: widget.width, height: widget.height, child: widget.after);

    final Map<ShortcutActivator, Intent> shortcutMap;
    switch (MediaQuery.navigationModeOf(context)) {
      case NavigationMode.directional:
        shortcutMap = _directionalNavShortcutMap;
        break;
      case NavigationMode.traditional:
        shortcutMap = _traditionalNavShortcutMap;
        break;
    }

    final states = {
      if (!_enabled) WidgetState.disabled,
      if (_focused) WidgetState.focused,
      if (_hovering) WidgetState.hovered,
      if (_dragging) WidgetState.dragged,
    };

    final effectiveOverlayColor = widget.overlayColor?.resolve(states) ??
        widget.trackColor?.withOpacity(0.12) ??
        WidgetStateProperty.resolveAs<Color?>(
            beforeAfterTheme.overlayColor, states) ??
        WidgetStateProperty.resolveAs<Color>(defaults.overlayColor!, states);

    final effectiveMouseCursor =
        WidgetStateProperty.resolveAs(widget.mouseCursor, states) ??
            beforeAfterTheme.mouseCursor?.resolve(states) ??
            WidgetStateMouseCursor.clickable.resolve(states);

    VoidCallback? handleDidGainAccessibilityFocus;
    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.iOS:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
        break;
      case TargetPlatform.windows:
        handleDidGainAccessibilityFocus = () {
          // Automatically activate the slider when it receives a11y focus.
          if (!_focusNode.hasFocus && _focusNode.canRequestFocus) {
            _focusNode.requestFocus();
          }
        };
    }

    return Semantics(
      container: true,
      slider: true,
      onDidGainAccessibilityFocus: handleDidGainAccessibilityFocus,
      child: MouseRegion(
        // Only used because we want to show the overlay when the mouse is
        // hovering the thumb. This is not possible with FocusableActionDetector
        // because it does not provides `PointerHoverEvent`.
        onHover: _onHover,
        child: FocusableActionDetector(
          actions: _actionMap,
          shortcuts: shortcutMap,
          focusNode: _focusNode,
          autofocus: widget.autofocus,
          onShowFocusHighlight: _handleFocusHighlightChanged,
          onShowHoverHighlight: _handleHoverChanged,
          mouseCursor: effectiveMouseCursor,
          child: TwoDirectionalSlider(
            key: _sliderKey,
            initialHorizontalValue: widget.value,
            initialVerticalValue: widget.thumbPosition,
            verticalDivisions:
            isXAxis ? widget.thumbDivisions : widget.divisions,
            horizontalDivisions:
            isXAxis ? widget.divisions : widget.thumbDivisions,
            onVerticalChangeStart: _handleDragStart,
            onVerticalChanged:
            isXAxis ? onVerticalChanged : onHorizontalChanged,
            onVerticalChangeEnd: _handleDragEnd,
            onHorizontalChangeStart: _handleDragStart,
            onHorizontalChanged:
            isXAxis ? onHorizontalChanged : onVerticalChanged,
            onHorizontalChangeEnd: _handleDragEnd,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                before,
                ClipRect(
                  clipper: RectClipper(
                    direction: widget.direction,
                    clipFactor: widget.value,
                  ),
                  child: after,
                ),
                CustomPaint(
                  painter: _painter
                    ..axis = widget.direction
                    ..value = widget.value
                    ..trackWidth = effectiveTrackWidth
                    ..trackColor = effectiveTrackColor
                    ..hideThumb = widget.hideThumb
                    ..thumbValue = widget.thumbPosition
                    ..thumbHeight = effectiveThumbHeight
                    ..thumbWidth = effectiveThumbWidth
                    ..overlayColor = effectiveOverlayColor
                    ..configuration = createLocalImageConfiguration(context)
                    ..thumbDecoration = effectiveThumbDecoration,
                  child: Hide(child: after),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A widget that hides its child widget from being visible.
class Hide extends StatelessWidget {
  /// Creates a [Hide] widget with the specified child.
  const Hide({
    super.key,
    required this.child,
  });

  /// The child widget to be hidden.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: false,
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      child: child,
    );
  }
}

class _AdjustSliderIntent extends Intent {
  const _AdjustSliderIntent({required this.type});

  const _AdjustSliderIntent.right() : type = _SliderAdjustmentType.right;

  const _AdjustSliderIntent.left() : type = _SliderAdjustmentType.left;

  const _AdjustSliderIntent.up() : type = _SliderAdjustmentType.up;

  const _AdjustSliderIntent.down() : type = _SliderAdjustmentType.down;

  final _SliderAdjustmentType type;
}

enum _SliderAdjustmentType { right, left, up, down }

class _BeforeAfterDefaultsM2 extends BeforeAfterTheme {
  _BeforeAfterDefaultsM2(BuildContext context)
      : _colors = Theme.of(context).colorScheme,
        super(trackWidth: 6.0, thumbWidth: 24.0, thumbHeight: 24.0);

  final ColorScheme _colors;

  @override
  Color get trackColor => _colors.primary;

  @override
  Color get overlayColor => _colors.primary.withOpacity(0.12);

  @override
  BoxDecoration get thumbDecoration {
    return BoxDecoration(
      color: trackColor,
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: _defaultThumbElevation,
          spreadRadius: _defaultThumbElevation / 2,
          offset: const Offset(0, _defaultThumbElevation / 2),
        ),
      ],
    );
  }
}

class _BeforeAfterDefaultsM3 extends BeforeAfterTheme {
  _BeforeAfterDefaultsM3(BuildContext context)
      : _colors = Theme.of(context).colorScheme,
        super(trackWidth: 6.0, thumbWidth: 24.0, thumbHeight: 24.0);

  final ColorScheme _colors;

  @override
  Color get trackColor => _colors.primary;

  @override
  Color get overlayColor {
    return WidgetStateColor.resolveWith((states) {
      if (states.contains(WidgetState.hovered)) {
        return _colors.primary.withOpacity(0.08);
      }
      if (states.contains(WidgetState.focused)) {
        return _colors.primary.withOpacity(0.12);
      }
      if (states.contains(WidgetState.dragged)) {
        return _colors.primary.withOpacity(0.12);
      }

      return Colors.transparent;
    });
  }

  @override
  BoxDecoration get thumbDecoration {
    return BoxDecoration(
      color: trackColor,
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: _defaultThumbElevation,
          spreadRadius: _defaultThumbElevation / 2,
          offset: const Offset(0, _defaultThumbElevation / 2),
        ),
      ],
    );
  }
}

/// A widget that allows interactive two-directional sliding gestures.
///
/// The `TwoDirectionalSlider` widget wraps a child widget and allows users to perform sliding gestures
/// both vertically and horizontally. It can be configured with callbacks to notify the parent widget
/// about the changes in the vertical and horizontal values.
///
/// The vertical sliding gesture is handled through the [onVerticalChanged] callback, which receives
/// a [double] value representing the current vertical position. The [verticalDivisions] property can
/// be used to discretize the vertical values into a specified number of divisions.
///
/// The horizontal sliding gesture is handled through the [onHorizontalChanged] callback, which receives
/// a [double] value representing the current horizontal position. The [horizontalDivisions] property can
/// be used to discretize the horizontal values into a specified number of divisions.
///
/// Example usage:
///
/// ```dart
/// TwoDirectionalSlider(
///   onVerticalChanged: (value) {
///     // Handle vertical value changes
///   },
///   onHorizontalChanged: (value) {
///     // Handle horizontal value changes
///   },
///   child: Container(
///     // Child widget
///   ),
/// )
/// ```
class TwoDirectionalSlider extends StatefulWidget {
  /// Creates a two-directional slider.
  ///
  /// The [child] parameter must not be null.
  const TwoDirectionalSlider({
    super.key,
    required this.child,
    this.initialVerticalValue = 0.0,
    this.initialHorizontalValue = 0.0,
    this.onVerticalChangeStart,
    this.onVerticalChanged,
    this.onVerticalChangeEnd,
    this.verticalDivisions,
    this.onHorizontalChangeStart,
    this.onHorizontalChanged,
    this.onHorizontalChangeEnd,
    this.horizontalDivisions,
  });

  /// The child widget wrapped by the slider.
  final Widget child;

  /// The initial vertical drag value.
  final double initialVerticalValue;

  /// The initial horizontal drag value.
  final double initialHorizontalValue;

  /// Called when the vertical value starts changing.
  final ValueChanged<double>? onVerticalChangeStart;

  /// Called when the vertical value changes.
  final ValueChanged<double>? onVerticalChanged;

  /// Called when the vertical value stops changing.
  final ValueChanged<double>? onVerticalChangeEnd;

  /// The number of divisions to discretize the vertical values.
  ///
  /// If null, the vertical values are continuous.
  final int? verticalDivisions;

  /// Called when the horizontal value starts changing.
  final ValueChanged<double>? onHorizontalChangeStart;

  /// Called when the horizontal value changes.
  final ValueChanged<double>? onHorizontalChanged;

  /// Called when the horizontal value stops changing.
  final ValueChanged<double>? onHorizontalChangeEnd;

  /// The number of divisions to discretize the horizontal values.
  ///
  /// If null, the horizontal values are continuous.
  final int? horizontalDivisions;

  @override
  State<TwoDirectionalSlider> createState() => _TwoDirectionalSliderState();
}

class _TwoDirectionalSliderState extends State<TwoDirectionalSlider> {
  late double _currentVerticalDragValue;
  late double _currentHorizontalDragValue;

  bool _active = false;

  double _convertVerticalValue(double value) {
    if (widget.verticalDivisions != null) {
      return _discretizeVertical(value);
    }
    return value;
  }

  double _convertHorizontalValue(double value) {
    if (widget.horizontalDivisions != null) {
      return _discretizeHorizontal(value);
    }
    return value;
  }

  @override
  void initState() {
    super.initState();
    _currentVerticalDragValue =
        _convertVerticalValue(widget.initialVerticalValue);
    _currentHorizontalDragValue =
        _convertHorizontalValue(widget.initialHorizontalValue);
  }

  @override
  void didUpdateWidget(covariant TwoDirectionalSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialVerticalValue != widget.initialVerticalValue) {
      _currentVerticalDragValue =
          _convertVerticalValue(widget.initialVerticalValue);
    }
    if (oldWidget.initialHorizontalValue != widget.initialHorizontalValue) {
      _currentHorizontalDragValue =
          _convertHorizontalValue(widget.initialHorizontalValue);
    }
  }

  /// Returns true if the vertical sliding is interactive.
  bool get isVerticalInteractive => widget.onVerticalChanged != null;

  /// Returns true if the horizontal sliding is interactive.
  bool get isHorizontalInteractive => widget.onHorizontalChanged != null;

  /// Returns true if the slider is interactive.
  bool get isInteractive => isVerticalInteractive || isHorizontalInteractive;

  /// Converts the visual position to a value based on the text direction.
  double _getValueFromVisualPosition(double visualPosition) {
    final textDirection = Directionality.of(context);
    switch (textDirection) {
      case TextDirection.rtl:
        return 1.0 - visualPosition;
      case TextDirection.ltr:
        return visualPosition;
    }
  }

  /// Converts the local position to a vertical value.
  double _getVerticalValueFromLocalPosition(Offset globalPosition) {
    final box = context.findRenderObject() as RenderBox;
    final localPosition = box.globalToLocal(globalPosition);
    final visualPosition = localPosition.dy / box.size.height;
    return _getValueFromVisualPosition(visualPosition);
  }

  /// Converts the local position to a horizontal value.
  double _getHorizontalValueFromLocalPosition(Offset globalPosition) {
    final box = context.findRenderObject() as RenderBox;
    final localPosition = box.globalToLocal(globalPosition);
    final visualPosition = localPosition.dx / box.size.width;
    return _getValueFromVisualPosition(visualPosition);
  }

  /// Discretizes the vertical value based on the number of divisions.
  double _discretizeVertical(double value) {
    double result = clampDouble(value, 0.0, 1.0);
    if (widget.verticalDivisions != null) {
      final divisions = widget.verticalDivisions!;
      result = (result * divisions).round() / divisions;
    }
    return result;
  }

  /// Discretizes the horizontal value based on the number of divisions.
  double _discretizeHorizontal(double value) {
    double result = clampDouble(value, 0.0, 1.0);
    if (widget.horizontalDivisions != null) {
      final divisions = widget.horizontalDivisions!;
      result = (result * divisions).round() / divisions;
    }
    return result;
  }

  void _updateAndCallHorizontalChanged(double value) {
    _currentHorizontalDragValue = value;
    widget.onHorizontalChanged?.call(value);
    // _focusNode.requestFocus();
  }

  void _updateAndCallVerticalChanged(double value) {
    _currentVerticalDragValue = value;
    widget.onVerticalChanged?.call(value);
    // _focusNode.requestFocus();
  }

  void _startInteraction(Offset globalPosition) {
    if (!_active && isInteractive) {
      _active = true;
      // We supply the *current* value as the start location, so that if we have
      // a tap, it consists of a call to onChangeStart with the previous value and
      // a call to onChangeEnd with the new value.
      final vValue = _discretizeVertical(_currentVerticalDragValue);
      widget.onVerticalChangeStart?.call(vValue);

      final hValue = _discretizeHorizontal(_currentHorizontalDragValue);
      widget.onHorizontalChangeStart?.call(hValue);

      return _handleGesture(globalPosition);
    }
  }

  void _endInteraction() {
    if (!mounted) return;

    if (_active && mounted) {
      final vValue = _discretizeVertical(_currentVerticalDragValue);
      widget.onVerticalChangeEnd?.call(vValue);

      final hValue = _discretizeHorizontal(_currentHorizontalDragValue);
      widget.onHorizontalChangeEnd?.call(hValue);

      _active = false;
    }
  }

  void _onTapDown(TapDownDetails details) =>
      _startInteraction(details.globalPosition);

  void _onTapUp(TapUpDetails details) => _endInteraction();

  void _onPanStart(DragStartDetails details) =>
      _startInteraction(details.globalPosition);

  /// Handles the pan update gesture.
  void _onPanUpdate(DragUpdateDetails details) =>
      _handleGesture(details.globalPosition);

  void _onPanEnd(DragEndDetails details) => _endInteraction();

  /// Handles the sliding gesture.
  void _handleGesture(Offset globalPosition) {
    if (!mounted) return;

    if (isVerticalInteractive) {
      final value = _getVerticalValueFromLocalPosition(globalPosition);
      _updateAndCallVerticalChanged(_discretizeVertical(value));
    }

    if (isHorizontalInteractive) {
      final value = _getHorizontalValueFromLocalPosition(globalPosition);
      _updateAndCallHorizontalChanged(_discretizeHorizontal(value));
    }
  }

  double get _adjustmentUnit {
    final platform = Theme.of(context).platform;
    switch (platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      // Matches iOS implementation of material slider.
        return 0.1;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
      // Matches Android implementation of material slider.
        return 0.05;
    }
  }

  double get _semanticHorizontalActionUnit {
    final divisions = widget.horizontalDivisions;
    return divisions != null ? 1.0 / divisions : _adjustmentUnit;
  }

  double get _semanticVerticalActionUnit {
    final divisions = widget.verticalDivisions;
    return divisions != null ? 1.0 / divisions : _adjustmentUnit;
  }

  void _increaseHorizontalAction() {
    if (isHorizontalInteractive) {
      final value = _currentHorizontalDragValue;
      _updateAndCallHorizontalChanged(
        clampDouble(value + _semanticHorizontalActionUnit, 0.0, 1.0),
      );
    }
  }

  void _decreaseHorizontalAction() {
    if (isHorizontalInteractive) {
      final value = _currentHorizontalDragValue;
      _updateAndCallHorizontalChanged(
        clampDouble(value - _semanticHorizontalActionUnit, 0.0, 1.0),
      );
    }
  }

  void _increaseVerticalAction() {
    if (isVerticalInteractive) {
      final value = _currentVerticalDragValue;
      _updateAndCallVerticalChanged(
        clampDouble(value + _semanticVerticalActionUnit, 0.0, 1.0),
      );
    }
  }

  void _decreaseVerticalAction() {
    if (isVerticalInteractive) {
      final value = _currentVerticalDragValue;
      _updateAndCallVerticalChanged(
        clampDouble(value - _semanticVerticalActionUnit, 0.0, 1.0),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      child: widget.child,
    );
  }
}

/// A theme extension class that defines custom styling and behavior for the
/// BeforeAfter widget.
///
/// Use the `BeforeAfterTheme` to customize the appearance and behavior of
/// the BeforeAfter widget throughout your app. The theme properties can be
/// accessed using `BeforeAfterTheme.of(context)`. By default, the theme's
/// properties will be used. To override specific properties, use the
/// `BeforeAfterThemeData.copyWith` method to create a new instance of the
/// theme with the desired changes.
///
/// See also:
///
///   * [BeforeAfterThemeData], which is used to define the actual theme data.
///   * [CompareImgWidget], which uses the `BeforeAfterTheme` to apply the styling
///     defined in the theme data.
class BeforeAfterTheme extends ThemeExtension<BeforeAfterTheme>
    with DiagnosticableTreeMixin {
  /// Creates a BeforeAfterTheme.
  ///
  /// The [trackWidth], [trackColor], [thumbHeight], [thumbWidth], [overlayColor],
  /// [thumbDecoration], and [mouseCursor] parameters can be used to customize
  /// the appearance and behavior of the theme.
  const BeforeAfterTheme({
    this.trackWidth,
    this.trackColor,
    this.thumbHeight,
    this.thumbWidth,
    this.overlayColor,
    this.thumbDecoration,
    this.mouseCursor,
  });

  /// The width of the track.
  final double? trackWidth;

  /// The color of the track.
  final Color? trackColor;

  /// The height of the thumb.
  final double? thumbHeight;

  /// The width of the thumb.
  final double? thumbWidth;

  /// The color of the overlay.
  final Color? overlayColor;

  /// The decoration of the thumb.
  final BoxDecoration? thumbDecoration;

  /// {@macro flutter.material.slider.mouseCursor}
  ///
  /// If specified, overrides the default value of [Slider.mouseCursor].
  final WidgetStateProperty<MouseCursor?>? mouseCursor;

  /// Returns the closest [BeforeAfterTheme] instance given the [context].
  static BeforeAfterTheme of(BuildContext context) {
    final theme = Theme.of(context).extension<BeforeAfterTheme>();
    return theme ?? const BeforeAfterTheme();
  }

  @override
  ThemeExtension<BeforeAfterTheme> copyWith({
    double? trackWidth,
    Color? trackColor,
    double? thumbHeight,
    double? thumbWidth,
    Color? overlayColor,
    BoxDecoration? thumbDecoration,
    WidgetStateProperty<MouseCursor?>? mouseCursor,
  }) {
    return BeforeAfterTheme(
      trackWidth: trackWidth ?? this.trackWidth,
      trackColor: trackColor ?? this.trackColor,
      thumbHeight: thumbHeight ?? this.thumbHeight,
      thumbWidth: thumbWidth ?? this.thumbWidth,
      overlayColor: overlayColor ?? this.overlayColor,
      thumbDecoration: thumbDecoration ?? this.thumbDecoration,
      mouseCursor: mouseCursor ?? this.mouseCursor,
    );
  }

  @override
  ThemeExtension<BeforeAfterTheme> lerp(
      covariant BeforeAfterTheme? other,
      double t,
      ) {
    return BeforeAfterTheme(
      trackWidth: lerpDouble(trackWidth, other?.trackWidth, t),
      trackColor: Color.lerp(trackColor, other?.trackColor, t),
      thumbHeight: lerpDouble(thumbHeight, other?.thumbHeight, t),
      thumbWidth: lerpDouble(thumbWidth, other?.thumbWidth, t),
      overlayColor: Color.lerp(overlayColor, other?.overlayColor, t),
      thumbDecoration: BoxDecoration.lerp(
        thumbDecoration,
        other?.thumbDecoration,
        t,
      ),
      mouseCursor: t < 0.5 ? mouseCursor : other?.mouseCursor,
    );
  }

  @override
  int get hashCode =>
      trackWidth.hashCode ^
      trackColor.hashCode ^
      thumbHeight.hashCode ^
      thumbWidth.hashCode ^
      overlayColor.hashCode ^
      thumbDecoration.hashCode ^
      mouseCursor.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is BeforeAfterTheme &&
              runtimeType == other.runtimeType &&
              trackWidth == other.trackWidth &&
              trackColor == other.trackColor &&
              thumbHeight == other.thumbHeight &&
              thumbWidth == other.thumbWidth &&
              overlayColor == other.overlayColor &&
              thumbDecoration == other.thumbDecoration &&
              mouseCursor == other.mouseCursor;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('trackWidth', trackWidth));
    properties.add(ColorProperty('trackColor', trackColor));
    properties.add(DoubleProperty('thumbHeight', thumbHeight));
    properties.add(DoubleProperty('thumbWidth', thumbWidth));
    properties.add(ColorProperty('overlayColor', overlayColor));
    properties.add(
      DiagnosticsProperty<BoxDecoration>('thumbDecoration', thumbDecoration),
    );
    properties.add(DiagnosticsProperty<WidgetStateProperty<MouseCursor?>>(
        'mouseCursor', mouseCursor));
  }
}

/// A custom clipper that clips a rectangular region based on the provided direction and clip factor.
///
/// The [RectClipper] is used to clip a rectangular region within a widget.
/// The clipping can be controlled by specifying the [direction] and [clipFactor].
///
/// The [direction] determines the direction of clipping and can be either [SliderDirection.horizontal] or [SliderDirection.vertical].
/// For the horizontal direction, the clipping width is calculated as the product of the widget's width and the [clipFactor].
/// For the vertical direction, the clipping height is calculated as the product of the widget's height and the [clipFactor].
///
/// The [clipFactor] specifies the fraction of the widget's size that should be clipped.
/// It should be a value between 0.0 and 1.0, where 0.0 indicates no clipping and 1.0 indicates full clipping.
class RectClipper extends CustomClipper<Rect> {
  /// Creates a [RectClipper] with the specified direction and clip factor.
  const RectClipper({
    required this.direction,
    required this.clipFactor,
  });

  /// The direction in which the clipping should occur.
  final SliderDirection direction;

  /// The fraction of the widget's size to be clipped.
  final double clipFactor;

  @override
  Rect getClip(Size size) {
    final rect = Rect.fromLTWH(
      0.0,
      0.0,
      direction == SliderDirection.horizontal
          ? size.width * clipFactor
          : size.width,
      direction == SliderDirection.vertical
          ? size.height * clipFactor
          : size.height,
    );

    return rect;
  }

  @override
  bool shouldReclip(RectClipper oldClipper) =>
      oldClipper.clipFactor != clipFactor || oldClipper.direction != direction;
}

/// A custom painter for rendering a slider.
///
/// The `SliderPainter` class is a custom painter that renders a slider with a track and a thumb.
/// It extends the [ChangeNotifier] class and implements the [CustomPainter] class.
///
/// The slider can be configured with various properties such as the axis (horizontal or vertical),
/// the current value, track width and color, thumb size and decoration, and more.
///
/// Example usage:
///
/// ```dart
/// SliderPainter painter = SliderPainter(
///   overlayAnimation: AnimationController(
///     vsync: this,
///     duration: Duration(milliseconds: 100),
///   ),
/// );
/// painter.axis = SliderAxis.horizontal;
/// painter.value = 0.5;
/// painter.trackWidth = 4.0;
/// painter.trackColor = Colors.grey;
/// painter.thumbValue = 0.5;
/// painter.thumbWidth = 20.0;
/// painter.thumbHeight = 40.0;
/// painter.thumbDecoration = BoxDecoration(
///   color: Colors.blue,
///   shape: BoxShape.circle,
/// );
///
/// CustomPaint(
///   painter: painter,
///   child: Container(
///     // Child widget
///   ),
/// )
/// ```
class SliderPainter extends ChangeNotifier implements CustomPainter {
  /// Creates a slider painter.
  SliderPainter({
    required Animation<double> overlayAnimation,
    ValueSetter<Rect>? onThumbRectChanged,
  })  : _overlayAnimation = overlayAnimation,
        _onThumbRectChanged = onThumbRectChanged {
    _overlayAnimation.addListener(notifyListeners);
  }

  /// The animation of the thumb overlay.
  final Animation<double> _overlayAnimation;

  /// Callback to notify when the thumb rect changes.
  final ValueSetter<Rect>? _onThumbRectChanged;

  /// The axis of the slider.
  SliderDirection get axis => _axis!;
  SliderDirection? _axis;

  set axis(SliderDirection value) {
    if (_axis != value) {
      _axis = value;
      notifyListeners();
    }
  }

  /// The current value of the slider.
  double get value => _value!;
  double? _value;

  set value(double value) {
    if (_value != value) {
      _value = value;
      notifyListeners();
    }
  }

  /// The width of the track.
  double get trackWidth => _trackWidth!;
  double? _trackWidth;

  set trackWidth(double value) {
    if (_trackWidth != value) {
      _trackWidth = value;
      notifyListeners();
    }
  }

  /// The color of the track.
  Color get trackColor => _trackColor!;
  Color? _trackColor;

  set trackColor(Color value) {
    if (_trackColor != value) {
      _trackColor = value;
      notifyListeners();
    }
  }

  /// The value of the thumb.
  double get thumbValue => _thumbValue!;
  double? _thumbValue;

  set thumbValue(double value) {
    if (_thumbValue != value) {
      _thumbValue = value;
      notifyListeners();
    }
  }

  /// The width of the thumb.
  double get thumbWidth => _thumbWidth!;
  double? _thumbWidth;

  set thumbWidth(double value) {
    if (_thumbWidth != value) {
      _thumbWidth = value;
      notifyListeners();
    }
  }

  /// The height of the thumb.
  double get thumbHeight => _thumbHeight!;
  double? _thumbHeight;

  set thumbHeight(double value) {
    if (_thumbHeight != value) {
      _thumbHeight = value;
      notifyListeners();
    }
  }

  /// The color of the thumb overlay.
  Color get overlayColor => _overlayColor!;
  Color? _overlayColor;

  set overlayColor(Color value) {
    if (_overlayColor != value) {
      _overlayColor = value;
      notifyListeners();
    }
  }

  /// The decoration of the thumb.
  BoxDecoration get thumbDecoration => _thumbDecoration!;
  BoxDecoration? _thumbDecoration;

  set thumbDecoration(BoxDecoration? value) {
    if (_thumbDecoration != value) {
      _thumbDecoration = value;

      // Dispose and reset the thumb painter if it exists.
      _thumbPainter?.dispose();
      _thumbPainter = null;

      notifyListeners();
    }
  }

  /// The image configuration for the thumb.
  ImageConfiguration get configuration => _configuration!;
  ImageConfiguration? _configuration;

  set configuration(ImageConfiguration value) {
    if (_configuration != value) {
      _configuration = value;
      notifyListeners();
    }
  }

  /// Whether to hide the thumb.
  bool get hideThumb => _hideThumb!;
  bool? _hideThumb;

  set hideThumb(bool value) {
    if (_hideThumb != value) {
      _hideThumb = value;
      notifyListeners();
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Clip the canvas to the size of the slider so that we don't draw outside.
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final isHorizontal = axis == SliderDirection.horizontal;

    final trackPaint = Paint()
      ..color = trackColor
      ..strokeWidth = trackWidth;

    // If the thumb is hidden, draw a straight line.
    if (hideThumb) {
      return canvas.drawLine(
        Offset(
          isHorizontal ? size.width * value : 0.0,
          isHorizontal ? 0.0 : size.height * value,
        ),
        Offset(
          isHorizontal ? size.width * value : size.width,
          isHorizontal ? size.height : size.height * value,
        ),
        trackPaint,
      );
    }

    // Draw track (first and second half).
    canvas
      ..drawLine(
        Offset(
          isHorizontal ? size.width * value : 0.0,
          isHorizontal ? 0.0 : size.height * value,
        ),
        Offset(
          isHorizontal
              ? size.width * value
              : size.width * thumbValue - (thumbHeight / 2),
          isHorizontal
              ? size.height * thumbValue - (thumbHeight / 2)
              : size.height * value,
        ),
        trackPaint,
      )
      ..drawLine(
        Offset(
          isHorizontal
              ? size.width * value
              : size.width * thumbValue + thumbHeight / 2,
          isHorizontal
              ? size.height * thumbValue + thumbHeight / 2
              : size.height * value,
        ),
        Offset(
          isHorizontal ? size.width * value : size.width,
          isHorizontal ? size.height : size.height * value,
        ),
        trackPaint,
      );

    // Calculate the thumb rect.
    final thumbRect = Rect.fromCenter(
      center: Offset(
        isHorizontal ? size.width * value : size.width * thumbValue,
        isHorizontal ? size.height * thumbValue : size.height * value,
      ),
      width: isHorizontal ? thumbWidth : thumbHeight,
      height: isHorizontal ? thumbHeight : thumbWidth,
    );

    // Notify the listener of the thumb rect.
    _onThumbRectChanged?.call(thumbRect);

    // Draw the thumb overlay.
    if (!_overlayAnimation.isDismissed) {
      const lengthMultiplier = 2;

      final overlayRect = Rect.fromCenter(
        center: thumbRect.center,
        width: thumbRect.width * lengthMultiplier * _overlayAnimation.value,
        height: thumbRect.height * lengthMultiplier * _overlayAnimation.value,
      );

      // Draw the overlay.
      _drawOverlay(canvas, overlayRect);
    }

    // Draw the thumb.
    _drawThumb(canvas, thumbRect);
  }

  void _drawOverlay(Canvas canvas, Rect overlayRect) {
    Path? overlayPath;
    switch (thumbDecoration.shape) {
      case BoxShape.circle:
        assert(thumbDecoration.borderRadius == null);
        final Offset center = overlayRect.center;
        final double radius = overlayRect.shortestSide / 2.0;
        final Rect square = Rect.fromCircle(center: center, radius: radius);
        overlayPath = Path()..addOval(square);
        break;
      case BoxShape.rectangle:
        if (thumbDecoration.borderRadius == null ||
            thumbDecoration.borderRadius == BorderRadius.zero) {
          overlayPath = Path()..addRect(overlayRect);
        } else {
          overlayPath = Path()
            ..addRRect(thumbDecoration.borderRadius!
                .resolve(configuration.textDirection)
                .toRRect(overlayRect));
        }
        break;
    }

    canvas.drawPath(overlayPath, Paint()..color = overlayColor);
  }

  bool _isPainting = false;

  void _handleThumbChange() {
    // If the thumb decoration is available synchronously, we'll get called here
    // during paint. There's no reason to mark ourselves as needing paint if we
    // are already in the middle of painting. (In fact, doing so would trigger
    // an assert).
    if (!_isPainting) {
      notifyListeners();
    }
  }

  BoxPainter? _thumbPainter;

  void _drawThumb(Canvas canvas, Rect thumbRect) {
    try {
      _isPainting = true;
      if (_thumbPainter == null) {
        _thumbPainter?.dispose();
        _thumbPainter = thumbDecoration.createBoxPainter(_handleThumbChange);
      }
      final config = configuration.copyWith(size: thumbRect.size);
      _thumbPainter!.paint(canvas, thumbRect.topLeft, config);
    } finally {
      _isPainting = false;
    }
  }

  @override
  void dispose() {
    _thumbPainter?.dispose();
    _thumbPainter = null;
    _overlayAnimation.removeListener(notifyListeners);
    super.dispose();
  }

  @override
  bool shouldRepaint(covariant SliderPainter oldDelegate) => false;

  @override
  bool? hitTest(Offset position) => null;

  @override
  SemanticsBuilderCallback? get semanticsBuilder => null;

  @override
  bool shouldRebuildSemantics(covariant CustomPainter oldDelegate) => false;

  @override
  String toString() => describeIdentity(this);
}
