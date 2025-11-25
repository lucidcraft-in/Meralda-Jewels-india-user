import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../utils/commonHead.dart';

class BenefitsSection extends StatelessWidget {
  const BenefitsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 60),
        CommonHead(
          headLine: "Why Choose Meralda",
          subTitle:
              'Experience trust, transparency, and unmatched value with every purchase',
        ),
        const SizedBox(height: 60),
        LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 600;
            final isTablet =
                constraints.maxWidth >= 600 && constraints.maxWidth < 1100;
            final isDesktop = constraints.maxWidth >= 1100;

            // Common section padding
            final horizontalPadding = isMobile
                ? 20.0
                : isTablet
                    ? 60.0
                    : 120.0;

            return Container(
              color: const Color(0xFFF8F8F5),
              padding: EdgeInsets.symmetric(
                vertical: isMobile ? 40 : 80,
                horizontal: horizontalPadding,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1400),
                  child: isDesktop
                      ? _buildDesktopLayout(context)
                      : _buildMobileTabletLayout(context, isTablet: isTablet),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  /// ------------------- 📱 MOBILE / 💻 TABLET -------------------
  Widget _buildMobileTabletLayout(BuildContext context,
      {required bool isTablet}) {
    return Column(
      children: [
        /// Benefits List (Mobile) or Grid (Tablet)
        isTablet
            ? _buildBenefitsGrid(isTablet: isTablet)
            : _buildBenefitsList(),

        const SizedBox(height: 40),

        /// Image Section
        Stack(
          alignment: Alignment.bottomLeft,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                "assets/photos/imag1.png",
                fit: BoxFit.cover,
                height: 500,
                width: double.infinity,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Trusted by Families",
                    style: TextStyle(
                      fontFamily: "playfair",
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Making dreams come true since our inception",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// ------------------- 🖥 DESKTOP -------------------
  Widget _buildDesktopLayout(BuildContext context) {
    return Column(
      children: [
        /// Image Section - CENTERED
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 60),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      "assets/photos/imag1.png",
                      fit: BoxFit.cover,
                      height: 400,
                      width: double.infinity,
                    ),
                  ),
                  Container(
                    height: 400,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.4),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Trusted by Families",
                          style: TextStyle(
                            fontFamily: "playfair",
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Making dreams come true since our inception",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        /// Benefits Grid Section
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: _buildBenefitsGrid(isTablet: false),
          ),
        ),
      ],
    );
  }

  /// ------------------- MOBILE LIST VIEW -------------------
  Widget _buildBenefitsList() {
    final benefits = [
      {
        'icon': FontAwesomeIcons.scaleBalanced,
        'title': "Transparent Pricing",
        'description':
            "Know what you pay for. We provide exact details of gold weight, stone weight, making charges, taxes, and more.",
      },
      {
        'icon': FontAwesomeIcons.gem,
        'title': "Certified Diamonds & Gemstones",
        'description':
            "All our diamonds and gemstones are certified by internationally accredited laboratories.",
      },
      {
        'icon': FontAwesomeIcons.infinity,
        'title': "Lifetime Maintenance",
        'description':
            "Enjoy lifetime free maintenance to keep your jewellery shining forever.",
      },
      {
        'icon': FontAwesomeIcons.handHoldingUsd,
        'title': "Guaranteed Buyback",
        'description':
            "We offer buyback of all our products so you always get the best value for your assets.",
      },
      {
        'icon': FontAwesomeIcons.certificate,
        'title': "100% Hallmarked Jewellery",
        'description':
            "Each piece carries Hallmark Unique Identification (HUID) for verified purity assurance.",
      },
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: benefits.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final benefit = benefits[index];
        return _BenefitCard(
          icon: benefit['icon'] as IconData,
          title: benefit['title'] as String,
          description: benefit['description'] as String,
          isTab: false,
          isList: true,
        );
      },
    );
  }

  /// ------------------- GRID BUILDER -------------------
  Widget _buildBenefitsGrid({required bool isTablet}) {
    int crossAxisCount = isTablet ? 2 : 3; // 3 columns on desktop, 2 on tablet
    double aspectRatio = isTablet ? 2.6 : 1.5;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: 24,
      mainAxisSpacing: 24,
      childAspectRatio: aspectRatio,
      children: [
        _BenefitCard(
          icon: FontAwesomeIcons.scaleBalanced,
          title: "Transparent Pricing",
          description:
              "Know what you pay for. We provide exact details of gold weight, stone weight, making charges, taxes, and more.",
          isTab: isTablet,
        ),
        _BenefitCard(
          icon: FontAwesomeIcons.gem,
          title: "Certified Diamonds & Gemstones",
          description:
              "All our diamonds and gemstones are certified by internationally accredited laboratories.",
          isTab: isTablet,
        ),
        _BenefitCard(
          icon: FontAwesomeIcons.infinity,
          title: "Lifetime Maintenance",
          description:
              "Enjoy lifetime free maintenance to keep your jewellery shining forever.",
          isTab: isTablet,
        ),
        _BenefitCard(
          icon: FontAwesomeIcons.handHoldingUsd,
          title: "Guaranteed Buyback",
          description:
              "We offer buyback of all our products so you always get the best value for your assets.",
          isTab: isTablet,
        ),
        _BenefitCard(
          icon: FontAwesomeIcons.certificate,
          title: "100% Hallmarked Jewellery",
          description:
              "Each piece carries Hallmark Unique Identification (HUID) for verified purity assurance.",
          isTab: isTablet,
        ),
      ],
    );
  }
}

/// ------------------- ANIMATED BENEFIT CARD -------------------
class _BenefitCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isTab;
  final bool isList;

  const _BenefitCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.isTab,
    this.isList = false,
  });

  @override
  State<_BenefitCard> createState() => _BenefitCardState();
}

class _BenefitCardState extends State<_BenefitCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(
          0,
          _isHovered ? -6 : 0,
          0,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_isHovered ? 0.12 : 0.05),
              blurRadius: _isHovered ? 20 : 10,
              offset: Offset(0, _isHovered ? 8 : 3),
            ),
          ],
        ),
        padding: widget.isList
            ? const EdgeInsets.all(20)
            : widget.isTab
                ? const EdgeInsets.symmetric(horizontal: 20, vertical: 24)
                : const EdgeInsets.all(24),
        child: widget.isList || widget.isTab
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: _isHovered
                          ? const Color(0xFFF5E9D3)
                          : const Color(0xFFFDF7E7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Icon(
                      widget.icon,
                      color: _isHovered
                          ? const Color(0xFFA68849)
                          : const Color(0xFFBFA05A),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontFamily: "playfair",
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: _isHovered
                                ? const Color(0xFF000000)
                                : const Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.description,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: _isHovered
                          ? const Color(0xFFF5E9D3)
                          : const Color(0xFFFDF7E7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Icon(
                      widget.icon,
                      color: _isHovered
                          ? const Color(0xFFA68849)
                          : const Color(0xFFBFA05A),
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontFamily: "playfair",
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: _isHovered
                          ? const Color(0xFF000000)
                          : const Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Text(
                      widget.description,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
