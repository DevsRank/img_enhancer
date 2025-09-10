import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_enhancer_app/dashboard/view_model/bloc/bottom_nav_bar/bottom_nav_bar_bloc.dart';
import 'package:image_enhancer_app/splash/view/widget/text_widget.dart';
import 'package:image_enhancer_app/utils/constant/alignment.dart';
import 'package:image_enhancer_app/utils/constant/color.dart';
import 'package:image_enhancer_app/utils/constant/image_path.dart';
import 'package:image_enhancer_app/utils/constant/padding.dart';
import 'package:image_enhancer_app/utils/extension/common_extension.dart';
import 'package:image_enhancer_app/utils/extension/widget_extension.dart';

class BottomNavBarWidget extends StatefulWidget {
  const BottomNavBarWidget({
    super.key,
    required this.onPressed,
  });
  final Function(int index) onPressed;
  @override
  State<BottomNavBarWidget> createState() => _BottomNavBarWidgetState();
}

class _BottomNavBarWidgetState extends State<BottomNavBarWidget> {

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      notchMargin: .0,
      elevation: .0,
      shadowColor: kShadowColor,
      color: kBlack2Color,
      surfaceTintColor: kBlack2Color,
      height: context.width(68.0),
      padding: kZeroEdgeInsets,
      child: Container(
        padding: context.width(1.4).topEdgeInsets,
        decoration: BoxDecoration(
            gradient: kBlueGradient,
            borderRadius: context.width(26.0).borderRadius.copyWith(
                bottomLeft: Radius.zero,
                bottomRight: Radius.zero
            )
        ),
        child: Container(
          decoration: BoxDecoration(
            color: kBlack2Color,
              borderRadius: context.width(24.0).borderRadius.copyWith(bottomLeft: Radius.zero, bottomRight: Radius.zero)
          ),
          child: Row(
              children: [
                Expanded(
                    child: BlocBuilder<BottomNavBarBloc, BottomNavBarState>(
                    buildWhen: (previous, current) {
                      return previous.index != current.index && (current.index == 0 || previous.index == 0);
                    },
                    builder: (context, bottomNavBarState) {
                      return _buildBottomAppBarItem(
                          index: 0,
                          icon: kHomeIcnPath,
                          label: "Home", context: context,
                        borderRadius: context.width(24.0).topLeftBorderRadius
                      );
                    }
                )),
                Expanded(
                    child: BlocBuilder<BottomNavBarBloc, BottomNavBarState>(
                    buildWhen: (previous, current) {
                      return previous.index != current.index && (current.index == 1 || previous.index == 1);
                    },
                    builder: (context, bottomNavBarState) {
                      return _buildBottomAppBarItem(
                          index: 1,
                          icon: kExploreIcnPath,
                          label: "Explore", context: context
                      );
                    }
                )),
                Expanded(
                    child: BlocBuilder<BottomNavBarBloc, BottomNavBarState>(
                        buildWhen: (previous, current) {
                          return previous.index != current.index && (current.index == 2 || previous.index == 2);
                        },
                        builder: (context, bottomNavBarState) {
                          return _buildBottomAppBarItem(
                              index: 2,
                              icon: kHistoryIcnPath,
                              label: "History", context: context
                          );
                        }
                    )),
                Expanded(
                    child: BlocBuilder<BottomNavBarBloc, BottomNavBarState>(
                    buildWhen: (previous, current) {
                      return previous.index != current.index && (current.index == 3 || previous.index == 3);
                    },
                    builder: (context, bottomNavBarState) {
                      return _buildBottomAppBarItem(
                          index: 3,
                          icon: kSettingIcnPath,
                          label: "Settings", context: context,
                        borderRadius: context.width(24.0).topRightBorderRadius
                      );
                    }
                ))
              ]
          ),
        ),
      ),
    );
  }

  Widget _buildBottomAppBarItem({required int index, required String icon, required String label, required BuildContext context, BorderRadius? borderRadius}) {
    return Tooltip(
      message: label,
      child: Material(
        color: kTransparentColor,
        borderRadius: borderRadius,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: () => widget.onPressed(index),
          child: Column(
            crossAxisAlignment: kCenterCrossAxisAlignment,
            mainAxisAlignment: kCenterMainAxisAlignment,
            children: [
              AnimatedContainer(
                  duration: 300.millisecond,
                  curve: Curves.easeInOut,
                  alignment: Alignment.center,
                  child: Image.asset(
                      icon,
                      color: kWhiteColor,
                      height: context.width(20.0),
                      width: context.width(20.0)
                  ).gradient(gradient: index != context.read<BottomNavBarBloc>().state.index ? kGreyGradient : kBlueGradient)
              ),
              context.width(4.0).hMargin,
              TextWidget(
                text:  label,
                color: kWhiteColor,
                  gradient: index != context.read<BottomNavBarBloc>().state.index ? kGreyGradient : kBlueGradient
              )
            ],
          )
        ),
      ),
    );
  }
}