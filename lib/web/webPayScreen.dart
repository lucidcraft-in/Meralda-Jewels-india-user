import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:meralda_gold_user/model/customerModel.dart';
import 'package:meralda_gold_user/web/helperWidget.dart/rightProfile.dart';
import 'package:meralda_gold_user/web/newHomeScreen/newwebhome.dart';
import 'package:meralda_gold_user/web/webHome.dart';
import 'package:meralda_gold_user/web/webProfile.dart';
import 'package:meralda_gold_user/web/widgets/noSchemeWidget.dart';
import 'package:provider/provider.dart';
import 'package:meralda_gold_user/common/colo_extension.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/account_provider.dart';
import '../providers/collectionProvider.dart';
import '../providers/transaction.dart';
import '../providers/user.dart';
import 'helperWidget.dart/leftProfile.dart';
import 'webTransaction.dart';

class WebPayAmountScreen extends StatefulWidget {
  final String? userid;
  final Map? user;
  final String? custName;

  const WebPayAmountScreen({
    Key? key,
    this.userid,
    this.user,
    this.custName,
  }) : super(key: key);

  @override
  _WebPayAmountScreenState createState() => _WebPayAmountScreenState();
}

class _WebPayAmountScreenState extends State<WebPayAmountScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  DateTime now = DateTime.now();
  bool _isLoading = false;
  String selectedValue = 'Gold';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Controllers
  TextEditingController taxCntrl = TextEditingController();
  TextEditingController amcCntrl = TextEditingController();
  TextEditingController amountCntrl = TextEditingController();
  TextEditingController grampPerdayController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    getUserAccount();

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  bool isTransaFirst = false;
  // TransactionProvider? db;
  // User? dbUser;
  // List transactions = [];
  // double cashBalance = 0;
  // double gramBalance = 0;
  // getTransaction() {
  //   db = TransactionProvider();
  //   dbUser = User();
  //   db!.initiliase();
  //   print(widget.user!['id']);
  //   db!.read(widget.user!['id']).then((value) {
  //     if (value!.isEmpty) {
  //       setState(() {
  //         isTransaFirst = false;
  //       });
  //     } else {
  //       setState(() {
  //         cashBalance = value![1];
  //         gramBalance = value![2];
  //         isTransaFirst = true;
  //       });
  //     }
  //   });
  // }

  List<SchemeUserModel> userAccount = [];
  getUserAccount() async {
    Future.microtask(() {
      if (widget.user?["phoneNo"] != null) {
        context.read<AccountProvider>().loadAccounts(widget.user!["phoneNo"]);
      }
    });
  }

  Widget _buildAppBar(String type, String name, id, var user) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * .15,
      decoration: BoxDecoration(color: TColo.primaryColor1),
      child: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Image(
                image: AssetImage("assets/images/logo_bg_white.png"),
                width: 200,
              ),
            ),
            // if (type != "load")
            Positioned(
              top: 10,
              right: 50,
              child: Container(
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (user != null) SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        if (user != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Newwebhome(),
                            ),
                          );
                        } else {
                          // _showLoginDialog(context);
                        }
                      },
                      child: Icon(
                        FontAwesomeIcons.home,
                        color: TColo.primaryColor2,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }

  @override
  Widget build(BuildContext context) {
    final accountProvider = context.watch<AccountProvider>();
    final accounts = accountProvider.accounts;

    // Show loading state first
    if (accountProvider.isLoading) {
      return buildLoadingState();
    }

    final activeAccount = accounts.isNotEmpty
        ? accounts[accountProvider.selectedAccountIndex]
        : null;

    // Show "No data found" when activeAccount is null
    if (widget.user == null) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        body: Column(
          children: [
            _buildAppBar("load", widget.custName!, widget.userid, widget.user),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // No data icon
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(60),
                        border: Border.all(
                          color: Colors.grey[300]!,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.folder_open_outlined,
                        size: 60,
                        color: Colors.grey[400],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // No data found text
                    Text(
                      "No Data Found",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Description text
                    Text(
                      "No account information available",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[500],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Optional refresh button
                        ElevatedButton.icon(
                          onPressed: () {
                            // Add refresh functionality here
                            accountProvider.loadAccounts(activeAccount!
                                .phoneNo); // Assuming you have a method to reload data
                          },
                          icon: Icon(
                            Icons.refresh,
                            color: Colors.white,
                          ),
                          label: Text(
                            "Refresh",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TColo.primaryColor1,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton.icon(
                          onPressed: () async {
                            SharedPreferences preferences =
                                await SharedPreferences.getInstance();
                            await preferences.clear();

                            // Close loading dialog
                            Navigator.of(context).pop();

                            // Navigator.pushAndRemoveUntil(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => WebHomeScreen()),
                            //   (route) => false,
                            // );

                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Newwebhome()),
                              (route) => false,
                            );

                            // Show success message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Logged out successfully'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                          icon: Icon(FontAwesomeIcons.signOut,
                              color: const Color.fromARGB(255, 151, 45, 37)),
                          label: Text(
                            "Logout",
                            style: TextStyle(
                              color: const Color.fromARGB(255, 151, 45, 37),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 800) {
              // Mobile Layout - Stack panels vertically
              return Column(
                children: [
                  _buildAppBar("load", "", widget.user!["id"], widget.user),
                  Expanded(
                    child: ListView(
                      children: [
                        if (widget.user!.isNotEmpty)
                          Container(
                            child: LeftPanel(
                              user: widget.user,
                            ),
                          ),
                        // Remove Expanded and use Container with height
                        Container(
                          height: MediaQuery.of(context).size.height *
                              0.6, // Adjust as needed
                          child: activeAccount != null
                              ? RightPanalProfile(user: activeAccount!)
                              : noSchemeSec(widget.user!),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              // Desktop Layout - Side by side panels
              return Column(
                children: [
                  _buildAppBar("load", "", widget.user!["id"], widget.user),
                  Expanded(
                    child: Row(
                      children: [
                        if (widget.user!.isNotEmpty)
                          Expanded(
                            flex: 2,
                            child: LeftPanel(
                              user: widget.user,
                            ),
                          ),
                        Expanded(
                          flex: 3,
                          child: activeAccount != null
                              ? RightPanalProfile(user: activeAccount!)
                              : noSchemeSec(widget.user!),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

// Add this method to show loading state
  Widget buildLoadingState() {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(TColo.primaryColor1),
              strokeWidth: 4,
            ),
            const SizedBox(height: 20),
            Text(
              "Loading account information...",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

bool isAmountInitialized = false;
