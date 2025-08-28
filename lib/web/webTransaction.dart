import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/colo_extension.dart';
import '../providers/transaction.dart';
import '../providers/user.dart';

class CustomerInvestmentWebScreen extends StatefulWidget {
  @override
  State<CustomerInvestmentWebScreen> createState() =>
      _CustomerInvestmentWebScreenState();
}

class _CustomerInvestmentWebScreenState
    extends State<CustomerInvestmentWebScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  double balanceInGrams = 0.00;
  double investedAmount = 0.00;

  List transactions = [];

  @override
  void initState() {
    super.initState();
    loadUserLocally();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  var user;
  Future loadUserLocally() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    print("=====");
    print(pref.containsKey("user"));
    if (pref.containsKey("user")) {
      var userData = pref.getString("user");

      if (userData != null) {
        user = json.decode(userData);

        getTransaction();
      }
    } else {}
  }

  bool isLoading = true;
  TransactionProvider? db;
  User? dbUser;
  List alllist = [];
  List transactionList = [];
  double customerBalance = 0;
  double totalGram = 0;
  getTransaction() {
    db = TransactionProvider();
    dbUser = User();
    db!.initiliase();

    db!.read(user['id']).then((value) {
      setState(() {
        alllist = value!;
        transactions = alllist[0];
        investedAmount = alllist[1];
        balanceInGrams = alllist[2];
      });
      print(transactions);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            return SingleChildScrollView(
              child: Container(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Column(
                  children: [
                    buildAppBar(context),
                    Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 1000),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth < 600 ? 16 : 24,
                            vertical: 24,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildBalanceSummary(screenWidth),
                              const SizedBox(height: 32),
                              Text(
                                "Transaction History",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildTransactionTable(screenWidth),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildAppBar(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final logoSize = screenWidth < 600 ? 220.0 : 350.0;

    return Container(
      width: screenWidth,
      height: MediaQuery.of(context).size.height * 0.2,
      decoration: BoxDecoration(color: TColo.primaryColor1),
      child: SafeArea(
        child: Center(
          child: RotatedBox(
            quarterTurns: 1,
            child: Image.asset(
              "assets/images/logo_bg_white.png",
              width: logoSize,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceSummary(double screenWidth) {
    final isSmallScreen = screenWidth < 600;

    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: isSmallScreen
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildInfoTile(
                      "Gold Balance", "${balanceInGrams.toStringAsFixed(2)} g"),
                  const SizedBox(height: 16),
                  Divider(color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  _buildInfoTile("Invested Amount",
                      "₹ ${investedAmount.toStringAsFixed(2)}"),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildInfoTile(
                      "Gold Balance", "${balanceInGrams.toStringAsFixed(2)} g"),
                  _buildDivider(),
                  _buildInfoTile("Invested Amount",
                      "₹ ${investedAmount.toStringAsFixed(2)}"),
                ],
              ),
      ),
    );
  }

  Widget _buildInfoTile(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
        const SizedBox(height: 6),
        Text(value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            )),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 50,
      color: Colors.grey[300],
    );
  }

  Widget _buildTransactionTable(double screenWidth) {
    final isSmallScreen = screenWidth < 600;

    return Container(
      width: double.infinity,
      child: Card(
        elevation: 3,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: transactions.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      "No data found",
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
              : DataTable(
                  columnSpacing: isSmallScreen ? 16 : 24,
                  headingRowColor:
                      MaterialStateProperty.all(const Color(0xFFF1F3F4)),
                  columns: const [
                    DataColumn(label: Text("Date")),
                    DataColumn(label: Text("Gold Weight (g)")),
                    DataColumn(label: Text("Amount (₹)")),
                    DataColumn(label: Text("Note")),
                  ],
                  rows: transactions.map((tx) {
                    final timestamp = tx['date'] as Timestamp?;
                    final weight = tx['gramWeight'] ?? 0.0;
                    final amount = tx['amount'] ?? 0.0;
                    final note = tx['note'] ?? '';
                    return DataRow(
                      color: MaterialStateProperty.all(
                          tx["transactionType"] == 0
                              ? Color.fromARGB(255, 215, 230, 216)
                              : Color.fromARGB(255, 228, 215, 215)),
                      cells: [
                        DataCell(Text(
                          timestamp != null
                              ? timestamp.toDate().toString().split(' ')[0]
                              : 'N/A',
                          style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                        )),
                        DataCell(Text(
                          weight.toStringAsFixed(2),
                          style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                        )),
                        DataCell(Text(
                          "₹ ${amount.toStringAsFixed(2)}",
                          style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                        )),
                        DataCell(Text(
                          note,
                          style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                        )),
                      ],
                    );
                  }).toList(),
                ),
        ),
      ),
    );
  }
}

class Transaction {
  final String date;
  final double grams;
  final double amount;
  final String note;

  Transaction({
    required this.date,
    required this.grams,
    required this.amount,
    required this.note,
  });
}
