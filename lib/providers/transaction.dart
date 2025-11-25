import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  final String id;
  final String customerName;
  final String customerId;
  final String custId; // ✅ newly added
  final DateTime date;
  final double amount;
  final int transactionType; // 0: receipt, 1: purchase
  final String note;
  final String invoiceNo;
  final String category;
  final double discount;
  final String staffId;
  final double gramPriceInvestDay;
  final double gramWeight;
  final String branch;
  final String branchName;
  final String staffName;
  final String merchentTransactionId;
  final String transactionMode;

  // ✅ newly added fields
  final DateTime maturityDate;
  final String schemeName;

  TransactionModel({
    required this.id,
    required this.customerName,
    required this.customerId,
    required this.custId, // ✅ required
    required this.date,
    required this.amount,
    required this.transactionType,
    required this.note,
    required this.invoiceNo,
    required this.category,
    required this.discount,
    required this.staffId,
    required this.gramPriceInvestDay,
    required this.gramWeight,
    required this.branch,
    required this.branchName,
    required this.staffName,
    required this.merchentTransactionId,
    required this.transactionMode,
    required this.maturityDate,
    required this.schemeName,
  });

  factory TransactionModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return TransactionModel(
      id: doc.id,
      customerName: data['customerName'] ?? '',
      customerId: data['customerId'] ?? '',
      custId: data['custId'] ?? '', // ✅ read from Firestore
      date: (data['date'] as Timestamp).toDate(),
      amount: (data['amount'] ?? 0).toDouble(),
      transactionType: data['transactionType'] ?? 0,
      note: data['note'] ?? '',
      invoiceNo: data['invoiceNo'] ?? '',
      category: data['category'] ?? '',
      discount: (data['discount'] ?? 0).toDouble(),
      staffId: data['staffId'] ?? '',
      gramPriceInvestDay: (data['gramPriceInvestDay'] ?? 0).toDouble(),
      gramWeight: (data['gramWeight'] ?? 0).toDouble(),
      branch: data['branch'] ?? '',
      branchName: data["branchName"] ?? '',
      staffName: data['staffName'] ?? '',
      merchentTransactionId: data['merchentTransactionId'] ?? '',
      transactionMode: data['transactionMode'] ?? '',
      maturityDate: data['maturityDate'] != null
          ? (data['maturityDate'] as Timestamp).toDate()
          : DateTime.now(),
      schemeName: data['schemeName'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'customerName': customerName,
      'customerId': customerId,
      'custId': custId, // ✅ store in Firestore
      'date': Timestamp.fromDate(date),
      'amount': amount,
      'transactionType': transactionType,
      'note': note,
      'invoiceNo': invoiceNo,
      'category': category,
      'discount': discount,
      'staffId': staffId,
      'gramPriceInvestDay': gramPriceInvestDay,
      'gramWeight': gramWeight,
      'branch': branch,
      "branchName": branchName,
      'staffName': staffName,
      'merchentTransactionId': merchentTransactionId,
      'transactionMode': transactionMode,
      'maturityDate': Timestamp.fromDate(maturityDate),
      'schemeName': schemeName,
    };
  }

  bool get isReceipt => transactionType == 0;
  bool get isPurchase => transactionType == 1;

  /// copyWith function to update only specific fields
  TransactionModel copyWith({
    String? id,
    String? customerName,
    String? customerId,
    String? custId, // ✅ copyWith
    DateTime? date,
    double? amount,
    int? transactionType,
    String? note,
    String? invoiceNo,
    String? category,
    double? discount,
    String? staffId,
    double? gramPriceInvestDay,
    double? gramWeight,
    String? branch,
    String? branchName,
    String? staffName,
    String? merchentTransactionId,
    String? transactionMode,
    DateTime? maturityDate,
    String? schemeName,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      customerId: customerId ?? this.customerId,
      custId: custId ?? this.custId, // ✅ keep
      date: date ?? this.date,
      amount: amount ?? this.amount,
      transactionType: transactionType ?? this.transactionType,
      note: note ?? this.note,
      invoiceNo: invoiceNo ?? this.invoiceNo,
      category: category ?? this.category,
      discount: discount ?? this.discount,
      staffId: staffId ?? this.staffId,
      gramPriceInvestDay: gramPriceInvestDay ?? this.gramPriceInvestDay,
      gramWeight: gramWeight ?? this.gramWeight,
      branch: branch ?? this.branch,
      branchName: branchName ?? this.branchName,
      staffName: staffName ?? this.staffName,
      merchentTransactionId:
          merchentTransactionId ?? this.merchentTransactionId,
      transactionMode: transactionMode ?? this.transactionMode,
      maturityDate: maturityDate ?? this.maturityDate,
      schemeName: schemeName ?? this.schemeName,
    );
  }
}

class TransactionProvider with ChangeNotifier {
  late FirebaseFirestore firestore;
  initiliase() {
    firestore = FirebaseFirestore.instance;
  }

  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('transactions');

  CollectionReference collectionReferenceUser =
      FirebaseFirestore.instance.collection('user');
  CollectionReference collectionReferenceSchemeUser =
      FirebaseFirestore.instance.collection('schemeusers');

  CollectionReference collectionReferenceGoldrate =
      FirebaseFirestore.instance.collection('goldrate');

  late List<TransactionModel> _transaction;
  double newbalance = 0;
  double oldBalance = 0;
  double gramWeight = 0;
  double gramTotalWeight = 0;
  double gramTotalWeightFinal = 0;
  int custBranch = 0;
  Future<void> create(TransactionModel transactionModel) async {
    // print("pro trans 1");
    QuerySnapshot querySnapshot;
    QuerySnapshot goldRate;
    QuerySnapshot transactionQuerySnapshot;
    List userlist = [];
    String? usrId = transactionModel.customerId;
    double averageRate = 0;
    double totalAverageRate = 0;
    try {
      querySnapshot = await collectionReferenceSchemeUser.get();
      goldRate = await collectionReferenceGoldrate.get();
      //  oldBalance = oldBal;

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs
            .where((element) => element.id.toString() == usrId.toString())
            .toList()) {
          oldBalance = doc["balance"].toDouble();
          gramTotalWeight = doc["total_gram"];
          custBranch = doc['branch'];
          if (doc["balance"] != 0) {
            averageRate = doc["balance"] / doc["total_gram"];
          }
        }
      }

      gramWeight = transactionModel.amount! / goldRate.docs[0]['gram'];

      double gramWeightFixed = double.parse(gramWeight.toStringAsFixed(4));

      // if (transactionModel.transactionType == 0) {
      newbalance = oldBalance + transactionModel.amount!;

      gramTotalWeightFinal = gramTotalWeight + gramWeight;

      double gramTotalWeightFinalFixed =
          double.parse(gramTotalWeightFinal.toStringAsFixed(4));

      await collectionReference.add({
        'customerName': transactionModel.customerName,
        'customerId': transactionModel.customerId,
        'custId': transactionModel.custId,
        'date': transactionModel.date,
        'amount': transactionModel.amount,
        'transactionType': transactionModel.transactionType,
        'note': transactionModel.note,
        'timestamp': FieldValue.serverTimestamp(),
        'invoiceNo': "",
        'category': "",
        'discount': 0,
        'staffId': "",
        'gramWeight': gramWeightFixed,
        'gramPriceInvestDay': goldRate.docs[0]['gram'],
        'branch': custBranch,
        "transactionMode": transactionModel.transactionMode,
        "merchentTransactionId": transactionModel.merchentTransactionId
      });
      await collectionReferenceUser.doc(transactionModel.customerId).update({
        'balance': newbalance,
        'total_gram': gramTotalWeightFinalFixed,
      });
      // print("pro trans 3");
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<List?> read(String id) async {
    QuerySnapshot querySnapshot;
    double purchaseAmt = 0;
    double reciptAmt = 0;
    double balance = 0;
    double purchasegram = 0;
    double reciptgram = 0;
    double balancegram = 0;
    List transactionList = [];

    try {
      querySnapshot = await collectionReference
          .where("customerId", isEqualTo: id)
          .orderBy("date", descending: true)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          Map a = {
            "id": doc.id,
            'customerName': doc['customerName'],
            'customerId': doc['customerId'],
            'date': doc['date'],
            'amount': doc['amount'],
            'transactionType': doc['transactionType'],
            'note': doc['note'],
            'invoiceNo': doc['invoiceNo'],
            'category': doc['category'],
            'discount': doc['discount'],
            'staffId': doc['staffId'],
            'gramWeight': doc['gramWeight'],
            'gramPriceInvestDay': doc['gramPriceInvestDay'],
            // 'branch': doc['branch'],
            'transactionMode': doc['transactionMode'],
            'merchentTransactionId': doc['merchentTransactionId']
          };
          transactionList.add(a);
          if (doc['transactionType'] == 1) {
            purchaseAmt = purchaseAmt + doc['amount'];
            purchasegram = purchasegram + doc['gramWeight'];
          } else {
            reciptAmt = reciptAmt + doc['amount'];
            reciptgram = reciptgram + doc['gramWeight'];
          }
        }
        balance = reciptAmt - purchaseAmt;
        balancegram = reciptgram - purchasegram;

        return [transactionList, balance, balancegram];
      }
      return [];
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future createDirect(
      TransactionModel transactionModel, double tax, double amc) async {
    QuerySnapshot querySnapshot;
    QuerySnapshot goldRate;

    String usrId = transactionModel.customerId;

    double averageRate = 0;
    double totalAverageRate = 0;
    try {
      querySnapshot = await collectionReferenceSchemeUser.get();
      goldRate = await collectionReferenceGoldrate.get();
      print("----- length --------");
      print(usrId);
      print(querySnapshot.docs.length);
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs
            .where((element) => element.id.toString() == usrId.toString())
            .toList()) {
          print("=== --- --- -- -- ====");
          print(doc);
          oldBalance = doc["balance"].toDouble();
          gramTotalWeight = doc["total_gram"];

          if (doc["balance"] != 0) {
            averageRate = doc["balance"] / doc["total_gram"];
          }
        }
      }

      // if (transactionModel.transactionType == 0) {
//       if (tax > 0 && amc > 0) {
// // find mc value
//         double mcValue = (transactionModel.gramPriceInvestDay * amc) / 100;
//         // print("---- mcValue");
//         // print(mcValue);
// // find Gram Included mc
//         double gramIncludedMc = transactionModel.gramPriceInvestDay + mcValue;
//         // print("---- gramIncludedMc");
//         // print(gramIncludedMc);
// // find Tax value
//         double taxValue = (gramIncludedMc * tax) / 100;
//         // print("---- taxValue");
//         // print(taxValue);
// // find gramwightPrice
//         double priceValue = taxValue + gramIncludedMc;
//         // print("---- priceValue");
//         // print(priceValue);
// // find gramwightPrice
//         gramWeight = transactionModel.amount / priceValue;
//         // print("---- gramWeight");
//         // print(gramWeight);
//         // gramWeight = (transactionModel.amount -
//         //         (transactionModel.amount * tax / 100) -
//         //         (transactionModel.amount * amc / 100)) /
//         //     transactionModel.gramPriceInvestDay;
//       } else {

      gramWeight =
          transactionModel.amount / transactionModel.gramPriceInvestDay;

      // }
      // } else {
      //   // gram weight for purchase

      //   if (averageRate != 0) {
      //     gramWeight = transactionModel.amount / averageRate;
      //   }
      // }
      num gramWeightFixed = num.parse(gramWeight.toStringAsFixed(4));

      // if (transactionModel.transactionType == 0) {

      newbalance = oldBalance + transactionModel.amount;

      // if (transactionModel.discount != 0) {
      //   newbalance = newbalance - transactionModel.discount;
      // }
      gramTotalWeightFinal = gramTotalWeight + gramWeight;

      // } else if (transactionModel.transactionType == 1) {
      //   newbalance = oldBalance - transactionModel.amount;
      //   gramTotalWeightFinal = gramTotalWeight - gramWeight;
      // }

      num gramTotalWeightFinalFixed =
          num.parse(gramTotalWeightFinal.toStringAsFixed(4));

      DocumentReference docRef = await collectionReference.add({
        'customerName': transactionModel.customerName,
        'customerId': transactionModel.customerId,
        'date': transactionModel.date,
        'amount': transactionModel.amount,
        'transactionType': transactionModel.transactionType,
        'note': transactionModel.note,
        'timestamp': FieldValue.serverTimestamp(),
        'invoiceNo': transactionModel.invoiceNo,
        'category': transactionModel.category,
        'discount': transactionModel.discount,
        'staffId': transactionModel.staffId,
        'gramWeight': gramWeightFixed,
        'gramPriceInvestDay': transactionModel.transactionType == 0
            ? transactionModel.gramPriceInvestDay
            : goldRate.docs[0]['gram'],
        'staffName': "",
        'transactionMode': "Direct",
        "merchentTransactionId": "",
        "currentBalance": newbalance,
        "currentBalanceGram": gramTotalWeightFinalFixed,
        "tax": tax,
        "amc": amc,
        "branch": transactionModel.branch,
        "branchName": transactionModel.branchName,
        "custId": transactionModel.custId,
        "maturityDate": transactionModel.maturityDate, // ✅ +1 year
        "schemeName": transactionModel.schemeName,
      });

      await collectionReferenceSchemeUser
          .doc(transactionModel.customerId)
          .update({
        'balance': newbalance,
        'total_gram': gramTotalWeightFinalFixed,
        'openingAmount': transactionModel.amount,
        "lastPaidDate": DateTime.now()
      });
      notifyListeners();

      String documentId = docRef.id;

      // Return the document ID

      notifyListeners();
      return [
        newbalance,
        gramWeightFixed,
        gramTotalWeightFinalFixed,
        documentId
      ];
    } catch (e) {
      print(e);
    }
  }

  Future<Map<String, dynamic>?> getTransactionById(String transId) async {
    try {
      final snapshot = await collectionReference
          .where('merchentTransactionId', isEqualTo: transId)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // ✅ Explicitly cast the document data to Map<String, dynamic>
        final data = snapshot.docs.first.data() as Map<String, dynamic>;
        return data;
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching transaction: $e');
      return null;
    }
  }
}
