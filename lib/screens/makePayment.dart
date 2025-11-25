// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:quickalert/quickalert.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import '../providers/phonePe_payment.dart';
// import '../providers/staff.dart';
// import '../providers/transaction.dart';
// import 'login_screen.dart';
// import 'paymentResponseScreen.dart';

// class MakePayment extends StatefulWidget {
//   const MakePayment({Key? key}) : super(key: key);

//   @override
//   State<MakePayment> createState() => _MakePaymentState();
// }

// class _MakePaymentState extends State<MakePayment> {
//   late Razorpay razorpay;
//   TextEditingController amountController = TextEditingController();
//   TextEditingController noteController = TextEditingController();
//   double finalAmount = 0;
//   bool pressPay = false;

//   @override
//   void initState() {
//     print("------");
//     checkUser();
//     razorpay = Razorpay();
//     razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, errorHandler);
//     razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, successHandler);
//     razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, externalWalletHandler);
//     super.initState();
//   }

//   void errorHandler(PaymentFailureResponse response) {
//     // print("======eee=======");
//     // print(response.error);
//     var db = phonePe_Payment();
//     db.initiliase();
//     db.updateTransaction(orderId, "Failed");
//     var res = {
//       "code": "Failed",
//       "amount": amountController.text,
//       "type": "online",
//       "transactionId": orderId
//     };

//     QuickAlert.show(
//         context: context,
//         type: QuickAlertType.error,
//         title: 'Oops...',
//         text: 'Sorry, Payment Failed',
//         confirmBtnColor: Theme.of(context).primaryColor,
//         confirmBtnTextStyle: TextStyle(
//             fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold),
//         onConfirmBtnTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => ResponseScreen(
//                 response: res,
//               ),
//             ),
//           );
//         });

//     // showDialog(
//     //   context: context,
//     //   builder: (BuildContext context) {
//     //     return AlertDialog(
//     //       title: Text("Payment Failed"),
//     //       content: Text(""),
//     //       actions: <Widget>[
//     //         TextButton(
//     //           child: Text("OK"),
//     //           onPressed: () {
//     //             Navigator.push(
//     //               context,
//     //               MaterialPageRoute(
//     //                 builder: (context) => ResponseScreen(
//     //                   response: res,
//     //                 ),
//     //               ),
//     //             );
//     //           },
//     //         ),
//     //       ],
//     //     );
//     //   },
//     // );
//     setState(() {
//       pressPay = false;
//     });
//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text(response.message!),
//         backgroundColor: Colors.red,
//       ));
//     }
//   }

//   void successHandler(PaymentSuccessResponse response) {
//     // print("========success=====");
//     // print(response.data);
//     var db = phonePe_Payment();
//     db.initiliase();
//     db.updateTransaction(orderId, "Success");
//     var res = {
//       "code": "PAYMENT_SUCCESS",
//       "amount": amountController.text,
//       "type": "online",
//       "transactionId": orderId
//     };
//     addTransaction(res);
//     QuickAlert.show(
//         context: context,
//         type: QuickAlertType.success,
//         text: 'Transaction Completed Successfully!',
//         confirmBtnColor: Theme.of(context).primaryColor,
//         confirmBtnTextStyle: TextStyle(
//             fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold),
//         onConfirmBtnTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => ResponseScreen(
//                 response: res,
//               ),
//             ),
//           );
//         });

//     // showDialog(
//     //   context: context,
//     //   builder: (BuildContext context) {
//     //     return AlertDialog(
//     //       title: Text("Payment Successful"),
//     //       content: Text("Payment ID: ${response.paymentId}"),
//     //       actions: <Widget>[
//     //         TextButton(
//     //           child: Text("OK"),
//     //           onPressed: () {
//     //             Navigator.push(
//     //               context,
//     //               MaterialPageRoute(
//     //                 builder: (context) => ResponseScreen(
//     //                   response: res,
//     //                 ),
//     //               ),
//     //             );
//     //           },
//     //         ),
//     //       ],
//     //     );
//     //   },
//     // );

//     setState(() {
//       pressPay = false;
//     });
//   }

//   void externalWalletHandler(ExternalWalletResponse response) {
//     // print("======wallet=======");
//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text(response.walletName!),
//         backgroundColor: Colors.green,
//       ));
//     }
//   }

//   var userData;
//   String custId = "";
//   String userName = "";
//   String mobileNo = "";

//   Future checkUser() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     // print(pref.containsKey("user"));
//     var user = pref.getString("user")!;

//     var decodedJson = json.decode(user);
//     userData = decodedJson;
//     // print(userData);
//     setState(() {
//       custId = userData["custId"];
//       userName = userData["name"];
//       mobileNo = userData["phoneNo"];
//     });

//     // Provider.of<User>(context, listen: false).getUserById(custId).then((value) {
//     //   print("========");
//     //   print(value);
//     //   if (value == true) {
//     //     clearData();
//     //   }
//     // });
//     // getAdminStaff();
//   }

//   Staff? db;
//   List staffList = [];
//   List filterList = [];
//   String adminToken = "";
//   getAdminStaff() async {
//     db = Staff();
//     db!.initiliase();
//     db!.read().then((value) => {
//           setState(() {
//             staffList = value!;
//           }),
//         });

//     filterList = staffList
//         .where((element) => (element['type'].toString().contains("1")))
//         .toList();

//     setState(() {
//       adminToken = filterList[0]["token"];
//     });
//   }

//   clearData() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     preferences.getKeys();
//     for (String key in preferences.getKeys()) {
//       preferences.remove(key);
//     }
//     Navigator.pushReplacement(context,
//         new MaterialPageRoute(builder: (context) => new LoginScreen()));
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Payment"),
//         centerTitle: false,
//         backgroundColor: Theme.of(context).primaryColor,
//       ),
//       body: Container(
//         height: MediaQuery.of(context).size.height * .6,
//         width: double.infinity,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             SizedBox(height: 30),
//             Column(
//               children: [
//                 Text("Hello...",
//                     style:
//                         TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Text(
//                   userData != null ? userName.toUpperCase() : "",
//                   style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
//                 ),
//               ],
//             ),
//             SizedBox(height: 30),
//             Column(
//               children: [
//                 Container(
//                   height: 100,
//                   child: IntrinsicWidth(
//                     child: Center(
//                       child: TextField(
//                         textAlign: TextAlign.start,
//                         onChanged: (amountController) {
//                           setState(() {
//                             double amount =
//                                 double.tryParse(amountController) ?? 0;
//                             double twoPercent =
//                                 amount * 0.02; // Calculate 2% of the amount
//                             finalAmount = amount +
//                                 twoPercent; // Add 2% to the original amount
//                           });
//                         },
//                         controller: amountController,
//                         keyboardType: TextInputType.number,
//                         cursorColor: Colors.grey,
//                         style: TextStyle(
//                           fontSize: 50,
//                           fontWeight: FontWeight.w500,
//                           color: Colors
//                               .grey, // Style hint as grey to differentiate from input
//                         ),
//                         decoration: InputDecoration(
//                           hintText: "0", // Set default value as "0"
//                           hintStyle: TextStyle(
//                             fontSize: 50,
//                             fontWeight: FontWeight.w500,
//                             color: Colors
//                                 .grey, // Style hint as grey to differentiate from input
//                           ),

//                           prefixIcon: Padding(
//                             padding: EdgeInsets.symmetric(
//                               vertical: 10.0,
//                             ),
//                             child: Image(
//                               height: 30,
//                               image: AssetImage(
//                                   "assets/images/Rupee-Symbol-Black.png"),
//                               color: Theme.of(context).primaryColor,
//                             ),
//                           ),
//                           // Icon(
//                           //   FontAwesomeIcons.rupeeSign,
//                           //   size: 25,
//                           //   color: Colors.black,
//                           // ),

//                           border: InputBorder.none,
//                           contentPadding: EdgeInsets.symmetric(vertical: -12.0),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Container(
//                     width: 250,
//                     height: 65,
//                     decoration: BoxDecoration(
//                         color: Colors.grey.shade300,
//                         borderRadius: BorderRadius.circular(20)),
//                     child: Center(
//                       child: Padding(
//                         padding: const EdgeInsets.all(7.0),
//                         child: IntrinsicWidth(
//                           child: TextField(
//                             controller: noteController,
//                             onChanged: (Value) {
//                               setState(() {});
//                             },
//                             style:
//                                 TextStyle(fontSize: 16.0, color: Colors.black),
//                             decoration: InputDecoration(
//                                 hintText: "add a note",
//                                 hintStyle: TextStyle(fontSize: 14),
//                                 border: InputBorder.none),
//                           ),
//                         ),
//                       ),
//                     )),
//                 SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       "Plane Price ",
//                       style: TextStyle(
//                           fontSize: 12,
//                           color: const Color.fromARGB(255, 92, 92, 92)),
//                     ),
//                     Image(
//                       height: 10,
//                       image: AssetImage("assets/images/Rupee-Symbol-Black.png"),
//                       color: Theme.of(context).primaryColor,
//                     ),
//                     Text(
//                       amountController.text,
//                       style: TextStyle(
//                           fontSize: 12, color: Color.fromARGB(255, 20, 20, 20)),
//                     ),
//                   ],
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       "Including convenience fee(2%) : ",
//                       style: TextStyle(
//                           fontSize: 12,
//                           color: const Color.fromARGB(255, 92, 92, 92)),
//                     ),
//                     Image(
//                       height: 10,
//                       image: AssetImage("assets/images/Rupee-Symbol-Black.png"),
//                       color: Theme.of(context).primaryColor,
//                     ),
//                     Text(
//                       finalAmount.toString(),
//                       style: TextStyle(
//                           fontSize: 12, color: Color.fromARGB(255, 18, 18, 18)),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 30),
//                 Container(
//                   height: 50,
//                   width: 150,
//                   child: amountController.text.isEmpty
//                       ? Center(child: Text("Pay Now"))
//                       : pressPay == false
//                           ? Container(
//                               width: double.infinity,
//                               height: double.infinity,
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(12)),
//                               child: OutlinedButton(
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Theme.of(context)
//                                         .primaryColor, // Background color
//                                   ),
//                                   onPressed: () {
//                                     if (amountController.text.isNotEmpty) {
//                                       setState(() {
//                                         pressPay = true;
//                                       });
//                                       final snackBar = SnackBar(
//                                           content: Text(
//                                               "Payment must be at least ₹1"));
//                                       if (double.parse(amountController.text) >
//                                           0) {
//                                         submit();
//                                       } else {
//                                         ScaffoldMessenger.of(context)
//                                             .showSnackBar(snackBar);
//                                         setState(() {
//                                           pressPay = false;
//                                         });
//                                       }
//                                     } else {
//                                       final snackBar = SnackBar(
//                                           content: Text(
//                                               "Payment must be at least ₹1"));
//                                       ScaffoldMessenger.of(context)
//                                           .showSnackBar(snackBar);
//                                       setState(() {
//                                         pressPay = false;
//                                       });
//                                     }
//                                   },
//                                   child: Text(
//                                     "Pay Now",
//                                     style: TextStyle(
//                                         color:
//                                             Color.fromARGB(255, 250, 250, 250),
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w600),
//                                   )))
//                           : Container(
//                               width: double.infinity,
//                               height: double.infinity,
//                               decoration: BoxDecoration(
//                                   color: Theme.of(context).primaryColor,
//                                   borderRadius: BorderRadius.circular(30)),
//                               child: Center(
//                                   child: Text(
//                                 "Wait...!",
//                                 style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w600),
//                               ))),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   String url = "https://prakash-jewellery.web.app/api/create-order";
//   String orderId = "";
//   submit() async {
//     // print("------");

//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: {
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({
//           "amount": finalAmount * 100,
//           "currency": "INR",
//           "receipt": "receipt#1",
//           "partial_payment": false,
//           "notes": {
//             "key1": noteController.text,
//             "key2": "value2",
//           }
//         }),
//       );

//       if (response.statusCode == 201) {
//         // print('Order created successfully');

//         var responseData = jsonDecode(response.body);
//         orderId = responseData['order']['id'];

//         var data = {
//           "custId": custId,
//           "TransactionId": orderId,
//           "custName": userName,
//           "amount": double.parse(amountController.text),
//           "note": noteController.text,
//           "custPhone": double.parse(mobileNo),
//         };

//         firebaseInsert(data);
//       } else {
//         // print('Error: ${response.body}');
//         setState(() {
//           pressPay = false;
//         });
//       }
//     } catch (e) {
//       // print('An error occurred: $e');
//       setState(() {
//         pressPay = false;
//       });
//     }
//   }

//   // ------ insert transtaction data in firebase ---------
//   firebaseInsert(var data) {
//     var db = phonePe_Payment();
//     db.initiliase();
//     db.addTransaction(data).then((value) {
//       openCheckout(data["TransactionId"]);
//       // print("----payment data ----");
//       setState(() {
//         transactionId = value.toUpperCase();
//       });
//       // print("----- Firebase insert ----------");
//       // print(transactionId);
//       if (transactionId != "") {
//         insertAPI(data.amount, data.note, transactionId);
//       } else {
//         // print("----- Firebase insert error----------");
//       }
//     });
//   }

//   openCheckout(String orderId) {
//     var options = {
//       "key": "rzp_live_d9IgRmrW09JzTu",
//       "amount": num.parse(amountController.text) * 100,
//       "name": "Prakash Jewellers",
//       'order_id': orderId,
//       "description": "Prakash Jewwllery",
//       "timeout": "180",
//       "currency": "INR",
//       "prefill": {
//         "contact": mobileNo,
//         "email": "",
//       }
//     };
//     try {
//       razorpay.open(options);
//     } catch (e) {
//       print(e.toString());
//     }
//   }

//   addTransaction(var response) async {
//     var data = TransactionModel(
//         id: "",
//         customerName: userName,
//         customerId: userData["id"],
//         date: DateTime.now(),
//         amount: double.parse(response["amount"]),
//         transactionType: 0,
//         note: noteController.text,
//         invoiceNo: response["transactionId"],
//         category: "GOLD",
//         discount: 0,
//         staffId: "",
//         merchentTransactionId: response["transactionId"],
//         transactionMode: "online");
//     var db = Transaction();
//     db.initiliase();
//     db.create(data).then((value) {
//       final snackBar =
//           SnackBar(content: const Text("Transaction Add Successfully...."));

//       ScaffoldMessenger.of(context).showSnackBar(snackBar);
//       // Navigator.pushReplacement(context,
//       //     MaterialPageRoute(builder: (context) => TransactionScreen()));
//     });
//     final title = "Successfully Deposited";
//   }
// }
