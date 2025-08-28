import 'package:flutter/material.dart';

class GoldRateSection extends StatefulWidget {
  const GoldRateSection({super.key});

  @override
  State<GoldRateSection> createState() => _GoldRateSectionState();
}

class _GoldRateSectionState extends State<GoldRateSection> {
  int _hoveredIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            children: [
              const Text(
                "Today Gold Rate",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                "Live",
                style: TextStyle(color: Colors.green, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            "Last updated: 12:30 PM",
            style: TextStyle(
              fontSize: 13,
              color: Colors.black54,
            ),
          ),

          const SizedBox(height: 16),

          /// GOLD RATE CARDS
          Row(
            children: [
              Expanded(
                  child: _buildGoldRateCard(0, "24K", "₹6,725 / g", "+2.1%")),
              const SizedBox(width: 12),
              Expanded(
                  child: _buildGoldRateCard(1, "22K", "₹6,150 / g", "+1.8%")),
              const SizedBox(width: 12),
              Expanded(
                  child: _buildGoldRateCard(2, "18K", "₹4,890 / g", "+1.2%")),
            ],
          ),
        ],
      ),
    );
  }

  /// GOLD CARD WIDGET
  Widget _buildGoldRateCard(
      int index, String title, String price, String change) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredIndex = index),
      onExit: (_) => setState(() => _hoveredIndex = -1),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 200),
        scale: _hoveredIndex == index ? 1.05 : 1.0,
        child: Card(
          elevation: _hoveredIndex == index ? 10 : 6,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87)),
                const SizedBox(height: 8),
                Text(price,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.trending_up,
                        color: Colors.green, size: 18),
                    const SizedBox(width: 4),
                    Text(change,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.green)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class QuickAccessSection extends StatelessWidget {
  const QuickAccessSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// HEADER
        const Text(
          "Quick Access",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),

        /// QUICK ACCESS CARDS
        Row(
          children: [
            Expanded(
              child: _buildQuickAccessCard(
                title: "Purchase",
                subtitle: "Add new purchase",
                icon: Icons.shopping_cart,
                color: Colors.blue,
                onTap: () {
                  // TODO: Navigate to Purchase Screen
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildQuickAccessCard(
                title: "Sales",
                subtitle: "Add new sale",
                icon: Icons.sell,
                color: Colors.orange,
                onTap: () {
                  // TODO: Navigate to Sales Screen
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// CARD WIDGET
  Widget _buildQuickAccessCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87)),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
