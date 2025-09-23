import 'package:flutter/material.dart';

import '../webHome.dart';
import '../webProfile.dart';

class GoldCalculatorScreen extends StatefulWidget {
  GoldCalculatorScreen({super.key, required this.userName});
  String userName;

  @override
  State<GoldCalculatorScreen> createState() => _GoldCalculatorScreenState();
}

class _GoldCalculatorScreenState extends State<GoldCalculatorScreen>
    with TickerProviderStateMixin {
  double monthlyAmount = 5000;
  int selectedMonths = 11;
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  // Define colors
  Color primaryColor1 = const Color(0xFF003A35);
  Color secondaryColor = const Color(0xFFb58763);

  // Define the bonus structure based on months (matches your screenshot)
  Map<int, double> bonusPercentages = {
    6: 25.0,
    8: 50.0,
    11: 100.0,
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - _slideAnimation.value)),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              width: double.infinity,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 12,
                shadowColor: primaryColor1.withOpacity(0.3),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white,
                        secondaryColor.withOpacity(0.1),
                      ],
                    ),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      bool isLargeScreen = constraints.maxWidth > 1000;
                      bool isMediumScreen = constraints.maxWidth > 600 &&
                          constraints.maxWidth <= 1000;
                      bool isSmallScreen = constraints.maxWidth <= 600;

                      // Large screen layout (desktop)
                      if (isLargeScreen) {
                        return IntrinsicHeight(
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: _buildImageSection(isLargeScreen,
                                    isMediumScreen, isSmallScreen),
                              ),
                              Container(
                                width: 1,
                                color: secondaryColor.withOpacity(0.3),
                                margin: EdgeInsets.symmetric(vertical: 20),
                              ),
                              Expanded(
                                flex: 3,
                                child: _buildCalculatorSection(
                                  isLargeScreen,
                                  isMediumScreen,
                                  isSmallScreen,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      // Medium and Small screen layout (tablet and mobile)
                      else {
                        return Column(
                          children: [
                            Container(
                              height: isMediumScreen ? 180 : 160,
                              child: _buildImageSection(
                                  isLargeScreen, isMediumScreen, isSmallScreen),
                            ),
                            _buildCalculatorSection(
                              isLargeScreen,
                              isMediumScreen,
                              isSmallScreen,
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageSection(
      bool isLargeScreen, bool isMediumScreen, bool isSmallScreen) {
    double iconSize = isLargeScreen ? 80 : (isMediumScreen ? 60 : 40);
    double titleSize = isLargeScreen ? 24 : (isMediumScreen ? 20 : 16);
    double subtitleSize = isLargeScreen ? 14 : (isMediumScreen ? 13 : 12);

    return Container(
      padding: EdgeInsets.all(isLargeScreen ? 24 : (isMediumScreen ? 10 : 12)),
      constraints: isSmallScreen ? BoxConstraints(minHeight: 140) : null,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding:
                EdgeInsets.all(isLargeScreen ? 20 : (isMediumScreen ? 16 : 10)),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor1, primaryColor1.withOpacity(0.8)],
              ),
              borderRadius: BorderRadius.circular(isLargeScreen ? 20 : 16),
              boxShadow: [
                BoxShadow(
                  color: primaryColor1.withOpacity(0.3),
                  blurRadius: 15,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              Icons.auto_awesome,
              size: iconSize,
              color: Colors.white,
            ),
          ),
          SizedBox(height: isLargeScreen ? 20 : (isMediumScreen ? 16 : 8)),
          Text(
            'Smart Gold Investment',
            style: TextStyle(
              fontSize: titleSize,
              fontWeight: FontWeight.bold,
              color: primaryColor1,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: isLargeScreen ? 8 : 4),
          Text(
            'Plan your gold savings with flexible monthly payments',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: subtitleSize,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildCalculatorSection(
    bool isLargeScreen,
    bool isMediumScreen,
    bool isSmallScreen,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isLargeScreen ? 24 : (isMediumScreen ? 20 : 16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildSectionHeader('Gold Calculator', Icons.calculate, isLargeScreen,
              isMediumScreen, isSmallScreen),
          SizedBox(height: isLargeScreen ? 24 : (isMediumScreen ? 20 : 16)),

          // Monthly Amount Slider
          _buildAmountSlider(isLargeScreen, isMediumScreen, isSmallScreen),
          SizedBox(height: isLargeScreen ? 24 : (isMediumScreen ? 20 : 16)),

          // Results Table (matches your screenshot)
          _buildComparisonTable(isLargeScreen, isMediumScreen, isSmallScreen),
          SizedBox(height: isLargeScreen ? 24 : (isMediumScreen ? 20 : 16)),

          // Action Button
          _buildActionButton(isLargeScreen, isMediumScreen, isSmallScreen),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, bool isLargeScreen,
      bool isMediumScreen, bool isSmallScreen) {
    double iconSize = isLargeScreen ? 20 : (isMediumScreen ? 18 : 16);
    double titleSize = isLargeScreen ? 20 : (isMediumScreen ? 18 : 16);

    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(isLargeScreen ? 8 : 6),
          decoration: BoxDecoration(
            color: primaryColor1.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: primaryColor1,
            size: iconSize,
          ),
        ),
        SizedBox(width: 12),
        Flexible(
          child: Text(
            title,
            style: TextStyle(
              fontSize: titleSize,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAmountSlider(
      bool isLargeScreen, bool isMediumScreen, bool isSmallScreen) {
    double titleSize = isLargeScreen ? 16 : (isMediumScreen ? 15 : 14);

    return Container(
      padding: EdgeInsets.all(isLargeScreen ? 20 : (isMediumScreen ? 16 : 12)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: secondaryColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: primaryColor1.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.currency_rupee,
                  color: primaryColor1, size: titleSize + 4),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Monthly Scheme Amount',
                  style: TextStyle(
                    fontSize: titleSize,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: primaryColor1,
              inactiveTrackColor: secondaryColor.withOpacity(0.3),
              thumbColor: primaryColor1,
              overlayColor: secondaryColor.withOpacity(0.2),
              trackHeight: 6,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12),
            ),
            child: Slider(
              value: monthlyAmount,
              min: 1000,
              max: 50000,
              divisions: 98,
              label: "₹${monthlyAmount.toInt()}",
              onChanged: (value) => setState(() => monthlyAmount = value),
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('₹1,000',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              Text('₹50,000',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonTable(
      bool isLargeScreen, bool isMediumScreen, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isLargeScreen ? 20 : (isMediumScreen ? 16 : 12)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: secondaryColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: primaryColor1.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(Icons.assessment, color: primaryColor1, size: 20),
              SizedBox(width: 8),
              Text(
                'Scheme Comparison',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: isSmallScreen ? Axis.horizontal : Axis.vertical,
            child: DataTable(
              columnSpacing: 24,
              // isLargeScreen ? 24 : (isMediumScreen ? 16 : 12),
              columns: [
                DataColumn(
                  label: Text(
                    'Description',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primaryColor1,
                    ),
                  ),
                ),
                ...bonusPercentages.keys.map((months) => DataColumn(
                      label: Text(
                        '$months months',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryColor1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )),
              ],
              rows: [
                // Monthly Scheme Amount Row
                DataRow(cells: [
                  DataCell(Text('Monthly Scheme Amount')),
                  ...bonusPercentages.keys.map((months) => DataCell(
                        Text(
                          '₹ ${monthlyAmount.toInt()}',
                          textAlign: TextAlign.center,
                        ),
                      )),
                ]),
                // No. of Installments Row
                DataRow(cells: [
                  DataCell(Text('No. of Installments')),
                  ...bonusPercentages.keys.map((months) => DataCell(
                        Text(
                          '$months months',
                          textAlign: TextAlign.center,
                        ),
                      )),
                ]),
                // Total Installment Paid Row
                DataRow(cells: [
                  DataCell(Text('Total Installment Paid')),
                  ...bonusPercentages.keys.map((months) => DataCell(
                        Text(
                          '₹ ${(monthlyAmount * months).toInt()}',
                          textAlign: TextAlign.center,
                        ),
                      )),
                ]),
                // Bonus Percentage Row
                DataRow(cells: [
                  DataCell(Text('Bonus Percentage')),
                  ...bonusPercentages.keys.map((months) => DataCell(
                        Text(
                          '${bonusPercentages[months]!.toInt()}%',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )),
                ]),
                // Bonus Amount Row (percentage of monthly installment amount)
                DataRow(cells: [
                  DataCell(Text('Bonus Amount')),
                  ...bonusPercentages.keys.map((months) {
                    double bonusAmount =
                        monthlyAmount * (bonusPercentages[months]! / 100);
                    return DataCell(
                      Text(
                        '₹ ${bonusAmount.toInt()}',
                        textAlign: TextAlign.center,
                      ),
                    );
                  }),
                ]),
                // Total Redemption Value Row (Total Installment Paid + Bonus Amount)
                DataRow(cells: [
                  DataCell(Text(
                    'Total Redemption Value',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primaryColor1,
                    ),
                  )),
                  ...bonusPercentages.keys.map((months) {
                    double totalPayment = monthlyAmount * months;
                    double bonusAmount =
                        monthlyAmount * (bonusPercentages[months]! / 100);
                    double finalAmount = totalPayment + bonusAmount;
                    return DataCell(
                      Text(
                        '₹ ${finalAmount.toInt()}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryColor1,
                        ),
                      ),
                    );
                  }),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      bool isLargeScreen, bool isMediumScreen, bool isSmallScreen) {
    double buttonHeight = isLargeScreen ? 56 : (isMediumScreen ? 50 : 48);
    double fontSize = isLargeScreen ? 16 : (isMediumScreen ? 15 : 14);
    double iconSize = isLargeScreen ? 20 : (isMediumScreen ? 18 : 16);

    return Container(
      width: double.infinity,
      height: buttonHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor1, primaryColor1.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryColor1.withOpacity(0.4),
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
            // Handle button press
            if (widget.userName != "") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Webprofile(),
                ),
              );
            } else {
              showLoginDialog(context);
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.rocket_launch, color: Colors.white, size: iconSize),
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
    );
  }
}
