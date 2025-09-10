import 'package:flutter/material.dart';
import 'package:image_enhancer_app/create_category/view/widget/app_bar_widget.dart';
import 'package:image_enhancer_app/create_category/view/widget/medium_heading_widget.dart';
import 'package:image_enhancer_app/splash/view/widget/text_widget.dart';
import 'package:image_enhancer_app/utils/constant/color.dart';
import 'package:image_enhancer_app/utils/extension/common_extension.dart';
import 'package:image_enhancer_app/utils/extension/snackbar_extension.dart';
import 'package:image_enhancer_app/utils/extension/widget_extension.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpAndSupportScreen extends StatefulWidget {
  const HelpAndSupportScreen({super.key});

  @override
  State<HelpAndSupportScreen> createState() => _HelpAndSupportScreenState();
}

class _HelpAndSupportScreenState extends State<HelpAndSupportScreen> {

  void _openWebsiteFunction() {
    _urlLauncherFunction(url: "https://www.devsrank.com/");
  }

  void _urlLauncherFunction({required String url}) async {

    final Uri emailLaunchUri = Uri.parse(url);

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      context.showSnackBar(msg: "No browser app found. Please install browser");
    }
  }

  void _launchPhoneDialer() async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: "+923001234968",
    );
    if (await launchUrl(launchUri)) {

    } else {
      context.showSnackBar(msg: "Something went wrong");
    }
  }


  void _helpAndSupportBtnFunction() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'hello@devsrank.com',
      query: Uri.encodeFull(
        'subject=Support Needed&body=Hi Team, I need help regarding...',
      ),
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri, mode: LaunchMode.externalApplication);
    } else {
      final Uri gmailWebUri = Uri.parse(
        'https://mail.google.com/mail/?view=cm&fs=1&to=info@devsrank.com&su=Support%20Needed&body=Hi%20Team,%20I%20need%20help%20regarding...',
      );
      if (await canLaunchUrl(gmailWebUri)) {
        await launchUrl(gmailWebUri, mode: LaunchMode.externalApplication);
      } else {
        context.showSnackBar(msg: "No email app found. Please install Gmail");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget.build(context: context, title: "Help & Support"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.width(16.0)),
        child: Column(
          children: [
            context.height(16.0).hMargin,
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(context.width(14.0))
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MediumHeadingWidget(title: "Information"),
                  context.height(8.0).hMargin,
                  ListView.separated(
                    itemCount: 3,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) =>
                        SizedBox(height: context.height(16.0)),
                    itemBuilder: (context, index) {
                      return MaterialButton(
                          elevation: .0,
                          color: kGrey2Color,
                          padding: EdgeInsets.zero,
                          highlightElevation: 1.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(context.width(100.0)),
                              side: BorderSide(color: Colors.grey, width: .1)
                          ),
                          onPressed: [
                            _helpAndSupportBtnFunction,
                            _openWebsiteFunction,
                            _launchPhoneDialer
                          ][index],
                          child: Padding(
                            padding: EdgeInsets.all(context.width(12)),
                            child: Row(
                              children: [
                                Icon(
                                  <IconData>[
                                    Icons.mail_outline,
                                    Icons.link,
                                    Icons.call_outlined
                                  ][index],
                                  size: context.width(24.0),
                                  color: Colors.white,
                                ),
                                context.width(10.0).wMargin,
                                TextWidget(
                                  text: [
                                    "hello@devsrank.com",
                                    "www.devsrank.com",
                                    "+923001234968"
                                  ][index],
                                ),
                                const Spacer(),
                                Icon(Icons.arrow_forward_ios, size: context.width(18.0), color: Colors.white),
                              ],
                            ),
                          )
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
