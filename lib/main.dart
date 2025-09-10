import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_enhancer_app/create_category/view/widget/loading_view_widget.dart';
import 'package:image_enhancer_app/create_category/view_model/bloc/loading_btn/loading_btn_bloc.dart';
import 'package:image_enhancer_app/create_category/view_model/bloc/loading_view/loading_view_bloc.dart';
import 'package:image_enhancer_app/dashboard/view_model/bloc/bottom_nav_bar/bottom_nav_bar_bloc.dart';
import 'package:image_enhancer_app/history/view_model/bloc/fun_preset_bloc/fun_preset_history_bloc.dart';
import 'package:image_enhancer_app/history/view_model/bloc/img_utils_bloc/img_utils_history_bloc.dart';
import 'package:image_enhancer_app/history/view_model/bloc/magic_remover_bloc/img_utils_history_bloc.dart';
import 'package:image_enhancer_app/premium/view_model/bloc/in_app_purchase/in_app_purchase_bloc.dart';
import 'package:image_enhancer_app/service/in_app_purchase/in_app_purchase_subscription_bloc.dart';
import 'package:image_enhancer_app/splash/view/screen/splash_screen.dart';
import 'package:image_enhancer_app/utils/constant/color.dart';
import 'package:image_enhancer_app/utils/enum/loading_type.dart';
import 'package:image_enhancer_app/utils/extension/common_extension.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  _myAppFunction();
}

void _myAppFunction() async {
  runApp(
      MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => InAppPurchaseSubscriptionBloc()),
            BlocProvider(create: (context) => InAppPurchaseBloc()),
            BlocProvider(create: (context) => BottomNavBarBloc()),
            BlocProvider(create: (context) => BtnLoadingBloc()),
            BlocProvider(create: (context) => LoadingViewBloc()),
            BlocProvider(create: (context) => ImgUtilsHistoryBloc()),
            BlocProvider(create: (context) => MagicRemoverHistoryBloc()),
            BlocProvider(create: (context) => FunPresetHistoryBloc())
          ],
          child: MyApp()
      )
  );
}

final GlobalKey<NavigatorState> _materialAppKey = GlobalKey();
GlobalKey<NavigatorState> get materialAppKey => _materialAppKey;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  void _initFunction() {
    // SharedPrefService.clearPref();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if(Platform.isIOS) context.read<InAppPurchaseSubscriptionBloc>().initFunction();
    });
  }

  void _disposeFunction() {

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initFunction();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _disposeFunction();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorKey: _materialAppKey,
        navigatorObservers: [AppRouteObserver()],
        title: 'PixeLift',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            scaffoldBackgroundColor: kBlack2Color,
            textTheme: TextTheme(
              displayLarge: TextStyle(color: kWhiteColor),
              displayMedium: TextStyle(color: kWhiteColor),
              displaySmall: TextStyle(color: kWhiteColor),
              headlineLarge: TextStyle(color: kWhiteColor),
              headlineMedium: TextStyle(color: kWhiteColor),
              headlineSmall: TextStyle(color: kWhiteColor),
              titleLarge: TextStyle(color: kWhiteColor),
              titleMedium: TextStyle(color: kWhiteColor),
              titleSmall: TextStyle(color: kWhiteColor),
              bodyLarge: TextStyle(color: kWhiteColor),
              bodyMedium: TextStyle(color: kWhiteColor),
              bodySmall: TextStyle(color: kWhiteColor),
              labelLarge: TextStyle(color: kWhiteColor),
              labelMedium: TextStyle(color: kWhiteColor),
              labelSmall: TextStyle(color: kWhiteColor)
            ),
            iconTheme: IconThemeData(
                color: kWhiteColor
            )
        ),
        builder: (context, child) {
          return Stack(
              children: [
                child!,
                BlocBuilder<LoadingViewBloc, LoadingViewState>(
                    buildWhen: (previous, current) => previous != current,
                    builder: (context, loadingViewState) {
                      return loadingViewState.loadingType != LoadingType.none
                          ? LoadingViewWidget(title: loadingViewState.title) : SizedBox.shrink();
                    })
              ]
          );
        },
        home: SplashScreen()
    );
  }
}

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class AppRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  @override
  void didPop(Route route, Route? previousRoute) {
    debugPrint("🔙 Route popped: ${route.settings.name}, Back pressed!");
    // super.didPop(route, previousRoute);
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    debugPrint("➡️ New route pushed: ${route.settings.name}");
    super.didPush(route, previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    debugPrint("🔄 Route replaced: ${oldRoute?.settings.name} → ${newRoute?.settings.name}");
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
}


