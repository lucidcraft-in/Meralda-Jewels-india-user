import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meralda_gold_user/model/appUser.dart';
import 'package:meralda_gold_user/model/customerModel.dart';
import 'package:provider/provider.dart';

import '../../common/colo_extension.dart';
import '../../providers/account_provider.dart';
import '../webBasicRag.dart';
import '../webProfile.dart';
import '../webRegistration.dart';
import 'helperWid.dart';

class LeftPanel extends StatefulWidget {
  LeftPanel({Key? key, required this.user}) : super(key: key);
  final Map? user;

  @override
  State<LeftPanel> createState() => _LeftPanelState();
}

class _LeftPanelState extends State<LeftPanel> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final accountProvider = context.watch<AccountProvider>();
    final accounts = accountProvider.accounts;

    final cashBalance = accountProvider.cashBalance;
    final gramBalance = accountProvider.gramBalance;

    final averagePrice =
        accountProvider.cashBalance / accountProvider.gramBalance;

    final activeAccount = accounts.isNotEmpty
        ? accounts[accountProvider.selectedAccountIndex]
        : null;

    final user = widget.user;

    if (activeAccount != null) {
      return Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              TColo.primaryColor1.withOpacity(0.8),
              TColo.primaryColor1,
              TColo.primaryColor2,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Customer Details',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Webprofile()));
                    },
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.person_outline,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // Customer Information Card
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (activeAccount.name != "")
                      _buildInfoRow(
                        icon: Icons.badge_outlined,
                        label: 'Customer Name',
                        value: activeAccount!.name ?? 'N/A',
                      ),
                    if (activeAccount.custId != "") SizedBox(height: 12),
                    if (activeAccount.custId != "")
                      _buildInfoRow(
                        icon: Icons.fingerprint,
                        label: 'Customer ID',
                        value: activeAccount.custId ?? 'N/A',
                      ),
                    if (activeAccount.schemeType != "") SizedBox(height: 12),
                    if (activeAccount.schemeType != "")
                      _buildInfoRow(
                        icon: Icons.category_outlined,
                        label: 'Scheme Type',
                        value: activeAccount.schemeType ?? 'N/A',
                      ),
                    SizedBox(height: 12),
                    _buildInfoRow(
                      icon: Icons.phone_outlined,
                      label: 'Phone Number',
                      value: activeAccount.phoneNo ?? 'N/A',
                    ),
                    SizedBox(height: 12),
                    Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 0.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              "Account Status  :   ",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 12),
                            ),
                            SizedBox(height: 2),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: getStatusColors(activeAccount.status),
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: getStatusBorderColor(
                                      activeAccount.status),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: getStatusShadowColor(
                                        activeAccount.status),
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: getStatusIndicatorColor(
                                          activeAccount.status),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: getStatusIndicatorColor(
                                                  activeAccount.status)
                                              .withOpacity(0.3),
                                          blurRadius: 2,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    getStatusText(activeAccount.status),
                                    style: TextStyle(
                                      color: getStatusTextColor(
                                          activeAccount.status),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ],
                              ),
                            )

                            // Container(
                            //   padding: EdgeInsets.symmetric(
                            //       horizontal: 6, vertical: 2),
                            //   decoration: BoxDecoration(
                            //     color: Color.fromARGB(201, 255, 255, 255),
                            //     borderRadius: BorderRadius.circular(8),
                            //     border: Border.all(
                            //       color: Colors.white.withOpacity(0.2),
                            //       width: 0.5,
                            //     ),
                            //   ),
                            //   child: Text(
                            //     activeAccount.status == CustomerStatus.pending
                            //         ? "Pending"
                            //         : SchemeUserModel.statusToString(
                            //                 activeAccount.status)
                            //             .toString(),
                            //     style: TextStyle(
                            //         color:
                            //             const Color.fromARGB(179, 44, 43, 43),
                            //         fontSize: 12),
                            //   ),
                            // )

                            //   Text(
                            //     account.schemeType!.toUpperCase(),
                            //     style: TextStyle(
                            //       color: Colors.black,
                            //       fontSize: 9,
                            //       fontWeight: FontWeight.w700,
                            //       letterSpacing: 0.5,
                            //     ),
                            //   ),
                            // ),
                          ],
                        )),
                    if (activeAccount.name == "") SizedBox(height: 12),
                    if (activeAccount.name == "")
                      GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) =>
                                  // UserRegistrationDialog(),
                                  UserRegistrationDialog(
                                    type: "update",
                                    user: widget.user,
                                  ));
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 8),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 2,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: Text(
                            'Add Scheme ',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              if (activeAccount.schemeType != "") SizedBox(height: 16),

              if (activeAccount.schemeType != "")
                Row(
                  children: [
                    Expanded(
                      child: _buildBalanceCard(
                        title: 'Gold Balance',
                        value: '${gramBalance.toStringAsFixed(3)} g',
                        icon: Icons.auto_awesome,
                        gradient: [
                          Colors.amber.shade400,
                          Colors.amber.shade600
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: _buildBalanceCard(
                        title: 'Amount Balance',
                        value: '₹$cashBalance.00',
                        icon: Icons.account_balance_wallet,
                        gradient: [
                          Colors.green.shade400,
                          Colors.green.shade600
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: _buildBalanceCard(
                        title: 'Avg. Price',
                        value: cashBalance != 0
                            ? '₹${averagePrice.toStringAsFixed(0)}/g'
                            : "0.00/g",
                        icon: Icons.trending_up,
                        gradient: [Colors.blue.shade400, Colors.blue.shade600],
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 24),

              // Settings Section Header
              Row(
                children: [
                  Icon(
                    Icons.settings,
                    color: Colors.white,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Scheme Settings',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12),
              _buildAddAccountCard(context), SizedBox(height: 16),

              if (accounts.length > 1)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Multiple Schems',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    ...accounts.asMap().entries.map((entry) {
                      final acc = entry.value;
                      return GestureDetector(
                        onTap: () => accountProvider.switchAccount(
                            acc, entry.key, context),
                        child: _buildAccountCard(acc, entry.key, context),
                      );
                    }),
                  ],
                ),

              SizedBox(height: 16),

              // Footer
              Container(
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.white70, size: 16),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'All transactions are secure and encrypted',
                        style: TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
    final dynamic createdAtValue = user!["createdAt"];
    final DateTime createdAt = createdAtValue is DateTime
        ? createdAtValue
        : DateTime.parse(createdAtValue.toString());

    final formattedDate = DateFormat('dd/MM/yyyy').format(createdAt);
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            TColo.primaryColor1.withOpacity(0.8),
            TColo.primaryColor1,
            TColo.primaryColor2,
          ],
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Customer Details',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Webprofile()),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.person_outline,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            // Customer Information Card - Simplified with only phone and date
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Phone Number
                  _buildInfoRow(
                    icon: Icons.phone_outlined,
                    label: 'Phone Number',
                    value: user!["phoneNo"],
                  ),
                  SizedBox(height: 12),

                  // // Creation Date
                  _buildInfoRow(
                    icon: Icons.calendar_today,
                    label: 'Member Since',
                    value: formattedDate,
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            // Settings Section Header
            Row(
              children: [
                Icon(
                  Icons.settings,
                  color: Colors.white,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Scheme Settings',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            SizedBox(height: 12),
            _buildAddAccountCard(context),
            SizedBox(height: 16),

            if (accounts.length > 1)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Multiple Schemes',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  ...accounts.asMap().entries.map((entry) {
                    final acc = entry.value;
                    return GestureDetector(
                      onTap: () => accountProvider.switchAccount(
                          acc, entry.key, context),
                      child: _buildAccountCard(acc, entry.key, context),
                    );
                  }),
                ],
              ),

            SizedBox(height: 16),

            // Footer
            Container(
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.white70, size: 16),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'All transactions are secure and encrypted',
                      style: TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountCard(
      SchemeUserModel account, int index, BuildContext context) {
    final accountProvider = context.watch<AccountProvider>();
    final isSelected = index == accountProvider.selectedAccountIndex;

    return GestureDetector(
      onTap: () => accountProvider.switchAccount(account, index, context),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        margin: EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withOpacity(0.25)
              : Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Colors.white.withOpacity(0.5)
                : Colors.white.withOpacity(0.1),
            width: isSelected ? 2.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- header row
            Row(
              children: [
                Icon(
                  isSelected
                      ? Icons.account_circle
                      : Icons.account_circle_outlined,
                  color: Colors.white,
                  size: 20,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Account name with scheme type chip
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              account.name ?? 'N/A',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (account.schemeType != null &&
                              account.schemeType!.isNotEmpty) ...[
                            SizedBox(width: 8),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                  width: 0.5,
                                ),
                              ),
                              child: Text(
                                account.schemeType!.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 2),
                      Text(
                        'ID: ${account.custId ?? "N/A"}',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white, size: 12),
                        SizedBox(width: 4),
                        Text("Active",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
              ],
            ),

            SizedBox(height: 12),

            // --- balances
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Gold Balance",
                          style:
                              TextStyle(color: Colors.white70, fontSize: 11)),
                      Text(
                        '${account.totalGram?.toStringAsFixed(3) ?? "0.000"} g',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Cash Balance",
                          style:
                              TextStyle(color: Colors.white70, fontSize: 11)),
                      Text(
                        '₹${account.balance ?? "0"}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddAccountCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => UserRegistrationDialog(
            type: "add",
            user: widget.user,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.15),
            width: 1.5,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left icon
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 24,
              ),
            ),

            const SizedBox(width: 14),

            // Middle text section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Add New Scheme',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Create multiple schemes for customers',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            // Right button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.25)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    Icons.person_add,
                    color: Colors.white,
                    size: 14,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Create',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 18),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceCard({
    required String title,
    required String value,
    required IconData icon,
    required List<Color> gradient,
  }) {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradient),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: gradient[1].withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 20),
          SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(color: Colors.white70, fontSize: 11),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
