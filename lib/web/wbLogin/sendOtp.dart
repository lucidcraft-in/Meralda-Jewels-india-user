// 1. Mobile Number Input Screen
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../common/colo_extension.dart';
import '../../providers/otpProvider.dart';
import 'otpVerfyScreen.dart';

class MobileNumberScreen extends StatefulWidget {
  const MobileNumberScreen({Key? key}) : super(key: key);

  @override
  State<MobileNumberScreen> createState() => _MobileNumberScreenState();
}

class _MobileNumberScreenState extends State<MobileNumberScreen> {
  final TextEditingController _mobileController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    final isMediumScreen = screenWidth >= 400 && screenWidth < 600;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            constraints: BoxConstraints(
              maxWidth: isSmallScreen
                  ? screenWidth * 0.95
                  : isMediumScreen
                      ? 400
                      : 450,
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isSmallScreen ? 15 : 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SizedBox(height: isSmallScreen ? 20 : 40),
                    Center(
                      child: Image(
                          image:
                              AssetImage("assets/images/merladlog_white.png"),
                          width: 250),
                    ),
                    // Header
                    Center(
                      child: Text(
                        "Enter Your Mobile Number",
                        style: TextStyle(
                          color: TColo.primaryColor1,
                          fontSize: isSmallScreen
                              ? 18
                              : isMediumScreen
                                  ? 18
                                  : 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 8 : 10),
                    Text(
                      "We'll send you a verification code to confirm your number",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: isSmallScreen ? 14 : 16,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 30 : 50),

                    // Mobile number input
                    Container(
                      decoration: BoxDecoration(
                        color: TColo.primaryColor2.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: TColo.primaryColor1.withOpacity(0.2),
                        ),
                      ),
                      child: TextFormField(
                        controller: _mobileController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        decoration: InputDecoration(
                          hintText: "Enter mobile number",
                          hintStyle: TextStyle(
                            color: Colors.grey[500],
                            fontSize: isSmallScreen ? 14 : 16,
                          ),
                          prefixIcon: Container(
                            padding: EdgeInsets.all(isSmallScreen ? 12 : 15),
                            child: Text(
                              "+91",
                              style: TextStyle(
                                color: TColo.primaryColor1,
                                fontWeight: FontWeight.w600,
                                fontSize: isSmallScreen ? 14 : 16,
                              ),
                            ),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: isSmallScreen ? 16 : 20,
                          ),
                        ),
                        style: TextStyle(
                          fontSize: isSmallScreen ? 14 : 16,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter mobile number';
                          }
                          if (value.length != 10) {
                            return 'Please enter valid 10-digit mobile number';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 30 : 40),

                    // Continue button
                    Container(
                      width: double.infinity,
                      height: isSmallScreen ? 48 : 55,
                      decoration: BoxDecoration(
                        color: TColo.primaryColor1,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _sendOTP,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: _isLoading
                            ? SizedBox(
                                height: isSmallScreen ? 18 : 20,
                                width: isSmallScreen ? 18 : 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : Text(
                                "Send OTP",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isSmallScreen ? 16 : 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 20 : 30),

                    // Info section
                    Container(
                      padding: EdgeInsets.all(isSmallScreen ? 15 : 20),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: TColo.primaryColor1,
                            size: isSmallScreen ? 20 : 24,
                          ),
                          SizedBox(width: isSmallScreen ? 10 : 15),
                          Expanded(
                            child: Text(
                              "By continuing, you agree to our Terms of Service and Privacy Policy",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: isSmallScreen ? 12 : 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: isSmallScreen ? 8 : 10,
            right: isSmallScreen ? 8 : 10,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.close,
                size: isSmallScreen ? 20 : 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // void _sendOTP() async {
  //   if (_formKey.currentState!.validate()) {
  //     setState(() => _isLoading = true);

  //     // Simulate API call
  //     await Future.delayed(const Duration(seconds: 2));

  //     setState(() => _isLoading = false);

  //     // Navigate to OTP screen
  //     if (mounted) {
  //       Navigator.pop(context);
  //       showDialog(
  //         context: context,
  //         barrierDismissible: false,
  //         builder: (context) =>
  //             // UserRegistrationDialog(),
  //             OTPVerificationScreen(
  //           mobileNumber: _mobileController.text,
  //         ),
  //       );
  //     }
  //   }
  // }
  void _sendOTP() async {
    if (_formKey.currentState!.validate()) {
      final otpProvider = Provider.of<OTPProvider>(context, listen: false);
      setState(() => _isLoading = true);

      // Simulate API call

      bool success = await otpProvider.sendOTP(_mobileController.text.trim());

      if (success) {
        if (mounted) {
          Navigator.pop(context);
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => OTPVerificationScreen(
              mobileNumber: _mobileController.text.trim(),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to send OTP")),
        );
      }
      await Future.delayed(const Duration(seconds: 2));

      setState(() => _isLoading = false);
    }
  }
}
