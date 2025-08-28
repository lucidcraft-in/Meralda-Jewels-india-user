import 'package:flutter/material.dart';

class LocationSection extends StatelessWidget {
  final List<Map<String, String>> locations = [
    {
      "image": "assets/jewelleryLoc/kozhikode.jpg",
      "title": "KOZHIKODE",
      "phone": "0495-2773916",
      "mobile": "+91 8111 859 916",
      "address": "Near Arayidathupalam, Mavoor Road, Kozhikode - 673004",
    },
    {
      "image": "assets/jewelleryLoc/kochi_370x.jpg",
      "title": "KOCHI",
      "phone": "0484-2944916",
      "mobile": "+91 8113 022 916",
      "address": "Iyyattil Junction, MG Road, Kochi - 682011",
    },
    {
      "image": "assets/jewelleryLoc/kannur_370x.jpg",
      "title": "KANNUR",
      "phone": "0497-2999916",
      "mobile": "+91 9645 033 916",
      "address": "MG Road, Near New Bus Stand, Kannur - 670001",
    },
    {
      "image": "assets/jewelleryLoc/karnataka_370x.jpg",
      "title": "MANGALURU",
      "phone": "0824-4621515",
      "mobile": " +91 8747 999 916",
      "address":
          "Balmatta Rd, opposite Don Bosco Hall Hampankatta, Mangaluru Karnataka - 575001",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            const Text(
              "INDIA LOCATIONS",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 50,
              runSpacing: 20,
              alignment: WrapAlignment.spaceEvenly,
              children: locations.map((loc) {
                return Container(
                  width: 260,
                  height: 400,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _ZoomableImage(image: loc["image"]!),
                      const SizedBox(height: 10),
                      Text(
                        loc["title"]!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text("☎ ${loc["phone"]}"),
                      Text("📱 ${loc["mobile"]}"),
                      const SizedBox(height: 6),
                      Text(
                        loc["address"]!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text("LOCATE US"),
                      )
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

/// 🔥 Reusable widget for zoom effect
class _ZoomableImage extends StatefulWidget {
  final String image;
  const _ZoomableImage({required this.image});

  @override
  State<_ZoomableImage> createState() => _ZoomableImageState();
}

class _ZoomableImageState extends State<_ZoomableImage> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedScale(
        scale: _hovering ? 1.08 : 1.0, // zoom effect
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            widget.image,
            fit: BoxFit.cover,
            height: 160,
            width: 260,
          ),
        ),
      ),
    );
  }
}
