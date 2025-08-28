import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
                    "assets/images/merladlog_white.png", // replace with your brand logo
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

          // 🔹 Payments
          // Column(
          //   children: [
          //     const Text("Payments",
          //         style: TextStyle(color: Colors.black54, fontSize: 14)),
          //     const SizedBox(height: 8),
          //     Image.asset(
          //       "assets/payment_logo.png", // example CC Avenue logo
          //       height: 30,
          //     ),
          //   ],
          // ),
          // const SizedBox(height: 30),

          // 🔹 Links Row
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 20,
            children: const [
              Text("Terms Of Use",
                  style: TextStyle(color: Colors.black54, fontSize: 13)),
              Text("Privacy Policy",
                  style: TextStyle(color: Colors.black54, fontSize: 13)),
              Text("Contact Us",
                  style: TextStyle(color: Colors.black54, fontSize: 13)),
              Text("FAQ",
                  style: TextStyle(color: Colors.black54, fontSize: 13)),
              Text("Feedback",
                  style: TextStyle(color: Colors.black54, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 20),

          // 🔹 Copyright
          const Text(
            "Copyright © 2025 Under Meralda Jewels. All Rights Reserved.\nNo imagery or logos contained within this site may be used without the express permission of Meralda Jewels Group.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _socialIcon(IconData icon) {
    return CircleAvatar(
      radius: 18,
      backgroundColor: Colors.grey.shade300,
      child: Icon(icon, size: 16, color: Colors.black54),
    );
  }
}
