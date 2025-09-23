import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/customerModel.dart';

class AccountProvider extends ChangeNotifier {
  double cashBalance = 0;
  double gramBalance = 0;
  double averagePrice = 6250.0;
  int selectedAccountIndex = 0;
  bool _isLoading = false;
  String? _errorMessage;

  // Getter for loading state
  bool get isLoading => _isLoading;

  // Getter for error message
  String? get errorMessage => _errorMessage;

  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('user');
  CollectionReference schemeUsersCollectionReference =
      FirebaseFirestore.instance.collection('schemeusers');

  List<SchemeUserModel> _accounts = [];
  List<SchemeUserModel> get accounts => _accounts; // ✅ public getter

  SchemeUserModel? get currentAccount =>
      _accounts.isNotEmpty ? _accounts[selectedAccountIndex] : null;

  /// ✅ Load accounts once using phone number
  Future<void> loadAccounts(String mobileNo) async {
    try {
      // Set loading state to true
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // final querySnapshot = await collectionReference
      //     .where("phone_no", isEqualTo: mobileNo)
      //     .get();

      // _accounts = querySnapshot.docs.map((doc) {
      //   return SchemeUserModel.fromData({
      //     "id": doc.id,
      //     ...doc.data() as Map<String, dynamic>,
      //   }, doc.id);
      // }).toList();

      //--------------------------
      print("--- ---- ------ ----");
      final schemeUsersSnapshot = await schemeUsersCollectionReference
          .where("phone_no", isEqualTo: mobileNo)
          .get();
      print(schemeUsersSnapshot.docs.length);
      // 🔹 Step 3: Map to model
      _accounts = schemeUsersSnapshot.docs.map((doc) {
        return SchemeUserModel.fromData(
          {
            "id": doc.id,
            ...doc.data() as Map<String, dynamic>,
          },
          doc.id,
        );
      }).toList();
      print("====================");
      print(_accounts);
      if (_accounts.isNotEmpty) {
        cashBalance = _accounts[0].balance?.toDouble() ?? 0.0;
        gramBalance = _accounts[0].totalGram?.toDouble() ?? 0.0;
        selectedAccountIndex = 0;
      }

      // Set loading state to false after successful load
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      // Set loading state to false and capture error
      _isLoading = false;
      _errorMessage = "Failed to load accounts: ${e.toString()}";
      debugPrint("Error loading accounts: $e");
      notifyListeners();
    }
  }

  /// ✅ Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// ✅ Switch active account
  void switchAccount(SchemeUserModel account, int index, BuildContext context) {
    selectedAccountIndex = index;
    cashBalance = account.balance?.toDouble() ?? 0.0;
    gramBalance = account.totalGram?.toDouble() ?? 0.0;

    final screenWidth = MediaQuery.of(context).size.width;
    final snackbarWidth = 400.0; // Fixed width for the snackbar

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          width: snackbarWidth,
          child: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 20,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Account Switched Successfully',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Now using: ${account.name}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          left: screenWidth - snackbarWidth - 32, // Position from right
          bottom: 16,
          right: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: Duration(seconds: 3),
      ),
    );

    notifyListeners();
  }
}
