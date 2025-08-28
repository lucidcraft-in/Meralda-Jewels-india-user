import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/customerModel.dart';

class AccountProvider extends ChangeNotifier {
  double cashBalance = 0;
  double gramBalance = 0;
  double averagePrice = 6250.0;
  int selectedAccountIndex = 0;

  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('user');

  List<UserModel> _accounts = [];
  List<UserModel> get accounts => _accounts; // ✅ public getter

  UserModel? get currentAccount =>
      _accounts.isNotEmpty ? _accounts[selectedAccountIndex] : null;

  /// ✅ Load accounts once using phone number
  Future<void> loadAccounts(String mobileNo) async {
    try {
      final querySnapshot = await collectionReference
          .where("phone_no", isEqualTo: mobileNo)
          .get();

      _accounts = querySnapshot.docs.map((doc) {
        return UserModel.fromData({
          "id": doc.id,
          ...doc.data() as Map<String, dynamic>,
        }, doc.id);
      }).toList();

      if (_accounts.isNotEmpty) {
        cashBalance = _accounts[0].balance?.toDouble() ?? 0.0;
        gramBalance = _accounts[0].totalGram?.toDouble() ?? 0.0;
        selectedAccountIndex = 0;
      }

      notifyListeners();
    } catch (e) {
      debugPrint("Error loading accounts: $e");
    }
  }

  /// ✅ Switch active account
  void switchAccount(UserModel account, int index, BuildContext context) {
    selectedAccountIndex = index;
    cashBalance = account.balance?.toDouble() ?? 0.0;
    gramBalance = account.totalGram?.toDouble() ?? 0.0;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
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
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: Duration(seconds: 3),
      ),
    );

    notifyListeners();
  }
}
