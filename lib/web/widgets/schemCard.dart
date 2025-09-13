import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meralda_gold_user/web/webRegistration.dart';
import 'package:meralda_gold_user/web/widgets/aboutScheme.dart';

class RightSideImgSchemeCard extends StatefulWidget {
  const RightSideImgSchemeCard({super.key});

  @override
  State<RightSideImgSchemeCard> createState() => _RightSideImgSchemeCardState();
}

class _RightSideImgSchemeCardState extends State<RightSideImgSchemeCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()
          ..scale(_hovering ? 1.05 : 1.0), // zoom card
        child: Card(
          elevation: _hovering ? 12 : 4, // lift effect
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
              padding: const EdgeInsets.all(16),
              // height: 400,
              child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => UserRegistrationDialog(type: "add"),
                    );
                  },
                  child: Image(
                      image: AssetImage("assets/schemeImg/Wishlist_doc.png")))
              //  Row(
              //   children: [
              // Left Section
              // Expanded(
              //   flex: 2,
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       // const Text(
              //       //   "SHOP",
              //       //   style: TextStyle(
              //       //     color: Colors.brown,
              //       //     fontSize: 18,
              //       //     fontWeight: FontWeight.bold,
              //       //   ),
              //       // ),
              //       // const SizedBox(height: 4),
              //       Image(
              //         image: AssetImage("assets/photos/wishlist.png"),
              //         width: 200,
              //       ),
              //       // const Text(
              //       //   "SCHEME",
              //       //   style: TextStyle(
              //       //     fontSize: 32,
              //       //     fontWeight: FontWeight.bold,
              //       //     color: Colors.black87,
              //       //   ),
              //       // ),
              //       const SizedBox(height: 8),
              //       const Text(
              //         "With the WishList Jewellery Buying Plan, we love to turn your desires into reality. \n"
              //         "Now, you can open an account with a minimum amount of 2000.\nYou will be qualified for a bonus of up to 100% of your initial instalment,\nif you make fixed monthly payments for 11 months continuously.",
              //         style: TextStyle(
              //           color: Colors.black54,
              //           fontSize: 14,
              //           height: 1.4,
              //         ),
              //       ),
              //       const SizedBox(height: 16),
              //       ElevatedButton(
              //         style: ElevatedButton.styleFrom(
              //           backgroundColor: Colors.brown,
              //           shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(20),
              //           ),
              //           padding: const EdgeInsets.symmetric(
              //               horizontal: 20, vertical: 12),
              //         ),
              //         onPressed: () {
              //           showDialog(
              //             context: context,
              //             barrierDismissible: false,
              //             builder: (context) =>
              //                 UserRegistrationDialog(type: "add"),
              //           );
              //         },
              //         child: const Text(
              //           "Registration",
              //           style: TextStyle(color: Colors.white),
              //         ),
              //       ),
              //       SizedBox(height: 20),
              //       GestureDetector(
              //         onTap: () {
              //           _showLoginDialog(context, "wish");
              //         },
              //         child: const Text(
              //           "Learn more",
              //           style: TextStyle(
              //             color: Color.fromARGB(123, 121, 85, 72),
              //             fontSize: 12,
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

              // const SizedBox(width: 12),

              // // Right Section (Image)
              // Expanded(
              //   flex: 1,
              //   child: Image.asset(
              //     "assets/photos/imag1.png", // replace with your asset
              //     fit: BoxFit.contain,
              //   ),
              // ),

              //   ],
              // ),
              ),
        ),
      ),
    );
  }
}

class LeftSideImgSchemeCard extends StatefulWidget {
  const LeftSideImgSchemeCard({super.key});

  @override
  State<LeftSideImgSchemeCard> createState() => _LeftSideImgSchemeCardState();
}

class _LeftSideImgSchemeCardState extends State<LeftSideImgSchemeCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()
          ..scale(_hovering ? 1.05 : 1.0), // zoom card
        child: Card(
          elevation: _hovering ? 12 : 4, // lift effect
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            // height: 400,
            child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => UserRegistrationDialog(type: "add"),
                  );
                },
                child: Image(
                    image: AssetImage("assets/schemeImg/aspire_img.jpeg"))),
            // child: Row(
            //   children: [
            //     Expanded(
            //       flex: 1,
            //       child: Image.asset(
            //         "assets/photos/imag2.png", // <-- replace with your image asset
            //         fit: BoxFit.contain,
            //       ),
            //     ),
            //     const SizedBox(width: 12),
            //     // Left Section
            //     Expanded(
            //       flex: 2,
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           // const Text(
            //           //   "SHOP",
            //           //   style: TextStyle(
            //           //     color: Colors.brown,
            //           //     fontSize: 18,
            //           //     fontWeight: FontWeight.bold,
            //           //   ),
            //           // ),
            //           // const SizedBox(height: 4),
            //           // const Text(
            //           //   "SCHEME",
            //           //   style: TextStyle(
            //           //     fontSize: 32,
            //           //     fontWeight: FontWeight.bold,
            //           //     color: Colors.black87,
            //           //   ),
            //           // ),
            //           Image(
            //             image: AssetImage("assets/photos/aspire.png"),
            //             width: 200,
            //           ),
            //           const SizedBox(height: 8),
            //           const Text(
            //             "Meralda Aspire Jewellery Buying Plan is a gateway to own coveted pieces by paying fixed instalment,\nstarting from only ₹2000 for 11 months. Each payment reserves a portion of gold weight equivalent to the amount paid and, at the time of redemption.\nyou can get your jewellery equivalent to the accumulated weight without paying any making charges up to 16%.",
            //             style: TextStyle(
            //               color: Colors.black54,
            //               fontSize: 14,
            //               height: 1.4,
            //             ),
            //           ),
            //           const SizedBox(height: 16),
            //           ElevatedButton(
            //             style: ElevatedButton.styleFrom(
            //               backgroundColor: Colors.brown,
            //               shape: RoundedRectangleBorder(
            //                 borderRadius: BorderRadius.circular(20),
            //               ),
            //               padding: const EdgeInsets.symmetric(
            //                   horizontal: 20, vertical: 12),
            //             ),
            //             onPressed: () {
            //               showDialog(
            //                 context: context,
            //                 barrierDismissible: false,
            //                 builder: (context) =>
            //                     UserRegistrationDialog(type: "add"),
            //               );
            //             },
            //             child: const Text(
            //               "Registration",
            //               style: TextStyle(color: Colors.white),
            //             ),
            //           ),
            //           SizedBox(height: 20),
            //           GestureDetector(
            //             onTap: () {
            //               _showLoginDialog(context, "asp");
            //             },
            //             child: const Text(
            //               "Learn more",
            //               style: TextStyle(
            //                 color: Color.fromARGB(123, 121, 85, 72),
            //                 fontSize: 12,
            //               ),
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
          ),
        ),
      ),
    );
  }
}

void _showLoginDialog(BuildContext context, String schem) {
  showGeneralDialog(
    context: context,
    transitionDuration: Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) {
      return Stack(
        children: [
          // Blurred background
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          Center(
            child: Material(
              color: Colors.transparent,
              child: schem == "wish"
                  ? buildWishListCard(context)
                  : buildAspireCard(context),
            ),
          ),
        ],
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}
