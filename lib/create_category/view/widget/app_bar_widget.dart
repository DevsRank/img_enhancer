
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_enhancer_app/create_category/view/widget/icn_btn_widget.dart';
import 'package:image_enhancer_app/dashboard/view/widget/pro_btn_widget.dart';
import 'package:image_enhancer_app/premium/view/screen/premium_screen.dart';
import 'package:image_enhancer_app/setting/view/widget/premium_widget_visibility_widget.dart';
import 'package:image_enhancer_app/splash/view/widget/text_widget.dart';
import 'package:image_enhancer_app/utils/constant/color.dart';
import 'package:image_enhancer_app/utils/constant/font_weight.dart';
import 'package:image_enhancer_app/utils/extension/common_extension.dart';
import 'package:image_enhancer_app/utils/extension/navigator_extension.dart';
import 'package:image_enhancer_app/utils/extension/widget_extension.dart';

class AppBarWidget {
  static PreferredSize build({
    required BuildContext context,
    required String title}) {
    return PreferredSize(
      preferredSize: Size(double.maxFinite, context.width(56.0)),
      child: AppBar(
        toolbarHeight: context.width(56.0),
        backgroundColor: kTransparentColor,
        leadingWidth: context.width(46.0),
        leading: IcnBtnWidget(tooltip: "Back", icn: Icons.arrow_back, color: kWhiteColor, onPressed: () => context.pop()),
        centerTitle: true,
        title: TextWidget(text: title, fontSize: 18.0, fontWeight: k500FontWeight, gradient: kBlueGradient),
        actions: [
          PremiumWidgetVisibilityWidget(
            child: ProBtnWidget(
              onPressed: () => context.push(widget: PremiumScreen()),
            ).padding(padding: context.width(16.0).rightEdgeInsets),
          )
        ],
        bottom: PreferredSize(
            preferredSize: Size(double.maxFinite, .0),
            child: Divider(height: .0, thickness: .5)),
      ),
    );
  }

}
