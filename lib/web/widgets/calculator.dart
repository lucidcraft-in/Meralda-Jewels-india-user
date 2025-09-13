import 'package:flutter/material.dart';

class GoldCalculatorScreen extends StatefulWidget {
  const GoldCalculatorScreen({super.key});

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

  // Define the bonus structure based on months
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

  double getBonusPercentage(int months) {
    return bonusPercentages[months] ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    double totalPayment = monthlyAmount * selectedMonths;
    double bonusPercentage = getBonusPercentage(selectedMonths);
    double bonusAmount = totalPayment * (bonusPercentage / 100);
    double finalAmount = totalPayment + bonusAmount;

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
                                  totalPayment,
                                  bonusAmount,
                                  finalAmount,
                                  bonusPercentage,
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
                              totalPayment,
                              bonusAmount,
                              finalAmount,
                              bonusPercentage,
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
    double totalPayment,
    double bonusAmount,
    double finalAmount,
    double bonusPercentage,
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

          // Month Selection
          _buildMonthSelection(isLargeScreen, isMediumScreen, isSmallScreen),
          SizedBox(height: isLargeScreen ? 32 : (isMediumScreen ? 24 : 20)),

          // Calculation Results
          _buildResultsChart(totalPayment, bonusAmount, finalAmount,
              bonusPercentage, isLargeScreen, isMediumScreen, isSmallScreen),
          SizedBox(height: isLargeScreen ? 24 : (isMediumScreen ? 20 : 16)),

          // Action Button
          _buildActionButton(
              finalAmount, isLargeScreen, isMediumScreen, isSmallScreen),
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
                  'Monthly Payment Amount',
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

          // For small screens, stack vertically
          if (isSmallScreen) ...[
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
            SizedBox(height: 12),
            _buildAmountTextField(),
          ] else ...[
            // For medium and large screens, keep horizontal layout
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: SliderTheme(
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
                      onChanged: (value) =>
                          setState(() => monthlyAmount = value),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Container(
                  width: isMediumScreen ? 110 : 120,
                  child: _buildAmountTextField(),
                ),
              ],
            ),
          ],

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

  Widget _buildAmountTextField() {
    return TextField(
      decoration: InputDecoration(
        prefixText: "₹ ",
        prefixStyle: TextStyle(
          color: primaryColor1,
          fontWeight: FontWeight.bold,
        ),
        filled: true,
        fillColor: secondaryColor.withOpacity(0.1),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: secondaryColor.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primaryColor1, width: 2),
        ),
      ),
      style: TextStyle(fontWeight: FontWeight.bold),
      keyboardType: TextInputType.number,
      controller: TextEditingController(text: monthlyAmount.toInt().toString()),
      onChanged: (val) {
        double? v = double.tryParse(val);
        if (v != null && v >= 1000 && v <= 50000) {
          setState(() => monthlyAmount = v);
        }
      },
    );
  }

  Widget _buildMonthSelection(
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
              Icon(Icons.schedule, color: primaryColor1, size: titleSize + 4),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Select Payment Duration',
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

          // Responsive month selection
          // isSmallScreen
          //     ? Column(
          //         children: bonusPercentages.keys
          //             .map((months) => _buildMonthOption(
          //                 months, isLargeScreen, isMediumScreen, isSmallScreen,
          //                 isFullWidth: true))
          //             .toList(),
          //       )
          //     :
          Row(
            children: bonusPercentages.keys
                .map((months) => _buildMonthOption(
                    months, isLargeScreen, isMediumScreen, isSmallScreen))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthOption(
      int months, bool isLargeScreen, bool isMediumScreen, bool isSmallScreen,
      {bool isFullWidth = false}) {
    bool isSelected = selectedMonths == months;
    double monthFontSize = isLargeScreen ? 24 : (isMediumScreen ? 20 : 18);
    double labelFontSize = isLargeScreen ? 12 : (isMediumScreen ? 11 : 10);
    double bonusFontSize = isLargeScreen ? 10 : (isMediumScreen ? 9 : 8);

    Widget monthCard = GestureDetector(
      onTap: () => setState(() => selectedMonths = months),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        margin: EdgeInsets.symmetric(
          horizontal: isFullWidth ? 0 : 4,
          vertical: isFullWidth ? 4 : 0,
        ),
        padding: EdgeInsets.symmetric(
            vertical: isLargeScreen ? 16 : (isMediumScreen ? 14 : 12)),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [primaryColor1, primaryColor1.withOpacity(0.8)],
                )
              : null,
          color: isSelected ? null : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? primaryColor1 : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: primaryColor1.withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Text(
              '$months',
              style: TextStyle(
                fontSize: monthFontSize,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.grey[800],
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Months',
              style: TextStyle(
                fontSize: labelFontSize,
                color: isSelected ? Colors.white70 : Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withOpacity(0.2)
                    : secondaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${getBonusPercentage(months).toInt()}% Bonus',
                style: TextStyle(
                  fontSize: bonusFontSize,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : primaryColor1,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return isFullWidth ? monthCard : Expanded(child: monthCard);
  }

  Widget _buildResultsChart(
      double totalPayment,
      double bonusAmount,
      double finalAmount,
      double bonusPercentage,
      bool isLargeScreen,
      bool isMediumScreen,
      bool isSmallScreen) {
    double titleSize = isLargeScreen ? 16 : (isMediumScreen ? 15 : 14);

    return Container(
      padding: EdgeInsets.all(isLargeScreen ? 20 : (isMediumScreen ? 16 : 12)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            secondaryColor.withOpacity(0.1),
            secondaryColor.withOpacity(0.05)
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: secondaryColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: primaryColor1.withOpacity(0.1),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.assessment, color: primaryColor1, size: titleSize + 4),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Investment Summary',
                  style: TextStyle(
                    fontSize: titleSize,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),

          // Results Table
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border:
                  Border.all(color: secondaryColor.withOpacity(0.5), width: 2),
            ),
            child: Column(
              children: [
                _buildTableHeader(isLargeScreen, isMediumScreen, isSmallScreen),
                _buildTableRow(
                    'Monthly Payment',
                    '₹${monthlyAmount.toStringAsFixed(0)}',
                    primaryColor1,
                    isLargeScreen,
                    isMediumScreen,
                    isSmallScreen),
                _buildTableRow(
                    'No. of Installments',
                    '$selectedMonths months',
                    primaryColor1,
                    isLargeScreen,
                    isMediumScreen,
                    isSmallScreen),
                _buildTableRow(
                    'Total Payment',
                    '₹${totalPayment.toStringAsFixed(0)}',
                    primaryColor1,
                    isLargeScreen,
                    isMediumScreen,
                    isSmallScreen),
                _buildTableRow(
                    'Bonus Percentage',
                    '${bonusPercentage.toInt()}%',
                    primaryColor1,
                    isLargeScreen,
                    isMediumScreen,
                    isSmallScreen),
                _buildTableRow(
                    'Bonus Amount',
                    '₹${bonusAmount.toStringAsFixed(0)}',
                    primaryColor1,
                    isLargeScreen,
                    isMediumScreen,
                    isSmallScreen),
                _buildTableRow(
                    'Total Value',
                    '₹${finalAmount.toStringAsFixed(0)}',
                    primaryColor1,
                    isLargeScreen,
                    isMediumScreen,
                    isSmallScreen,
                    isLast: true,
                    isHighlighted: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(
      bool isLargeScreen, bool isMediumScreen, bool isSmallScreen) {
    double fontSize = isLargeScreen ? 14 : (isMediumScreen ? 13 : 12);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isLargeScreen ? 16 : (isMediumScreen ? 14 : 12),
        vertical: isLargeScreen ? 12 : (isMediumScreen ? 10 : 8),
      ),
      decoration: BoxDecoration(
        color: primaryColor1,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Description',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
            ),
          ),
          Text(
            'Amount',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(String label, String value, Color color,
      bool isLargeScreen, bool isMediumScreen, bool isSmallScreen,
      {bool isLast = false, bool isHighlighted = false}) {
    double labelFontSize = isLargeScreen
        ? (isHighlighted ? 15 : 14)
        : (isMediumScreen
            ? (isHighlighted ? 14 : 13)
            : (isHighlighted ? 13 : 12));
    double valueFontSize = isLargeScreen
        ? (isHighlighted ? 16 : 15)
        : (isMediumScreen
            ? (isHighlighted ? 15 : 14)
            : (isHighlighted ? 14 : 13));

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isLargeScreen ? 16 : (isMediumScreen ? 14 : 12),
        vertical: isLargeScreen ? 12 : (isMediumScreen ? 10 : 8),
      ),
      decoration: BoxDecoration(
        color: isHighlighted ? secondaryColor.withOpacity(0.1) : Colors.white,
        border: !isLast
            ? Border(bottom: BorderSide(color: Colors.grey[200]!))
            : null,
        borderRadius: isLast
            ? BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              )
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w500,
                color: Colors.grey[700],
                fontSize: labelFontSize,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: valueFontSize,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(double finalAmount, bool isLargeScreen,
      bool isMediumScreen, bool isSmallScreen) {
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
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                title: Text('Start Investment Plan'),
                content: Text(
                    'Ready to start your gold investment plan worth ₹${finalAmount.toStringAsFixed(0)}?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor1,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text('Start Plan',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            );
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
