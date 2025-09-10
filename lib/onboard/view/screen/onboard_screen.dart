
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_enhancer_app/config/shared_preference/shared_pref_service.dart';
import 'package:image_enhancer_app/create_category/view/widget/img_widget.dart';
import 'package:image_enhancer_app/create_category/view/widget/loading_btn_widget.dart';
import 'package:image_enhancer_app/dashboard/view/screen/dashboard_screen.dart';
import 'package:image_enhancer_app/onboard/view/widget/carousel_slider_widget.dart';
import 'package:image_enhancer_app/onboard/view/widget/smooth_page_indicator_widget.dart';
import 'package:image_enhancer_app/splash/view/widget/text_widget.dart';
import 'package:image_enhancer_app/utils/constant/alignment.dart';
import 'package:image_enhancer_app/utils/constant/color.dart';
import 'package:image_enhancer_app/utils/constant/font_weight.dart';
import 'package:image_enhancer_app/utils/constant/image_path.dart';
import 'package:image_enhancer_app/utils/enum/img_type.dart';
import 'package:image_enhancer_app/utils/enum/loading_state.dart';
import 'package:image_enhancer_app/utils/extension/common_extension.dart';
import 'package:image_enhancer_app/utils/extension/navigator_extension.dart';
import 'package:image_enhancer_app/utils/extension/widget_extension.dart';
import 'package:in_app_review/in_app_review.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

  final PageController _pageController = PageController();
  final ValueNotifier<int> _pageNotifier = ValueNotifier<int>(0);
  final ValueNotifier<bool> _isInAppReviewAvailable = ValueNotifier(false);

  void _nextBtnFunction() async {
    if (_pageNotifier.value != 3) {
      final val = _pageNotifier.value;
      _pageController.animateToPage(val+1, duration: 500.millisecond, curve: Curves.easeInOut);
    } else {
      context.setBtnLoading(loadingState: LoadingState.onboard_continue);
      if(await InAppReview.instance.isAvailable() && _isInAppReviewAvailable.value) {
        await Future.wait([
          InAppReview.instance.requestReview(),
          2000.millisecond.wait()
        ]);
        _isInAppReviewAvailable.value = false;
      } else {
        await SharedPrefService.setOnboardDisplay(display: false);
        context.pushReplacement(widget: DashboardScreen());
      }
      context.stopBtnLoading(loadingState: LoadingState.onboard_continue);
    }
  }

  void _initFunction() async {

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      for (var path in [kOnboardScreen1Img1Path, kOnboardScreen2Img1Path, kOnboardScreen3Img1Path, kOnboardScreen3Img2Path, kOnboardScreen3Img3Path, kOnboardScreen4BkgImg1Path]) {
        await precacheImage(AssetImage(path), context);
      }
    });

    _isInAppReviewAvailable.value = await InAppReview.instance.isAvailable();

  }

  void _disposeFunction() {

  }

  @override
  void dispose() {
    // TODO: implement dispose
    _disposeFunction();
    super.dispose();
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
        resizeToAvoidBottomInset: false,
        body: Stack(
            children: [
              Positioned.fill(
                  child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      onPageChanged: (value) {
                        _pageNotifier.value = value;
                      },
                      children: [
                        ImgWidget(imgType: ImgType.asset, img: kOnboardScreen1Img1Path),
                        ImgWidget(imgType: ImgType.asset, img: kOnboardScreen2Img1Path),
                        _buildOnboardCarouselSliderWidget(),
                        Stack(
                          children: [
                            Opacity(
                                opacity: .06,
                                child: Column(
                                  children: [
                                    Expanded(child: ImgWidget(imgType: ImgType.asset, img: kOnboardScreen4BkgImg1Path)),
                                    Expanded(child: ImgWidget(imgType: ImgType.asset, img: kOnboardScreen4BkgImg1Path)),
                                  ],
                                )),
                            Align(
                              child: ImgWidget(imgType: ImgType.asset, img: kAppIcnPath, width: context.width(126.0), borderRadius: context.width(22.0).borderRadius),
                            )
                          ],
                        ),
                      ]
                  ).padding(padding: context.height(136.0).bottomEdgeInsets)
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: context.width(16.0).horizontalEdgeInsets,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: AssetImage(kOnboardBkgImgPath), fit: BoxFit.cover, opacity: .14),
                        gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black,
                              Colors.black,
                              Colors.black,
                              Colors.transparent,
                            ]
                        )
                    ),
                    child: Column(
                        mainAxisSize: kMinMainAxisSize,
                        mainAxisAlignment: kEndMainAxisAlignment,
                        children: [
                        context.height(160.0).hMargin,
                          ValueListenableBuilder<int>(
                              valueListenable: _pageNotifier,
                              builder: (context, value, _) {
                                return TextWidget(
                                    text:
                                    <String>["Make Every Photo Perfect", "Smart AI Tools in One Tap", "Create Stunning AI Avatars", "Help Us to Grow"][value],
                                    fontWeight: kBoldFontWeight,
                                    fontSize: 22.0,
                                  gradient: kBlueGradient,
                                  height: .0,
                                  fontStyle: FontStyle.italic,
                                  textAlign: TextAlign.center,
                                );
                              }
                          ),
                          context.height(16.0).hMargin,
                          ValueListenableBuilder(
                              valueListenable: _pageNotifier,
                              builder: (context, value, _) {
                                return AnimatedSwitcher(
                                    duration: 300.millisecond,
                                    transitionBuilder: (child, animation) =>
                                        FadeTransition(opacity: animation, child: child),
                                    child: TextWidget(
                                      key: ValueKey<int>(value),
                                      text:
                                        "${<String>["Upgrade photo quality, add effects, text, stickers & more — all in one place",
                                          "Remove backgrounds and erase objects, instantly with AI magic",
                                          "Unleash your imagination and transform photos into incredible AI avatars",
                                          "Share feedback and ideas to improve your PixeLift experience."][value]}\n",
                                        maxLines: 2,
                                            textAlign: TextAlign.center,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: k300FontWeight,
                                            fontSize: 15.0
                                    )
                                );
                              }
                          ),
                          context.height(16.0).hMargin,
                          Center(
                            child: ValueListenableBuilder<int>(
                              valueListenable: _pageNotifier,
                              builder: (context, value, _) {
                                return AnimatedSmoothIndicatorWidget(
                                  activeIndex: value,
                                  count: 4,
                                  duration: 300.millisecond,
                                  effect: CustomizableEffect(
                                    dotDecoration: DotDecoration(
                                        height: context.width(6.2),
                                        width: context.width(6.2),
                                        color: kGreyColor,
                                        borderRadius: 100.borderRadius
                                    ),
                                    activeDotDecoration: DotDecoration(
                                        width: context.width(8.6),
                                        height: context.width(8.6),
                                        color: kBlueColor,
                                        borderRadius: 100.borderRadius
                                    ),
                                  ),
                                  onDotClicked: (index) {
                                    _pageNotifier.value = index;
                                    _pageController.animateToPage(index, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                                  },
                                );
                              },
                            ),
                          ),
                          context.height(16.0).hMargin,

                          ValueListenableBuilder<int>(
                              valueListenable: _pageNotifier,
                              builder: (context, value, _) {
                                return ValueListenableBuilder(
                                    valueListenable: _isInAppReviewAvailable,
                                    builder: (context, _value, child) {
                                      return LoadingBtnWidget(
                                        loadingState: LoadingState.onboard_continue,
                                        toolTip: value != 3 ? "Next" : _value ? "Continue" : "Get Started",
                                        text: value != 3 ? "Next" : _value ? "Continue" : "Get Started",
                                        displayIcnRight: true,
                                        icn: value != 3 || _value ? CupertinoIcons.arrow_right : null,
                                        onPressed: _nextBtnFunction,
                                      );
                                    }
                                );
                              }
                          ),
                          context.height(48.0).hMargin,
                        ]
                    ),
                  )
              ),
            ]
        )
    );
  }

  Widget _buildOnboardCarouselSliderWidget() {
    return CarouselSliderWidget(
        items: <Widget>[
          ImgWidget(imgType: ImgType.asset, img: kOnboardScreen3Img1Path, borderRadius: context.width(40.0).borderRadius),
          ImgWidget(imgType: ImgType.asset, img: kOnboardScreen3Img2Path, borderRadius: context.width(40.0).borderRadius),
          ImgWidget(imgType: ImgType.asset, img: kOnboardScreen3Img3Path, borderRadius: context.width(40.0).borderRadius),
        ],
        options: CarouselOptions(
          autoPlay: true,
          enlargeCenterPage: true,
          aspectRatio: 1.1,
          autoPlayInterval: 1.second,
          autoPlayAnimationDuration: 1.second
        )
    );
  }
}