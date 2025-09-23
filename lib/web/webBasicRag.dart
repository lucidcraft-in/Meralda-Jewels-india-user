import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/colo_extension.dart';
import '../model/appUser.dart';
import '../model/customerModel.dart';
import '../providers/otpProvider.dart';
import 'webPayScreen.dart';

// 2. OTP Verification Screen

// 3. Set Password Screen
class SetPasswordScreen extends StatefulWidget {
  final String mobileNumber;

  const SetPasswordScreen({
    Key? key,
    required this.mobileNumber,
  }) : super(key: key);

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  // Password requirements
  bool _hasMinLength = false;
  bool _hasUppercase = false;
  bool _hasLowercase = false;
  bool _hasDigits = false;
  bool _hasSpecialCharacters = false;
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
                    SizedBox(height: 10),

                    // Header
                    Text(
                      "Set Your Password",
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
                      "Create a strong password to secure your account",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: isSmallScreen ? 14 : 16,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 30 : 40),

                    // Password input
                    Container(
                      decoration: BoxDecoration(
                        color: TColo.primaryColor2.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: TColo.primaryColor1.withOpacity(0.2),
                        ),
                      ),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        onChanged: _onPasswordChanged,
                        decoration: InputDecoration(
                          hintText: "Enter password",
                          hintStyle: TextStyle(
                            color: Colors.grey[500],
                            fontSize: isSmallScreen ? 14 : 16,
                          ),
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: TColo.primaryColor1,
                            size: isSmallScreen ? 20 : 24,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: TColo.primaryColor1,
                              size: isSmallScreen ? 20 : 24,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
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
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 15 : 20),

                    // Password requirements
                    _buildPasswordRequirements(),
                    SizedBox(height: isSmallScreen ? 20 : 30),

                    // Confirm password input
                    Container(
                      decoration: BoxDecoration(
                        color: TColo.primaryColor2.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: TColo.primaryColor1.withOpacity(0.2),
                        ),
                      ),
                      child: TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: !_isConfirmPasswordVisible,
                        decoration: InputDecoration(
                          hintText: "Confirm password",
                          hintStyle: TextStyle(
                            color: Colors.grey[500],
                            fontSize: isSmallScreen ? 14 : 16,
                          ),
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: TColo.primaryColor1,
                            size: isSmallScreen ? 20 : 24,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isConfirmPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: TColo.primaryColor1,
                              size: isSmallScreen ? 20 : 24,
                            ),
                            onPressed: () {
                              setState(() {
                                _isConfirmPasswordVisible =
                                    !_isConfirmPasswordVisible;
                              });
                            },
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
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 30 : 40),

                    // Create account button
                    Container(
                      width: double.infinity,
                      height: isSmallScreen ? 48 : 55,
                      decoration: BoxDecoration(
                        color: TColo.primaryColor1,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ElevatedButton(
                        onPressed: _isLoading || !_isPasswordValid()
                            ? null
                            : _createAccount,
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
                                "Create Account",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isSmallScreen ? 16 : 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Positioned(
          //   top: isSmallScreen ? 8 : 10,
          //   right: isSmallScreen ? 8 : 10,
          //   child: IconButton(
          //     onPressed: () {
          //       Navigator.pop(context);
          //     },
          //     icon: Icon(
          //       Icons.close,
          //       size: isSmallScreen ? 20 : 24,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildPasswordRequirements() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Password Requirements:",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: TColo.primaryColor1,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 15),
          _buildRequirementItem("At least 8 characters", _hasMinLength),
          _buildRequirementItem("One uppercase letter", _hasUppercase),
          _buildRequirementItem("One lowercase letter", _hasLowercase),
          _buildRequirementItem("One number", _hasDigits),
          _buildRequirementItem("One special character", _hasSpecialCharacters),
        ],
      ),
    );
  }

  Widget _buildRequirementItem(String requirement, bool isValid) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isValid ? Colors.green : Colors.grey[400],
            size: 20,
          ),
          const SizedBox(width: 10),
          Text(
            requirement,
            style: TextStyle(
              color: isValid ? Colors.green : Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _onPasswordChanged(String password) {
    setState(() {
      _hasMinLength = password.length >= 8;
      _hasUppercase = password.contains(RegExp(r'[A-Z]'));
      _hasLowercase = password.contains(RegExp(r'[a-z]'));
      _hasDigits = password.contains(RegExp(r'[0-9]'));
      _hasSpecialCharacters =
          password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    });
  }

  bool _isPasswordValid() {
    return _hasMinLength &&
        _hasUppercase &&
        _hasLowercase &&
        _hasDigits &&
        _hasSpecialCharacters;
  }

  void _createAccount() async {
    if (_formKey.currentState!.validate() && _isPasswordValid()) {
      setState(() => _isLoading = true);
      final user = SchemeUserModel(
          name: "",
          custId: "",
          phoneNo: widget.mobileNumber,
          address: "",
          place: "",
          balance: 0,
          openingAmount: 0,
          staffId: "",
          token: "",
          schemeType: "",
          totalGram: 0,
          branch: "",
          branchName: "",
          dateofBirth: DateTime.now(),
          nominee: "",
          nomineePhone: "",
          nomineeRelation: "",
          adharCard: "",
          panCard: "",
          pinCode: "",
          staffName: "",
          mailId: "",
          tax: 0,
          amc: 0,
          country: "",
          aadharFrontUrl: "",
          aadharBackUrl: "",
          panCardUrl: "",
          password: _passwordController.text,
          createdDate: DateTime.now(),
          updatedDate: DateTime.now(),
          status: CustomerStatus.pending);
      final docRef =
          await FirebaseFirestore.instance.collection("user").add(user.toMap());

// Fetch back the created doc
      final userDoc = await docRef.get();
      final userData = userDoc.data()!;

// Sanitize Timestamp for JSON
      final sanitizedUserData = userData.map((key, value) {
        if (value is Timestamp) {
          return MapEntry(key, value.toDate().toIso8601String());
        }
        return MapEntry(key, value);
      });

// Save to SharedPreferences with doc id
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        "user",
        json.encode({
          "id": docRef.id, // 👈 always use Firestore doc id
          ...sanitizedUserData,
        }),
      );

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      setState(() => _isLoading = false);
      Navigator.pop(context); // Show success dialog
      _showSuccessDialog(docRef.id, user);
    }
  }

  void _showSuccessDialog(String userId, SchemeUserModel userData) {
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
                  "Account login Successfully!",
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
                    child: const Text(
                      "Get Started",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
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
