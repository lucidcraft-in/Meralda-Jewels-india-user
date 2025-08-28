import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class TransactionModel {
  final String id;
  final String customerName;
  final String customerId;
  final DateTime date;
  final double amount;
  final int transactionType;
  final String note;
  final String invoiceNo;
  final String category;
  final double discount;
  final String staffId;
  final double gramPriceInvestDay;
  final double gramWeight;
  final int branch;

  final merchentTransactionId; //
  final String transactionMode;

  TransactionModel({
    required this.id,
    required this.customerName,
    required this.customerId,
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
    required this.merchentTransactionId,
    required this.transactionMode,
  });
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
      querySnapshot = await collectionReferenceUser.get();
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

      if (transactionModel.transactionType == 0) {
        // gram wait for recieve
        gramWeight = transactionModel.amount! / goldRate.docs[0]['gram'];
      } else {
        // gram weight for purchase
        transactionQuerySnapshot = await collectionReference
            .orderBy('timestamp', descending: true)
            .get();

        if (averageRate != 0) {
          gramWeight = transactionModel.amount! / averageRate;
        }
      }
      double gramWeightFixed = double.parse(gramWeight.toStringAsFixed(4));

      if (transactionModel.transactionType == 0) {
        newbalance = oldBalance + transactionModel.amount!;

        gramTotalWeightFinal = gramTotalWeight + gramWeight;
      } else if (transactionModel.transactionType == 1) {
        newbalance = oldBalance - transactionModel.amount!;
        gramTotalWeightFinal = gramTotalWeight - gramWeight;
      }

      double gramTotalWeightFinalFixed =
          double.parse(gramTotalWeightFinal.toStringAsFixed(4));

      await collectionReference.add({
        'customerName': transactionModel.customerName,
        'customerId': transactionModel.customerId,
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
      querySnapshot = await collectionReferenceUser.get();
      goldRate = await collectionReferenceGoldrate.get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs
            .where((element) => element.id.toString() == usrId.toString())
            .toList()) {
          oldBalance = doc["balance"].toDouble();
          gramTotalWeight = doc["total_gram"];

          if (doc["balance"] != 0) {
            averageRate = doc["balance"] / doc["total_gram"];
          }
        }
      }

      if (transactionModel.transactionType == 0) {
        if (tax > 0 && amc > 0) {
// find mc value
          double mcValue = (transactionModel.gramPriceInvestDay * amc) / 100;
          // print("---- mcValue");
          // print(mcValue);
// find Gram Included mc
          double gramIncludedMc = transactionModel.gramPriceInvestDay + mcValue;
          // print("---- gramIncludedMc");
          // print(gramIncludedMc);
// find Tax value
          double taxValue = (gramIncludedMc * tax) / 100;
          // print("---- taxValue");
          // print(taxValue);
// find gramwightPrice
          double priceValue = taxValue + gramIncludedMc;
          // print("---- priceValue");
          // print(priceValue);
// find gramwightPrice
          gramWeight = transactionModel.amount / priceValue;
          // print("---- gramWeight");
          // print(gramWeight);
          // gramWeight = (transactionModel.amount -
          //         (transactionModel.amount * tax / 100) -
          //         (transactionModel.amount * amc / 100)) /
          //     transactionModel.gramPriceInvestDay;
        } else {
          gramWeight =
              transactionModel.amount / transactionModel.gramPriceInvestDay;
        }
      } else {
        // gram weight for purchase

        if (averageRate != 0) {
          gramWeight = transactionModel.amount / averageRate;
        }
      }
      num gramWeightFixed = num.parse(gramWeight.toStringAsFixed(4));
      print("---------- gramWeightFixed");
      print(gramWeightFixed);
      if (transactionModel.transactionType == 0) {
        newbalance = oldBalance + transactionModel.amount;
        if (transactionModel.discount != 0) {
          newbalance = newbalance - transactionModel.discount;
        }
        gramTotalWeightFinal = gramTotalWeight + gramWeight;
      } else if (transactionModel.transactionType == 1) {
        newbalance = oldBalance - transactionModel.amount;
        gramTotalWeightFinal = gramTotalWeight - gramWeight;
      }

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
        "amc": amc
      });
      await collectionReferenceUser.doc(transactionModel.customerId).update({
        'balance': newbalance,
        'total_gram': gramTotalWeightFinalFixed,
        'openingAmount': transactionModel.amount
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
}
