import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:meralda_gold_user/model/customerModel.dart';
import 'package:meralda_gold_user/web/helperWidget.dart/rightProfile.dart';
import 'package:meralda_gold_user/web/webHome.dart';
import 'package:meralda_gold_user/web/webProfile.dart';
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

  // Transaction model
  var _transaction = TransactionModel(
    id: '',
    customerName: '',
    customerId: '',
    date: DateTime.now(),
    amount: 0,
    transactionType: 0,
    note: '',
    invoiceNo: '',
    category: '',
    discount: 0,
    staffId: '',
    gramPriceInvestDay: 0,
    gramWeight: 0,
    branch: 0,
    merchentTransactionId: "",
    transactionMode: 'Direct',
  );

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
  TransactionProvider? db;
  User? dbUser;
  List transactions = [];
  double cashBalance = 0;
  double gramBalance = 0;
  getTransaction() {
    db = TransactionProvider();
    dbUser = User();
    db!.initiliase();
    print(widget.user!['id']);
    db!.read(widget.user!['id']).then((value) {
      if (value!.isEmpty) {
        setState(() {
          isTransaFirst = false;
        });
      } else {
        setState(() {
          cashBalance = value![1];
          gramBalance = value![2];
          isTransaFirst = true;
        });
      }
    });
  }

  List<UserModel> userAccount = [];
  getUserAccount() async {
    Future.microtask(() {
      if (widget.user?["phone_no"] != null) {
        context.read<AccountProvider>().loadAccounts(widget.user!["phone_no"]);
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
              child: RotatedBox(
                quarterTurns: 1, // 1 = 90° clockwise, 2 = 180°, 3 = 270°
                child: Image(
                  image: AssetImage("assets/images/logo_bg_white.png"),
                  width: 400,
                ),
              ),
            ),
            if (type != "load")
              Positioned(
                top: 10,
                right: 50,
                child: Container(
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (name != "") SizedBox(width: 20),
                      GestureDetector(
                        onTap: () {
                          if (name != "") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WebHomeScreen(),
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

    final activeAccount = accounts.isNotEmpty
        ? accounts[accountProvider.selectedAccountIndex]
        : null;

    // Show "No data found" when activeAccount is null
    if (activeAccount == null) {
      //  logout();
      return Scaffold(
        backgroundColor: Colors.grey[50],
        body: Column(
          children: [
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

                    // Optional refresh button
                    ElevatedButton.icon(
                      onPressed: () {
                        // Add refresh functionality here
                        // You can call your data loading method
                        setState(() {
                          // Trigger a rebuild or reload data
                        });
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
                  _buildAppBar("load", activeAccount!.name, activeAccount.id,
                      activeAccount),
                  if (widget.user!.isNotEmpty)
                    Container(
                      height: 300,
                      child: buildLeftPanel(context),
                    ),
                  Expanded(
                    child: rightPanalProfile(user: activeAccount!),
                  ),
                ],
              );
            } else {
              // Desktop Layout - Side by side panels
              return Column(
                children: [
                  _buildAppBar("locad", activeAccount.name, activeAccount.id,
                      activeAccount),
                  Expanded(
                    child: Row(
                      children: [
                        if (widget.user!.isNotEmpty)
                          Expanded(
                            flex: 2,
                            child: buildLeftPanel(context),
                          ),
                        Expanded(
                          flex: 3,
                          child: rightPanalProfile(user: activeAccount!),
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
}
