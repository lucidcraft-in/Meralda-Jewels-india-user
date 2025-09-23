import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

import 'zample.dart';

void main() async {
  TargetPlatform isIOS = TargetPlatform.iOS;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // LocalNotificationService.initialize();
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // HttpOverrides.global = MyHttpOverrides();
  runApp(
    GoldJewelryApp(),
    // MyApp()
  );
}




// void main() {
//   runApp(MunawaraGoldApp());
// }

// class MunawaraGoldApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Meralda Jewels',
//       theme: ThemeData(
//         primaryColor: Color(0xFF003a34), // Dark green from your image
//         colorScheme: ColorScheme.light(
//           primary: Color(0xFF003a34), // Dark green
//           secondary: Color(0xFFFFD700), // Gold color
//         ),
//         fontFamily: 'Roboto',
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       initialRoute: '/',
//       routes: {
//         '/': (context) => HomePage(),
//         '/login': (context) => LoginPage(),
//       },
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }