import 'package:flutter/material.dart';
import 'package:image_enhancer_app/splash/view/widget/text_widget.dart';
import 'package:image_enhancer_app/utils/constant/color.dart';
import 'package:image_enhancer_app/utils/constant/padding.dart';
import 'package:image_enhancer_app/utils/extension/common_extension.dart';
import 'package:image_enhancer_app/utils/extension/widget_extension.dart';

class ColorOptionWidget extends StatelessWidget {
  final ValueNotifier<int>? valueNotifier;
  final List<Map<String, dynamic>> data;
  final ScrollPhysics? physics;
  final Function(int index)? onPressed;
  const ColorOptionWidget({
    super.key,
    this.valueNotifier,
    required this.data,
    this.physics,
    this.onPressed});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<int> _valueNotifier = valueNotifier ?? ValueNotifier(0);
    return SizedBox(
      height: context.width(94.0),
      width: double.maxFinite,
      child: ValueListenableBuilder<int>(
        valueListenable: _valueNotifier,
        builder: (context, selectedIndex, _) {
          return ListView.separated(
            itemCount: data.length,
            scrollDirection: Axis.horizontal,
            padding: kZeroEdgeInsets,
            physics: physics,
            shrinkWrap: true,
            separatorBuilder: (context, index) => context.width(8.0).wMargin,
            itemBuilder: (context, index) {
              final ValueNotifier<double> sizeNotifier = ValueNotifier(1.0);
              return ValueListenableBuilder(
                  valueListenable: sizeNotifier,
                  builder: (context, value, child) {
                    return AnimatedScale(
                      scale: value,
                      duration: 100.millisecond,
                      child: Column(
                        children: [
                          Container(
                            width: context.width(72.0),
                            height: context.width(72.0),
                            padding: 1.0.allEdgeInsets,
                            child: Card(
                              elevation: .2,
                              shadowColor: kShadowColor,
                              surfaceTintColor: kWhiteColor,
                              margin: kZeroEdgeInsets,
                              color: kWhiteColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: context.width(14.0).borderRadius
                              ),
                              child: Material(
                                color: kTransparentColor,
                                borderRadius: context.width(14.0).borderRadius,
                                child: InkWell(
                                  borderRadius: context.width(14.0).borderRadius,
                                  onTapDown: (details) => sizeNotifier.value = 0.94,
                                  onTapUp: (details) {
                                    sizeNotifier.value = 1.0;
                                    _valueNotifier.value = index;
                                  },
                                  onTapCancel: () => sizeNotifier.value = 1.0,
                                  onTap: () {
                                    _valueNotifier.value = index;
                                    if(onPressed != null) onPressed!(index);
                                  },
                                  child: AnimatedContainer(
                                    duration: 100.millisecond,
                                    decoration: BoxDecoration(
                                        color: kWhiteColor,
                                        gradient: kBlueGradient,
                                        borderRadius: context.width(14.0).borderRadius,
                                        border: index != selectedIndex
                                            ? Border.all(color: kTransparentColor, width: .0)
                                            : Border.all(
                                            color: kTransparentColor,
                                            width: context.width(1.2))
                                    ),
                                    child: Container(
                                      width: double.maxFinite,
                                      height: double.maxFinite,
                                      decoration: BoxDecoration(
                                          color: data[index]["color"],
                                          borderRadius: context.width(14.0).borderRadius
                                      ),
                                    )
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if(data[index]["title"] != null) ...[
                            4.0.hMargin,
                            TextWidget(text: data[index]["title"], fontSize: 12.0)
                          ]
                        ]
                      )
                    );
                  }
              );
            },
          );
        },
      ),
    );
  }
}

