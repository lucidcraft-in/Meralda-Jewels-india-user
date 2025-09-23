import 'package:flutter/material.dart';
import 'package:meralda_gold_user/common/colo_extension.dart';

import '../webHome.dart';
import '../webPayScreen.dart';
import '../webProfile.dart';

class AspireInfoDialog extends StatelessWidget {
  AspireInfoDialog({super.key, required this.userName, required this.user});
  String userName;
  var user;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    final isMediumScreen = screenWidth >= 400 && screenWidth < 600;
    double fontSize = isMediumScreen ? 15 : 14;
    double iconSize = isMediumScreen ? 18 : 16;
    double buttonHeight = isMediumScreen ? 50 : 48;
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
                      ? 800
                      : 850,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Center(
                      child: Image(
                    image: AssetImage("assets/photos/aspire.png"),
                    width: 250,
                  )),
                  const SizedBox(height: 20),

                  // Benefits
                  _buildBenefitItem(
                    'Get Advantage of Average Gold Rate',
                    Icons.trending_up,
                  ),
                  _buildBenefitItem(
                    'Easy Monthly Instalments',
                    Icons.credit_card,
                  ),
                  const SizedBox(height: 20),

                  // Description
                  Text(
                    'Meralda Aspire Jewellery Buying Plan is a gateway to own coveted pieces by paying '
                    'fixed instalment starting from only ₹2000 for 11 months. Each payment reserves a '
                    'portion of gold weight equivalent to the amount paid and, at the time of redemption, '
                    'you can get your jewellery equivalent to the accumulated weight without paying any '
                    'making charges up to 16%.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Table
                  _buildGoldRateTable(),
                  const SizedBox(height: 20),

                  // Total Row
                  _buildTotalRow(),
                  const SizedBox(height: 30),

                  // Close Button
                  Container(
                    width: double.infinity,
                    height: buttonHeight,
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
                        onTap: () {
                          if (userName != "") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WebPayAmountScreen(
                                  custName: user,
                                  userid: user["id"],
                                  user: user,
                                ),
                              ),
                            );
                          } else {
                            showLoginDialog(context);
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.rocket_launch,
                                color: Colors.white, size: iconSize),
                            SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                'Start Investment Plan',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
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

  Widget _buildGoldRateTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color.fromARGB(255, 224, 224, 224)),
        ),
        child: Table(
          border: TableBorder.symmetric(
            inside: const BorderSide(
                color: const Color.fromARGB(255, 224, 224, 224)),
            outside: BorderSide.none,
          ),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: const {
            0: FixedColumnWidth(80), // Gold Rate
            1: FixedColumnWidth(60), // Month
            2: FixedColumnWidth(100), // Instalment Value
            3: FixedColumnWidth(120), // Total Gold booked
            4: FixedColumnWidth(200), // Gold jewellery waiver
            5: FixedColumnWidth(200), // Diamond discount
          },
          children: [
            // Header Row
            TableRow(
              decoration: BoxDecoration(
                color: TColo.primaryColor1.withOpacity(0.1),
              ),
              children: [
                _buildTableHeaderCell('Gold Rate'),
                _buildTableHeaderCell('Month'),
                _buildTableHeaderCell('Instalment Value'),
                _buildTableHeaderCell('Total Gold booked\n(in grams)'),
                _buildTableHeaderCell(
                    '% of making charges waiver\non purchase of gold jewellery'),
                _buildTableHeaderCell(
                    '% discount on making charges\non purchase of diamond jewellery'),
              ],
            ),

            // Data Rows
            _buildTableDataRow('6100', '1', '₹10,000', '1.6', '', ''),
            _buildTableDataRow('6500', '2', '₹10,000', '1.5', '', ''),
            _buildTableDataRow('6650', '3', '₹10,000', '1.5', '', ''),
            _buildTableDataRow('6600', '4', '₹10,000', '1.5', '', ''),
            _buildTableDataRow('6400', '5', '₹10,000', '1.6', '', ''),
            _buildTableDataRow('6700', '6', '₹10,000', '1.5', '', ''),
            _buildTableDataRow('6850', '7', '₹10,000', '1.5',
                'No making charges\nUp to 10%', '30%'),
            _buildTableDataRow('7100', '8', '₹10,000', '1.4',
                'No making charges\nUp to 10%', '30%'),
            _buildTableDataRow('7050', '9', '₹10,000', '1.4',
                'No making charges\nUp to 12%', '40%'),
            _buildTableDataRow('7100', '10', '₹10,000', '1.4',
                'No making charges\nUp to 12%', '40%'),
            _buildTableDataRow('7200', '11', '₹10,000', '1.4',
                'No making charges\nUp to 16%', '50%'),
          ],
        ),
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
          fontSize: 12,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTableDataCell(String text,
      {bool isBold = false, bool isCentered = true}) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          color: Colors.grey[800],
          fontSize: 12,
          height: 1.3,
        ),
        textAlign: isCentered ? TextAlign.center : TextAlign.left,
      ),
    );
  }

  TableRow _buildTableDataRow(String goldRate, String month, String installment,
      String gold, String waiver, String discount) {
    return TableRow(
      children: [
        _buildTableDataCell(goldRate),
        _buildTableDataCell(month),
        _buildTableDataCell(installment),
        _buildTableDataCell(gold),
        _buildTableDataCell(waiver, isCentered: false),
        _buildTableDataCell(discount),
      ],
    );
  }

  Widget _buildTotalRow() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TColo.primaryColor1.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: TColo.primaryColor1,
              fontSize: 16,
            ),
          ),
          Text(
            '16.3 grams',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

// Usage example:
void showAspireInfoDialog(BuildContext context, String userName, var user) {
  showDialog(
    context: context,
    builder: (context) => AspireInfoDialog(userName: userName, user: user),
  );
}
