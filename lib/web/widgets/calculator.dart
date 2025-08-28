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
            child: Center(
              child: Container(
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
                        bool isMobile = constraints.maxWidth < 900;

                        return isMobile
                            ? Column(
                                children: [
                                  Container(
                                    height: 200,
                                    child: _buildImageSection(),
                                  ),
                                  Expanded(
                                    child: _buildCalculatorSection(
                                      totalPayment,
                                      bonusAmount,
                                      finalAmount,
                                      bonusPercentage,
                                    ),
                                  ),
                                ],
                              )
                            : IntrinsicHeight(
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: _buildImageSection(),
                                    ),
                                    Container(
                                      width: 1,
                                      color: secondaryColor.withOpacity(0.3),
                                      margin:
                                          EdgeInsets.symmetric(vertical: 20),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: _buildCalculatorSection(
                                        totalPayment,
                                        bonusAmount,
                                        finalAmount,
                                        bonusPercentage,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor1, primaryColor1.withOpacity(0.8)],
              ),
              borderRadius: BorderRadius.circular(20),
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
              size: 80,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Smart Gold Investment',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: primaryColor1,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Plan your gold savings with flexible monthly payments',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
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
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryColor1.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.calculate,
                  color: primaryColor1,
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              Text(
                'Gold Calculator',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),

          SizedBox(height: 24),

          // Monthly Amount Slider
          _buildAmountSlider(),

          SizedBox(height: 24),

          // Month Selection
          _buildMonthSelection(),

          SizedBox(height: 32),

          // Calculation Results
          _buildResultsChart(
              totalPayment, bonusAmount, finalAmount, bonusPercentage),

          SizedBox(height: 24),

          // Action Button
          _buildActionButton(finalAmount),
        ],
      ),
    );
  }

  Widget _buildAmountSlider() {
    return Container(
      padding: EdgeInsets.all(20),
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
              Icon(Icons.currency_rupee, color: primaryColor1, size: 20),
              SizedBox(width: 8),
              Text(
                'Monthly Payment Amount',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
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
                    onChanged: (value) => setState(() => monthlyAmount = value),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Container(
                width: 120,
                child: TextField(
                  decoration: InputDecoration(
                    prefixText: "₹ ",
                    prefixStyle: TextStyle(
                      color: primaryColor1,
                      fontWeight: FontWeight.bold,
                    ),
                    filled: true,
                    fillColor: secondaryColor.withOpacity(0.1),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          BorderSide(color: secondaryColor.withOpacity(0.5)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: primaryColor1, width: 2),
                    ),
                  ),
                  style: TextStyle(fontWeight: FontWeight.bold),
                  keyboardType: TextInputType.number,
                  controller: TextEditingController(
                      text: monthlyAmount.toInt().toString()),
                  onChanged: (val) {
                    double? v = double.tryParse(val);
                    if (v != null && v >= 1000 && v <= 50000) {
                      setState(() => monthlyAmount = v);
                    }
                  },
                ),
              ),
            ],
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

  Widget _buildMonthSelection() {
    return Container(
      padding: EdgeInsets.all(20),
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
              Icon(Icons.schedule, color: primaryColor1, size: 20),
              SizedBox(width: 8),
              Text(
                'Select Payment Duration',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: bonusPercentages.keys.map((months) {
              bool isSelected = selectedMonths == months;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => selectedMonths = months),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? LinearGradient(
                              colors: [
                                primaryColor1,
                                primaryColor1.withOpacity(0.8)
                              ],
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
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.grey[800],
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Months',
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                isSelected ? Colors.white70 : Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white.withOpacity(0.2)
                                : secondaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${getBonusPercentage(months).toInt()}% Bonus',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : primaryColor1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsChart(double totalPayment, double bonusAmount,
      double finalAmount, double bonusPercentage) {
    return Container(
      padding: EdgeInsets.all(20),
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
              Icon(Icons.assessment, color: primaryColor1, size: 20),
              SizedBox(width: 8),
              Text(
                'Investment Summary',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
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
                _buildTableHeader(),
                _buildTableRow(
                  'Monthly Payment',
                  '₹${monthlyAmount.toStringAsFixed(0)}',
                  primaryColor1,
                ),
                _buildTableRow(
                  'No. of Installments',
                  '$selectedMonths months',
                  primaryColor1,
                ),
                _buildTableRow(
                  'Total Payment',
                  '₹${totalPayment.toStringAsFixed(0)}',
                  primaryColor1,
                ),
                _buildTableRow(
                  'Bonus Percentage',
                  '${bonusPercentage.toInt()}%',
                  primaryColor1,
                ),
                _buildTableRow(
                  'Bonus Amount',
                  '₹${bonusAmount.toStringAsFixed(0)}',
                  primaryColor1,
                ),
                _buildTableRow(
                  'Total Value',
                  '₹${finalAmount.toStringAsFixed(0)}',
                  primaryColor1,
                  isLast: true,
                  isHighlighted: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
              fontSize: 14,
            ),
          ),
          Text(
            'Amount',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(String label, String value, Color color,
      {bool isLast = false, bool isHighlighted = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
          Text(
            label,
            style: TextStyle(
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w500,
              color: Colors.grey[700],
              fontSize: isHighlighted ? 15 : 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: isHighlighted ? 16 : 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(double finalAmount) {
    return Container(
      width: double.infinity,
      height: 56,
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
            // Add your action here
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
              Icon(Icons.rocket_launch, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                'Start Investment Plan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
