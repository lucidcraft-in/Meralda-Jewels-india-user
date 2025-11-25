import 'package:flutter/material.dart';
import 'package:meralda_gold_user/web/newHomeScreen/utils/commonHead.dart';

class HowItWorksScreen extends StatelessWidget {
  const HowItWorksScreen({Key? key}) : super(key: key);

  // ✅ Updated Step Data List (7 Steps Now)
  List<Map<String, dynamic>> get steps => [
        {
          'icon': Icons.person_add_outlined,
          'title': 'Choose Your Plan',
          'description':
              'Select either Aspire or WishList plan based on your savings goals and preferences.',
        },
        {
          'icon': Icons.credit_card_outlined,
          'title': 'Pay Monthly Instalments',
          'description':
              'If you miss two consecutive instalments, your plan and benefits will be recalculated based on the total amount paid up to that point.',
        },
        {
          'icon': Icons.trending_up_outlined,
          'title': 'Track Progress Online',
          'description':
              'Monitor your accumulated gold weight or value through your customer dashboard.',
        },
        {
          'icon': Icons.card_giftcard_outlined,
          'title': 'Payment Options',
          'description':
              'Pay easily via cash, card, cheque, UPI, or online at scheme.meraldajewels.com.',
        },
        {
          'icon': Icons.access_time_outlined,
          'title': 'Plan Validity',
          'description':
              'Your plan matures after 11 months and must be redeemed within 400 days of enrolment.',
        },
        {
          'icon': Icons.event_busy_outlined,
          'title': 'Post Maturity',
          'description':
              'If you miss the redemption date, you’ll get only the paid amount back.',
        },
        {
          'icon': Icons.badge_outlined,
          'title': 'Required Documents',
          'description':
              'Provide a valid photo ID such as Aadhaar, PAN, or Passport.',
        },
      ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
        child: Column(
          children: [
            CommonHead(
              headLine: "How It Works",
              subTitle: 'Start your gold savings journey in four simple steps',
            ),
            const SizedBox(height: 60),

            /// 📱 Responsive Layout
            LayoutBuilder(
              builder: (context, constraints) {
                final screenWidth = constraints.maxWidth;
                final isDesktop = screenWidth >= 1024;
                final isTablet = screenWidth > 600 && screenWidth <= 1200;

                if (isDesktop) {
                  return ModernDesktopLayout(steps: steps);
                } else if (isTablet) {
                  return TabletLayout(steps: steps);
                } else {
                  return MobileLayout(steps: steps);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------
// 📱 Mobile Layout
// ------------------------------
class MobileLayout extends StatelessWidget {
  final List<Map<String, dynamic>> steps;
  const MobileLayout({Key? key, required this.steps}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: StepCard(
            icon: step['icon'],
            title: step['title'],
            description: step['description'],
            stepNumber: '${index + 1}',
            showNumberOnRight: true,
          ),
        );
      }),
    );
  }
}

// ------------------------------
// 💻 Tablet Layout (2x2 Grid)
// ------------------------------
class TabletLayout extends StatelessWidget {
  final List<Map<String, dynamic>> steps;
  const TabletLayout({Key? key, required this.steps}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < steps.length; i += 2)
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: StepCard(
                    icon: steps[i]['icon'],
                    title: steps[i]['title'],
                    description: steps[i]['description'],
                    stepNumber: '${i + 1}',
                    showNumberOnRight: true,
                  ),
                ),
                const SizedBox(width: 20),
                if (i + 1 < steps.length)
                  Expanded(
                    child: StepCard(
                      icon: steps[i + 1]['icon'],
                      title: steps[i + 1]['title'],
                      description: steps[i + 1]['description'],
                      stepNumber: '${i + 2}',
                      showNumberOnRight: true,
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

// // ------------------------------
// // 🖥️ Desktop Layout (Horizontal Flow)
// // ------------------------------
// class DesktopLayout extends StatelessWidget {
//   final List<Map<String, dynamic>> steps;
//   const DesktopLayout({Key? key, required this.steps}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 50),
//       child: Stack(
//         children: [
//           // Connector Line
//           Positioned(
//             top: 30,
//             left: 0,
//             right: 0,
//             child: Container(
//               height: 2,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     const Color(0xFFD4A574).withOpacity(0.2),
//                     const Color(0xFFD4A574),
//                     const Color(0xFFD4A574),
//                     const Color(0xFFD4A574).withOpacity(0.2),
//                   ],
//                 ),
//               ),
//             ),
//           ),

//           // Step Cards Row
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: List.generate(steps.length, (index) {
//               final step = steps[index];
//               return Expanded(
//                 child: Padding(
//                   padding: EdgeInsets.only(
//                     left: index == 0 ? 0 : 12,
//                     right: index == steps.length - 1 ? 0 : 12,
//                   ),
//                   child: _DesktopStepCard(
//                     number: '${index + 1}',
//                     icon: step['icon'],
//                     title: step['title'],
//                     description: step['description'],
//                   ),
//                 ),
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ------------------------------
// // 🧱 Desktop Step Card with Hover Animation
// // ------------------------------
// class _DesktopStepCard extends StatefulWidget {
//   final String number;
//   final IconData icon;
//   final String title;
//   final String description;

//   const _DesktopStepCard({
//     required this.number,
//     required this.icon,
//     required this.title,
//     required this.description,
//   });

//   @override
//   State<_DesktopStepCard> createState() => _DesktopStepCardState();
// }

// class _DesktopStepCardState extends State<_DesktopStepCard> {
//   bool _isHovered = false;

//   @override
//   Widget build(BuildContext context) {
//     return MouseRegion(
//       onEnter: (_) => setState(() => _isHovered = true),
//       onExit: (_) => setState(() => _isHovered = false),
//       cursor: SystemMouseCursors.click,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           // Number Circle
//           AnimatedContainer(
//             duration: const Duration(milliseconds: 300),
//             curve: Curves.easeOut,
//             width: 50,
//             height: 50,
//             decoration: BoxDecoration(
//               color: _isHovered
//                   ? const Color(0xFFBF8E4A)
//                   : const Color(0xFFD4A574),
//               shape: BoxShape.circle,
//               boxShadow: _isHovered
//                   ? [
//                       BoxShadow(
//                         color: const Color(0xFFD4A574).withOpacity(0.4),
//                         blurRadius: 12,
//                         offset: const Offset(0, 4),
//                       ),
//                     ]
//                   : [],
//             ),
//             child: Center(
//               child: Text(
//                 widget.number,
//                 style: const TextStyle(
//                   fontSize: 17,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 24),

//           // Step Card
//           AnimatedContainer(
//             duration: const Duration(milliseconds: 300),
//             curve: Curves.easeOut,
//             transform: Matrix4.translationValues(0, _isHovered ? -8 : 0, 0),
//             padding: const EdgeInsets.all(32),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(_isHovered ? 0.08 : 0.03),
//                   blurRadius: _isHovered ? 20 : 10,
//                   offset: Offset(0, _isHovered ? 8 : 4),
//                 ),
//               ],
//             ),
//             child: Column(
//               children: [
//                 AnimatedContainer(
//                   duration: const Duration(milliseconds: 300),
//                   width: 64,
//                   height: 64,
//                   decoration: BoxDecoration(
//                     color: _isHovered
//                         ? const Color(0xFFFFEFD5)
//                         : const Color(0xFFFFF8F0),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Icon(
//                     widget.icon,
//                     size: 32,
//                     color: _isHovered
//                         ? const Color(0xFFBF8E4A)
//                         : const Color(0xFFD4A574),
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 Text(
//                   widget.title,
//                   style: TextStyle(
//                     fontFamily: "playfair",
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: _isHovered
//                         ? const Color(0xFF000000)
//                         : const Color(0xFF1A1A1A),
//                     height: 1.3,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 12),
//                 Text(
//                   widget.description,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     color: Color(0xFF6B6B6B),
//                     height: 1.6,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// ------------------------------
// 🖥️ Modern Desktop Layout with Glassmorphism & 3D Effects
// ------------------------------
class ModernDesktopLayout extends StatelessWidget {
  final List<Map<String, dynamic>> steps;
  const ModernDesktopLayout({Key? key, required this.steps}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
      decoration: BoxDecoration(
          // gradient: LinearGradient(
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          //   colors: [
          //     const Color(0xFFFFFBF5),
          //     const Color(0xFFFFF8F0),
          //     const Color(0xFFFFFBF5),
          //   ],
          // ),
          ),
      child: Stack(
        children: [
          // Animated Gradient Line
          Positioned(
            top: 80,
            left: 60,
            right: 60,
            child: _AnimatedProgressLine(stepCount: steps.length),
          ),

          // Step Cards
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 20),
          //   child: Row(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: List.generate(steps.length, (index) {
          //       final step = steps[index];
          //       return Expanded(
          //         child: Padding(
          //           padding: EdgeInsets.only(
          //             left: index == 0 ? 0 : 8,
          //             right: index == steps.length - 1 ? 0 : 8,
          //           ),
          //           child: _ModernStepCard(
          //             number: index + 1,
          //             icon: step['icon'],
          //             title: step['title'],
          //             description: step['description'],
          //             delay: Duration(milliseconds: index * 100),
          //           ),
          //         ),
          //       );
          //     }),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                // 🔹 First Row (4 cards)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(4, (index) {
                    final step = steps[index];
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: index == 0 ? 0 : 8,
                          right: index == 3 ? 0 : 8,
                        ),
                        child: _ModernStepCard(
                          number: index + 1,
                          icon: step['icon'],
                          title: step['title'],
                          description: step['description'],
                          delay: Duration(milliseconds: index * 100),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 60),

                // 🔹 Second Row (remaining 3 cards)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(3, (index) {
                    final step = steps[index + 4];
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: index == 0 ? 0 : 8,
                          right: index == 2 ? 0 : 8,
                        ),
                        child: _ModernStepCard(
                          number: index + 5,
                          icon: step['icon'],
                          title: step['title'],
                          description: step['description'],
                          delay: Duration(milliseconds: (index + 4) * 100),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------
// 🌊 Animated Progress Line
// ------------------------------
class _AnimatedProgressLine extends StatefulWidget {
  final int stepCount;
  const _AnimatedProgressLine({required this.stepCount});

  @override
  State<_AnimatedProgressLine> createState() => _AnimatedProgressLineState();
}

class _AnimatedProgressLineState extends State<_AnimatedProgressLine>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Stack(
          children: [
            // Background Line
            Container(
              height: 3,
              decoration: BoxDecoration(
                color: const Color(0xFFD4A574).withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            // Animated Progress Line
            FractionallySizedBox(
              widthFactor: _animation.value,
              child: Container(
                height: 3,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFBF8E4A),
                      Color(0xFFD4A574),
                      Color(0xFFE8C89F),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFD4A574).withOpacity(0.5),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ------------------------------
// 💎 Modern Step Card with Glassmorphism
// ------------------------------
class _ModernStepCard extends StatefulWidget {
  final int number;
  final IconData icon;
  final String title;
  final String description;
  final Duration delay;

  const _ModernStepCard({
    required this.number,
    required this.icon,
    required this.title,
    required this.description,
    required this.delay,
  });

  @override
  State<_ModernStepCard> createState() => _ModernStepCardState();
}

class _ModernStepCardState extends State<_ModernStepCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOut),
    );

    // Entrance animation
    Future.delayed(widget.delay, () {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _scaleController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _scaleController.reverse();
      },
      cursor: SystemMouseCursors.click,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Floating Number Badge with Pulse Effect
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 600 + (widget.number * 100)),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Glow Effect
                      if (_isHovered)
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                const Color(0xFFD4A574).withOpacity(0.4),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      // Number Circle
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: _isHovered
                                ? [
                                    const Color(0xFFBF8E4A),
                                    const Color(0xFFD4A574),
                                  ]
                                : [
                                    const Color(0xFFD4A574),
                                    const Color(0xFFE8C89F),
                                  ],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFD4A574)
                                  .withOpacity(_isHovered ? 0.6 : 0.3),
                              blurRadius: _isHovered ? 20 : 12,
                              offset: Offset(0, _isHovered ? 6 : 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            '${widget.number}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 30),

            // Glassmorphism Card
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              constraints: const BoxConstraints(
                minHeight: 320,
              ),
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: _isHovered
                      ? [
                          Colors.white,
                          const Color(0xFFFFFBF5),
                        ]
                      : [
                          Colors.white.withOpacity(0.9),
                          Colors.white.withOpacity(0.8),
                        ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: _isHovered
                      ? const Color(0xFFD4A574).withOpacity(0.3)
                      : const Color(0xFFD4A574).withOpacity(0.15),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFD4A574)
                        .withOpacity(_isHovered ? 0.15 : 0.08),
                    blurRadius: _isHovered ? 30 : 20,
                    offset: Offset(0, _isHovered ? 12 : 8),
                    spreadRadius: _isHovered ? 2 : 0,
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.8),
                    blurRadius: 10,
                    offset: const Offset(-5, -5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon Container with Gradient
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: _isHovered ? 80 : 72,
                    height: _isHovered ? 80 : 72,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: _isHovered
                            ? [
                                const Color(0xFFFFEFD5),
                                const Color(0xFFFFE5C0),
                              ]
                            : [
                                const Color(0xFFFFF8F0),
                                const Color(0xFFFFF4E8),
                              ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFD4A574)
                              .withOpacity(_isHovered ? 0.25 : 0.1),
                          blurRadius: _isHovered ? 15 : 10,
                          offset: Offset(0, _isHovered ? 5 : 3),
                        ),
                      ],
                    ),
                    child: Icon(
                      widget.icon,
                      size: _isHovered ? 38 : 34,
                      color: _isHovered
                          ? const Color(0xFFBF8E4A)
                          : const Color(0xFFD4A574),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title with Gradient Text Effect
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: _isHovered
                          ? [
                              const Color(0xFF000000),
                              const Color(0xFF1A1A1A),
                            ]
                          : [
                              const Color(0xFF1A1A1A),
                              const Color(0xFF4A4A4A),
                            ],
                    ).createShader(bounds),
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        fontFamily: "playfair",
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.3,
                        letterSpacing: -0.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Description
                  Text(
                    widget.description,
                    style: TextStyle(
                      fontSize: 13,
                      color: _isHovered
                          ? const Color(0xFF5A5A5A)
                          : const Color(0xFF6B6B6B),
                      height: 1.7,
                      letterSpacing: 0.2,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  // Decorative Bottom Accent
                  if (_isHovered) ...[
                    const SizedBox(height: 16),
                    Container(
                      width: 40,
                      height: 3,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFBF8E4A),
                            Color(0xFFD4A574),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------
// 🧩 Step Card Widget (Mobile + Tablet)
// ------------------------------
class StepCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final String stepNumber;
  final bool showNumberOnRight;

  const StepCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
    required this.stepNumber,
    this.showNumberOnRight = false,
  }) : super(key: key);

  @override
  State<StepCard> createState() => _StepCardState();
}

class _StepCardState extends State<StepCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(0, _isHovered ? -4 : 0, 0),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isHovered ? 0.08 : 0.04),
                blurRadius: _isHovered ? 24 : 20,
                offset: Offset(0, _isHovered ? 8 : 4),
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: _isHovered
                          ? const Color(0xFFFFEFD5)
                          : const Color(0xFFFFF8E8),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      widget.icon,
                      size: 26,
                      color: _isHovered
                          ? const Color(0xFFBF8E4A)
                          : const Color(0xFFD4A574),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontFamily: "playfair",
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _isHovered
                          ? const Color(0xFF000000)
                          : const Color(0xFF1A1A1A),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF5A7070),
                      height: 1.6,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
              Positioned(
                top: -16,
                right: -16,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: _isHovered
                        ? const Color(0xFFBF8E4A)
                        : const Color(0xFFD4A574),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.black.withOpacity(_isHovered ? 0.15 : 0.1),
                        blurRadius: _isHovered ? 12 : 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      widget.stepNumber,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
