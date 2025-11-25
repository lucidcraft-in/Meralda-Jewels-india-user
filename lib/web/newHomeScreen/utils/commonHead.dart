import 'package:flutter/material.dart';

class CommonHead extends StatelessWidget {
  CommonHead({super.key, required this.headLine, required this.subTitle});
  String headLine;
  String subTitle;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600 && screenWidth < 1024;
    final bool isDesktop = screenWidth >= 1024;
    final bool isMobile = screenWidth < 600;
    final titleFontSize = isTablet
        ? 28.0
        : isTablet
            ? 28.0
            : 38.0;
    final double subtitleSize = isMobile
        ? 14
        : isTablet
            ? 16
            : 18;
    return Column(
      children: [
        Text(
          headLine,
          style: TextStyle(
            fontFamily: "playfair",
            fontSize: titleFontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1A4D3E),
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          subTitle,
          style: TextStyle(
            fontSize: isMobile ? 16 : 18,
            color: const Color(0xFF666666),
            height: 1.6,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
