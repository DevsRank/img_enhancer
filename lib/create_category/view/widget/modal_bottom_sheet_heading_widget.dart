
import 'package:flutter/material.dart';
import 'package:image_enhancer_app/create_category/view/widget/icn_btn_widget.dart';
import 'package:image_enhancer_app/create_category/view/widget/medium_heading_widget.dart';
import 'package:image_enhancer_app/utils/extension/navigator_extension.dart';

class ModalBottomSheetHeadingWidget extends StatelessWidget {
  final String title;
  const ModalBottomSheetHeadingWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: MediumHeadingWidget(title: title)),
        Spacer(),
        IcnBtnWidget(
          tooltip: "Cancel",
          icn: Icons.cancel,
          onPressed: () {
            context.pop();
          },)
      ],
    );
  }
}
