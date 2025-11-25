import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meralda_gold_user/web/helperWidget.dart/documentsDialog.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/colo_extension.dart';

class CustomFooter extends StatelessWidget {
  const CustomFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 255, 255, 255),
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: Column(
        children: [
          // 🔹 Top row: Brand + Social Media
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    "Powered by ",
                    style: TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                  Image.asset(
                    "assets/images/merladlog_white.png",
                    height: 60,
                  ),
                ],
              ),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 20,
                children: [
                  _footerLink("Terms Of Use", context,
                      () => showTermsAndConditionsDialog(context)),
                  _footerLink("Privacy Policy", context,
                      () => showPrivacyPolicyDialog(context)),
                  _footerLink("Contact Us", context,
                      () => showContactUsDialog(context)),
                  // _footerLink("FAQ", context, () => showFAQDialog(context)),
                  // _footerLink(
                  //     "Feedback", context, () => showFeedbackDialog(context)),
                ],
              ),
              Row(
                children: [
                  _socialIcon(FontAwesomeIcons.facebookF,
                      "https://www.facebook.com/meraldajewels/"),
                  const SizedBox(width: 12),
                  _socialIcon(
                      FontAwesomeIcons.twitter, "https://x.com/meraldajewels"),
                  const SizedBox(width: 12),
                  _socialIcon(FontAwesomeIcons.instagram,
                      "https://www.instagram.com/meralda.jewels/?hl=en"),
                ],
              )
            ],
          ),
          const SizedBox(height: 30),

          // Wrap(
          //   alignment: WrapAlignment.center,
          //   spacing: 20,
          //   children: [
          //     _footerLink("Terms Of Use", context,
          //         () => showTermsAndConditionsDialog(context)),
          //     _footerLink("Privacy Policy", context,
          //         () => showPrivacyPolicyDialog(context)),
          //     _footerLink(
          //         "Contact Us", context, () => showContactUsDialog(context)),
          //     // _footerLink("FAQ", context, () => showFAQDialog(context)),
          //     // _footerLink(
          //     //     "Feedback", context, () => showFeedbackDialog(context)),
          //   ],
          // ),
          const SizedBox(height: 20),

          // 🔹 Copyright
          const Text(
            "Copyright © 2025 Under Meralda Jewels. All Rights Reserved.\n"
            "No imagery or logos contained within this site may be used without the express permission of Meralda Jewels Group.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // static Widget _footerLink(String text, String url, BuildContext context) {
  //   return InkWell(
  //     onTap: () async {
  //       // final Uri uri = Uri.parse(url);
  //       // try {
  //       //   if (await canLaunchUrl(uri)) {
  //       //     await launchUrl(uri, mode: LaunchMode.externalApplication);
  //       //   }
  //       // } catch (e) {
  //       //   print(e);
  //       // }
  //       if (text == "Terms Of Use") {
  //         showTermsAndConditionsDialog(context);
  //       }
  //     },
  //     child: Text(
  //       text,
  //       style: const TextStyle(
  //         color: Colors.black54,
  //         fontSize: 13,
  //         decoration: TextDecoration.underline, // modern web style
  //       ),
  //     ),
  //   );
  // }

  Widget _footerLink(String text, BuildContext context, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
          color: TColo.primaryColor1,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  static Widget _socialIcon(IconData icon, String url) {
    return InkWell(
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      borderRadius: BorderRadius.circular(18),
      child: CircleAvatar(
        radius: 18,
        backgroundColor: Colors.grey.shade300,
        child: Icon(icon, size: 16, color: Colors.black54),
      ),
    );
  }
}
