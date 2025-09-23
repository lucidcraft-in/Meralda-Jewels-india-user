import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meralda_gold_user/web/schemeDiologs/aspireDialog.dart';
import 'package:meralda_gold_user/web/webRegistration.dart';
import 'package:meralda_gold_user/web/widgets/aboutScheme.dart';

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
                    showWishlistInfoDialog(
                        context, widget.userName, widget.user);
                  },
                  child: Image(
                      image: AssetImage(
                          "assets/schemeImg/1800-x-600-px-Wishlist (2).png")))),
        ),
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
                  showAspireInfoDialog(context, widget.username, widget.user);
                  // showDialog(
                  //   context: context,
                  //   barrierDismissible: false,
                  //   builder: (context) => UserRegistrationDialog(
                  //     type: "add",
                  //   ),
                  // );
                },
                child: Image(
                    image: AssetImage(
                        "assets/schemeImg/1800-x-600-px-Aspire.png"))),
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
