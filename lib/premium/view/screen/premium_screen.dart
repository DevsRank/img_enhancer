import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_enhancer_app/create_category/view/widget/icn_btn_widget.dart';
import 'package:image_enhancer_app/create_category/view/widget/loading_btn_widget.dart';
import 'package:image_enhancer_app/create_category/view/widget/loading_view_widget.dart';
import 'package:image_enhancer_app/dashboard/view/widget/pro_btn_widget.dart';
import 'package:image_enhancer_app/premium/view/widget/text_btn_widget.dart';
import 'package:image_enhancer_app/premium/view_model/bloc/in_app_purchase/in_app_purchase_bloc.dart';
import 'package:image_enhancer_app/splash/view/widget/text_widget.dart';
import 'package:image_enhancer_app/utils/constant/alignment.dart';
import 'package:image_enhancer_app/utils/constant/color.dart';
import 'package:image_enhancer_app/utils/constant/font_weight.dart';
import 'package:image_enhancer_app/utils/constant/image_path.dart';
import 'package:image_enhancer_app/utils/constant/padding.dart';
import 'package:image_enhancer_app/utils/extension/common_extension.dart';
import 'package:image_enhancer_app/utils/extension/navigator_extension.dart';
import 'package:image_enhancer_app/utils/extension/snackbar_extension.dart';
import 'package:image_enhancer_app/utils/extension/widget_extension.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zo_animated_border/zo_animated_border.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  final ValueNotifier<int> _imgNotifier = ValueNotifier<int>(0);
  final ValueNotifier<int> _packageNotifier = ValueNotifier<int>(-1);
  // final ValueNotifier<bool> _freeTrialBtnNotifier = ValueNotifier<bool>(false);

  void _continueBtnFunction() async {
    if(context.read<InAppPurchaseBloc>().state.availableProducts.isEmpty || context.read<InAppPurchaseBloc>().state.isPurchasing) {
      return;
    } else {
      await context.read<InAppPurchaseBloc>().purchasingProduct(context.read<InAppPurchaseBloc>().state.availableProducts[_packageNotifier.value]);
    }
  }

  void _termConditionBtnFunction() {
    _urlLauncherFunction(url: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/");
  }

  void _privacyPolicyBtnFunction() {
    _urlLauncherFunction(url: "https://devs-privacy.vercel.app/AI-Photo-Enhancer");
  }

  void _urlLauncherFunction({required String url}) async {

    final Uri emailLaunchUri = Uri.parse(url);

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      context.showSnackBar(msg: "No browser app found. Please install browser");
    }
  }

  Map<String, String> extractCurrencyAndAmount(String input) {
    final match = RegExp(r'^([^\d\-.,]+)\s*([\-]?[0-9,\.]+)').firstMatch(input.trim());

    if (match != null) {
      String currency = match.group(1)?.trim() ?? '';
      String amount = match.group(2)?.replaceAll(',', '') ?? '';
      return {'currency': currency, 'amount': amount};
    } else {
      return {'currency': '', 'amount': ''};
    }
  }

  void _initFunction() async {
    // context.read<InAppPurchaseBloc>().initFunction();
    Timer.periodic(5.second, (timer) {
      _imgNotifier.value = (_imgNotifier.value + 1) % 4;
    });
    // final pref = await SharedPrefService.checkFreeTrial();
    // _freeTrialBtnNotifier.value = pref.isFreeTrialLeft;
  }

  @override
  void initState() {
    super.initState();
    _initFunction();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !context.read<InAppPurchaseBloc>().state.isPurchasing,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            ValueListenableBuilder<int>(
              valueListenable: _imgNotifier,
              builder: (context, value, _) {
                return AnimatedSwitcher(
                  duration: 2000.millisecond, // Fade transition duration
                  reverseDuration: 2000.millisecond,
                  transitionBuilder:
                      (Widget child, Animation<double> animation) =>
                          FadeTransition(opacity: animation, child: child),
                  child: Image.asset(
                    <String>[
                      kPremiumScreenSlideImg1Path,
                      kPremiumScreenSlideImg2Path,
                      kPremiumScreenSlideImg3Path,
                      kPremiumScreenSlideImg4Path
                    ][value],
                    key: ValueKey<int>(value), // Important for animation
                    height: double.maxFinite,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ).padding(padding: context.height(320.0).bottomEdgeInsets),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      kGrey2Color,
                      kGrey2Color,
                      kGrey2Color,
                      kGrey2Color,
                      kTransparentColor,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: kEndMainAxisAlignment,
                  children: [
                    context.height(78.0).hMargin,
                    Row(
                      mainAxisAlignment: kCenterMainAxisAlignment,
                      children: [
                        TextWidget(
                          text: "PixeLift",
                          fontSize: 19.0,
                          fontWeight: k600FontWeight,
                        ),
                        context.width(8.0).wMargin,
                        ProBtnWidget(onPressed: () {})
                      ]
                    ),
                    context.height(12.0).hMargin,
                    TextWidget(
                      text: "Unleash your creativity with PRO",
                      fontWeight: k600FontWeight,
                      fontSize: 16.0,
                    ),
                    context.height(12.0).hMargin,
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: kStartCrossAxisAlignment,
                            children: [
                              _buildPremiumFeatureWidget(title: "Premium Styles"),
                              context.height(16.0).hMargin,
                              _buildPremiumFeatureWidget(title: "Remove Ads"),
                            ]
                          )
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: kStartCrossAxisAlignment,
                            children: [
                              _buildPremiumFeatureWidget(title: "No Watermark"),
                              context.height(16.0).hMargin,
                              _buildPremiumFeatureWidget(title: "And Much More"),
                            ]
                          )
                        )
                      ]
                    ).padding(padding: context.width(16.0).horizontalEdgeInsets),
                    context.height(16.0).hMargin,
                    BlocBuilder<InAppPurchaseBloc, InAppPurchaseState>(
                      builder: (context, inAppPurchaseState) {
                        if (inAppPurchaseState.queryProductError.isNotEmpty) {
                          return Center(
                            child: TextWidget(
                              text: inAppPurchaseState.queryProductError,
                            ),
                          ).padding(
                            padding: context.height(24.0).verticalEdgeInsets,
                          );
                        } else if (inAppPurchaseState.availableProducts.isEmpty) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: kBlueColor,
                              strokeWidth: context.width(2.6),
                            ),
                          ).padding(
                            padding: context.height(24.0).verticalEdgeInsets,
                          );
                        } else {
                          return ValueListenableBuilder<int>(
                            valueListenable: _packageNotifier,
                            builder: (context, value, _) {
                              return ListView.separated(
                                itemCount: inAppPurchaseState.availableProducts.length,
                                shrinkWrap: true,
                                padding: kZeroEdgeInsets,
                                physics: const NeverScrollableScrollPhysics(),
                                separatorBuilder: (context, index) =>
                                    SizedBox(height: context.height(16.0)),
                                itemBuilder: (context, index) {
                                  final product = inAppPurchaseState.availableProducts[index];
                                  String bannerText = '';
                                  String planType = 'WEEKLY ACCESS';
                                  String discount = '';
                                  if (product.id.toLowerCase().contains(
                                    'pixeliftweekly',
                                  )) {
                                    planType = 'WEEKLY ACCESS';
                                    discount =
                                        '${product.price.replaceAll(RegExp(r'[\d.,]'), '').trim()}${(double.parse(product.price.replaceAll(RegExp(r'[^\d.]'), '')) / 4).toStringAsFixed(2)}';
                                    bannerText = '25% save';
                                  } else if (product.id.toLowerCase().contains(
                                    'pixeliftyearly',
                                  )) {
                                    if (_packageNotifier.value == -1) {
                                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                                        _packageNotifier.value = index;
                                      });
                                    }
                                    planType = 'YEARLY ACCESS';
                                    discount =
                                        '${product.price.replaceAll(RegExp(r'[\d.,]'), '').trim()}${(double.parse(product.price.replaceAll(RegExp(r'[^\d.]'), '')) / 48).toStringAsFixed(2)}';
                                    bannerText = 'Best Offer';
                                  }
                                  return ZoAnimatedGradientBorder(
                                    gradientColor: kBlueGradient.colors,
                                    borderRadius: context.width(100.0),
                                    shouldAnimate: true,
                                    glowOpacity: .0,
                                    borderThickness: context.width(1.6),
                                    animationDuration: 5.second,
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Material(
                                          color: kTransparentColor,
                                          borderRadius: context
                                              .width(100.0)
                                              .borderRadius,
                                          child: InkWell(
                                            borderRadius: context
                                                .width(100.0)
                                                .borderRadius,
                                            splashColor: kSplashColor,
                                            onTap: () {
                                              _packageNotifier.value = index;
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                gradient: index != value
                                                    ? null
                                                    : kBlueGradient.withOpacity(
                                                        .4,
                                                      ),
                                                borderRadius: context
                                                    .width(100.0)
                                                    .borderRadius,
                                              ),
                                              child: ListTile(
                                                minTileHeight: context.width(
                                                  66.0,
                                                ),
                                                tileColor: kTransparentColor,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: context
                                                      .width(100.0)
                                                      .borderRadius,
                                                ),
                                                leading: index != value
                                                    ? Icon(
                                                        Icons
                                                            .radio_button_off_outlined,
                                                        size: context.width(22.0),
                                                        color: kBlueColor,
                                                      )
                                                    : Icon(
                                                        Icons.check_circle,
                                                        color: kBlueColor,
                                                        size: context.width(22.0),
                                                      ),
                                                title: TextWidget(
                                                  text: planType,
                                                  fontWeight: kBoldFontWeight,
                                                  fontSize: 16.0,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                // subtitle: product.id !=
                                                //         "com.devsrank.pixeliftyearly.app"
                                                //         ? null
                                                //         : Builder(
                                                //           builder: (context) {
                                                //             final result = extractCurrencyAndAmount(product.price);
                                                //             return TextWidget(
                                                //                 text: "Just ${result["currency"]}${result["amount"]} Per Year",
                                                //                 fontSize: 12.0,
                                                //                 maxLines: 1,
                                                //                 overflow: TextOverflow.ellipsis
                                                //             );
                                                //           }
                                                //         ),
                                                trailing: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Builder(
                                                        builder: (context) {
                                                          String cleanedPrice = product.price.replaceAll(RegExp(r'[^\d.]'), '');
                                                          double weeklyPrice = (double.tryParse(cleanedPrice) ?? .0) / 52;
                                                          final result = extractCurrencyAndAmount(product.price);
                                                          return TextWidget(
                                                              // text: product.id != "com.devsrank.pixeliftyearly.app" ?
                                                              //     result["currency"].toString()+cleanedPrice : result["currency"].toString()+weeklyPrice.toStringAsFixed(2),
                                                            text: "${result["currency"]}${result["amount"]}",
                                                              fontSize: 16.0,
                                                              maxLines: 1,
                                                              fontWeight: kBoldFontWeight,
                                                              overflow: TextOverflow.ellipsis
                                                          );
                                                        }
                                                    ),
                                                    // context.width(2.0).hMargin,
                                                    2.0.hMargin,
                                                    TextWidget(
                                                      text: product.id != "com.devsrank.pixeliftyearly.app" ? "Per Week" : "Per Year",
                                                        fontSize: 12.0,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis
                                                    )
                                                  ]
                                                )
                                              )
                                            )
                                          )
                                        ),
                                        if(product.id != "com.devsrank.pixeliftweekly.app") Positioned(
                                          top: -10.0,
                                          right: 26.0,
                                          child: AnimatedContainer(
                                            duration: 100.millisecond,
                                            alignment: Alignment.topCenter,
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: context.width(16.0),
                                                vertical: context.width(2.0),
                                              ),
                                              decoration: BoxDecoration(
                                                gradient: kBlueGradient,
                                                borderRadius: 8.0.borderRadius

                                              ),
                                              child: TextWidget(
                                                text: "Best Offer",
                                                fontSize: 11.0,
                                                color: kWhiteColor,
                                              ),
                                            ),
                                          ),
                                        )
                                      ]
                                    ),
                                  );
                                }
                              );
                            }
                          );
                        }
                      }
                    ),
                    context.height(12.0).hMargin,
                    TextWidget(
                      text: "Auto-renewable, Cancel anytime",
                      fontSize: 12.0,
                    ),
                    context.height(12.0).hMargin,
                    LoadingBtnWidget(
                      toolTip: "Continue",
                      // loadingState: LoadingState.IN_APP_PURCHASE_CONTINUE,
                      text: "Continue",
                      displayIcnRight: true,
                      icn: CupertinoIcons.arrow_right,
                      onPressed: _continueBtnFunction
                    ),
                    context.height(6.0).hMargin,
                    IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextBtnWidget(
                              tooltip: "Term of Use",
                              text: "Term of Use",
                              decoration: TextDecoration.underline,
                              fontSize: 12.0,
                              onPressed: _termConditionBtnFunction
                          ),
                          // if(value) ...[
                          //   VerticalDivider(color: kBlackColor, width: context.width(1.0)).padding(padding: context.width(4.0).verticalEdgeInsets),
                          //   TextBtnWidget(
                          //       tooltip: "Free Trial",
                          //       text: "Try free trial",
                          //       fontSize: 12.0,
                          //       onPressed: () => context.pop()
                          //   ),
                          // ],
                          VerticalDivider(color: kWhiteColor, width: context.width(1.0)).padding(padding: context.width(4.0).verticalEdgeInsets),
                          TextBtnWidget(
                              tooltip: "Privacy Policy",
                              text: "Privacy Policy",
                              decoration: TextDecoration.underline,
                              fontSize: 12.0,
                              onPressed: _privacyPolicyBtnFunction
                          ),
                        ],
                      ),
                    ),
                    context.height(12.0).hMargin,
                  ],
                ).padding(padding: context.width(16.0).horizontalEdgeInsets),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Row(
                children: [
                  LoadingBtnWidget(
                      toolTip: "Restore",
                      text: "Restore",
                      padding: context.width(8.0).verticalEdgeInsets,
                      onPressed: () {
                        context.read<InAppPurchaseBloc>().restorePurchases();
                  }).sized(width: context.width(76.0)),
                  Spacer(),
                  IcnBtnWidget(
                      tooltip: "Back",
                      color: kWhiteColor,
                      icn: CupertinoIcons.clear_circled_solid,
                      onPressed: () {
                        context.pop();
                  })
                ],
              ).padding(padding: context.width(16.0).horizontalEdgeInsets.copyWith(top: context.height(46.0)))
            ),
            BlocBuilder<InAppPurchaseBloc, InAppPurchaseState>(
                builder: (context, inAppPurchaseState) {
              return inAppPurchaseState.isPurchasing ? LoadingViewWidget(
                title: "Purchasing",
              ) : SizedBox.shrink();
            })
          ]
        )
      )
    );
  }

  Widget _buildPremiumFeatureWidget({required String title}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.check_circle,
          size: context.width(20.0),
          color: kWhiteColor,
        ).gradient(gradient: kBlueGradient),
        context.width(14.0).wMargin,
        TextWidget(text: title, fontWeight: k600FontWeight, fontSize: 13.0)
      ]
    );
  }
}
