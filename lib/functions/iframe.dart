import 'dart:js' as js;
import 'dart:math';

import 'package:provider/provider.dart';

import '../model/customerModel.dart';
import '../providers/transaction.dart';

void callback(String response) {
  if (response == 'USER_CANCEL') {
    print(response);
    print('❌ User cancelled payment');
    // Handle user cancellation logic
  } else if (response == 'CONCLUDED') {
    print(response);
    print('✅ Payment completed or reached terminal state');
    // Handle success/failure check by verifying payment on backend
  }
}

// void openPayPage(String tokenUrl) {
//   print("------------");
//   if (js.context.hasProperty('checkout')) {
//     const type = "IFRAME"; // or "REDIRECT" if you prefer
//     js.context.callMethod('checkout', [
//       tokenUrl,
//       type,
//       js.allowInterop(callback),
//     ]);
//   } else {
//     print('⚠️ checkout() function not found in JS context');
//   }
// }
void openPayPage(String tokenUrl, void Function(String) onPaymentCallback) {
  print("------------");

  // Callback triggered by JS after payment action
  void jsCallback(String response) {
    print("JS callback: $response");
    onPaymentCallback(response); // ✅ Pass result back to Flutter
  }

  if (js.context.hasProperty('checkout')) {
    const type = "IFRAME"; // or "REDIRECT" if you prefer
    js.context.callMethod('checkout', [
      tokenUrl,
      type,
      js.allowInterop(jsCallback),
    ]);
  } else {
    print('⚠️ checkout() function not found in JS context');
  }
}
