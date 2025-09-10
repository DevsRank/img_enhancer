

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_enhancer_app/dashboard/view/widget/bottom_nav_bar_widget.dart';
import 'package:image_enhancer_app/dashboard/view/widget/dashboard_appbar_widget.dart';
import 'package:image_enhancer_app/dashboard/view_model/bloc/bottom_nav_bar/bottom_nav_bar_bloc.dart';
import 'package:image_enhancer_app/explore/view/screen/explore_screen.dart';
import 'package:image_enhancer_app/history/view/screen/history_screen.dart';
import 'package:image_enhancer_app/home/view/screen/home_screen.dart';
import 'package:image_enhancer_app/setting/view/screen/setting_screen.dart';
import 'package:image_enhancer_app/utils/constant/image_path.dart';
import 'package:image_enhancer_app/utils/extension/common_extension.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  final PageController _pageController = PageController();
  final ValueNotifier<bool> _isChangeNotifier = ValueNotifier(false);

  void _initFunction() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initFunction();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DashboardAppbarWidget.build(context: context),
      body: PageView(
        controller: _pageController,
        children: [
          HomeScreen(),
          ExploreScreen(),
          HistoryScreen(pageController: _pageController, isChangeNotifier: _isChangeNotifier),
          SettingScreen()
        ],
        onPageChanged: (index) async {
          if(!_isChangeNotifier.value) {
            context.read<BottomNavBarBloc>().setIndex(index: index);
            return;
          }
          await 201.millisecond.wait();
          _isChangeNotifier.value = false;
        },
      ),
      bottomNavigationBar: BottomNavBarWidget(
        onPressed: (index) {
          _isChangeNotifier.value  = true;
          _pageController.animateToPage(
            index,
            duration: 200.millisecond,
            curve: Curves.easeInOutCubic,
          );
          context.read<BottomNavBarBloc>().setIndex(index: index);
      })
    );
  }
}
