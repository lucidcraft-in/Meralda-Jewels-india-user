import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meralda_gold_user/providers/collectionProvider.dart';
import 'package:meralda_gold_user/screens/homeNavigation.dart';
import 'package:meralda_gold_user/web/webHome.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'providers/account_provider.dart';
import 'providers/banner.dart';
import 'providers/branchProvider.dart';
import 'providers/category.dart';
import 'providers/goldrate.dart';
import 'providers/payment.dart';
import 'providers/paymentBill.dart';
import 'providers/paymentConfi.dart';
import 'providers/phonePe_payment.dart';
import 'providers/product.dart';
import 'providers/staff.dart';
import 'providers/transaction.dart';
import 'providers/user.dart';
import 'screens/newHomeScreen.dart';
import 'web/webPayScreen.dart';

class GoldJewelryApp extends StatefulWidget {
  @override
  State<GoldJewelryApp> createState() => _GoldJewelryAppState();
}

class _GoldJewelryAppState extends State<GoldJewelryApp> {
  Future<Map<String, dynamic>?> loadUserLocally() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.containsKey("user")) {
      final userData = pref.getString("user");
      if (userData != null) {
        return json.decode(userData);
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => User()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ChangeNotifierProvider(create: (_) => Goldrate()),
        ChangeNotifierProvider(create: (_) => Product()),
        ChangeNotifierProvider(create: (_) => Payment()),
        ChangeNotifierProvider(create: (_) => Staff()),
        ChangeNotifierProvider(create: (_) => BannerProvider()),
        ChangeNotifierProvider(create: (_) => phonePe_Payment()),
        ChangeNotifierProvider(create: (_) => PaymentBillProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => PaymentDetails()),
        ChangeNotifierProvider(create: (_) => BranchProvider()),
        ChangeNotifierProvider(create: (_) => AccountProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Meralda Jewels',
        theme: ThemeData(
          primaryColor: Color(0xFF003a34),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
            elevation: 0,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Color(0xFFb58763)),
          ),
          textTheme: GoogleFonts.poppinsTextTheme(),
          colorScheme: ColorScheme.light(
            primary: Color(0xFFb58763),
            secondary: Color(0xFF81C784),
          ),
        ),
        home: FutureBuilder<Map<String, dynamic>?>(
          future: loadUserLocally(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final user = snapshot.data;

            if (kIsWeb) {
              if (user != null) {
                // If user exists → go to PayAmount
                return WebPayAmountScreen(
                  user: user,
                  userid: user["id"],
                  custName: user["name"],
                );
              } else {
                // If no user → go to Home
                return WebHomeScreen();
              }
            } else {
              return HomeNavigation();
            }
          },
        ),
      ),
    );
  }
}
