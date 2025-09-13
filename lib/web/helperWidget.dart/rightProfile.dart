import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meralda_gold_user/model/customerModel.dart';
import 'package:meralda_gold_user/web/widgets/noSchemeWidget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/colo_extension.dart';
import '../../providers/account_provider.dart';
import '../../providers/transaction.dart';
import '../../providers/user.dart';

class rightPanalProfile extends StatefulWidget {
  rightPanalProfile({super.key, required this.user});
  SchemeUserModel user;

  @override
  State<rightPanalProfile> createState() => _rightPanalProfileState();
}

class _rightPanalProfileState extends State<rightPanalProfile>
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
    branch: 0,
    merchentTransactionId: "",
    transactionMode: 'Direct',
  );
  String selectedValue = 'Gold';
  @override
  void initState() {
    super.initState();
    getUserAccount(widget.user);
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
    print("----");
    _initializeData(activeAccount);
    getTransaction(activeAccount);
    // Future.microtask(() {
    //   if (widget.user.phoneNo != "") {
    //     context.read<AccountProvider>().loadAccounts(widget.user.phoneNo);
    //   }
    // });
  }

  void _initializeData(SchemeUserModel activeAccount) {
    setState(() {
      print("===============");
      print(activeAccount.openingAmount);
      amountCntrl.text = activeAccount.openingAmount.toString();
      taxCntrl.text = activeAccount.tax?.toString() ?? '0';
      amcCntrl.text = activeAccount.amc?.toString() ?? '0';
      grampPerdayController.text = '0.0';

      _transaction = TransactionModel(
        customerName: activeAccount.name,
        customerId: activeAccount.custId,
        date: DateTime.now(),
        amount: double.parse(amountCntrl.text),
        transactionType: 0,
        note: '',
        invoiceNo: '',
        category: selectedValue,
        discount: 0,
        staffId: '',
        gramPriceInvestDay: 0,
        gramWeight: 0,
        branch: 0,
        merchentTransactionId: "",
        transactionMode: 'Direct',
        id: '',
      );
    });
  }

  bool isTransaFirst = false;
  TransactionProvider? db;
  User? dbUser;
  List transactions = [];
  double cashBalance = 0;
  double gramBalance = 0;
  getTransaction(SchemeUserModel activeAccount) {
    db = TransactionProvider();
    dbUser = User();
    db!.initiliase();

    db!.read(activeAccount.custId).then((value) {
      if (value!.isEmpty) {
        setState(() => isTransaFirst = false);
      } else {
        setState(() {
          cashBalance = value[1];
          gramBalance = value[2];
          isTransaFirst = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accountProvider = context.watch<AccountProvider>();
    final accounts = accountProvider.accounts;

    final activeAccount = accounts.isNotEmpty
        ? accounts[accountProvider.selectedAccountIndex]
        : null;

    if (activeAccount == null) {
      // Show loader while activeAccount is not loaded
      return Container();
    }
    if (activeAccount.name == null || activeAccount.name.isEmpty) {
      return noSchemeSec();
    }
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
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

          SizedBox(height: 20),

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

                        // Amount Field
                        // _buildFormField(
                        //   user: activeAccount,
                        //   label: 'Payment Amount',
                        //   controller: amountCntrl,
                        //   isReadOnly: activeAccount.schemeType == "Wishlist",
                        //   keyboardType: TextInputType.number,
                        //   icon: Icons.currency_rupee,
                        //   isImportant: true,
                        // ),
                        TextFormField(
                          controller: amountCntrl
                            ..text = accountProvider
                                .currentAccount!.openingAmount
                                .toString(),
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
                                _isLoading ? null : _saveForm(activeAccount);
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
            readOnly: isTransaFirst || isReadOnly,
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
              onTap: () => _selectDate(context),
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
    print(activeAc);

    if (activeAc.status == CustomerStatus.created) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please wait for verification'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      print(userAccount);
      return;
    }
    if (activeAc.status == CustomerStatus.pending) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please wait for verification'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      print(userAccount);
      return;
    }
    if (activeAc.status == CustomerStatus.rejected) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Your account has rejected'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      print(userAccount);
      return;
    }
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all required fields correctly!'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      print(userAccount);
      return;
    }

    _formKey.currentState!.save();

    if (activeAc.schemeType != "Wishlist" &&
        double.parse(amountCntrl.text) < 2000) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Minimum amount required is 2000 for this scheme'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
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
}
