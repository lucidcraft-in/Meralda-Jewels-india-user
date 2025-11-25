import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meralda_gold_user/model/customerModel.dart';
import 'package:meralda_gold_user/providers/transaction.dart';

import '../model/phonePeModel.dart';

class phonePe_PaymentModel {
  String custId;
  String custName;
  double amount;
  String note;
  double custPhone;
  String merchantId;
  String currency;
  String status;

  phonePe_PaymentModel(
      {required this.custId,
      required this.amount,
      required this.note,
      required this.custName,
      required this.custPhone,
      required this.merchantId,
      required this.currency,
      required this.status});
  @override
  String toString() {
    return '''
phonePe_PaymentModel(
  merchantId: $merchantId,
  custId: $custId,
  custName: $custName,
  amount: $amount,
  note: $note,
  custPhone: $custPhone,
  currency: $currency,
  status: $status
)''';
  }

  Map<String, dynamic> toJson() {
    return {
      "merchantId": merchantId,
      "custId": custId,
      "custName": custName,
      "amount": amount,
      "note": note,
      "custPhone": custPhone,
      "currency": currency,
      "status": status,
    };
  }
}

class phonePe_Payment with ChangeNotifier {
  late FirebaseFirestore firestore;
  initiliase() {
    firestore = FirebaseFirestore.instance;
  }

  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('online_Transaction');
  String cmpnyCode = "MRLD";
  Future addTransaction(phonePe_PaymentModel paymentData,
      TransactionModel _transaction, SchemeUserModel user) async {
    DateTime now = DateTime.now();
    String id = "";
    // DocumentReference docRef = await collectionReference.add({
    //   "custId": paymentData.custId,
    //   "TransactionId": "",
    //   "custName": paymentData.custName,
    //   "amount": paymentData.amount,
    //   "note": paymentData.note,
    //   "date": now,
    //   "custPhone": paymentData.custPhone,
    //   "merchantId": paymentData.merchantId,
    //   "currency": paymentData.currency,
    //   "status": paymentData.status,
    //   "invoiceNo": _transaction.invoiceNo,
    //   "customerName": _transaction.customerName,
    //   "customerId": _transaction.custId,
    //   "branch": user.branch,
    //   "branchName": user.branchName,
    //   "staffId": user.staffId,
    //   "staffName": user.schemeType,
    // });

    final data = PaymentData(
        custId: paymentData.custId,
        custName: paymentData.custName,
        custPhone: paymentData.custPhone,
        amount: paymentData.amount,
        note: _transaction.note,
        merchantId: "MERCHANT123",
        currency: "INR",
        status: "PENDING",
        schemeName: user.schemeType,
        invoiceNo: _transaction.invoiceNo,
        customerName: _transaction.customerName,
        customerId: user.id!,
        branch: user.branch,
        branchName: user.branchName!,
        staffId: user.staffId,
        staffName: user.staffName!,
        date: DateTime.now(),
        openingAmount: user.openingAmount);
    DocumentReference docRef = await collectionReference.add(data.toJson());
    id = cmpnyCode + "_" + docRef.id.toUpperCase();
    docRef.update({
      "TransactionId": id,
    });
    return id;
  }

  updateTransaction(String orderId, String status) async {
    try {
      // Query the collection where 'orderId' matches the given value
      QuerySnapshot snapshot =
          await collectionReference // Replace with your collection name
              .where('TransactionId', isEqualTo: orderId)
              .limit(1) // Limit the result to 1 document
              .get();

      // Check if any document was found
      if (snapshot.docs.isNotEmpty) {
        // Return the document ID
        await collectionReference
            .doc(snapshot.docs.first.id)
            .update({"status": status});
      } else {
        // No document found
        return null;
      }
    } catch (e) {
      // print('Error fetching document: $e');
      return null;
    }
  }

  Future updatePaymentbyTransactionId(
      String id, String status, var data) async {
    var transaction =
        await collectionReference.where("TransactionId", isEqualTo: id).get();

    if (transaction.docs.isNotEmpty) {
      var docId = transaction.docs.first.id;

      await collectionReference
          .doc(docId)
          .update({"status": status, "payment_responce": data});
    }
    // print(querySnapshot.docs[0]);
    return;
  }
}
