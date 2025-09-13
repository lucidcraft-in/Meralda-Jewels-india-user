// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class OTPProvider with ChangeNotifier {
//   bool _isLoading = false;
//   bool get isLoading => _isLoading;

//   Future<bool> sendOTP(String mobile) async {
//     print(mobile);
//     _isLoading = true;
//     notifyListeners();

//     try {
//       final response = await http.post(
//         Uri.parse("https://wa-api.cloud/api/v1/messages"),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization":
//               "Bearer 84922|M2MzDHqeLKnr2H0DTnC8EeCKNCbXUZ7w6ims64rk",
//         },
//         body: jsonEncode({
//           "to": "919961624063", // e.g. "918590836052"
//           "type": "template",
//           "template": {
//             "name": "otp_test",
//             "language": {"code": "en"},
//             "components": [
//               {
//                 "type": "body",
//                 "parameters": [
//                   {"type": "text", "text": "2345"} // OTP value
//                 ]
//               },
//               {
//                 "type": "button",
//                 "sub_type": "url",
//                 "index": "0",
//                 "parameters": [
//                   {"type": "text", "text": "4321"} // OTP value
//                 ]
//               }
//             ]
//           }
//         }),
//       );

//       _isLoading = false;
//       notifyListeners();
//       print("-----------");
//       print(response.statusCode);
//       print(response.body);
//       if (response.statusCode == 201) {
//         return true;
//       } else {
//         debugPrint("OTP API Error: ${response.body}");
//         return false;
//       }
//     } catch (e) {
//       _isLoading = false;
//       notifyListeners();
//       debugPrint("OTP Exception: $e");
//       return false;
//     }
//   }
// }

// import 'dart:convert';
// import 'dart:math';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// import '../model/customerModel.dart';

// class OTPProvider with ChangeNotifier {
//   bool _isLoading = false;
//   bool get isLoading => _isLoading;

//   /// Generate a random 6 digit OTP
//   String _generateOTP() {
//     final random = Random();
//     return (100000 + random.nextInt(900000)).toString();
//   }

//   /// Send OTP and also save to Firestore user collection
//   Future<bool> sendOTP(String mobile) async {
//     _isLoading = true;
//     notifyListeners();

//     try {
//       final otp = _generateOTP();
//       final now = DateTime.now();

//       // 🔹 Save OTP & otpSentAt in Firestore user collection
//       final userRef = FirebaseFirestore.instance.collection("user");
//       final existingUser =
//           await userRef.where("phoneNo", isEqualTo: mobile).limit(1).get();

//       if (existingUser.docs.isEmpty) {
//         // create new user with otp
//         await userRef.add({
//           "name": "",
//           "custId": "",
//           "phoneNo": mobile,
//           "address": "",
//           "place": "",
//           "balance": 0,
//           "openingAmount": 0,
//           "staffId": "",
//           "token": "",
//           "schemeType": "",
//           "totalGram": 0,
//           "branch": "",
//           "branchName": "",
//           "dateofBirth": now,
//           "nominee": "",
//           "nomineePhone": "",
//           "nomineeRelation": "",
//           "adharCard": "",
//           "panCard": "",
//           "pinCode": "",
//           "staffName": "",
//           "mailId": "",
//           "tax": 0,
//           "amc": 0,
//           "country": "",
//           "aadharFrontUrl": "",
//           "aadharBackUrl": "",
//           "panCardUrl": "",
//           "status": "start", // match your CustomerStatus.start
//           "otp": otp,
//           "otpSentAt": now,
//           "createdDate": now,
//           "updatedDate": now,
//         });
//       } else {
//         // update existing user otp
//         await userRef.doc(existingUser.docs.first.id).update({
//           "otp": otp,
//           "otpSentAt": now,
//           "updatedDate": now,
//         });
//       }

//       // 🔹 Send OTP via WhatsApp API
//       final response = await http.post(
//         Uri.parse("https://wa-api.cloud/api/v1/messages"),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization":
//               "Bearer 84922|M2MzDHqeLKnr2H0DTnC8EeCKNCbXUZ7w6ims64rk",
//         },
//         body: jsonEncode({
//           "to": "91$mobile", // actual user number
//           "type": "template",
//           "template": {
//             "name": "otp_test",
//             "language": {"code": "en"},
//             "components": [
//               {
//                 "type": "body",
//                 "parameters": [
//                   {"type": "text", "text": otp} // OTP value
//                 ]
//               }
//             ]
//           }
//         }),
//       );

//       _isLoading = false;
//       notifyListeners();

//       if (response.statusCode == 201 || response.statusCode == 200) {
//         print("OTP sent successfully to $mobile : $otp");
//         return true;
//       } else {
//         debugPrint("OTP API Error: ${response.body}");
//         return false;
//       }
//     } catch (e) {
//       _isLoading = false;
//       notifyListeners();
//       debugPrint("OTP Exception: $e");
//       return false;
//     }
//   }

//   /// Verify OTP for given mobile
//   // Future<String?> verifyOTP(String mobile, String enteredOtp) async {
//   //   try {
//   //     final userRef = FirebaseFirestore.instance.collection("user");
//   //     final snapshot =
//   //         await userRef.where("phoneNo", isEqualTo: mobile).limit(1).get();

//   //     if (snapshot.docs.isEmpty) return "User not found";

//   //     final user = snapshot.docs.first.data();
//   //     final otp = user["otp"];
//   //     final otpSentAt = (user["otpSentAt"] as Timestamp).toDate();

//   //     final now = DateTime.now();
//   //     final difference = now.difference(otpSentAt).inMinutes;

//   //     if (difference > 5) return "OTP expired";
//   //     if (otp != enteredOtp) return "Invalid OTP";

//   //     return null; // ✅ success
//   //   } catch (e) {
//   //     return "Error verifying OTP";
//   //   }
//   // }
//   Future<String?> verifyOTP(String mobile, String enteredOtp) async {
//     try {
//       final userRef = FirebaseFirestore.instance.collection("user");
//       final snapshot =
//           await userRef.where("phoneNo", isEqualTo: mobile).limit(1).get();

//       if (snapshot.docs.isEmpty) return "User not found";

//       final doc = snapshot.docs.first;
//       final user = doc.data();
//       final otp = user["otp"];
//       final otpSentAt = (user["otpSentAt"] as Timestamp).toDate();

//       final now = DateTime.now();
//       final difference = now.difference(otpSentAt).inMinutes;

//       if (difference > 5) return "OTP expired";
//       if (otp != enteredOtp) return "Invalid OTP";

//       // ✅ OTP Success → Create user with your UserModel fields
//       final newUser = UserModel(
//         name: "",
//         custId: "",
//         phoneNo: mobile,
//         address: "",
//         place: "",
//         balance: 0,
//         openingAmount: 0,
//         staffId: "",
//         token: "",
//         schemeType: "",
//         totalGram: 0,
//         branch: "",
//         branchName: "",
//         dateofBirth: DateTime.now(),
//         nominee: "",
//         nomineePhone: "",
//         nomineeRelation: "",
//         adharCard: "",
//         panCard: "",
//         pinCode: "",
//         staffName: "",
//         mailId: "",
//         tax: 0,
//         amc: 0,
//         country: "",
//         aadharFrontUrl: "",
//         aadharBackUrl: "",
//         panCardUrl: "",
//         createdDate: DateTime.now(),
//         updatedDate: DateTime.now(),
//         status: CustomerStatus.start,
//         otp: enteredOtp,
//         otpSentAt: now,
//       );

//       // Save user in Firestore
//       final docRef = await FirebaseFirestore.instance
//           .collection("user")
//           .add(newUser.toMap());

//       // Fetch back the created doc
//       final userDoc = await docRef.get();
//       final userData = userDoc.data()!;

//       // Sanitize Timestamp for JSON storage
//       final sanitizedUserData = userData.map((key, value) {
//         if (value is Timestamp) {
//           return MapEntry(key, value.toDate().toIso8601String());
//         }
//         return MapEntry(key, value);
//       });

//       // ✅ Save to SharedPreferences
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString(
//         "user",
//         json.encode({
//           "id": docRef.id, // Firestore doc id
//           ...sanitizedUserData,
//         }),
//       );

//       return null; // success
//     } catch (e) {
//       debugPrint("OTP Verify Exception: $e");
//       return "Error verifying OTP";
//     }
//   }
// }
import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/appUser.dart';
import 'package:http/http.dart' as http;

class OTPProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _generateOTP() {
    final random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }

  Future<bool> sendOTP(String mobile) async {
    _isLoading = true;
    notifyListeners();
    print("---------");
    print(mobile);
    try {
      final otp = _generateOTP();
      try {
        final response = await http.post(
          Uri.parse("https://wa-api.cloud/api/v1/messages"),
          headers: {
            "Content-Type": "application/json",
            "Authorization":
                "Bearer 84922|M2MzDHqeLKnr2H0DTnC8EeCKNCbXUZ7w6ims64rk",
          },
          body: jsonEncode({
            "to": "91${mobile}", // e.g. "918590836052"
            "type": "template",
            "template": {
              "name": "otp_test",
              "language": {"code": "en"},
              "components": [
                {
                  "type": "body",
                  "parameters": [
                    {"type": "text", "text": otp} // OTP value
                  ]
                },
                {
                  "type": "button",
                  "sub_type": "url",
                  "index": "0",
                  "parameters": [
                    {"type": "text", "text": otp} // OTP value
                  ]
                }
              ]
            }
          }),
        );

        _isLoading = false;
        notifyListeners();
        print("-----------");
        print(response.statusCode);
        print(response.body);
        if (response.statusCode == 201) {
          final now = DateTime.now();

          final userRef = FirebaseFirestore.instance.collection("user");
          final existingUser =
              await userRef.where("phoneNo", isEqualTo: mobile).limit(1).get();

          if (existingUser.docs.isEmpty) {
            // create a temp user with only phone and otp
            await userRef.add({
              "phoneNo": mobile,
              "otp": otp,
              "otpSentAt": now,
              "createdAt": now,
            });
          } else {
            await userRef.doc(existingUser.docs.first.id).update({
              "otp": otp,
              "otpSentAt": now,
            });
          }

          _isLoading = false;
          notifyListeners();

          debugPrint("OTP for $mobile is $otp"); // TODO: send via API/WhatsApp
          return true;
          // return true;
        } else {
          debugPrint("OTP API Error: ${response.body}");
          return false;
        }
      } catch (e) {
        _isLoading = false;
        notifyListeners();
        debugPrint("OTP Exception: $e");
        return false;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint("Send OTP error: $e");
      return false;
    }
  }

  Future<Map<String, dynamic>> verifyOTP(
      String mobile, String enteredOtp) async {
    try {
      final userRef = FirebaseFirestore.instance.collection("user");
      final snapshot =
          await userRef.where("phoneNo", isEqualTo: mobile).limit(1).get();

      if (snapshot.docs.isEmpty) {
        return {"status": "not_found"};
      }

      final doc = snapshot.docs.first;
      final data = doc.data();

      final otp = data["otp"];
      final otpSentAt = (data["otpSentAt"] as Timestamp).toDate();
      final createdAt = (data["createdAt"] as Timestamp?)?.toDate();
      final now = DateTime.now();

      // Expiry checks
      if (now.difference(otpSentAt).inMinutes > 5) {
        return {"status": "expired"};
      }

      if (otp != enteredOtp) {
        return {"status": "invalid"};
      }

      // Success
      final appUser = AppUser(
        id: doc.id,
        phoneNo: mobile,
        createdAt: createdAt ?? now,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        "user",
        jsonEncode({
          "id": appUser.id,
          "phoneNo": appUser.phoneNo,
          "createdAt": appUser.createdAt.toIso8601String(),
        }),
      );

      return {"status": "success", "user": appUser};
    } catch (e) {
      debugPrint("Verify OTP error: $e");
      return {"status": "error", "message": e.toString()};
    }
  }
}
