import 'package:flutter/material.dart';

import '../../common/colo_extension.dart';
import 'columnUi.dart';

Widget buildWishListCard(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final isWeb = screenWidth > 600;
  return Container(
    padding: EdgeInsets.symmetric(horizontal: isWeb ? 0 : 15),
    constraints: BoxConstraints(
      maxWidth: isWeb ? 750 : double.infinity,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: Colors.white,
      border: Border.all(color: Color(0xFF1B5E20).withOpacity(0.2), width: 2),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 15),
        Container(
            width: 160,
            child: Image(image: AssetImage("assets/photos/wishlist.png"))),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.offline_bolt,
                        color: TColo.primaryColor1,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Get up to 100% of first installment as Bonus',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(
                        Icons.offline_bolt,
                        color: TColo.primaryColor1,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Easy Monthly Installments',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'With the WishList Jewellery Buying Plan, we love to turn your desires into reality. Now, you can open an account with a minimum amount of 2000.You will be qualified for a bonus of up to 100% of your initial instalment, if you make fixed monthly payments for 11 months continuously.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                child: SchemeTableScreen(),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Container(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // if (_userName != "") {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => Webprofile(),
              //     ),
              //   );
              // } else {
              //   _showLoginDialog(context);
              // }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: TColo.primaryColor1,
              padding: EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
            ),
            child: Text(
              'Subscribe to WishList',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(height: 15),
      ],
    ),
  );
}

Widget buildAspireCard(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final isWeb = screenWidth > 600;
  return Container(
    padding: EdgeInsets.symmetric(horizontal: isWeb ? 0 : 15),
    constraints: BoxConstraints(
      maxWidth: isWeb ? 750 : double.infinity,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: Colors.white,
      border: Border.all(color: Color(0xFF1B5E20).withOpacity(0.2), width: 2),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 15),
        Container(
            width: 160,
            child: Image(image: AssetImage("assets/photos/aspire.png"))),
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.offline_bolt,
                        color: TColo.primaryColor1,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Get Advantage of Average Gold Rate',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(
                        Icons.offline_bolt,
                        color: TColo.primaryColor1,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Easy Monthly Installments',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Meralda Aspire Jewellery Buying Plan is a gateway to own coveted pieces by paying fixed instalment starting from only ₹2000 for 11 months. Each payment reserves a portion of gold weight equivalent to the amount paid and, at the time of redemption, you can get your jewellery equivalent to the accumulated weight without paying any making charges up to 16%.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(child: GoldBookingTable()),
            ),
          ],
        )),
        SizedBox(height: 20),
        Container(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // if (_userName != "") {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => Webprofile(),
              //     ),
              //   );
              // } else {
              //   _showLoginDialog(context);
              // }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: TColo.primaryColor1,
              padding: EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
            ),
            child: Text(
              'Subscribe to Aspire',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(height: 15),
      ],
    ),
  );
}
