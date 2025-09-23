import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/colo_extension.dart';
import '../../model/appUser.dart';
import '../../model/customerModel.dart';
import '../../providers/otpProvider.dart';
import '../webPayScreen.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String mobileNumber;

  const OTPVerificationScreen({
    Key? key,
    required this.mobileNumber,
  }) : super(key: key);

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final List<TextEditingController> _otpControllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _otpFocusNodes =
      List.generate(6, (index) => FocusNode());
  bool _isLoading = false;
  bool _isResending = false;
  int _countdown = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _otpFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startCountdown() {
    _countdown = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() => _countdown--);
      } else {
        timer.cancel();
      }
    });
  }

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),

                  // Header
                  Text(
                    "Verify Your Number",
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
                  SizedBox(height: isSmallScreen ? 8 : 10),
                  Text(
                    "Enter the code sent via WhatsApp to\n+91 ${widget.mobileNumber}",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: isSmallScreen ? 14 : 16,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 30 : 50),

                  // OTP input boxes
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(6, (index) {
                      return Container(
                        width: isSmallScreen ? 40 : 50,
                        height: isSmallScreen ? 50 : 60,
                        decoration: BoxDecoration(
                          color: TColo.primaryColor2.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: TColo.primaryColor1.withOpacity(0.2),
                            width: 1.5,
                          ),
                        ),
                        child: TextFormField(
                          controller: _otpControllers[index],
                          focusNode: _otpFocusNodes[index],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          style: TextStyle(
                            fontSize: isSmallScreen ? 18 : 24,
                            fontWeight: FontWeight.bold,
                            color: TColo.primaryColor1,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            counterText: "",
                          ),
                          onChanged: (value) {
                            if (value.isNotEmpty && index < 5) {
                              _otpFocusNodes[index + 1].requestFocus();
                            } else if (value.isEmpty && index > 0) {
                              _otpFocusNodes[index - 1].requestFocus();
                            }

                            // Auto verify when all fields are filled
                            if (index == 5 && value.isNotEmpty) {
                              _verifyOTP();
                            }
                          },
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: isSmallScreen ? 30 : 40),

                  // Verify button
                  Container(
                    width: double.infinity,
                    height: isSmallScreen ? 48 : 55,
                    decoration: BoxDecoration(
                      color: TColo.primaryColor1,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _verifyOTP,
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
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              "Verify OTP",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isSmallScreen ? 16 : 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 20 : 30),

                  // Resend OTP section
                  Center(
                    child: Column(
                      children: [
                        if (_countdown > 0)
                          Text(
                            "Resend code in ${_countdown}s",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: isSmallScreen ? 14 : 16,
                            ),
                          )
                        else
                          TextButton(
                            onPressed: _isResending ? null : _resendOTP,
                            child: _isResending
                                ? SizedBox(
                                    height: isSmallScreen ? 14 : 16,
                                    width: isSmallScreen ? 14 : 16,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  )
                                : Text(
                                    "Resend OTP",
                                    style: TextStyle(
                                      color: TColo.primaryColor1,
                                      fontSize: isSmallScreen ? 14 : 16,
                                      fontWeight: FontWeight.w600,
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

  void _verifyOTP() async {
    final otpProvider = Provider.of<OTPProvider>(context, listen: false);
    String otp = _otpControllers.map((controller) => controller.text).join();

    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter complete OTP')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await otpProvider.verifyOTP(widget.mobileNumber, otp);

      setState(() => _isLoading = false);

      // switch (result["status"]) {
      //   case "success":
      //     final user = result["user"] as AppUser;
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(content: Text("Welcome ${user.phoneNo}")),
      //     );
      //     Navigator.pop(context);
      //     _showSuccessDialog(user.id, user);
      //     break;

      //   case "expired":
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       const SnackBar(content: Text("OTP expired")),
      //     );
      //     break;

      //   case "invalid":
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       const SnackBar(content: Text("Invalid OTP")),
      //     );
      //     break;

      //   case "not_found":
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       const SnackBar(content: Text("User not found")),
      //     );
      //     break;

      //   default:
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(content: Text("Error: ${result["message"] ?? "Unknown"}")),
      //     );
      // }
      switch (result["status"]) {
        case "success":
          final user = result["user"] as AppUser;
          Navigator.pop(context);
          _showSuccessDialog(user.id, user);
          break;

        case "expired":
          _showErrorDialog("Your OTP has expired. Please request a new one.");
          break;

        case "invalid":
          _showErrorDialog("The OTP you entered is invalid. Try again.");
          break;

        case "not_found":
          _showErrorDialog("No account found for this number.");
          break;

        default:
          _showErrorDialog("Error: ${result["message"] ?? "Unknown"}");
      }
    } catch (error) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${error.toString()}")),
      );
    }
  }

  void _showErrorDialog(String message) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    final isMediumScreen = screenWidth >= 400 && screenWidth < 600;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            constraints: BoxConstraints(
              maxWidth: isSmallScreen
                  ? screenWidth * 0.9
                  : isMediumScreen
                      ? 400
                      : 450,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error, color: Colors.red, size: 48),
                const SizedBox(height: 15),
                Text(
                  "Verification Failed",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[700],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColo.primaryColor1,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 25),
                  ),
                  child: const Text(
                    "OK",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _resendOTP() async {
    setState(() => _isResending = true);

    try {
      // Call the provider's resend OTP method
      final otpProvider = Provider.of<OTPProvider>(context, listen: false);
      // await otpProvider.resendOTP(widget.mobileNumber);

      setState(() => _isResending = false);
      _startCountdown();

      // Clear OTP fields
      for (var controller in _otpControllers) {
        controller.clear();
      }
      _otpFocusNodes[0].requestFocus();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP sent successfully')),
      );
    } catch (error) {
      setState(() => _isResending = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${error.toString()}")),
      );
    }
  }

  void _showSuccessDialog(String userId, AppUser userData) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    final isMediumScreen = screenWidth >= 400 && screenWidth < 600;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            constraints: BoxConstraints(
              maxWidth: isSmallScreen
                  ? screenWidth * 0.95
                  : isMediumScreen
                      ? 400
                      : 450,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Login Successfully!",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: TColo.primaryColor1,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  "Welcome to Meralda Gold! You can now start using your account.",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => WebPayAmountScreen(
                            user: {
                              "id": userId,
                              ...userData.toMap(), // convert model to map
                            },
                            userid: userId,
                            custName: "",
                          ),
                        ),
                        (Route<dynamic> route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          TColo.primaryColor1, // Use your color here
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 0, // Remove shadow if needed
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                        "Get Started",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
