import 'dart:convert';

import 'package:meralda_gold_user/model/customerModel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import '../../functions/iframe.dart';

class PaymentService {
  static Future<void> processPaymentAndLaunch(
    var data,
    SchemeUserModel user,
    String transactionId, {
    required void Function(String) onPaymentCallback,
  }) async {
    // String metchentId = generateMerchantOrderId();
    final url =
        Uri.parse('https://api-2litnpsfvq-uc.a.run.app/process-payment');

    // final payload = {
    //   "merchantOrderId": metchentId,
    //   "amount": 100,
    //   "expireAfter": 1200,
    //   "metaInfo": {
    //     "udf1": "test1",
    //     "udf2": "new param2",
    //     "udf3": "test3",
    //     "udf4": "dummy value 4",
    //     "udf5": "addition info ref1"
    //   },
    //   "paymentFlow": {
    //     "type": "PG_CHECKOUT",
    //     "message": "Payment message used for collect requests",
    //     "merchantUrls": {"redirectUrl": "https://meralda-gold-9ff64.web.app/"}
    //   }
    // };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
        final redirectUrl = data['paymentResponse']?['redirectUrl'];
        if (redirectUrl != null && redirectUrl.isNotEmpty) {
          print('✅ Redirect URL: $redirectUrl');

          // openPayPage(redirectUrl);
          openPayPage(redirectUrl, onPaymentCallback);
        } else {
          print('⚠️ Redirect URL not found in response.');
        }
      } else {
        print('❌ Failed: ${response.statusCode}');
        print(response.body);
      }
    } catch (e) {
      print('⚠️ Error occurred: $e');
    }
  }

  static Future<void> checkOrderStatus(
      String merchantOrderId, String tok) async {
    if (merchantOrderId.isEmpty) {
      print('⚠️ Invalid merchantOrderId');
      return;
    }
    print(tok);
    print(merchantOrderId);
    final url = Uri.parse(
        'https://api.phonepe.com/apis/pg/checkout/v2/order/$merchantOrderId/status');
    print("------ ------- ------- --------");

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'O-Bearer ${tok}', // Replace this dynamically
        },
      );

      print('📡 GET $url');
      print('🔐 Headers: ${response.request?.headers}');
      print('📩 Response Code: ${response.statusCode}');
      print('📩 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final state = data['state'];
        print('🟢 Order State: $state');

        switch (state) {
          case 'COMPLETED':
            print('✅ Payment Successful');
            break;
          case 'FAILED':
            print('❌ Payment Failed');
            break;
          default:
            print('⏳ Payment Pending or Processing');
        }
      } else {
        print('❌ Failed: ${response.statusCode}');
        print(response.body);
      }
    } catch (e) {
      print('⚠️ Error while checking order status: $e');
    }
  }

  static Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
