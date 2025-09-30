import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResponseScreen extends StatefulWidget {
  ResponseScreen({this.response});
  var response;

  @override
  State<ResponseScreen> createState() => _ResponseScreenState();
}

class _ResponseScreenState extends State<ResponseScreen> {
  var response;
  var userData;
  // String custId = "";
  String userName = "";
  // double mobileNo = 0;
  var paymentDetails;
  var amount;
  String mernttransId = "";
  DateTime now = DateTime.now();
  String formattedDateTime = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Format the date and time

    setState(() {
      formattedDateTime = formatDate(now);
      response = widget.response;
      amount = response["amount"];
      //   mernttransId = response["data"]["merchantTransactionId"];
    });
    // print(
    //     "----------------------------------- response -------------------------");
    // print(response["data"]);
    checkUser();
  }

  Future checkUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var user = pref.getString("user");
    if (user != null) {
      var decodedJson = json.decode(user);
      userData = decodedJson;
      // print("----------");
      // print(userData);
      setState(() {
        userName = userData["name"];
      });
      // print("========== user Data ============");

      // print(userName);

      // getAdminStaff(widget.userBranch);
    }
    // updateFirebaseStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   leading: GestureDetector(
      //       onTap: () {
      //         Navigator.pushAndRemoveUntil(
      //             context,
      //             MaterialPageRoute(builder: (context) => HomeScreen()),
      //             (route) => true);
      //       },
      //       child: Icon(Icons.close_rounded)),
      //   actions: [
      //     Icon(Icons.ios_share),
      //     SizedBox(
      //       width: 10,
      //     ),
      //   ],
      // ),
      bottomNavigationBar: Container(
        height: 150,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Container(
              //   height: MediaQuery.of(context).size.height * .06,
              //   width: double.infinity,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(14),
              //     border: Border.all(
              //       color: Color(0xFFcc9900),
              //       width: 2.0,
              //     ),
              //   ),
              //   child: GestureDetector(
              //     onTap: () {
              //       _savePdfAndPrint();
              //     },
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Icon(Icons.cloud_download_outlined),
              //         SizedBox(
              //           width: 10,
              //         ),
              //         Text(
              //           "Get PDF Receipt",
              //           style: TextStyle(
              //               fontWeight: FontWeight.w500, fontSize: 16),
              //         )
              //       ],
              //     ),
              //   ),
              // ),
              GestureDetector(
                onTap: () {
                  // Navigator.pushAndRemoveUntil(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => HomeScreen()),
                  //     (route) => false);
                },
                child: Container(
                    height: MediaQuery.of(context).size.height * .06,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Color(0xFFcc9900),
                    ),
                    child: Center(
                        child: Text(
                      "Done",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.white),
                    ))),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(child: recipt()),
    );
  }

  Widget recipt() => SingleChildScrollView(
        // height: double.infinity,
        // width: double.infinity,
        // color: Colors.red,
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * .06,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // GestureDetector(
                    //     onTap: () {
                    //       Navigator.pushAndRemoveUntil(
                    //           context,
                    //           MaterialPageRoute(
                    //               builder: (context) => HomeScreen()),
                    //           (route) => false);
                    //     },
                    //     child: Icon(Icons.close_rounded)),
                  ],
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * .15,
              child: Center(
                child: response["code"] == "PAYMENT_SUCCESS"
                    ? CircleAvatar(
                        radius: 50,
                        backgroundColor: Color(0xFFe6fff2),
                        child: CircleAvatar(
                          radius: 20,
                          child: Image(
                            fit: BoxFit.scaleDown,
                            image: AssetImage("assets/images/checked.png"),
                          ),
                        ),
                      )
                    : Image(
                        fit: BoxFit.scaleDown,
                        image: AssetImage(
                            "assets/images/Screenshot 2023-06-22 at 3.08.47 PM.png"),
                      ),
              ),
            ),
            response["code"] == "PAYMENT_SUCCESS"
                ? Text(
                    "Payment Success!",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  )
                : Text(
                    "Payment Failed!",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
            SizedBox(
              height: 10,
            ),
            response["code"] == "PAYMENT_SUCCESS"
                ? Text(
                    "Your payment has been successfully done.",
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  )
                : Text(
                    "Your payment has been Failed",
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * .45,
                decoration: BoxDecoration(
                    color: Color(0xFFf0f5f5),
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * .11,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        .11,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text("Amount"),
                                        Text("Payment Status")
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        .11,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(amount.toString()),
                                        ),
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .04,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .25,
                                          decoration: BoxDecoration(
                                              color: response["code"] ==
                                                      "PAYMENT_SUCCESS"
                                                  ? Color(0xFFadebad)
                                                  : Color(0xFFffb3b3),
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: Center(
                                            child: response["code"] ==
                                                    "PAYMENT_SUCCESS"
                                                ? Text(
                                                    "Success",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFF196619)),
                                                  )
                                                : Text(
                                                    "Failed",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFF660000)),
                                                  ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 2,
                      ),
                      Expanded(
                        child: Container(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 210,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text("Ref Number"),
                                        Text("Merchant Name"),
                                        response["code"] == "PAYMENT_SUCCESS"
                                            ? Text("Payment Method")
                                            : Container(),
                                        Text("Payment Time"),
                                        Text("Sender")
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 210,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                                response["transactionId"] !=
                                                        null
                                                    ? response["transactionId"]
                                                    : ""),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text("Meralda Jewels"),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: response["code"] ==
                                                    "PAYMENT_SUCCESS"
                                                ? Text(response["type"])
                                                : Container(),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(formattedDateTime),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(userName.toUpperCase()),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      );
  Uint8List? bytes;
  // Future _captureWidget() async {
  //   final controller = ScreenshotController();
  //   final bytes = await controller.captureFromWidget(Material(child: recipt()));
  //   setState(() => this.bytes = bytes);

  //   return bytes;
  // }

  Future<void> _savePdfAndPrint() async {
    // final doc = pw.Document();
    // // Uint8List capturedImage = await _captureWidget();

    // final pdfImage = pw.MemoryImage(capturedImage);
    // // print("---------------");
    // // print(pdfImage);
    // doc.addPage(
    //   pw.Page(
    //     build: (pw.Context context) {
    //       return pw.Center(
    //         child: pw.Image(pdfImage),
    //       );
    //     },
    //   ),
    // );

    // final appDocDir = await getApplicationDocumentsDirectory();
    // // print(appDocDir);
    // final pdfPath = "${appDocDir.path}/Receipt.pdf";
    // final File outputFile = File(pdfPath);

    // await outputFile.writeAsBytes(await doc.save());

    // // Share the PDF file with other applications
    // await ShareExtend.share(pdfPath, 'Share Receipt!');
  }

  // Staff? db;
  // List staffList = [];
  // List filterList = [];
  // String adminToken = "";
  // getAdminStaff(int brchId) async {
  //   print("======= Branch Id =======");
  //   print(brchId);
  //   db = Staff();
  //   db!.initiliase();
  //   db!.read(brchId).then((value) {
  //     setState(() {
  //       staffList = value!;
  //     });
  //     print("======= Branch Id =======");
  //     print(staffList);
  //   });
  //   setState(() {
  //     filterList = staffList
  //         .where((element) => (element['type'].toString().contains("1")))
  //         .toList();
  //   });

  //   print("======= Token =======");
  //   print(filterList);
  // }

  // sendNotification(String title, String token, double amt) async {
  //   print("check notification");
  //   print(token);
  //   final data = {
  //     'click_action': 'FLUTTER_NOTIFICATION_CLICK',
  //     'id': 1,
  //     'status': 'done',
  //     'message': title,
  //   };
  //   try {
  //     http.Response response =
  //         await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
  //             headers: <String, String>{
  //               'Content-Type': 'application/json',
  //               'Authorization':
  //                   'key=AAAAYxF4bUQ:APA91bE-vvHQIfOI27flf420DjMEb1fkc0rlrFLz6N5HqVKvstpVEl-HzVmubii6ZDHDO5AYHVdvauIbGC0T-dS9yXskwgi4XVd38HOaix_hwBt7riU3tjDBdYx4mGAgglXPP3cEp5jX'
  //             },
  //             body: jsonEncode(<String, dynamic>{
  //               'notification': <String, dynamic>{
  //                 'title': title,
  //                 'body':
  //                     "You have received a deposit of Rs $amt from a $userName"
  //               },
  //               'priority': 'high',
  //               'data': data,
  //               'to': "$token"
  //             }));
  //     print(response.body);
  //     if (response.statusCode == 200) {
  //       print("notification is sended");
  //     } else {
  //       print("error");
  //     }
  //   } catch (e) {}
  // }

  String formatDate(DateTime dateTime) {
    // Months mapping
    List<String> months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    // Get month abbreviation
    String monthAbbreviation = months[dateTime.month];

    // Format date and time
    String formattedDateTime =
        "$monthAbbreviation ${dateTime.day}, ${dateTime.year}, "
        "${dateTime.hour}:${dateTime.minute}:${dateTime.second}";

    return formattedDateTime;
  }
}
