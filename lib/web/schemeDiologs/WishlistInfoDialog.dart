import 'package:flutter/material.dart';
import 'package:meralda_gold_user/common/colo_extension.dart';
import 'package:meralda_gold_user/providers/user.dart';
import 'package:meralda_gold_user/web/widgets/calculator.dart';

class WishlistInfoDialog extends StatelessWidget {
  WishlistInfoDialog({super.key, required this.userName, required this.user});
  String userName;
  var user;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    final isMediumScreen = screenWidth >= 400 && screenWidth < 600;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            constraints: BoxConstraints(
              maxWidth: isSmallScreen
                  ? screenWidth * 0.95
                  : isMediumScreen
                      ? 600
                      : 850,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Center(
                      child: Image(
                    image: AssetImage("assets/photos/wishlist.png"),
                    width: 250,
                  )),
                  const SizedBox(height: 20),

                  // Benefits
                  _buildBenefitItem(
                    'Get up to 100% of First Instalment as Bonus',
                    Icons.star,
                  ),
                  _buildBenefitItem(
                    'Easy Monthly Instalments',
                    Icons.credit_card,
                  ),
                  const SizedBox(height: 20),

                  // Description
                  Text(
                    'With the WishList Jewellery Buying Plan, we love to turn your desires into reality. '
                    'Now, you can open an account with a minimum amount of 2000. You will be qualified for '
                    'a bonus of up to 100% of your initial instalment, if you make fixed monthly payments '
                    'for 11 months continuously.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Table
                  // _buildPricingTable(),
                  GoldCalculatorScreen(
                    userName: userName,
                  ),
                  // const SizedBox(height: 30),
                ],
              ),
            ),
          ),
          Positioned(
            top: isSmallScreen ? 8 : 10,
            right: isSmallScreen ? 8 : 10,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.close,
                size: isSmallScreen ? 20 : 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: TColo.primaryColor1,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color.fromARGB(255, 224, 224, 224)),
      ),
      child: Table(
        border: TableBorder.symmetric(
          inside:
              const BorderSide(color: const Color.fromARGB(255, 224, 224, 224)),
          outside: BorderSide.none,
        ),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        columnWidths: const {
          0: FlexColumnWidth(1.5),
          1: FlexColumnWidth(1),
          2: FlexColumnWidth(1),
          3: FlexColumnWidth(1),
        },
        children: [
          // Header Row
          TableRow(
            decoration: BoxDecoration(
              color: TColo.primaryColor1.withOpacity(0.1),
            ),
            children: [
              _buildTableHeaderCell(''),
              _buildTableHeaderCell('₹ 5000'),
              _buildTableHeaderCell('₹ 5000'),
              _buildTableHeaderCell('₹ 5000'),
            ],
          ),

          // Data Rows
          _buildTableRow(
              'No.of Instalments', ['11 months', '8 months', '6 months']),
          _buildTableRow(
              'Total Instalment Paid', ['₹ 55,000', '₹ 40,000', '₹ 30,000']),
          _buildTableRow('Bonus Percentage', ['100%', '50%', '25%']),
          _buildTableRow('Bonus Amount', ['₹ 5000', '₹ 2500', '₹ 1250']),

          // Total Row with different styling
          TableRow(
            decoration: BoxDecoration(
              color: TColo.primaryColor1.withOpacity(0.05),
              border: const Border(
                  top: BorderSide(
                      color: const Color.fromARGB(255, 224, 224, 224))),
            ),
            children: [
              _buildTableHeaderCell('Total Redemption Value'),
              _buildTableCell('₹ 60,000', isBold: true),
              _buildTableCell('₹ 42,500', isBold: true),
              _buildTableCell('₹ 31,250', isBold: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: TColo.primaryColor1,
          fontSize: 14,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTableCell(String text, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          color: Colors.grey[800],
          fontSize: 14,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  TableRow _buildTableRow(String label, List<String> values) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
              fontSize: 14,
            ),
          ),
        ),
        ...values.map((value) => _buildTableCell(value)).toList(),
      ],
    );
  }
}

// Usage example:
void showWishlistInfoDialog(BuildContext context, String userName, var user) {
  showDialog(
    context: context,
    builder: (context) => WishlistInfoDialog(userName: userName, user: user),
  );
}
