import 'package:flutter/material.dart';

import '../utils/textColor.dart';

class BuildHeroSection extends StatelessWidget {
  const BuildHeroSection({
    super.key,
    required this.isMobile,
    this.isTablet = false,
    required this.onExplorePlans,
  });

  final bool isMobile;
  final bool isTablet;
  final VoidCallback onExplorePlans; // ✅ new callback

  @override
  Widget build(BuildContext context) {
    final double height = isMobile
        ? 500
        : isTablet
            ? 600
            : 700;
    final double horizontalPadding = isMobile
        ? 16
        : isTablet
            ? 48
            : 80;
    final double verticalPadding = isMobile
        ? 40
        : isTablet
            ? 60
            : 80;

    return Container(
      width: double.infinity,
      height: height,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
              'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?w=1600'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              const Color(0xFF1A4D3E).withOpacity(0.95),
              const Color(0xFF1A4D3E).withOpacity(0.4),
            ],
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: GoldSavingsSection(onExplorePlans: onExplorePlans),
      ),
    );
  }
}

class GoldSavingsSection extends StatefulWidget {
  const GoldSavingsSection({super.key, required this.onExplorePlans});
  final VoidCallback onExplorePlans;

  @override
  State<GoldSavingsSection> createState() => _GoldSavingsSectionState();
}

class _GoldSavingsSectionState extends State<GoldSavingsSection>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  final List<String> bulletPoints = [
    "100% BIS Hallmarked",
    "Guaranteed Purity",
    "Flexible Payment Options",
  ];

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool isMobile = width < 600;
    final bool isTablet = width >= 600 && width < 1024;

    final double titleSize = isMobile
        ? 36
        : isTablet
            ? 48
            : 64;
    final double subtitleSize = isMobile
        ? 14
        : isTablet
            ? 16
            : 18;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Tag
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color.fromARGB(64, 212, 166, 116),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.auto_awesome, color: Color(0xFFD4A574), size: 16),
              SizedBox(width: 8),
              Text(
                'A Medley of Desires',
                style: TextStyle(
                  color: ColorConstant.whiteText,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),

        // Title
        Text(
          'Start Your Gold\nSavings Journey Today',
          style: TextStyle(
            fontFamily: "playfair",
            fontSize: titleSize,
            fontWeight: FontWeight.bold,
            color: ColorConstant.whiteText,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 20),

        // Subtitle
        Text(
          'Own your dream jewellery with easy monthly installments. Choose from our Aspire and Wishlist plans designed to make luxury accessible.',
          style: TextStyle(
            fontSize: subtitleSize,
            color: ColorConstant.whiteText,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 40),

        // Button with hover
        MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            onTap: widget.onExplorePlans,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              decoration: BoxDecoration(
                color: _isHovered
                    ? const Color(0xFFC4925F)
                    : const Color(0xFFD4A574),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Explore Plans',
                    style: TextStyle(
                      color: Color(0xFF1A4D3E),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, color: Color(0xFF1A4D3E), size: 20),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 40),

        // Animated bullet tags
        Wrap(
          spacing: 30,
          runSpacing: 10,
          children: bulletPoints.map((text) {
            return AnimatedBuilder(
              animation: _animation,
              builder: (context, child) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.lerp(
                        const Color(0xFFD4A574).withOpacity(0.6),
                        const Color(0xFFD4A574),
                        _animation.value,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    text,
                    style: TextStyle(
                      color: ColorConstant.whiteText,
                      fontSize: isMobile ? 12 : 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
