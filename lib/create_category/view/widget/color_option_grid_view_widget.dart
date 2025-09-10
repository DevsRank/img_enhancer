
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_enhancer_app/splash/view/widget/text_widget.dart';
import 'package:image_enhancer_app/utils/constant/color.dart';
import 'package:image_enhancer_app/utils/constant/padding.dart';
import 'package:image_enhancer_app/utils/extension/common_extension.dart';
import 'package:image_enhancer_app/utils/extension/navigator_extension.dart';
import 'package:image_enhancer_app/utils/extension/widget_extension.dart';

class ColorOptionGridViewWidget extends StatelessWidget {
  final ValueNotifier<int>? valueNotifier;
  final List<Map<String, dynamic>> data;
  final Function(int index)? onPressed;

  const ColorOptionGridViewWidget({
    super.key,
     this.valueNotifier,
    required this.data,
    this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<int> _valueNotifier = valueNotifier ?? ValueNotifier(0);
    return GridView.builder(
      itemCount: data.length,
      padding: kZeroEdgeInsets,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, // Adjust as needed
          mainAxisSpacing: context.width(8.0),
          crossAxisSpacing: context.width(8.0),
          childAspectRatio: .68
      ),
      itemBuilder: (context, index) {
        final ValueNotifier<double> sizeNotifier = ValueNotifier(1.0);
        return Column(
          children: [
            Expanded(
              child: ValueListenableBuilder(
                  valueListenable: sizeNotifier,
                  builder: (context, value, child) {
                    return AnimatedScale(
                      scale: value,
                      duration: const Duration(milliseconds: 100),
                      child: ValueListenableBuilder<int>(
                        valueListenable: _valueNotifier,
                        builder: (context, _value, child) {
                          return Card(
                            elevation: .2,
                            shadowColor: kShadowColor,
                            surfaceTintColor: kWhiteColor,
                            margin: kZeroEdgeInsets,
                            color: kWhiteColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: context.width(14.0).borderRadius,
                                side: index != _value
                                    ? BorderSide.none
                                    : BorderSide(color: kBlueColor, width: context.width(1.2))
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
                                onTap: () async {
                                  _valueNotifier.value = index;
                                  await 100.millisecond.wait();
                                  context.pop();
                                  },
                                child: Container(
                                  width: double.maxFinite,
                                  height: double.maxFinite,
                                  decoration: BoxDecoration(
                                    color: data[index]["color"],
                                    borderRadius: context.width(14.0).borderRadius
                                  )
                                )
                              )
                            )
                          );
                        }
                      )
                    );
                  }
              )
            ),
            if(data[index]["title"] != null) ...[
              context.height(4.0).hMargin,
              TextWidget(
                  text: data[index]["title"]+"\n",
                  fontSize: 12.0,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center
              )
            ]
          ],
        );
      },
    );
  }
}