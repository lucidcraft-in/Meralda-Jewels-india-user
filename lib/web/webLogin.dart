import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:meralda_gold_user/web/webBasicRag.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/colo_extension.dart';
import '../providers/user.dart';
import 'wbLogin/sendOtp.dart';
import 'webPayScreen.dart';

class WebLoginpage extends StatefulWidget {
  @override
  _WebLoginpageState createState() => _WebLoginpageState();
}

class _WebLoginpageState extends State<WebLoginpage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String _errorMessage = "";
  bool _showErrorCard = false;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0.0, -1.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  void _showErrorMessage(String message) {
    setState(() {
      _errorMessage = message;
      _showErrorCard = true;
    });

    _animationController.forward();

    // Hide the error card after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        _animationController.reverse().then((_) {
          if (mounted) {
            setState(() {
              _showErrorCard = false;
              _errorMessage = "";
            });
          }
        });
      }
    });
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      login();
      await Future.delayed(Duration(seconds: 1));

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isWeb = screenWidth > 600;
    final isSmallScreen = screenWidth < 400;
    final isMediumScreen = screenWidth >= 400 && screenWidth < 600;

    return Container(
      width: double.infinity,
      height: double.infinity,
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(isSmallScreen ? 10 : 20),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: isWeb ? 0 : 15),
              constraints: BoxConstraints(
                maxWidth: isSmallScreen
                    ? screenWidth * 0.95
                    : isMediumScreen
                        ? 400
                        : 450,
              ),
              child: Stack(
                children: [
                  Card(
                    elevation: 20,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(isSmallScreen
                          ? 20
                          : isMediumScreen
                              ? 30
                              : 40),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Logo and Title
                            _buildHeader(isSmallScreen),
                            // SizedBox(height: isSmallScreen ? 10 : 10),

                            // Error Card (positioned above phone field)
                            if (_showErrorCard) _buildErrorCard(),
                            if (_showErrorCard)
                              SizedBox(height: isSmallScreen ? 10 : 15),

                            // Email Field
                            _buildCustIdField(isSmallScreen),
                            SizedBox(height: isSmallScreen ? 15 : 20),

                            // Password Field
                            _buildPasswordField(isSmallScreen),
                            SizedBox(height: isSmallScreen ? 20 : 30),

                            // Login Button
                            _buildLoginButton(isSmallScreen),
                            SizedBox(height: isSmallScreen ? 15 : 20),

                            // Forgot Password
                            _buildForgotPassword(isSmallScreen),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) => MobileNumberScreen());
                              },
                              child: Text(
                                "New user? Register here",
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 14 : 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorCard() {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          border: Border.all(color: Colors.red.shade300),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red.shade600,
              size: 20,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                _errorMessage,
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                _animationController.reverse().then((_) {
                  if (mounted) {
                    setState(() {
                      _showErrorCard = false;
                      _errorMessage = "";
                    });
                  }
                });
              },
              child: Icon(
                Icons.close,
                color: Colors.red.shade600,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isSmallScreen) {
    return Column(
      children: [
        Container(
          width: isSmallScreen ? 100 : 200,
          height: isSmallScreen ? 100 : 200,
          child: Image(image: AssetImage("assets/images/merladlog_white.png")),
        ),
      ],
    );
  }

  Widget _buildCustIdField(bool isSmallScreen) {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: 'Mobile Number',
        hintText: 'Enter your mobile number',
        prefixIcon: Icon(Icons.phone_outlined, color: TColo.primaryColor1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: TColo.primaryColor1, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: EdgeInsets.symmetric(
          vertical: isSmallScreen ? 14 : 16,
          horizontal: 16,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your mobile number';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField(bool isSmallScreen) {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Enter your password',
        prefixIcon: Icon(Icons.lock_outline, color: TColo.primaryColor1),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: Color(0xFF1B5E20),
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: TColo.primaryColor1, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: EdgeInsets.symmetric(
          vertical: isSmallScreen ? 14 : 16,
          horizontal: 16,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }

  Widget _buildLoginButton(bool isSmallScreen) {
    return SizedBox(
      width: double.infinity,
      height: isSmallScreen ? 48 : 55,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: TColo.primaryColor1,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5,
        ),
        child: _isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                'Login',
                style: TextStyle(
                  fontSize: isSmallScreen ? 16 : 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _buildForgotPassword(bool isSmallScreen) {
    return TextButton(
      onPressed: () {
        _showErrorMessage('Forgot password feature coming soon!');
      },
      child: Text(
        'Forgot Password?',
        style: TextStyle(
          color: Color(0xFF1B5E20),
          fontWeight: FontWeight.w600,
          fontSize: isSmallScreen ? 14 : 16,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  login() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final mobileNo = _phoneController.text.trim();
    final password = _passwordController.text.trim();

    if (mobileNo.isEmpty || password.isEmpty) {
      _showErrorMessage("Mobile Number and Password are required");
      return;
    }

    final userProvider = Provider.of<User>(context, listen: false);

    try {
      final users = await userProvider.loginUser(mobileNo, password);

      if (users.isNotEmpty) {
        final user = users[0];
        sharedPreferences.setString("user", json.encode(user.toMap()));

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => WebPayAmountScreen(
              user: user.toMap(),
              userid: user.id ?? "",
              custName: user.name.isNotEmpty ? user.name : "Customer",
            ),
          ),
          (Route<dynamic> route) => false,
        );
      } else {
        _showErrorMessage("Invalid mobile number or password");
      }
    } catch (e, st) {
      _showErrorMessage("An error occurred during login");
    }
  }
}
