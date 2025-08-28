import 'package:flutter/material.dart';

class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 800;

    return Container(
      padding: const EdgeInsets.all(20),
      child: isSmallScreen
          ? Column(
              children: [
                _buildImage(),
                const SizedBox(height: 30),
                _buildSteps(),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: _buildImage()),
                const SizedBox(width: 40),
                Expanded(flex: 6, child: _buildSteps()),
              ],
            ),
    );
  }

  /// LEFT IMAGE
  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        "assets/photos/imag3.png", // replace with your image
        fit: BoxFit.cover,
      ),
    );
  }

  /// RIGHT SIDE STEPS
  Widget _buildSteps() {
    final steps = [
      {
        "title": "User Registration",
        "subtitle": "Create an account in easybuy",
        "icon": Icons.edit_note,
      },
      {
        "title": "Add the Scheme into your Account",
        "subtitle":
            "Add schemes registered in shops to your account or else create a new scheme & wait for approval",
        "icon": Icons.person_add_alt_1,
      },
      {
        "title": "Make online payment",
        "subtitle":
            "After approval make payments for each month through online",
        "icon": Icons.payment,
      },
      {
        "title": "Purchase after Scheme completion",
        "subtitle":
            "After all scheme payments you can make a purchase through online or any of our Physical shops",
        "icon": Icons.assignment_turned_in,
      },
    ];

    return Column(
      children: List.generate(
        steps.length,
        (index) => _buildStepCard(
          index + 1,
          steps[index]["title"] as String,
          steps[index]["subtitle"] as String,
          steps[index]["icon"] as IconData,
          isLast: index == steps.length - 1,
        ),
      ),
    );
  }

  /// SINGLE STEP CARD
  Widget _buildStepCard(
      int number, String title, String subtitle, IconData icon,
      {bool isLast = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // LEFT Number + Connector line
        Column(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: const Color(0xFFD2B48C),
              child: Text(
                "$number",
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            if (!isLast)
              Container(
                height: 60,
                width: 2,
                color: const Color(0xFFD2B48C),
              ),
          ],
        ),
        const SizedBox(width: 20),

        // RIGHT Card
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 25),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 30, color: Colors.black87),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF8B6F47))),
                      const SizedBox(height: 5),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
