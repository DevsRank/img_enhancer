
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_enhancer_app/create_category/view/widget/img_widget.dart';
import 'package:image_enhancer_app/create_category/view/widget/loading_btn_widget.dart';
import 'package:image_enhancer_app/help_and_support/view/screen/help_and_support_screen.dart';
import 'package:image_enhancer_app/premium/view/screen/premium_screen.dart';
import 'package:image_enhancer_app/service/in_app_purchase/in_app_purchase_subscription_bloc.dart';
import 'package:image_enhancer_app/setting/view/widget/premium_widget_visibility_widget.dart';
import 'package:image_enhancer_app/splash/view/widget/text_widget.dart';
import 'package:image_enhancer_app/utils/constant/alignment.dart';
import 'package:image_enhancer_app/utils/constant/color.dart';
import 'package:image_enhancer_app/utils/constant/font_weight.dart';
import 'package:image_enhancer_app/utils/constant/image_path.dart';
import 'package:image_enhancer_app/utils/constant/padding.dart';
import 'package:image_enhancer_app/utils/enum/img_type.dart';
import 'package:image_enhancer_app/utils/extension/common_extension.dart';
import 'package:image_enhancer_app/utils/extension/navigator_extension.dart';
import 'package:image_enhancer_app/utils/extension/snackbar_extension.dart';
import 'package:image_enhancer_app/utils/extension/widget_extension.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> with AutomaticKeepAliveClientMixin {

  void _appReviewBtnFunction() async {
    if(await InAppReview.instance.isAvailable()) await InAppReview.instance.openStoreListing(appStoreId: "6748871047");
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

  void _shareAppBtnFunction() {
    SharePlus.instance.share(ShareParams(
      title: "PixeLift",
      text: Platform.isIOS
          ? "https://apps.apple.com/app/id=6748871047"
          : 'https://play.google.com/store/apps/details?id=com.jetset_ride.app',
    ));
  }

  void _helpAndSupportBtnFunction() {
    context.push(widget: HelpAndSupportScreen());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            PremiumWidgetVisibilityWidget(
              child: Column(
                children: [
                  context.height(16.0).hMargin,
                  Container(
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: kBlueColor,
                        width: context.width(1.0),
                      ),
                      borderRadius: context.width(14.0).borderRadius,
                    ),
                    child: ClipRRect(
                      borderRadius: context.width(14.0).borderRadius,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            right: -186.0,
                            child: Transform.scale(
                              scale: 1.4,
                              child: ImgWidget(
                                  imgType: ImgType.asset,
                                  img: kPremiumBannerBkgImg,
                                  fit: BoxFit.contain,
                                  borderRadius: context.width(14.0).borderRadius
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 6,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          kBlackColor,
                                          kBlackColor,
                                          kTransparentColor,
                                        ],
                                      ),
                                      borderRadius: context.width(14.0).borderRadius,
                                    ),
                                  ),
                                ),
                                Expanded(child: SizedBox.shrink()),
                              ],
                            ),
                          ),
                          Column(
                            mainAxisSize: kMinMainAxisSize,
                            crossAxisAlignment: kStartCrossAxisAlignment,
                            children: [
                              TextWidget(
                                text: "Transform Your\nPhotos with\nAI Magic",
                                fontSize: 22.0,
                                fontWeight: k900FontWeight,
                                color: kWhiteColor,
                                height: .0,
                              ).padding(
                                padding: EdgeInsets.only(
                                  left: context.width(16.0),
                                  top: context.width(16.0),
                                ),
                              ),
                              context.width(8.0).hMargin,
                              LoadingBtnWidget(
                                text: "Upgrade",
                                padding: 10.0.verticalEdgeInsets,
                                onPressed: () {
                                  context.push(widget: PremiumScreen());
                                },
                              )
                                  .sized(
                                  width: context.width(104.0)
                              )
                                  .padding(
                                padding: EdgeInsets.only(
                                  left: context.width(16.0),
                                  bottom: context.width(16.0),
                                ),
                              ),
                            ],
                          )

                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            context.height(16.0).hMargin,
            ListView.separated(
              itemCount: 5,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) =>
                  SizedBox(height: context.height(16.0)),
              itemBuilder: (context, index) {
                return MaterialButton(
                  elevation: .0,
                  color: kGrey3Color,
                  padding: kZeroEdgeInsets,
                  highlightElevation: 1.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: context.width(100.0).borderRadius,
                    side: BorderSide(color: kGreyColor, width: .1)
                  ),
                  onPressed: [
                    _helpAndSupportBtnFunction,
                    _appReviewBtnFunction,
                    _shareAppBtnFunction,
                    _privacyPolicyBtnFunction,
                    _termConditionBtnFunction
                  ][index],
                  child: Row(
                    children: [
                      Icon(
                        <IconData>[
                          Icons.support_agent_outlined,
                          Icons.star,
                          Icons.share_outlined,
                          Icons.local_police_outlined,
                          Icons.list_alt_outlined,
                        ][index],
                        size: context.width(24.0),
                        color: kGreyColor,
                      ),
                      context.width(10.0).wMargin,
                      TextWidget(
                        text: [
                          "Help & Support",
                          "Rate Us",
                          "Share App",
                          "Privacy Policy",
                          "Terms of Use",
                        ][index],
                      ),
                      const Spacer(),
                      Icon(Icons.arrow_forward_ios, size: context.width(20.0), color: kWhiteColor),
                    ],
                  ).padding(padding: context.width(12).allEdgeInsets),
                );
              },
            ),
            context.height(16.0).hMargin,

          ],
        ).padding(padding: context.width(16.0).horizontalEdgeInsets),
      )
    );
  }

  @override
  bool get wantKeepAlive => true;
}
