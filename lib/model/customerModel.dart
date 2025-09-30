import 'package:cloud_firestore/cloud_firestore.dart';

/// 🔹 Simple Customer Status Flow
/// Created → Pending → Approved/Rejected
enum CustomerStatus { pending, approved, rejected, closed }

class BankDetailsModel {
  final String? bankName;
  final String? accountNumber;
  final String? ifsc;
  final String? branch;

  BankDetailsModel({
    this.bankName,
    this.accountNumber,
    this.ifsc,
    this.branch,
  });

  factory BankDetailsModel.fromMap(Map<String, dynamic>? data) {
    if (data == null) return BankDetailsModel();
    return BankDetailsModel(
      bankName: data['bankName']?.toString(),
      accountNumber: data['accountNumber']?.toString(),
      ifsc: data['ifsc']?.toString(),
      branch: data['branch']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bankName': bankName,
      'accountNumber': accountNumber,
      'ifsc': ifsc,
      'branch': branch,
    };
  }
}

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

  // 🔹 New optional fields
  final DateTime? lastPaidDate;
  final BankDetailsModel? bankDetails;

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
    this.lastPaidDate,
    this.bankDetails,
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
        status = statusFromString(data['status']?.toString() ?? "pending"),
        lastPaidDate = _parseDateTimeNullable(data['lastPaidDate']),
        bankDetails = BankDetailsModel.fromMap(data['bankDetails']);

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

  static DateTime? _parseDateTimeNullable(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value);
    if (value is DateTime) return value;
    return null;
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
      'lastPaidDate':
          lastPaidDate != null ? Timestamp.fromDate(lastPaidDate!) : null,
      'bankDetails': bankDetails?.toMap(),
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
      'lastPaidDate': lastPaidDate?.toIso8601String(),
      'bankDetails': bankDetails?.toMap(),
    };
  }

  /// 🔥 Fixed status mapping
  static CustomerStatus statusFromString(String value) {
    switch (value.toLowerCase()) {
      case "pending":
        return CustomerStatus.pending;
      case "approved":
        return CustomerStatus.approved;
      case "rejected":
        return CustomerStatus.rejected;
      case "closed":
        return CustomerStatus.closed;
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
      case CustomerStatus.closed:
        return "closed";
    }
  }
}
