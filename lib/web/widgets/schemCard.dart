import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meralda_gold_user/web/schemeDiologs/aspireDialog.dart';
import 'package:meralda_gold_user/web/webRegistration.dart';
import 'package:meralda_gold_user/web/widgets/aboutScheme.dart';

import '../../common/colo_extension.dart';
import '../schemeDiologs/WishlistInfoDialog.dart';

class RightSideImgSchemeCard extends StatefulWidget {
  RightSideImgSchemeCard({super.key, required this.userName});
  String userName;
  var user;
  @override
  State<RightSideImgSchemeCard> createState() => _RightSideImgSchemeCardState();
}

class _RightSideImgSchemeCardState extends State<RightSideImgSchemeCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return

        // MouseRegion(
        //   onEnter: (_) => setState(() => _hovering = true),
        //   onExit: (_) => setState(() => _hovering = false),
        //   child: AnimatedContainer(
        //     duration: const Duration(milliseconds: 300),
        //     curve: Curves.easeInOut,
        //     transform: Matrix4.identity()
        //       ..scale(_hovering ? 1.05 : 1.0), // zoom card
        //     child: Card(
        //       elevation: _hovering ? 12 : 4, // lift effect
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(12),
        //       ),
        //       child: Container(
        //           padding: const EdgeInsets.all(16),
        //           // height: 400,
        //           child: GestureDetector(
        //               onTap: () {
        //                 showWishlistInfoDialog(
        //                     context, widget.userName, widget.user);
        //               },
        //               child: Image(
        //                   image: AssetImage(
        //                       "assets/schemeImg/1800-x-600-px-Wishlist (2).png")))),
        //     ),
        //   ),
        // );

        Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Static image
          Image.asset(
            "assets/schemeImg/1800-x-600-px-Wishlist (2).png",
            fit: BoxFit.cover,
            // height: 220,
          ),

          // Animated button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: _AnimatedSeeDetailsButton(
                onTap: () {
                  showWishlistInfoDialog(context, widget.userName, widget.user);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LeftSideImgSchemeCard extends StatefulWidget {
  LeftSideImgSchemeCard(
      {super.key, required this.username, required this.user});
  String username;
  var user;
  @override
  State<LeftSideImgSchemeCard> createState() => _LeftSideImgSchemeCardState();
}

class _LeftSideImgSchemeCardState extends State<LeftSideImgSchemeCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return
        // MouseRegion(
        //   onEnter: (_) => setState(() => _hovering = true),
        //   onExit: (_) => setState(() => _hovering = false),
        //   child: AnimatedContainer(
        //     duration: const Duration(milliseconds: 300),
        //     curve: Curves.easeInOut,
        //     transform: Matrix4.identity()
        //       ..scale(_hovering ? 1.05 : 1.0), // zoom card
        //     child: Card(
        //       elevation: _hovering ? 12 : 4, // lift effect
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(12),
        //       ),
        //       child: Container(
        //         padding: const EdgeInsets.all(16),
        //         // height: 400,
        //         child: GestureDetector(
        //             onTap: () {
        //               showAspireInfoDialog(context, widget.username, widget.user);
        //               // showDialog(
        //               //   context: context,
        //               //   barrierDismissible: false,
        //               //   builder: (context) => UserRegistrationDialog(
        //               //     type: "add",
        //               //   ),
        //               // );
        //             },
        //             child: Image(
        //                 image: AssetImage(
        //                     "assets/schemeImg/1800-x-600-px-Aspire.png"))),
        //       ),
        //     ),
        //   ),
        // );
        Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Static image
          Image.asset(
            "assets/schemeImg/1800-x-600-px-Aspire.png",
            fit: BoxFit.cover,
            // height: 220,
          ),

          // Animated button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: _AnimatedSeeDetailsButton(
                onTap: () {
                  showAspireInfoDialog(context, widget.username, widget.user);
                },
              ),
            ),
          ),
        ],
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

class _AnimatedSeeDetailsButton extends StatefulWidget {
  final VoidCallback onTap;

  const _AnimatedSeeDetailsButton({required this.onTap});

  @override
  State<_AnimatedSeeDetailsButton> createState() =>
      _AnimatedSeeDetailsButtonState();
}

class _AnimatedSeeDetailsButtonState extends State<_AnimatedSeeDetailsButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedScale(
          scale: _hovering ? 1.08 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  TColo.primaryColor1,
                  TColo.primaryColor1.withOpacity(0.8)
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: TColo.primaryColor1.withOpacity(0.4),
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                // onTap: () {
                onTap: widget.onTap,
                // },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.rocket_launch, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'See Details',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )

          // ElevatedButton(
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor: Colors.amber.shade600,
          //     foregroundColor: Colors.black,
          //     padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(10),
          //     ),
          //     elevation: _hovering ? 10 : 4,
          //   ),
          //   onPressed: widget.onTap,
          //   child: const Text(
          //     "See Details",
          //     style: TextStyle(
          //       fontSize: 16,
          //       fontWeight: FontWeight.w600,
          //     ),
          //   ),
          // ),
          ),
    );
  }
}
