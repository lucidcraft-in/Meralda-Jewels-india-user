import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

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
              Row(
                children: [
                  _socialIcon(FontAwesomeIcons.facebookF),
                  const SizedBox(width: 12),
                  _socialIcon(FontAwesomeIcons.twitter),
                  const SizedBox(width: 12),
                  _socialIcon(FontAwesomeIcons.instagram),
                ],
              )
            ],
          ),
          const SizedBox(height: 30),

          // 🔹 Links Row (clickable)
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 20,
            children: [
              _footerLink(
                "Terms Of Use",
                "https://docs.google.com/document/d/1RuN2P5O6hEA3I3TBxqjVaXnNGhTdBLpxCmxzEHBmK10/edit?usp=sharing",
              ),
              _footerLink("Privacy Policy",
                  "https://docs.google.com/document/d/1RuN2P5O6hEA3I3TBxqjVaXnNGhTdBLpxCmxzEHBmK10/edit?usp=sharing"),
              _footerLink("Contact Us", "support@meraldajewels.com"),
              _footerLink("FAQ", "support@meraldajewels.com"),
              _footerLink("Feedback", "https://yourdomain.com/feedback"),
            ],
          ),
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

  static Widget _footerLink(String text, String url) {
    return InkWell(
      onTap: () async {
        final Uri uri = Uri.parse(url);
        try {
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        } catch (e) {
          print(e);
        }
      },
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black54,
          fontSize: 13,
          decoration: TextDecoration.underline, // modern web style
        ),
      ),
    );
  }

  static Widget _socialIcon(IconData icon) {
    return CircleAvatar(
      radius: 18,
      backgroundColor: Colors.grey.shade300,
      child: Icon(icon, size: 16, color: Colors.black54),
    );
  }
}
