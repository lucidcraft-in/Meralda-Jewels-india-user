import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String?> generateAuthToken() async {
  final url =
      Uri.parse("https://api.phonepe.com/apis/identity-manager/v1/oauth/token");

  final headers = {
    "Content-Type": "application/x-www-form-urlencoded",
  };

  final body = {
    "client_id": "SU2509231620268079558678",
    "client_version": "1",
    "client_secret": "7e700076-d1da-48a3-b728-c9c318cceca2",
    "grant_type": "client_credentials",
  };

  try {
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final token = data["access_token"];
      print("✅ Auth Token Generated: $token");
      return token;
    } else {
      print(
          "❌ Failed to generate token: ${response.statusCode} ${response.body}");
      return null;
    }
  } catch (e) {
    print("⚠️ Exception in generateAuthToken: $e");
    return null;
  }
}

Future<void> createPayment(String authToken, String orderId) async {
  final url = Uri.parse("https://api.phonepe.com/apis/pg/checkout/v2/pay");

  final headers = {
    "Content-Type": "application/json",
    "Authorization":
        "O-Bearer $authToken", // Note: Verify if "O-Bearer" is correct
  };

  final body = {
    "merchantOrderId": orderId,
    "amount": 1000, // in paise (₹10.00)
    "expireAfter": 1200, // seconds
    "metaInfo": {"udf1": "extra-info-1", "udf2": "extra-info-2"},
    "paymentFlow": {
      "type": "PG_CHECKOUT",
      "message": "Collect request",
      "merchantUrls": {"redirectUrl": "https://yourapp.com/callback"},
      "paymentModeConfig": {
        "enabledPaymentModes": [
          {"type": "UPI_INTENT"},
          {"type": "UPI_COLLECT"},
          {"type": "UPI_QR"},
          {"type": "NET_BANKING"},
          {
            "type": "CARD",
            "cardTypes": ["DEBIT_CARD", "CREDIT_CARD"]
          }
        ],
        "disabledPaymentModes": []
      }
    }
  };

  try {
    final response = await http.post(
      url,
      headers: headers,
      body: json.encode(body), // ✅ Convert Map to JSON string
    );

    print("===== Create Payment Response =====");
    print("Status Code: ${response.statusCode}");
    print("Body: ${response.body}");

    if (response.statusCode == 200) {
      final resData = json.decode(response.body);
      if (resData["success"] == true) {
        final redirectUrl =
            resData["data"]["instrumentResponse"]["redirectInfo"]["url"];
        print("✅ Redirect user to: $redirectUrl");
        // You can open this in WebView or external browser
      } else {
        print("❌ Payment failed: ${resData["message"]}");
      }
    } else {
      print("❌ Error: ${response.statusCode} - ${response.body}");
    }
  } catch (e) {
    print("⚠️ Exception in createPayment: $e");
  }
}
