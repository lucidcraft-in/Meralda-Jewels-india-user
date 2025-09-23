import 'package:cloud_firestore/cloud_firestore.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("goldrate")
            .limit(1)
            .snapshots()
            .map((snapshot) => snapshot.docs.first),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Text("No gold rate data available");
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          final gram = data["gram"] ?? 0;
          final eighteenGram = data["18gram"] ?? 0;
          final pavan = data["pavan"] ?? 0;
          final up = data["up"] ?? 0;
          final down = data["down"] ?? 0;
          final timestamp = (data["timestamp"] as Timestamp).toDate();

          return Column(
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
              Text(
                "Last updated: ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}",
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 16),

              /// GOLD RATE CARDS
              Row(
                children: [
                  Expanded(
                      child:
                          _buildGoldRateCard(0, "Per Gram", "₹$gram", "+$up")),
                  const SizedBox(width: 12),
                  Expanded(
                      child: _buildGoldRateCard(1, "18 Gram", "₹$eighteenGram",
                          down > 0 ? "-$down" : "+$up")),
                  const SizedBox(width: 12),
                  Expanded(
                      child: _buildGoldRateCard(2, "Pavan", "₹$pavan", "+$up")),
                ],
              ),
            ],
          );
        },
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
                    Icon(
                      change.startsWith("-")
                          ? Icons.trending_down
                          : Icons.trending_up,
                      color: change.startsWith("-") ? Colors.red : Colors.green,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(change,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: change.startsWith("-")
                                ? Colors.red
                                : Colors.green)),
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
