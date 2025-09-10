

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_enhancer_app/config/shared_preference/shared_pref_service.dart';
import 'package:image_enhancer_app/create_category/view/widget/img_widget.dart';
import 'package:image_enhancer_app/dashboard/view/screen/dashboard_screen.dart';
import 'package:image_enhancer_app/onboard/view/screen/onboard_screen.dart';
import 'package:image_enhancer_app/service/in_app_purchase/in_app_purchase_subscription_bloc.dart';
import 'package:image_enhancer_app/splash/view/widget/circular_progress_indicator_widget.dart';
import 'package:image_enhancer_app/splash/view/widget/text_widget.dart';
import 'package:image_enhancer_app/utils/constant/font_weight.dart';
import 'package:image_enhancer_app/utils/constant/image_path.dart';
import 'package:image_enhancer_app/utils/enum/img_type.dart';
import 'package:image_enhancer_app/utils/extension/common_extension.dart';
import 'package:image_enhancer_app/utils/extension/navigator_extension.dart';
import 'package:image_enhancer_app/utils/extension/widget_extension.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  void _initFunction() async {

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        await precacheImage(AssetImage(kAppIcnPath), context);
    });
    
    // wait until loading becomes false
    final futureList = await Future.wait([
      SharedPrefService.getOnboardDisplay(),
      2.second.wait(),
      Future(() async {
        if(!context.read<InAppPurchaseSubscriptionBloc>().state.isLoading) return;
        await for (final state in context.read<InAppPurchaseSubscriptionBloc>().stream) {
          if (!state.isLoading) break;
        }
      })
    ]);

    context.pushReplacement(
      widget: (futureList[0] as ({bool display})).display
          ? OnboardingScreen()
          : DashboardScreen()
          // : OnboardingScreen()
    );
  }

  @override
  void initState() {
    super.initState();
    _initFunction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImgWidget(imgType: ImgType.asset, img: kAppIcnPath, width: context.width(100.0), borderRadius: context.width(22.0).borderRadius),
            context.height(14.0).hMargin,
            TextWidget(text: "PixeLift", fontSize: 18.0, fontWeight: k500FontWeight)
          ]
        )
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: context.height(16.0).bottomEdgeInsets,
        child: CircularProgressIndicatorWidget(),
      ),
    );
  }
}
