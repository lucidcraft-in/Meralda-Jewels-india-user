import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:meralda_gold_user/common/colo_extension.dart';
import 'package:meralda_gold_user/web/webHome.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/customerModel.dart';
import '../providers/account_provider.dart';
import '../providers/transaction.dart';
import '../providers/user.dart';
import '../screens/login_screen.dart';
import 'helperWidget.dart/loader.dart';
import 'widgets/webLogout.dart';

class Webprofile extends StatefulWidget {
  const Webprofile({Key? key}) : super(key: key);

  @override
  State<Webprofile> createState() => _WebprofileState();
}

class _WebprofileState extends State<Webprofile> with TickerProviderStateMixin {
  SchemeUserModel? localUserData;
  bool isLoading = true;
  bool isLoadingTransactions = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Transaction related variables
  List transactions = [];
  double investedAmount = 0.00;
  double balanceInGrams = 0.00;
  TransactionProvider? db;
  User? dbUser;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _loadUserLocally();
    _loadUserDataAndTransactions();
  }

  void _initAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadUserLocally() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      isLoading = false;
    });
    _animationController.forward();
  }

  var activeAccount;
  Future<void> _loadUserDataAndTransactions() async {
    final accountProvider = context.read<AccountProvider>();
    final accounts = accountProvider.accounts;
    if (accounts.isNotEmpty) {
      activeAccount = accounts[accountProvider.selectedAccountIndex];

      await _getTransactions(activeAccount);
    }
  }

  Future<void> _getTransactions(SchemeUserModel user) async {
    if (user == null) return;

    db = TransactionProvider();
    dbUser = User();
    db!.initiliase();

    try {
      var result = await db!.read(user.id!);
      if (result != null && mounted) {
        setState(() {
          transactions = result[0] ?? [];
          investedAmount = result[1] ?? 0.0;
          balanceInGrams = result[2] ?? 0.0;
          isLoadingTransactions = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoadingTransactions = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final accountProvider = context.watch<AccountProvider>();
    final accounts = accountProvider.accounts;

    final activeAccount = accounts.isNotEmpty
        ? accounts[accountProvider.selectedAccountIndex]
        : null;
    localUserData = activeAccount;
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 1200;
    final isTablet = size.width > 800 && size.width <= 1200;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: isLoading
          ? buildLoadingState()
          : FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: CustomScrollView(
                  slivers: [
                    _buildSliverAppBar(),
                    SliverPadding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isDesktop ? 40 : 20,
                        vertical: 20,
                      ),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          if (isDesktop)
                            _buildDesktopLayout()
                          else
                            _buildMobileLayout(),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                TColo.primaryColor1,
                TColo.primaryColor1.withOpacity(0.8),
              ],
            ),
          ),
          child: Center(
            child: Text(
              'Profile Dashboard',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column
        Expanded(
          flex: 1,
          child: Column(
            children: [
              _buildProfileCard(),
              const SizedBox(height: 20),
              _buildQuickStatsCard(),
              const SizedBox(height: 20),
              _buildActionButtons(),
            ],
          ),
        ),
        const SizedBox(width: 30),
        // Right Column
        Expanded(
          flex: 2,
          child: Column(
            children: [
              _buildPersonalInfoCard(),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: _buildNomineeCard()),
                  const SizedBox(width: 20),
                  Expanded(child: _buildDocumentCard()),
                ],
              ),
              const SizedBox(height: 20),
              // _buildTransactionHistoryCard(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildProfileCard(),
        const SizedBox(height: 20),
        _buildQuickStatsCard(),
        const SizedBox(height: 20),
        _buildPersonalInfoCard(),
        const SizedBox(height: 20),
        // _buildTransactionHistoryCard(),
        // const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: _buildNomineeCard()),
            const SizedBox(width: 20),
            Expanded(child: _buildDocumentCard()),
          ],
        ),
        const SizedBox(width: 20),
        // _buildBankDetailsCard(),
        // const SizedBox(height: 20),
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildBankDetailsCard() {
    final bank = localUserData!.bankDetails;

    return _buildSectionCard(
      title: 'Bank Details',
      icon: Icons.account_balance,
      children: [
        _buildInfoTile(
          icon: Icons.account_balance,
          label: 'Bank Name',
          value: bank?.bankName ?? 'Not provided',
        ),
        _buildInfoTile(
          icon: Icons.credit_card,
          label: 'Account Number',
          value: bank?.accountNumber ?? 'Not provided',
        ),
        _buildInfoTile(
          icon: Icons.code,
          label: 'IFSC',
          value: bank?.ifsc ?? 'Not provided',
        ),
        _buildInfoTile(
          icon: Icons.location_city,
          label: 'Branch',
          value: bank?.branch ?? 'Not provided',
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {
            // _showBankDetailsDialog(user.id!, bank);
          },
          child: Text(bank == null ? 'Add Bank Details' : 'Edit Bank Details'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueGrey[800],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 30,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      TColo.primaryColor1,
                      TColo.primaryColor1.withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: TColo.primaryColor1.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 0,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: Icon(
                    Icons.verified,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            localUserData?.name ?? 'No Name',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: TColo.primaryColor1.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'ID: ${localUserData?.custId ?? 'N/A'}',
              style: TextStyle(
                color: TColo.primaryColor1,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on, size: 16, color: Colors.grey[500]),
              const SizedBox(width: 4),
              Text(
                localUserData?.branchName ?? 'Unknown Branch',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStatsCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 30,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Account Overview',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 20),
          _buildStatItem(
            icon: FontAwesomeIcons.coins,
            label: 'Balance',
            value: '₹${localUserData?.balance?.toStringAsFixed(2) ?? '0.00'}',
            color: Colors.green,
          ),
          const Divider(height: 24),
          _buildStatItem(
            icon: FontAwesomeIcons.weight,
            label: 'Total Gold',
            value:
                '${balanceInGrams > 0 ? balanceInGrams.toStringAsFixed(2) : (localUserData?.totalGram?.toStringAsFixed(2) ?? '0.00')} g',
            color: Colors.amber[700]!,
          ),
          const Divider(height: 24),
          _buildStatItem(
            icon: FontAwesomeIcons.chartLine,
            label: 'Invested',
            value: '₹${investedAmount.toStringAsFixed(2)}',
            color: Colors.blue,
          ),
          const Divider(height: 24),
          _buildStatItem(
            icon: FontAwesomeIcons.creditCard,
            label: 'Scheme',
            value: localUserData?.schemeType ?? 'N/A',
            color: Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 18,
            color: color,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget _buildTransactionHistoryCard() {
  //   return Container(
  //     padding: const EdgeInsets.all(24),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(24),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.08),
  //           blurRadius: 30,
  //           spreadRadius: 0,
  //           offset: const Offset(0, 8),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           children: [
  //             Container(
  //               width: 40,
  //               height: 40,
  //               decoration: BoxDecoration(
  //                 color: TColo.primaryColor1.withOpacity(0.1),
  //                 borderRadius: BorderRadius.circular(12),
  //               ),
  //               child: Icon(
  //                 FontAwesomeIcons.chartLine,
  //                 size: 20,
  //                 color: TColo.primaryColor1,
  //               ),
  //             ),
  //             const SizedBox(width: 16),
  //             Text(
  //               'Recent Transactions',
  //               style: TextStyle(
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.bold,
  //                 color: Colors.grey[800],
  //               ),
  //             ),
  //             const Spacer(),
  //             if (!isLoadingTransactions && transactions.isNotEmpty)
  //               Container(
  //                 padding:
  //                     const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  //                 decoration: BoxDecoration(
  //                   color: TColo.primaryColor1.withOpacity(0.1),
  //                   borderRadius: BorderRadius.circular(20),
  //                 ),
  //                 child: Text(
  //                   '${transactions.length} transactions',
  //                   style: TextStyle(
  //                     color: TColo.primaryColor1,
  //                     fontSize: 12,
  //                     fontWeight: FontWeight.w600,
  //                   ),
  //                 ),
  //               ),
  //           ],
  //         ),
  //         const SizedBox(height: 20),
  //         isLoadingTransactions
  //             ? _buildTransactionLoading()
  //             : transactions.isEmpty
  //                 ? _buildNoTransactions()
  //                 : _buildTransactionsList(),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildTransactionLoading() {
    return Container(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(TColo.primaryColor1),
              strokeWidth: 2,
            ),
            const SizedBox(height: 16),
            Text(
              'Loading transactions...',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoTransactions() {
    return Container(
      height: 120,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FontAwesomeIcons.receipt,
              size: 32,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 12),
            Text(
              'No transactions found',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              'Your transaction history will appear here',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionsList() {
    // Show only recent 5 transactions for compact view
    final recentTransactions = transactions.take(5).toList();

    return Column(
      children: [
        ...recentTransactions.map((tx) => _buildTransactionItem(tx)).toList(),
        if (transactions.length > 5) ...[
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Center(
              child: Text(
                '+${transactions.length - 5} more transactions',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTransactionItem(dynamic tx) {
    final timestamp = tx['date'] as Timestamp?;
    final weight = (tx['gramWeight'] ?? 0.0).toDouble();
    final amount = (tx['amount'] ?? 0.0).toDouble();
    final note = tx['note'] ?? '';
    final transactionType = tx['transactionType'] ?? 0;
    final isCredit = transactionType == 0;

    final date = timestamp != null
        ? DateFormat('MMM dd, yyyy').format(timestamp.toDate())
        : 'N/A';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCredit ? Colors.green[50] : Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCredit ? Colors.green[200]! : Colors.red[200]!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isCredit ? Colors.green : Colors.red[400],
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              isCredit ? FontAwesomeIcons.plus : FontAwesomeIcons.minus,
              size: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${weight.toStringAsFixed(2)} g',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    Text(
                      '₹${amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isCredit ? Colors.green[700] : Colors.red[700],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        note.isEmpty ? 'Gold transaction' : note,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoCard() {
    return _buildSectionCard(
      title: 'Personal Information',
      icon: Icons.person_outline,
      children: [
        _buildInfoTile(
          icon: Icons.phone,
          label: 'Phone',
          value: localUserData?.phoneNo,
        ),
        _buildInfoTile(
          icon: Icons.location_city,
          label: 'Address',
          value: localUserData?.address,
        ),
        _buildInfoTile(
          icon: Icons.place,
          label: 'Place',
          value: localUserData?.place?.isNotEmpty == true
              ? localUserData!.place
              : 'Not specified',
        ),
        _buildInfoTile(
            icon: Icons.store,
            label: 'Branch',
            value: localUserData?.branchName),
        _buildInfoTile(
          icon: Icons.public,
          label: 'Country',
          value: localUserData?.country,
        ),
      ],
    );
  }

  Widget _buildNomineeCard() {
    return _buildSectionCard(
      title: 'Nominee Details',
      icon: Icons.family_restroom,
      children: [
        _buildInfoTile(
          icon: Icons.person,
          label: 'Name',
          value: localUserData?.nominee?.isNotEmpty == true
              ? localUserData!.nominee
              : 'Not specified',
        ),
        _buildInfoTile(
          icon: Icons.phone,
          label: 'Phone',
          value: localUserData?.nomineePhone?.isNotEmpty == true
              ? localUserData!.nomineePhone
              : 'Not specified',
        ),
        _buildInfoTile(
          icon: Icons.people,
          label: 'Relation',
          value: localUserData?.nomineeRelation?.isNotEmpty == true
              ? localUserData!.nomineeRelation
              : 'Not specified',
        ),
      ],
    );
  }

  Widget _buildDocumentCard() {
    return _buildSectionCard(
      title: 'Documents',
      icon: Icons.description,
      children: [
        _buildInfoTile(
          icon: Icons.credit_card,
          label: 'Aadhar',
          value: localUserData?.adharCard,
        ),
        _buildInfoTile(
          icon: Icons.badge,
          label: 'PAN',
          value: localUserData?.panCard,
        ),
        _buildInfoTile(
          icon: Icons.pin_drop,
          label: 'PIN Code',
          value: localUserData?.pinCode?.isNotEmpty == true
              ? localUserData!.pinCode
              : 'Not specified',
        ),
      ],
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 30,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: TColo.primaryColor1.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: TColo.primaryColor1,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    String? value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: Colors.grey[500],
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value ?? 'Not provided',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Container(
        //   width: double.infinity,
        //   height: 56,
        //   decoration: BoxDecoration(
        //     gradient: LinearGradient(
        //       colors: [
        //         TColo.primaryColor1,
        //         TColo.primaryColor1.withOpacity(0.8),
        //       ],
        //     ),
        //     borderRadius: BorderRadius.circular(16),
        //     boxShadow: [
        //       BoxShadow(
        //         color: TColo.primaryColor1.withOpacity(0.3),
        //         blurRadius: 20,
        //         spreadRadius: 0,
        //         offset: const Offset(0, 8),
        //       ),
        //     ],
        //   ),
        //   child: ElevatedButton.icon(
        //     onPressed: () {
        //       // Add edit profile functionality
        //     },
        //     icon: Icon(Icons.edit, color: Colors.white),
        //     label: Text(
        //       'Edit Profile',
        //       style: TextStyle(
        //         color: Colors.white,
        //         fontSize: 16,
        //         fontWeight: FontWeight.w600,
        //       ),
        //     ),
        //     style: ElevatedButton.styleFrom(
        //       backgroundColor: Colors.transparent,
        //       shadowColor: Colors.transparent,
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(16),
        //       ),
        //     ),
        //   ),
        // ),
        // const SizedBox(height: 12),
        LogoutButton(
          onLogoutSuccess: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => WebHomeScreen()),
              (route) => false,
            );
          },
        ),
      ],
    );
  }
}
