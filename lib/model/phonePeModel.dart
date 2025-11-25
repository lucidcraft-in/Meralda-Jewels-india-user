import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentData {
  final String custId;
  final String custName;
  final double custPhone;
  final double amount;
  final double openingAmount; // ✅ new field
  final String note;
  final String merchantId;
  final String currency;
  final String status;
  final String invoiceNo;
  final String customerName;
  final String customerId;
  final String branch;
  final String branchName;
  final String staffId;
  final String staffName;
  final String schemeName;
  final DateTime date;
  final String transactionId;

  PaymentData({
    required this.custId,
    required this.custName,
    required this.custPhone,
    required this.amount,
    required this.openingAmount, // ✅ added to constructor
    required this.note,
    required this.merchantId,
    required this.currency,
    required this.status,
    required this.invoiceNo,
    required this.customerName,
    required this.customerId,
    required this.branch,
    required this.branchName,
    required this.staffId,
    required this.staffName,
    required this.schemeName,
    required this.date,
    this.transactionId = "",
  });

  /// Convert model to Firestore map
  Map<String, dynamic> toJson() {
    return {
      "custId": custId,
      "TransactionId": transactionId,
      "custName": custName,
      "custPhone": custPhone,
      "amount": amount,
      "openingAmount": openingAmount, // ✅ added here
      "note": note,
      "merchantId": merchantId,
      "currency": currency,
      "status": status,
      "invoiceNo": invoiceNo,
      "customerName": customerName,
      "customerId": customerId,
      "branch": branch,
      "branchName": branchName,
      "staffId": staffId,
      "staffName": staffName,
      "schemeName": schemeName,
      "date": Timestamp.fromDate(date),
    };
  }

  /// Create model from Firestore map
  factory PaymentData.fromJson(Map<String, dynamic> json) {
    return PaymentData(
      custId: json["custId"] ?? "",
      custName: json["custName"] ?? "",
      custPhone: (json["custPhone"] ?? 0).toDouble(),
      amount: (json["amount"] ?? 0).toDouble(),
      openingAmount: (json["openingAmount"] ?? 0).toDouble(), // ✅ added here
      note: json["note"] ?? "",
      merchantId: json["merchantId"] ?? "",
      currency: json["currency"] ?? "",
      status: json["status"] ?? "",
      invoiceNo: json["invoiceNo"] ?? "",
      customerName: json["customerName"] ?? "",
      customerId: json["customerId"] ?? "",
      branch: json["branch"] ?? "",
      branchName: json["branchName"] ?? "",
      staffId: json["staffId"] ?? "",
      staffName: json["staffName"] ?? "",
      schemeName: json["schemeName"] ?? "",
      date: (json["date"] as Timestamp).toDate(),
      transactionId: json["TransactionId"] ?? "",
    );
  }
}
