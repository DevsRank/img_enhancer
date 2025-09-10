import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_enhancer_app/dashboard/view/widget/pro_btn_widget.dart';
import 'package:image_enhancer_app/dashboard/view_model/bloc/bottom_nav_bar/bottom_nav_bar_bloc.dart';
import 'package:image_enhancer_app/premium/view/screen/premium_screen.dart';
import 'package:image_enhancer_app/setting/view/widget/premium_widget_visibility_widget.dart';
import 'package:image_enhancer_app/splash/view/widget/text_widget.dart';
import 'package:image_enhancer_app/utils/constant/color.dart';
import 'package:image_enhancer_app/utils/constant/font_weight.dart';
import 'package:image_enhancer_app/utils/extension/common_extension.dart';
import 'package:image_enhancer_app/utils/extension/navigator_extension.dart';
import 'package:image_enhancer_app/utils/extension/widget_extension.dart';

class DashboardAppbarWidget {
  static PreferredSize build({required BuildContext context}) {
    return PreferredSize(
      preferredSize: Size(double.maxFinite, context.width(56.0)),
      child: AppBar(
        backgroundColor: kTransparentColor,
        toolbarHeight: context.width(56.0),
        centerTitle: false,
        title: BlocBuilder<BottomNavBarBloc, BottomNavBarState>(
          builder: (context, bottomNavBarState) {
            return AnimatedSwitcher(
              duration: 300.millisecond,
              switchInCurve: Curves.easeInOut,
              switchOutCurve: Curves.easeInOut,
              transitionBuilder:
                  (Widget child, Animation<double> animation) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(.0, .0),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                      parent: animation, curve: Curves.easeInOut)),
                  child: FadeTransition(
                    opacity: animation,
                    child: child,
                  )
                );
              },
              child: TextWidget(key: ValueKey<int>(bottomNavBarState.index), text: <String>["PixeLift", "Explore", "History", "Settings"][bottomNavBarState.index], fontSize: 18.0, fontWeight: k500FontWeight, gradient: kBlueGradient),
            );
          },
        ),
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
