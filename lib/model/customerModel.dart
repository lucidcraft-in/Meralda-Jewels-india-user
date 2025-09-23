import 'package:cloud_firestore/cloud_firestore.dart';

/// 🔹 Simple Customer Status Flow
/// Created → Pending → Approved/Rejected
enum CustomerStatus { pending, approved, rejected }

class SchemeUserModel {
  final String? id;
  final String name;
  final String custId;

  final String phoneNo;
  final String address;
  final String place;
  final double balance;
  final double openingAmount;
  final String staffId;
  final String token;
  final String schemeType;
  final double totalGram;
  final String branch;
  final String? branchName;
  final DateTime dateofBirth;
  final String nominee;
  final String nomineePhone;
  final String? nomineeRelation;
  final String adharCard;
  final String? panCard;
  final String? pinCode;
  final String? staffName;
  final String? mailId;
  final double? tax;
  final double? amc;
  final String? country;
  final String? aadharFrontUrl;
  final String? aadharBackUrl;
  final String? panCardUrl;
  final String? password;
  final DateTime createdDate;
  final DateTime updatedDate;
  final CustomerStatus status;

  SchemeUserModel({
    this.id,
    required this.name,
    required this.custId,
    required this.phoneNo,
    required this.address,
    required this.place,
    required this.balance,
    required this.openingAmount,
    required this.staffId,
    required this.token,
    required this.schemeType,
    required this.totalGram,
    required this.branch,
    this.branchName,
    required this.dateofBirth,
    required this.nominee,
    required this.nomineePhone,
    this.nomineeRelation,
    required this.adharCard,
    this.panCard,
    this.pinCode,
    this.staffName,
    this.mailId,
    this.tax,
    this.amc,
    this.country,
    this.aadharFrontUrl,
    this.aadharBackUrl,
    this.panCardUrl,
    this.password,
    required this.createdDate,
    required this.updatedDate,
    this.status = CustomerStatus.pending,
  });

  SchemeUserModel.fromData(Map<String, dynamic> data, String documentId)
      : id = documentId,
        name = data['name']?.toString() ?? "",
        custId = data['custId']?.toString() ?? "",
        phoneNo = data['phone_no']?.toString() ?? "",
        address = data['address']?.toString() ?? "",
        place = data['place']?.toString() ?? "",
        balance = _parseDouble(data['balance']),
        openingAmount = _parseDouble(data['openingAmount']),
        staffId = data['staffId']?.toString() ?? "",
        token = data['token']?.toString() ?? "",
        schemeType = data['schemeType']?.toString() ?? "",
        totalGram = _parseDouble(data['total_gram']),
        branch = data['branch']?.toString() ?? "",
        branchName = data['branchName']?.toString(),
        dateofBirth = _parseDateTime(data['dateofBirth']),
        nominee = data['nominee']?.toString() ?? "",
        nomineePhone = data['nomineePhone']?.toString() ?? "",
        nomineeRelation = data['nomineeRelation']?.toString(),
        adharCard = data['adharCard']?.toString() ?? "",
        panCard = data['panCard']?.toString(),
        pinCode = data['pinCode']?.toString(),
        staffName = data['staffName']?.toString(),
        mailId = data['mailId']?.toString(),
        amc = _parseDouble(data['amc']),
        tax = _parseDouble(data['tax']),
        country = data['country']?.toString(),
        aadharFrontUrl = data['aadharFrontUrl']?.toString(),
        aadharBackUrl = data['aadharBackUrl']?.toString(),
        panCardUrl = data['panCardUrl']?.toString(),
        password = data['password']?.toString(),
        createdDate = _parseDateTime(data['createdDate']),
        updatedDate = _parseDateTime(data['updatedDate']),
        status = statusFromString(data['status']?.toString() ?? "created");

// Helper methods for safe parsing
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    if (value is DateTime) return value;
    return DateTime.now();
  }

  /// 🔥 For Firestore - uses Timestamp objects
  Map<String, dynamic> toFirestoreMap() {
    return {
      'name': name,
      'custId': custId,
      'phone_no': phoneNo,
      'address': address,
      'place': place,
      'balance': balance,
      'openingAmount': openingAmount,
      'staffId': staffId,
      'token': token,
      'schemeType': schemeType,
      'total_gram': totalGram,
      'branch': branch,
      'branchName': branchName,
      'dateofBirth': Timestamp.fromDate(dateofBirth),
      'nominee': nominee,
      'nomineePhone': nomineePhone,
      'nomineeRelation': nomineeRelation,
      'adharCard': adharCard,
      'panCard': panCard,
      'pinCode': pinCode,
      'staffName': staffName,
      'mailId': mailId,
      'amc': amc ?? 0,
      'tax': tax ?? 0,
      'country': country,
      'aadharFrontUrl': aadharFrontUrl,
      'aadharBackUrl': aadharBackUrl,
      'panCardUrl': panCardUrl,
      'password': password,
      'createdDate': Timestamp.fromDate(createdDate),
      'updatedDate': Timestamp.fromDate(updatedDate),
      'status': status.name,
    };
  }

  /// 🔥 For JSON serialization (SharedPreferences) - uses ISO8601 strings
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'custId': custId,
      'phone_no': phoneNo,
      'address': address,
      'place': place,
      'balance': balance,
      'openingAmount': openingAmount,
      'staffId': staffId,
      'token': token,
      'schemeType': schemeType,
      'total_gram': totalGram,
      'branch': branch,
      'branchName': branchName,
      'dateofBirth': dateofBirth.toIso8601String(),
      'nominee': nominee,
      'nomineePhone': nomineePhone,
      'nomineeRelation': nomineeRelation,
      'adharCard': adharCard,
      'panCard': panCard,
      'pinCode': pinCode,
      'staffName': staffName,
      'mailId': mailId,
      'amc': amc ?? 0,
      'tax': tax ?? 0,
      'country': country,
      'aadharFrontUrl': aadharFrontUrl,
      'aadharBackUrl': aadharBackUrl,
      'panCardUrl': panCardUrl,
      'password': password,
      'createdDate': createdDate.toIso8601String(),
      'updatedDate': updatedDate.toIso8601String(),
      'status': status.name,
    };
  }

  /// 🔥 Fixed status mapping
  static CustomerStatus statusFromString(String value) {
    switch (value.toLowerCase()) {
      // ✅ Fixed
      case "pending":
        return CustomerStatus.pending; // ✅ Added
      case "approved":
        return CustomerStatus.approved;
      case "rejected":
        return CustomerStatus.rejected;
      default:
        return CustomerStatus.pending;
    }
  }

  static String statusToString(CustomerStatus status) {
    switch (status) {
      case CustomerStatus.pending:
        return "pending";
      case CustomerStatus.approved:
        return "approved";
      case CustomerStatus.rejected:
        return "rejected";
    }
  }
}
