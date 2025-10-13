import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:meralda_gold_user/model/customerModel.dart';
import 'package:meralda_gold_user/web/widgets/noSchemeWidget.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/colo_extension.dart';
import '../../functions/SHA256.dart';
import '../../functions/base64.dart';
import '../../providers/account_provider.dart';
import '../../providers/goldrate.dart';

import '../../providers/phonePe_payment.dart';
import '../../providers/transaction.dart';
import '../../providers/user.dart';
import '../../screens/paymentResponseScreen.dart';
import '../apiService/phonepeAuth.dart';
import '../webPayScreen.dart';

class RightPanalProfile extends StatefulWidget {
  RightPanalProfile({super.key, required this.user});
  SchemeUserModel user;

  @override
  State<RightPanalProfile> createState() => _rightPanalProfileState();
}

class _rightPanalProfileState extends State<RightPanalProfile>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final _formKey = GlobalKey<FormState>();
  // Controllers
  TextEditingController taxCntrl = TextEditingController();
  TextEditingController amcCntrl = TextEditingController();
  TextEditingController amountCntrl = TextEditingController();
  TextEditingController grampPerdayController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool _isLoading = false;
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
      branch: "",
      branchName: "",
      staffName: "",
      merchentTransactionId: "",
      transactionMode: 'Direct',
      custId: "",
      schemeName: "",
      maturityDate: DateTime.now());
  String selectedValue = 'Gold';
  @override
  void initState() {
    super.initState();
    _initData();

    if (widget.user != null) {
      getUserAccount(widget.user);
    }
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

    _animationController.forward();
  }

  List<SchemeUserModel> userAccount = [];
  getUserAccount(SchemeUserModel activeAccount) async {
    // final accountProvider = context.read<AccountProvider>();
    // setState(() {
    //   amountCntrl.text =
    //       accountProvider.currentAccount?.openingAmount.toString() ?? '2000';
    // });
    // Future.microtask(() {
    //   if (widget.user.phoneNo != "") {
    //     context.read<AccountProvider>().loadAccounts(widget.user.phoneNo);
    //   }
    // });
  }

  late double grampPerdayAmount;
  Future<void> _initData() async {
    final dbGoldrate = Goldrate();
    await dbGoldrate.initiliase();
    final goldRates = await dbGoldrate.read();
    setState(() {
      var gramValue = goldRates![0]['gram'];
      grampPerdayAmount = double.parse(gramValue.toString());
      grampPerdayController.text = grampPerdayAmount.toString();
    });

    // _collection = CollectionModel(
    //   staffId: staffData['id'],
    //   staffname: staffData['staffName'],
    //   receivedAmount: 0,
    //   paidAmount: 0,
    //   balance: 0,
    //   date: selectedDate,
    //   type: 0,
    //   branch: branchId,
    // );
  }

  bool isTransaFirst = false;
  TransactionProvider? db;
  User? dbUser;
  List transactions = [];
  double cashBalance = 0;
  double gramBalance = 0;
  Future<List> getTransaction(SchemeUserModel activeAccount) async {
    db = TransactionProvider();
    dbUser = User();
    db!.initiliase();

    final value = await db!.read(activeAccount.id!);

    if (value == null || value.isEmpty) {
      setState(() => isTransaFirst = false);
      return [];
    } else {
      setState(() {
        transactions = value[0] ?? [];
        cashBalance = value[1];
        gramBalance = value[2];
        isTransaFirst = true;
      });
      return transactions;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildQuickAmountCards(double openingAmount) {
    final List<int> quickMultipliers = [1, 2, 3, 6, 11];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Quick Amount Options",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
          ),
        ),
        SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: quickMultipliers.map((multiplier) {
            double total = openingAmount * multiplier;
            return GestureDetector(
              onTap: () {
                print("-----");
                setState(() {
                  amountCntrl.text = total.toStringAsFixed(2);
                  isAmountInitialized = true;
                });
                print(amountCntrl.text);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300, width: 1.5),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 3,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${multiplier}x",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "₹${total.toStringAsFixed(0)}",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildInstallmentProgressCards() {
    final accountProvider = context.read<AccountProvider>();
    final currentAccount = accountProvider.currentAccount!;

    // Calculate completed installments
    double balance = currentAccount.balance;
    double openingAmount = currentAccount.openingAmount;
    int completedInstallments =
        balance > 0 ? (balance / openingAmount).floor() : 0;
    int totalInstallments = 11;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Installment Progress',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            Text(
              '$completedInstallments/$totalInstallments completed',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        SizedBox(height: 12),

        // Installment Cards
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(11, (index) {
              bool isCompleted = index < completedInstallments;
              bool isCurrent = index == completedInstallments;

              return Container(
                width: 60,
                margin: EdgeInsets.only(right: 8),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isCompleted
                      ? Colors.green.shade50
                      : isCurrent
                          ? Colors.blue.shade50
                          : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isCompleted
                        ? Colors.green.shade300
                        : isCurrent
                            ? Colors.blue.shade300
                            : Colors.grey.shade300,
                    width: isCurrent ? 2 : 1,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isCompleted
                            ? Colors.green.shade800
                            : isCurrent
                                ? Colors.blue.shade800
                                : Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Icon(
                      isCompleted ? Icons.check_circle : Icons.circle,
                      size: 12,
                      color: isCompleted
                          ? Colors.green.shade600
                          : isCurrent
                              ? Colors.blue.shade600
                              : Colors.grey.shade400,
                    ),
                  ],
                ),
              );
            }),
          ),
        ),

        // Progress Bar
        SizedBox(height: 12),
        Container(
          height: 6,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(3),
          ),
          child: Stack(
            children: [
              Container(
                width: (completedInstallments / totalInstallments) *
                    MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: completedInstallments == totalInstallments
                      ? Colors.green.shade500
                      : Colors.blue.shade500,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ],
          ),
        ),

        // Status Text
        SizedBox(height: 8),
        Text(
          completedInstallments == totalInstallments
              ? '✅ All installments completed!'
              : '${totalInstallments - completedInstallments} installments remaining',
          style: TextStyle(
            fontSize: 12,
            color: completedInstallments == totalInstallments
                ? Colors.green.shade700
                : Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final accountProvider = context.watch<AccountProvider>();
    final accounts = accountProvider.accounts;
    print(accountProvider.currentAccount!.openingAmount);
    final activeAccount = accounts.isNotEmpty
        ? accounts[accountProvider.selectedAccountIndex]
        : null;

    if (!isAmountInitialized) {
      final openingAmount = accountProvider.currentAccount!.openingAmount;
      amountCntrl.text = openingAmount.toString();
    }
    if (activeAccount == null) {
      // Show loader while activeAccount is not loaded
      return Container();
    }
    if (widget.user == null) {
      return noSchemeSec();
    }
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: TColo.primaryColor1.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.payment,
                      color: TColo.primaryColor1,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Payment Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () async {
                  final txns = await getTransaction(activeAccount);
                  if (txns.isNotEmpty) {
                    _showHistoryDialog(context, activeAccount, txns);
                  } else {
                    // optional: show snackbar or empty state
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("No transactions found")),
                    );
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: TColo.primaryColor1.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.history,
                    color: TColo.primaryColor1,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 20),
          _buildInstallmentProgressCards(),

          SizedBox(height: 24),
          // Form Card
          Expanded(
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white,
                      Colors.grey.shade50,
                    ],
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Form Header
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: TColo.primaryColor1.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: TColo.primaryColor1.withOpacity(0.1),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.edit_outlined,
                                color: TColo.primaryColor1,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Enter Payment Information',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: TColo.primaryColor1,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 24),

                        TextFormField(
                          controller: amountCntrl,
                          readOnly: activeAccount.balance > 0 ? true : false,
                          // ..text = accountProvider
                          //     .currentAccount!.openingAmount
                          //     .toString(),
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Payment Amount",
                            prefixIcon: Icon(Icons.currency_rupee),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          // onChanged: (val) {
                          //   double parsed = double.tryParse(val) ?? 0.0;
                          //   accountProvider.updateAmount(parsed);
                          // },
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Enter amount';
                            }
                            return null;
                          },
                        ),
                        if (accountProvider.currentAccount!.balance != 0)
                          SizedBox(height: 12),
                        if (accountProvider.currentAccount!.balance != 0)
                          _buildQuickAmountCards(
                              accountProvider.currentAccount!.openingAmount),

                        SizedBox(height: 20),
                        if (accountProvider.currentAccount!.schemeType ==
                            "Wishlist")
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(6),
                                border:
                                    Border.all(color: Colors.orange.shade200),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.info_outline,
                                      size: 14, color: Colors.orange.shade600),
                                  SizedBox(width: 4),
                                  Text(
                                    "Fixed amount: ₹2000 for Wishlist scheme",
                                    style: TextStyle(
                                        color: Colors.orange.shade700,
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (accountProvider.currentAccount!.schemeType !=
                            "Wishlist")
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Colors.blue.shade200),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.info_outline,
                                      size: 14, color: Colors.blue.shade600),
                                  SizedBox(width: 4),
                                  Text(
                                    "Minimum amount: ₹2000",
                                    style: TextStyle(
                                        color: Colors.blue.shade700,
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        SizedBox(height: 20),

                        // Description Field
                        _buildFormField(
                          user: activeAccount,
                          label: 'Description',
                          controller: descriptionController,
                          icon: Icons.description_outlined,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter description';
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 20),

                        // Gram Rate Field
                        _buildFormField(
                          user: activeAccount,
                          label: 'Gram Rate',
                          controller: grampPerdayController,
                          isReadOnly: false,
                          keyboardType: TextInputType.number,
                          icon: Icons.scale,
                        ),

                        SizedBox(height: 20),

                        // Date Field
                        _buildDateField(),

                        SizedBox(height: 32),

                        // Submit Button
                        Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            color: TColo.primaryColor1,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                _isLoading
                                    ? null
                                    :
                                    // : tokenGenarate(
                                    //     amountCntrl.text,
                                    //     descriptionController.text,
                                    //     activeAccount);
                                    _saveForm(activeAccount);
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                alignment: Alignment.center,
                                child: _isLoading
                                    ? SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.check_circle_outline,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'Process Payment',
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
                          ),
                        ),

                        SizedBox(height: 16),

                        // Security Notice
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.green.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.security,
                                size: 16,
                                color: Colors.green.shade600,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Your payment is secured with 256-bit encryption',
                                  style: TextStyle(
                                    color: Colors.green.shade700,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required SchemeUserModel user,
    required String label,
    required TextEditingController controller,
    bool isRequired = true,
    bool isReadOnly = false,
    TextInputType keyboardType = TextInputType.text,
    String? hintText,
    IconData? icon,
    bool isImportant = false,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18, color: TColo.primaryColor1),
              SizedBox(width: 8),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            if (isImportant) ...[
              SizedBox(width: 4),
              Text('*', style: TextStyle(color: Colors.red, fontSize: 16)),
            ],
          ],
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            readOnly: isTransaFirst || isReadOnly || label == "Gram Rate",
            keyboardType: keyboardType,
            style: TextStyle(fontSize: 16),
            decoration: InputDecoration(
              hintText: hintText ?? 'Enter $label',
              filled: true,
              fillColor:
                  isTransaFirst || isReadOnly ? Colors.grey[100] : Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: TColo.primaryColor1, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.red, width: 1),
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            onSaved: (val) {},
            validator: validator ??
                (isRequired
                    ? (value) =>
                        value?.isEmpty ?? true ? '$label is required' : null
                    : null),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField() {
    final accountProvider = Provider.of<User>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.calendar_today, size: 18, color: TColo.primaryColor1),
            SizedBox(width: 8),
            Text(
              'Payment Date',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(width: 4),
            Text('*', style: TextStyle(color: Colors.red, fontSize: 16)),
          ],
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              // onTap: () => _selectDate(context),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today_outlined,
                        size: 20, color: Colors.grey[600]),
                    SizedBox(width: 12),
                    Text(
                      selectedDate == null
                          ? DateFormat('MMM dd, yyyy').format(now)
                          : DateFormat('MMM dd, yyyy').format(selectedDate!),
                      style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                    ),
                    Spacer(),
                    Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  DateTime? selectedDate;
  DateTime now = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _saveForm(SchemeUserModel activeAc) async {
    // Auto-generate invoice number
    String invoiceNo = "ONLN${DateTime.now().millisecondsSinceEpoch}";

    _transaction = _transaction.copyWith(
      invoiceNo: invoiceNo, // ✅ Auto-generated
      merchentTransactionId: "",
      customerName: widget.user.name,
      customerId: widget.user.id!,
      date: DateTime.now(),
      note: descriptionController.text,
      transactionMode: 'online',
      gramPriceInvestDay: grampPerdayAmount,
      amount: double.parse(amountCntrl.text),
      branch: activeAc.branch,
      branchName: activeAc.branchName,
      staffId: activeAc.staffId,
      staffName: activeAc.staffName,
      custId: widget.user.custId,
      maturityDate: DateTime.now().add(const Duration(days: 365)), // +1 year
      schemeName: widget.user.schemeType,
    );

    if (activeAc.status == CustomerStatus.pending) {
      _showRightSnackBar(context, 'Please wait for verification', Colors.red);
      return;
    }

    if (activeAc.status == CustomerStatus.rejected) {
      _showRightSnackBar(context, 'Your account has been rejected', Colors.red);
      return;
    }

    if (!_formKey.currentState!.validate()) {
      _showRightSnackBar(
          context, 'Please fill all required fields correctly!', Colors.red);
      return;
    }

    _formKey.currentState!.save();

    if (activeAc.schemeType != "Wishlist" &&
        double.parse(amountCntrl.text) < 2000) {
      _showRightSnackBar(context,
          'Minimum amount required is 2000 for this scheme', Colors.red);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final transactionProvider =
          Provider.of<TransactionProvider>(context, listen: false);
      final data = await transactionProvider.createDirect(_transaction, 0, 0);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text("Payment recorded successfully!"),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );

      Navigator.of(context).pop(true);
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving payment: $err'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showRightSnackBar(
      BuildContext context, String message, Color backgroundColor) {
    final screenWidth = MediaQuery.of(context).size.width;
    final snackbarWidth = 400.0; // Fixed width for the snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          width: snackbarWidth,
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(message),
          ),
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.7,
            bottom: 16,
            right: 16),
      ),
    );
  }

  void _showHistoryDialog(
      BuildContext context, SchemeUserModel user, List txn) {
    // print(transactions);

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          alignment: Alignment.centerRight,
          insetPadding:
              EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.2),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width * 0.5,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: TColo.primaryColor1.withOpacity(0.1),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.history,
                        color: TColo.primaryColor1,
                        size: 28,
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Payment History',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: TColo.primaryColor1,
                        ),
                      ),
                      Spacer(),
                      if (txn.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: TColo.primaryColor1.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${txn.length} transactions',
                            style: TextStyle(
                              color: TColo.primaryColor1,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(
                          Icons.close,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                // Content

                Expanded(
                  child: txn.isNotEmpty
                      ? ListView.builder(
                          padding: EdgeInsets.all(16),
                          itemCount: txn.length,
                          itemBuilder: (context, index) {
                            final tx = txn[index];
                            final DateTime dateTime =
                                (tx["date"] as Timestamp).toDate();
                            return Container(
                              margin: EdgeInsets.only(bottom: 12),
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey[200]!,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: tx["transactionType"] == 0
                                          ? Colors.green
                                          : Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          tx["note"],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.grey[800],
                                          ),
                                        ),
                                        Text(
                                          "Invoice No : ${tx["invoiceNo"]}",
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Text(
                                              'Amount :',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 14,
                                              ),
                                            ),
                                            Text(
                                              '₹ ${tx["amount"]}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey[600],
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          'Date: ${dateTime.toLocal().toString().split(" ")[0]}',
                                          style: TextStyle(
                                            color: Colors.grey[500],
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: (tx["transactionType"] == 0
                                              ? Colors.green
                                              : Colors.red)
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      tx["transactionType"] == 0
                                          ? 'Recieved'
                                          : 'Purchased',
                                      style: TextStyle(
                                        color: tx["transactionType"] == 0
                                            ? Colors.green
                                            : Colors.red,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      : Container(
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
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String environment = "PRODUCTION";
  String merchantId = "M23L8P15TXS00";
  tokenGenarate(String amt, String note, SchemeUserModel user) async {
    var amount = double.parse(amt);
    print(user.custId);
    print(amount);
    try {
      print("======");
      var data = phonePe_PaymentModel(
          merchantId: merchantId,
          custId: user.custId,
          custName: user.name,
          amount: amount,
          note: note,
          custPhone: double.parse(user.phoneNo),
          currency: "INR",
          status: "Initaiated");
      print("---- --");
      print(data.toJson());
      firebaseInsert(data, user);
    } catch (e) {
      print('An error occurred: $e');
      setState(() {
        _isLoading = false;
      });
    }
    // firebaseInsert(data);
  }

  String transactionId = "";
  firebaseInsert(phonePe_PaymentModel data, SchemeUserModel user) {
    print(data.toJson());
    var db = phonePe_Payment();
    db.initiliase();
    db.addTransaction(data).then((value) {
      print("----payment data ----");
      setState(() {
        transactionId = value.toUpperCase();
      });
      print("----- Firebase insert ----------");
      print(transactionId);
      if (transactionId != "") {
        getchecksum(transactionId, user);
      } else {
        // print("----- Firebase insert error----------");
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  String checksum = "";
  String saltKey = "7e700076-d1da-48a3-b728-c9c318cceca2";
  String saltIndex = "1";
  String body = "";
  getchecksum(String transId, SchemeUserModel user) {
    final reqData = {
      "merchantId": merchantId,
      "merchantTransactionId": transId,
      "merchantUserId": user.custId,
      "amount": num.parse("1") * 100,
      "mobileNumber": double.parse(user.phoneNo),
      "callbackUrl":
          "https://us-central1-malabari-jewellery.cloudfunctions.net/app/api/create",
      "paymentInstrument": {
        "type": "PAY_PAGE",
      },
    };
    try {
      setState(() {
        String base64 = encodeJsonToBase64(reqData);
        String input = base64 + "/pg/v1/pay" + saltKey;
        checksum = "${convertToSHA256(input)}###${saltIndex}";
        body = base64;
      });
      startTransaction(user, transId);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String callbackUrl =
      "https://us-central1-malabari-jewellery.cloudfunctions.net/app/api/create";
  Object? result;
  String packageName = "com.example.malabari_jewellery";
  // void startTransaction(SchemeUserModel user, String transId) async {
  //   try {
  //     print("=======");

  //     final data = await PhonePePaymentSdk.startTransaction(
  //             body, callbackUrl, checksum, packageName)
  //         .then((response) {
  //       setState(() {
  //         print("===== ===");
  //         print(response);
  //         if (response != null) {
  //           String status = response['status'].toString();
  //           String error = response['error'].toString();
  //           print(status);
  //           print(error);
  //           setState(() {
  //             _isLoading = false;
  //           });
  //           if (status == 'SUCCESS') {
  //             result = "Flow Completed - Status: Success!";
  //             isSuccess(user, transId);
  //           } else {
  //             isfaild(transId);
  //             result = "Flow Completed - Status: $status and Error: $error";
  //           }
  //         } else {
  //           print("------ ++++++++");
  //           print(response);
  //           result = "Flow Incomplete";
  //         }
  //       });
  //     }).catchError((error) {
  //       return <dynamic>{};
  //     });

  //     print("===   =====");
  //     print(data);
  //   } catch (error) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //     print(error);
  //   }
  // }

  void startTransaction(SchemeUserModel user, String transId) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final authToken = await generateAuthToken();
      if (authToken == null) {
        result = "Failed to get auth token";
        return;
      }
      await createPayment(authToken, transId);
    } catch (e) {
      print(e);
    }
    // try {
    //   print("======= Starting PhonePe Transaction =======");

    //   final response = await PhonePePaymentSdk.startTransaction(
    //     body,
    //     callbackUrl,
    //     checksum,
    //     packageName,
    //   ).catchError((error) {
    //     // Ensure same type is returned
    //     print("Transaction error (catchError): $error");
    //     return <String, dynamic>{
    //       'status': 'FAILED',
    //       'error': error.toString(),
    //     };
    //   });

    //   print("===== Transaction Response =====");
    //   print(response);

    //   if (response != null) {
    //     final status = response['status']?.toString() ?? "UNKNOWN";
    //     final error = response['error']?.toString() ?? "NONE";

    //     print("Status: $status");
    //     print("Error: $error");

    //     if (status == 'SUCCESS') {
    //       result = "Flow Completed - Status: Success!";
    //       isSuccess(user, transId);
    //     } else {
    //       result = "Flow Completed - Status: $status and Error: $error";
    //       isfaild(transId);
    //     }
    //   } else {
    //     print("------ Response is NULL ------");
    //     result = "Flow Incomplete";
    //   }
    // } catch (e) {
    //   print("Exception in startTransaction: $e");
    //   result = "Exception occurred: $e";
    // } finally {
    //   setState(() {
    //     _isLoading = false;
    //   });
    // }
  }

  isfaild(String transId) {
    var res = {
      "code": "Failed",
      "amount": amountCntrl.text,
      "type": "online",
      "transactionId": transId
    };
    var db = phonePe_Payment();
    db.initiliase();
    db.updateTransaction(transId, "PAYMENT_ERROR");
    QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Oops...',
        text: 'Sorry, Payment Failed',
        confirmBtnColor: Theme.of(context).primaryColor,
        confirmBtnTextStyle: TextStyle(
            fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold),
        onConfirmBtnTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResponseScreen(
                response: res,
              ),
            ),
          );
        });
  }

  isSuccess(SchemeUserModel user, String transId) {
    var res = {
      "code": "PAYMENT_SUCCESS",
      "amount": amountCntrl.text,
      "type": "online",
      "transactionId": transId
    };
    var db = phonePe_Payment();
    db.initiliase();
    db.updateTransaction(transId, "PAYMENT_SUCCESS");
    _saveForm(
      user,
    );
    QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: 'Transaction Completed Successfully!',
        confirmBtnColor: Theme.of(context).primaryColor,
        confirmBtnTextStyle: TextStyle(
            fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold),
        onConfirmBtnTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResponseScreen(
                response: res,
              ),
            ),
          );
        });
  }
}
