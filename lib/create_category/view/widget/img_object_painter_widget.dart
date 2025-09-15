import 'package:flutter/material.dart';
import 'package:image_enhancer_app/create_category/view/widget/img_widget.dart';
import 'package:image_enhancer_app/create_category/view_model/model/stroke_model.dart';
import 'package:image_enhancer_app/utils/enum/img_type.dart';
import 'package:image_enhancer_app/utils/extension/common_extension.dart';
import 'package:image_enhancer_app/utils/extension/widget_extension.dart';

class ImgObjectPainterWidget extends StatelessWidget {
  final GlobalKey globalKey;
  final ValueNotifier<List<StrokeModel>> strokeNotifier;
  final ValueNotifier<List<StrokeModel>> undoStrokeNotifier;
  final ValueNotifier<double> brushSizeNotifier;
  final ImgType imgType;
  final String img;
  ImgObjectPainterWidget({super.key, required this.globalKey, required this.strokeNotifier, required this.undoStrokeNotifier, required this.brushSizeNotifier, required this.imgType, required this.img});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Wrap in RepaintBoundary
        RepaintBoundary(
          key: globalKey,
          child: GestureDetector(
            onPanStart: (details) {
              final newStroke = StrokeModel([details.localPosition], brushSizeNotifier.value);
              strokeNotifier.value = [...strokeNotifier.value, newStroke];
              undoStrokeNotifier.value = []; // clear redo history
            },
            onPanUpdate: (details) {
              final updatedStrokes = List<StrokeModel>.from(strokeNotifier.value);
              updatedStrokes.last.points =
              [...updatedStrokes.last.points, details.localPosition];
              strokeNotifier.value = updatedStrokes;
            },
            onPanEnd: (details) {
              final updatedStrokes = List<StrokeModel>.from(strokeNotifier.value);
              updatedStrokes.last.points =
              [...updatedStrokes.last.points, Offset.infinite];
              strokeNotifier.value = updatedStrokes;
            },
            child: Stack(
              children: [
                Positioned.fill(
                  child: ImgWidget(imgType: imgType, img: img, borderRadius: context.width(16.0).borderRadius, isInTerActive: true),
                ),
                Positioned.fill(
                  child: ValueListenableBuilder<List<StrokeModel>>(
                    valueListenable: strokeNotifier,
                    builder: (context, value, child) {
                      return CustomPaint(
                        painter: ImgObjectColorPainter(value),
                      );
                    },
                  ),
                ),
              ],
            ).clipRRect(borderRadius: context.width(16.0).borderRadius),
          ),
        )
      ],
    );
  }
}



// Painter
class ImgObjectColorPainter extends CustomPainter {
  final List<StrokeModel> strokes;
  ImgObjectColorPainter(this.strokes);

  @override
  void paint(Canvas canvas, Size size) {
    for (var stroke in strokes) {
      final paint = Paint()
        ..color = Color(0x1AFF2D2D)
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke.size
        ..strokeCap = StrokeCap.round;

      for (int i = 0; i < stroke.points.length - 1; i++) {
        if (stroke.points[i] != Offset.infinite &&
            stroke.points[i + 1] != Offset.infinite) {
          canvas.drawLine(stroke.points[i], stroke.points[i + 1], paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(ImgObjectColorPainter oldDelegate) => true;
}
