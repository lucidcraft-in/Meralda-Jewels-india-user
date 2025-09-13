import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/customerModel.dart';

DateTime? _toDate(dynamic value) {
  if (value == null) return null;
  if (value is Timestamp) return value.toDate();
  return value as DateTime?;
}

class User with ChangeNotifier {
  late FirebaseFirestore firestore;
  initiliase() {
    firestore = FirebaseFirestore.instance;
  }

  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('user');
  // Map<String, UserModel> _user = {};
  late List<SchemeUserModel> _user;
  late List<SchemeUserModel> user;

  set listStaff(List<SchemeUserModel> val) {
    _user = val;
    notifyListeners();
  }

  List<SchemeUserModel> get listUsers => _user;

  int get userCount {
    return _user.length;
  }

  Future<List?> read() async {
    QuerySnapshot querySnapshot;
    List userlist = [];
    try {
      querySnapshot = await collectionReference.orderBy('timestamp').get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          Map a = {
            "id": doc.id,
            "name": doc['name'],
            "custId": doc["custId"],
            "phoneNo": doc["phone_no"],
            "address": doc["address"],
            // "scheme": doc["scheme"],
            "place": doc["place"],
            "balance": doc['balance'],
            "totalGram": doc["total_gram"],
            "branch": doc['branch'],
            "schemeType": doc["schemeType"],
            // "dateofBirth": doc['dateofBirth'].toDate(),
            "nominee": doc['nominee'],
            "nomineePhone": doc['nomineePhone'],
            "nomineeRelation": doc['nomineeRelation'],
            "adharCard": doc['adharCard'],
            "panCard": doc['panCard'],
            "pinCode": doc['pinCode'],
          };
          userlist.add(a);
        }

        return userlist;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<List?> readById(String userId) async {
    QuerySnapshot querySnapshot;
    List userlist = [];
    try {
      querySnapshot = await collectionReference.orderBy('timestamp').get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          if (userId == doc.id) {
            Map a = {
              "id": doc.id,
              "name": doc['name'],
              "custId": doc["custId"],
              "phoneNo": doc["phone_no"],
              "address": doc["address"],
              "scheme": doc["scheme"],
              "schemeType": doc["schemeType"],

              "place": doc["place"],
              "balance": doc['balance'],
              "totalGram": doc["total_gram"],
              "branch": doc["branch"],
              //  "dateofBirth": doc['dateofBirth'].toDate(),
              "nominee": doc['nominee'],
              "nomineePhone": doc['nomineePhone'],
              "nomineeRelation": doc['nomineeRelation'],
              "adharCard": doc['adharCard'],
              "panCard": doc['panCard'],
              "pinCode": doc['pinCode'],
              "token": doc["token"],
            };
            userlist.add(a);
          }
        }
        // print(userlist);
        return userlist;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  void removeItem(String productId) {
    _user.remove(productId);
    notifyListeners();
  }

  void clear() {
    _user = [];
    notifyListeners();
  }

  Future getUserById(String custId) async {
    QuerySnapshot querySnapshot =
        await collectionReference.where("custId", isEqualTo: custId).get();
    if (querySnapshot.docs.length > 0) {
      return false;
    } else {
      return true;
    }
  }

  Future checkUserByPhone(String phoneNo) async {
    List userlist = [];
    QuerySnapshot querySnapshot =
        await collectionReference.where("phone_no", isEqualTo: phoneNo).get();
    if (querySnapshot.docs.length > 0) {
      for (var doc in querySnapshot.docs.toList()) {
        Map a = {
          "id": doc.id,
          "name": doc['name'],
          "custId": doc["custId"],
          "phoneNo": doc["phone_no"],
        };
        userlist.add(a);
      }
      return [true, userlist];
    } else {
      return [false, []];
    }
  }

  Future assignOtp(double otp, String userId) async {
    try {
      collectionReference.doc(userId).update({
        "otp": otp,
        "otpExp": FieldValue.serverTimestamp(),
        "otpGen": FieldValue.serverTimestamp()
      });
      return true;
    } catch (e) {
      return e;
    }
  }

  getUserOtpByUser(String userId) async {
    try {
      DocumentSnapshot userDoc = await collectionReference.doc(userId).get();
      if (userDoc.exists) {
        // print(userDoc['otp']);
        return [userDoc['otp'], userDoc['otpGen']];
      } else {
        // print('User not found');
      }
      return true;
    } catch (e) {
      return e;
    }
  }

  // Future loginUser(String mobileNo, String password) async {
  //   print("----------");
  //   List userlist = [];
  //   QuerySnapshot querySnapshot;

  //   try {
  //     querySnapshot = await collectionReference
  //         .where("phone_no", isEqualTo: mobileNo)
  //         .where("password", isEqualTo: password)
  //         .get();
  //     print(querySnapshot.docs.length);
  //     if (querySnapshot.docs.isNotEmpty) {
  //       for (var doc in querySnapshot.docs.toList()) {
  //         Map a = {
  //           "id": doc.id,
  //           "name": doc['name'],
  //           "custId": doc["custId"],
  //           "phoneNo": doc["phone_no"],
  //           "address": doc["address"],
  //           "staffId": doc["staffId"],
  //           // "scheme": doc["scheme"],
  //           "place": doc["place"],
  //           "balance": doc['balance'],
  //           "totalGram": doc["total_gram"],
  //           "branch": doc['branch'],
  //           "schemeType": doc["schemeType"],
  //           // "dateofBirth": doc['dateofBirth'].toDate(),
  //           "nominee": doc['nominee'],
  //           "nomineePhone": doc['nomineePhone'],
  //           "nomineeRelation": doc['nomineeRelation'],
  //           "adharCard": doc['adharCard'],
  //           "panCard": doc['panCard'],
  //           "pinCode": doc['pinCode'],
  //           "openingAmount": doc["openingAmount"],
  //         };
  //         userlist.add(a);
  //       }
  //       print(userlist);
  //       return userlist;
  //     } else {
  //       return [];
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }
  Future<List<SchemeUserModel>> loginUser(
      String mobileNo, String password) async {
    try {
      final querySnapshot = await collectionReference
          .where("phone_no", isEqualTo: mobileNo)
          .where("password", isEqualTo: password)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final users = querySnapshot.docs.map((doc) {
          return SchemeUserModel.fromData(
              doc.data() as Map<String, dynamic>, doc.id);
        }).toList();
        print("==================");
        for (var u in users) {
          print(u.toMap());
        }
        return users;
      } else {
        return [];
      }
    } catch (e) {
      print("Login error: $e");
      return [];
    }
  }

  Future<bool?> create(
      SchemeUserModel userModel,
      String customerId,
      String schemeType,
      String assignStaff,
      String assignStaffName,
      String orderAdv) async {
    try {
      QuerySnapshot querySnapshot;

      querySnapshot = await collectionReference.orderBy('custId').get();
      var user = querySnapshot.docs.where((doc) => doc['custId'] == customerId);
      // print(scheme);
      // print('Selected Scheme ID: ${scheme!.id}');
      // print('Selected Scheme Name: ${scheme!.name}');

      if (user.length == 0) {
        await collectionReference.add({
          'name': userModel.name,
          'custId': customerId,
          'phone_no': userModel.phoneNo,
          'address': userModel.address,
          'place': userModel.place,
          'balance': 0.00,
          'staffId': assignStaff,
          //  userModel.staffId,
          'timestamp': FieldValue.serverTimestamp(),
          'token': "",
          'schemeType': schemeType,
          // "scheme": {"id": scheme.id, "name": scheme.name},
          'total_gram': 0.0000,
          'branch': userModel.branch,
          'branchName': userModel.branchName,
          'dateofBirth': userModel.dateofBirth,
          'nominee': userModel.nominee,
          'nomineePhone': userModel.nomineePhone,
          'nomineeRelation': userModel.nomineeRelation,
          'adharCard': userModel.adharCard,
          'panCard': userModel.panCard,
          'pinCode': userModel.pinCode,
          'staffName': assignStaffName,
          "aadharFrontUrl": userModel.aadharFrontUrl,
          "aadharBackUrl": userModel.aadharBackUrl,
          "panCardUrl": userModel.panCardUrl,
          "openingAmount": userModel.openingAmount,

          //  userModel.staffName,
          "otp": 0,
          "isClosed": "false",
          "otpExp": FieldValue.serverTimestamp(),
          "otpGen": FieldValue.serverTimestamp(),
          "mail": userModel.mailId,
          "orderAdvance": orderAdv,
          "profileImage": "",
          "tax": userModel.tax,
          "amc": userModel.amc,
          "country": userModel.country
          // "staffAssigneeId": assignStaff,
          // "staffAssigneeName": assignStaffName
        });

        return Future<bool>.value(false);
      } else {
        return Future<bool>.value(true);
      }
    } catch (e) {
      print(e);
    }
  }
}
