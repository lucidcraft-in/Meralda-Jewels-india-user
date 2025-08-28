import 'package:flutter/material.dart';

class SsuranceContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: [
            // Header Section
            SizedBox(height: 10),
            Text(
              'Meralda Assurance',
              style: TextStyle(
                fontFamily: 'arsenica',
                fontSize: 36,
                // fontWeight: FontWeight.bold,
                color: Color(0xFFDEB887),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),

            // Circular Features Section
            Wrap(
              spacing: 60,
              runSpacing: 40,
              alignment: WrapAlignment.center,
              children: [
                CircularFeature(
                  icon: Icons.visibility,
                  title: 'Transparent\nPricing',
                ),
                CircularFeature(
                  icon: Icons.assignment_return,
                  title: 'Guaranteed\nBuyback',
                ),
                CircularFeature(
                  icon: Icons.build,
                  title: 'Lifetime\nMaintenance',
                ),
                CircularFeature(
                  icon: Icons.verified,
                  title: '100%\nHallmarked\nGold',
                ),
                CircularFeature(
                  icon: Icons.diamond,
                  title: 'Certified\nDiamonds &\nGemstones',
                ),
              ],
            ),

            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class DiamondIcon extends StatelessWidget {
  final IconData icon;
  final Color color;

  const DiamondIcon({
    Key? key,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 0.785398, // 45 degrees in radians
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Transform.rotate(
          angle: -0.785398, // Rotate icon back to normal
          child: Icon(
            icon,
            color: Colors.white,
            size: 40,
          ),
        ),
      ),
    );
  }
}

class CircularFeature extends StatelessWidget {
  final IconData icon;
  final String title;

  const CircularFeature({
    Key? key,
    required this.icon,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Color(0xFFDEB887),
              width: 2,
            ),
            color: Colors.white,
          ),
          child: Icon(
            icon,
            color: Color(0xFFDEB887),
            size: 30,
          ),
        ),
        SizedBox(height: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2C3E50),
            height: 1.3,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
