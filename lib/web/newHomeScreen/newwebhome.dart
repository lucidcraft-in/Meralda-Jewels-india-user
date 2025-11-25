import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:meralda_gold_user/common/colo_extension.dart';
import 'package:meralda_gold_user/web/newHomeScreen/utils/textColor.dart';
import 'package:meralda_gold_user/web/newHomeScreen/widget/benifitSection.dart';
import 'package:meralda_gold_user/web/newHomeScreen/widget/faqSection.dart';
import 'package:meralda_gold_user/web/newHomeScreen/widget/footerSection.dart';
import 'package:meralda_gold_user/web/newHomeScreen/widget/getInTouch.dart';
import 'package:meralda_gold_user/web/newHomeScreen/widget/heroSection.dart';
import 'package:meralda_gold_user/web/newHomeScreen/widget/howItWorkWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../webHome.dart';
import '../webPayScreen.dart';
import 'widget/planeSection.dart';

class Newwebhome extends StatefulWidget {
  const Newwebhome({Key? key}) : super(key: key);

  @override
  State<Newwebhome> createState() => _NewwebhomeState();
}

class _NewwebhomeState extends State<Newwebhome> {
  final ScrollController _scrollController = ScrollController();

  // Keys for each section
  final GlobalKey plansKey = GlobalKey();
  final GlobalKey howItWorksKey = GlobalKey();
  final GlobalKey benefitsKey = GlobalKey();
  final GlobalKey faqKey = GlobalKey();
  final GlobalKey contactKey = GlobalKey();

  void scrollToSection(GlobalKey key) {
    Scrollable.ensureVisible(
      key.currentContext!,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadUserLocally();
  }

  var user;
  String _userName = "";
  Future loadUserLocally() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    if (pref.containsKey("user")) {
      var userData = pref.getString("user");
      print(userData);
      if (userData != null) {
        setState(() {
          user = json.decode(userData);
        });

        setState(() {
          _userName = user['id'] ?? '';
        });
      }
    } else {
      showLoginDialog(context);
      // setState(() {
      //   _userName = '';
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      drawer: _buildDrawer(context), // <--- for mobile menu
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final bool isMobile = screenWidth < 600;
          final bool isTablet = screenWidth >= 600 && screenWidth < 1024;

          return SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                _buildAppBar(context, isMobile),
                BuildHeroSection(
                    isMobile: isMobile,
                    isTablet: isTablet,
                    onExplorePlans: () => scrollToSection(plansKey)),
                Container(
                    key: plansKey, child: buildPlansSection(context, isMobile)),
                Container(key: howItWorksKey, child: const HowItWorksScreen()),
                Container(key: benefitsKey, child: const BenefitsSection()),
                Container(key: faqKey, child: const FAQSection()),
                Container(key: contactKey, child: const ContactPage()),
                const FooterSection(),
              ],
            ),
          );
        },
      ),
    );
  }

  /// ✅ AppBar Section
  Widget _buildAppBar(BuildContext context, bool isMobile) {
    double logoHeight = !isMobile
        ? MediaQuery.of(context).size.height * .09
        :
        // : isMediumScreen
        // ?
        MediaQuery.of(context).size.height * .12;
    // : isSmallScreen
    //     ? MediaQuery.of(context).size.height * .10
    //     : MediaQuery.of(context).size.height * .08;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 60,
      ),
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.black.withOpacity(0.05),
      //       blurRadius: 10,
      //       offset: const Offset(0, 2),
      //     ),
      //   ],
      // ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  // color: const Color(0xFF1A4D3E),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WebPayAmountScreen(
                          custName: _userName,
                          userid: user["id"],
                          user: user,
                        ),
                      ),
                    );
                  },
                  child: Center(
                    child: Image.asset(
                      "assets/images/appbarLogo.png",
                      height: logoHeight,
                      width: 100,
                      fit: BoxFit
                          .contain, // Changed from fill to contain for better aspect ratio
                    ),
                  ),
                ),
              ),
            ],
          ),

          if (!isMobile)
            Row(
              children: [
                _buildNavItem('Our Plans', () => scrollToSection(plansKey)),
                _buildNavItem(
                    'How It Works', () => scrollToSection(howItWorksKey)),
                _buildNavItem('Benefits', () => scrollToSection(benefitsKey)),
                _buildNavItem('FAQ', () => scrollToSection(faqKey)),
                _buildNavItem('Contact', () => scrollToSection(contactKey)),
                const SizedBox(width: 20),
                const Icon(Icons.phone, size: 18, color: Color(0xFF1A4D3E)),
                const SizedBox(width: 5),
                const Text(
                  '+971 4 444 4444',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF1A4D3E),
                  ),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
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
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: TColo.primaryColor1,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      user != null ? "Dashboard" : 'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            )
          else
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu, color: Color(0xFF1A4D3E)),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
        ],
      ),
    );
  }

  /// ✅ Desktop Nav Item
  Widget _buildNavItem(String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            color: Color(0xFF1A4D3E),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  /// ✅ Drawer for mobile menu
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 40),
        children: [
          const ListTile(
            title: Text(
              'MERALDA',
              style: TextStyle(
                color: Color(0xFF1A4D3E),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          const Divider(),
          _buildDrawerItem('Our Plans', () {
            Navigator.pop(context);
            scrollToSection(plansKey);
          }),
          _buildDrawerItem('How It Works', () {
            Navigator.pop(context);
            scrollToSection(howItWorksKey);
          }),
          _buildDrawerItem('Benefits', () {
            Navigator.pop(context);
            scrollToSection(benefitsKey);
          }),
          _buildDrawerItem('FAQ', () {
            Navigator.pop(context);
            scrollToSection(faqKey);
          }),
          _buildDrawerItem('Contact', () {
            Navigator.pop(context);
            scrollToSection(contactKey);
          }),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(String title, VoidCallback onTap) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF1A4D3E),
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}
