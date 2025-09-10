
import 'package:flutter/material.dart';
import 'package:image_enhancer_app/create_category/view/widget/img_widget.dart';
import 'package:image_enhancer_app/splash/view/widget/text_widget.dart';
import 'package:image_enhancer_app/utils/constant/color.dart';
import 'package:image_enhancer_app/utils/constant/image_path.dart';
import 'package:image_enhancer_app/utils/constant/padding.dart';
import 'package:image_enhancer_app/utils/enum/img_type.dart';
import 'package:image_enhancer_app/utils/extension/common_extension.dart';
import 'package:image_enhancer_app/utils/extension/widget_extension.dart';

class AttributeOptionWidget extends StatelessWidget {
  final ValueNotifier<int>? valueNotifier;
  final List<Map<String, dynamic>> data;
  final ImgType imgType;
  final ScrollPhysics? physics;
  final int? skipIndex;
  final Function(int index)? onPressed;

  const AttributeOptionWidget({
    super.key,
    this.valueNotifier,
    required this.data,
    required this.imgType,
    this.physics,
    this.skipIndex,
    this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<int> _valueNotifier = valueNotifier ?? ValueNotifier(0);
    return SizedBox(
      height: context.width(94.0),
      width: double.maxFinite,
      child: ListView.separated(
        itemCount: data.length,
        scrollDirection: Axis.horizontal,
        padding: kZeroEdgeInsets,
        shrinkWrap: true,
        physics: physics,
        separatorBuilder: (context, index) => context.width(8.0).wMargin,
        itemBuilder: (context, index) {
          final ValueNotifier<double> sizeNotifier = ValueNotifier(1.0);
          return ValueListenableBuilder(
            valueListenable: sizeNotifier,
            builder: (context, value, child) {
              return AnimatedScale(
                scale: value,
                duration: 100.millisecond,
                child: ValueListenableBuilder<int>(
                  valueListenable: _valueNotifier,
                  builder: (context, selectedIndex, child) {
                    return Column(
                      children: [
                        Container(
                          width: context.width(72.0),
                          height: context.width(72.0),
                          padding: context.width(1.0).allEdgeInsets,
                          child: Card(
                            elevation: .2,
                            surfaceTintColor: kGrey2Color,
                            margin: kZeroEdgeInsets,
                            color: kGrey2Color,
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
                                    color: kGrey2Color,
                                    gradient: kBlueGradient,
                                      borderRadius: context.width(14.0).borderRadius,
                                    border:  index != selectedIndex ? Border.all(color: kTransparentColor, width: .0) : Border.all(
                                        color: kTransparentColor, width: context.width(1.2))
                                  ),
                                  child: index != skipIndex
                                      ? ImgWidget(imgType: imgType, img: data[index]["img"] ?? "",
                                    borderRadius: context.width(14.0).borderRadius
                                  )
                                      : Container(
                                      decoration: BoxDecoration(
                                        color: kGrey2Color,
                                        border: index != selectedIndex ? Border.all(color: kGreyColor, width: .4)
                                            : Border.all(color: kTransparentColor,
                                            width: .0
                                        ),
                                        borderRadius: context.width(14.0).borderRadius,
                                      ),
                                      child: FittedBox(
                                        fit: BoxFit.none,
                                        child: ImgWidget(
                                          imgType: ImgType.asset,
                                            img: kMagicStickIcnPath,
                                            color: kWhiteColor,
                                          width: context.width(26.0), height: context.width(26.0),
                                        ).gradient(gradient: index != selectedIndex ? kWhiteGradient : kBlueGradient),
                                      )),
                                ),
                              ),
                            ),
                          ),
                        ),
                        if(data[index]["title"] != null) ...[
                          context.height(4.0).hMargin,
                          TextWidget(text: data[index]["title"], fontSize: 12.0, gradient: index != selectedIndex ? kWhiteGradient : kBlueGradient)
                        ]
                      ],
                    );
                  }
                ),
              );
            }
          );
        },
      ),
    );
  }
}

