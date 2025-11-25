import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../schemeDiologs/WishlistInfoDialog.dart';
import '../../schemeDiologs/aspireDialog.dart';
import '../../webHome.dart';
import '../../webPayScreen.dart';
import '../../webProfile.dart';

Widget buildPlansSection(BuildContext context, bool isMobile) {
  final screenWidth = MediaQuery.of(context).size.width;
  final bool isTablet = screenWidth >= 600 && screenWidth < 1024;
  final bool isDesktop = screenWidth >= 1024;

  // Adjust padding and font sizes based on screen size
  final horizontalPadding = isMobile
      ? 20.0
      : isTablet
          ? 60.0
          : 100.0;
  final verticalPadding = isMobile
      ? 60.0
      : isTablet
          ? 80.0
          : 100.0;
  final titleFontSize = isMobile
      ? 28.0
      : isTablet
          ? 28.0
          : 38.0;

  return Container(
    padding: EdgeInsets.symmetric(
      horizontal: horizontalPadding,
      vertical: verticalPadding,
    ),
    color: const Color(0xFFFAFAFA),
    child: Column(
      children: [
        Text(
          'Choose Your Perfect Plan',
          style: TextStyle(
            fontFamily: "playfair",
            fontSize: titleFontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1A4D3E),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'Two exceptional ways to own your dream jewellery. Select the plan that matches your savings goals.',
          style: TextStyle(
            fontSize: isMobile ? 16 : 18,
            color: const Color(0xFF666666),
            height: 1.6,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 60),

        // Responsive layout
        if (isMobile)
          Column(
            children: [
              PlanCardWidget(
                title: 'Aspire',
                subtitle: 'Gateway to Luxury',
                description:
                    'The Meralda Aspire Jewellery Buying Plan is a gateway to owning coveted pieces by paying fixed instalments starting from only ₹2000 for 11 months. Each payment reserves a portion of gold weight equivalent to the amount paid, and, at the time of redemption, you can get your jewellery equivalent to the accumulated weight without paying any making charges up to 16%.',
                features: [
                  'Get Advantage of Average Gold Rate',
                  'Easy Monthly Instalments',
                ],
                isMobile: isMobile,
              ),
              const SizedBox(height: 30),
              PlanCardWidget(
                title: 'Wishlist',
                subtitle: 'Turn Desires into Reality',
                description:
                    'With the WishList Jewellery Buying Plan, we love to turn your desires into reality. Now, you can open an account with a minimum amount of 2000. You will be qualified for a bonus of up to 100% of your initial instalment if you make fixed monthly payments for 11 months continuously.',
                features: [
                  'Get up to 100% of the first instalment as a bonus.',
                  'Easy Monthly Instalments',
                  // 'Up to 100% bonus',
                  // '11 continuous payments',
                  // 'No hidden charges',
                ],
                isMobile: isMobile,
                isPopular: true,
                cardColor: const Color(0xFFD4A574),
              ),
            ],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: PlanCardWidget(
                  title: 'Aspire',
                  subtitle: 'Gateway to Luxury',
                  description:
                      'The Meralda Aspire Jewellery Buying Plan is a gateway to owning coveted pieces by paying fixed instalments starting from only ₹2000 for 11 months. Each payment reserves a portion of gold weight equivalent to the amount paid, and, at the time of redemption, you can get your jewellery equivalent to the accumulated weight without paying any making charges up to 16%.',
                  features: [
                    'Get Advantage of Average Gold Rate',
                    'Easy Monthly Instalments',
                  ],
                  isMobile: isMobile,
                  isPopular: true,
                ),
              ),
              SizedBox(width: isTablet ? 20 : 40),
              Expanded(
                child: PlanCardWidget(
                  title: 'Wishlist',
                  subtitle: 'Turn Desires into Reality',
                  description:
                      'With the WishList Jewellery Buying Plan, we love to turn your desires into reality. Now, you can open an account with a minimum amount of 2000. You will be qualified for a bonus of up to 100% of your initial instalment if you make fixed monthly payments for 11 months continuously.',
                  features: [
                    'Get up to 100% of the first instalment as a bonus.',
                    'Easy Monthly Instalments',
                  ],
                  isMobile: isMobile,
                  isPopular: false,
                  cardColor: const Color(0xFFD4A574),
                ),
              ),
            ],
          ),
      ],
    ),
  );
}

class PlanCardWidget extends StatefulWidget {
  final String title;
  final String subtitle;
  final String description;
  final List<String> features;
  final bool isMobile;
  final bool isPopular;
  final Color? cardColor;

  const PlanCardWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.features,
    required this.isMobile,
    this.isPopular = false,
    this.cardColor,
  });

  @override
  State<PlanCardWidget> createState() => _PlanCardWidgetState();
}

class _PlanCardWidgetState extends State<PlanCardWidget> {
  bool _hovering = false;
  bool _hoverPrimary = false;
  bool _hoverSecondary = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadUserLocally();
  }

  var user;
  Future loadUserLocally() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    if (pref.containsKey("user")) {
      var userData = pref.getString("user");

      if (userData != null) {
        user = json.decode(userData);

        // setState(() {
        //   _userName = user['id'] ?? '';
        // });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.cardColor ?? Colors.white;
    final textColor = widget.cardColor != null
        ? const Color(0xFF1A4D3E)
        : const Color(0xFF333333);
    print(widget.title);
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedScale(
        scale: _hovering ? 1.03 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: EdgeInsets.all(widget.isMobile ? 24 : 40),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontFamily: "playfair",
                      fontSize: widget.isMobile ? 22 : 30,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.subtitle,
                    style: TextStyle(
                      fontSize: widget.isMobile ? 12 : 14,
                      color: widget.cardColor != null
                          ? const Color(0xFF1A4D3E)
                          : const Color(0xFFD4A574),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.description,
                    style: TextStyle(
                      fontSize: widget.isMobile ? 12 : 13,
                      color: textColor.withOpacity(0.8),
                      height: 1.7,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ✅ Features List
                  ...widget.features.map(
                    (feature) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: widget.cardColor != null
                                ? Color.fromARGB(63, 27, 87, 31)
                                : Color.fromARGB(61, 212, 166, 116),
                            radius: 9,
                            child: Center(
                              child: Icon(
                                Icons.check,
                                color: widget.cardColor != null
                                    ? const Color(0xFF1A4D3E)
                                    : Color.fromARGB(244, 212, 166, 116),
                                size: 16,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              feature,
                              style: TextStyle(
                                fontSize: widget.isMobile ? 12 : 13,
                                color: textColor,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // 🔘 Primary Button ("Enroll Now")
                  MouseRegion(
                    onEnter: (_) => setState(() => _hoverPrimary = true),
                    onExit: (_) => setState(() => _hoverPrimary = false),
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        print(user);
                        if (user != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WebPayAmountScreen(
                                custName: user['id'],
                                userid: user["id"],
                                user: user,
                              ),
                            ),
                          );
                        } else {
                          showLoginDialog(context);
                        }
                        // showWishlistInfoDialog(context, "", "");
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: _hoverPrimary
                              ? const Color(0xFF246956) // lighter on hover
                              : const Color(0xFF1A4D3E),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Enroll Now',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                              ),
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              margin:
                                  EdgeInsets.only(left: _hoverPrimary ? 8 : 4),
                              child: Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                                size: _hoverPrimary ? 22 : 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ⚪ Secondary Button ("Learn More")
                  MouseRegion(
                    onEnter: (_) => setState(() => _hoverSecondary = true),
                    onExit: (_) => setState(() => _hoverSecondary = false),
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        widget.title != "Aspire"
                            ? showWishlistInfoDialog(context, "", "")
                            : showAspireInfoDialog(
                                // context, widget.username, widget.user);
                                context,
                                "",
                                {});
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: _hoverSecondary
                              ? Color.fromARGB(255, 244, 245,
                                  239) // slightly dark background on hover
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          // border: Border.all(
                          //   color: const Color(0xFF1A4D3E),
                          //   width: 1.4,
                          // ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Learn More',
                              style: TextStyle(
                                fontSize: 13,
                                color: widget.title == "Aspire"
                                    ? const Color(0xFFD4A574)
                                    : const Color(0xFF1A4D3E),
                              ),
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              margin: EdgeInsets.only(
                                  left: _hoverSecondary ? 8 : 4),
                              child: Icon(
                                Icons.arrow_forward_rounded,
                                color: widget.title == "Aspire"
                                    ? const Color(0xFFD4A574)
                                    : const Color(0xFF1A4D3E),
                                size: _hoverSecondary ? 22 : 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 🔖 Popular Tag
            if (widget.isPopular)
              Positioned(
                top: -12,
                right: 30,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A4D3E),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Popular Choice',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
