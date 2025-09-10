
import 'package:flutter/material.dart';
import 'package:image_enhancer_app/splash/view/widget/text_widget.dart';
import 'package:image_enhancer_app/utils/constant/color.dart';
import 'package:image_enhancer_app/utils/constant/padding.dart';
import 'package:image_enhancer_app/utils/extension/common_extension.dart';

class PopUpMenuItemWidget {

  static PopupMenuItem<int> build({required BuildContext context, required int value, required String title, required IconData icn, bool displayDivider = false}) {
    return PopupMenuItem<int>(
      height: context.width(26.0),
      padding: kZeroEdgeInsets,
      value: value,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            dense: true,
            contentPadding: context.width(6.0).horizontalEdgeInsets,
            horizontalTitleGap: context.width(6.0),
            leading: Container(
                width: context.width(24.0),
                height: context.width(24.0),
                alignment: Alignment.center,
                child: Icon(icn, color: kWhiteColor, size: context.width(22.0))
            ),
            title: TextWidget(
                text: title
            ),
          ),
         if(displayDivider) Divider(
           indent: 2.0,
            endIndent: 2.0,
            color: kGreyColor,
            height: context.width(.4),
            thickness: context.width(.4)
          ),
        ],
      ),
    );
  }
}
