import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../common/colo_extension.dart';

// Terms & Conditions Dialog
void showTermsAndConditionsDialog(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final isSmallScreen = screenWidth < 400;
  final isMediumScreen = screenWidth >= 400 && screenWidth < 600;

  showDialog(
    context: context,
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
                    : 750,
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Text(
                "Terms & Conditions",
                style: TextStyle(
                  fontSize: isSmallScreen ? 18 : 20,
                  fontWeight: FontWeight.bold,
                  color: TColo.primaryColor1,
                ),
              ),
              SizedBox(height: 15),

              // Terms Content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTermSection(
                        title: "Eligibility",
                        content:
                            "By using Meralda Jewels Pvt Ltd platform, you represent and warrant that you are at least 18 years old or have the permission of a legal guardian. If you are under the age of 18, you must have the consent of a parent or guardian to use our services.",
                      ),
                      _buildTermSection(
                        title: "Account Registration",
                        content:
                            "To access certain features of the platform, you may be required to create an account. You agree to provide accurate, current, and complete information during the registration process and to update such information to keep it accurate, current, and complete. You are responsible for safeguarding your account password and for any activities or actions under your account.",
                      ),
                      _buildTermSection(
                        title: "User Responsibilities",
                        content:
                            "Users must provide accurate and complete information when placing an order. Users are responsible for ensuring the safety and legality of the jewelry products they purchase from vendors. Users agree not to misuse the platform, including but not limited to spamming, hacking, or engaging in any illegal activities.",
                      ),
                      _buildTermSection(
                        title: "Vendor Responsibilities",
                        content:
                            "Registered vendors are responsible for the quality, safety, and delivery of their products. Vendors must comply with all applicable laws and regulations, including jewelry safety standards.",
                      ),
                      _buildTermSection(
                        title: "Payments and Fees",
                        content:
                            "All payments for orders are processed through our third-party payment processors. By placing an order, you agree to pay all applicable fees and charges associated with your order. Prices and availability of products are subject to change without notice.",
                      ),
                      _buildTermSection(
                        title: "Cancellations and Modifications",
                        content:
                            "Orders may be canceled or modified according to the cancellation policy of the respective vendor. Meralda Jewels is not responsible for any disputes arising from cancellations or modifications of orders.Refunds are processed within 4-5 working days after inspection.",
                      ),
                      _buildTermSection(
                        title: "Limitation of Liability",
                        content:
                            "Meralda Jewels is not liable for any indirect, incidental, special, consequential, or punitive damages, including loss of profits, data, use, goodwill, or other intangible losses resulting from your access to or use of the service.",
                      ),
                      _buildTermSection(
                        title: "Intellectual Property",
                        content:
                            "All content, trademarks, service marks, logos, and other intellectual property on the platform are the property of Meralda Jewels or its licensors. You may not use, reproduce, distribute, or create derivative works without our express written consent.",
                      ),
                      _buildTermSection(
                        title: "Termination",
                        content:
                            "We may terminate or suspend your account and access to the platform at our discretion, without notice, for conduct that we believe violates these Terms & Conditions or is harmful to other users of the platform, us, or third parties, or for any other reason.",
                      ),
                      _buildTermSection(
                        title: "Changes to Terms",
                        content:
                            "We reserve the right to modify these Terms & Conditions at any time. We will notify you of any changes by posting the new terms on this page and updating the 'Effective Date' at the top of these terms. Your continued use of the platform after any modifications constitutes acceptance of the new terms.",
                      ),
                      _buildTermSection(
                        title: "Governing Law",
                        content:
                            "These Terms & Conditions are governed by and construed in accordance with the laws of India, without regard to its conflict of law principles. Any disputes arising from these terms shall be resolved in the courts of India.",
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 15),

              // Close Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColo.primaryColor1,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "I Understand",
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 16,
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

// Privacy Policy Dialog
void showPrivacyPolicyDialog(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final isSmallScreen = screenWidth < 400;
  final isMediumScreen = screenWidth >= 400 && screenWidth < 600;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          constraints: BoxConstraints(
            maxWidth: isSmallScreen
                ? screenWidth * 0.95
                : isMediumScreen
                    ? 400
                    : 750,
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Text(
                "Privacy Policy",
                style: TextStyle(
                  fontSize: isSmallScreen ? 18 : 20,
                  fontWeight: FontWeight.bold,
                  color: TColo.primaryColor1,
                ),
              ),
              const SizedBox(height: 15),

              // Privacy Content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTermSection(
                        title: "Data Collection",
                        content:
                            "We collect certain personal information to ensure smooth processing of your orders and to enhance your overall shopping experience. "
                            "This may include your name, billing and shipping address, contact number, and payment information (processed securely). "
                            "We may also collect browsing data to improve website performance and provide a more personalized experience. "
                            "We strictly limit collection to what is necessary and use it only for legitimate business purposes.",
                      ),
                      _buildTermSection(
                        title: "Payment Security",
                        content:
                            "Your financial security is our top priority. We do not store your complete card or bank details on our servers. "
                            "All payments are processed through trusted, PCI-DSS compliant payment gateways with advanced encryption and fraud detection. "
                            "This ensures that your transactions remain safe and confidential at all times.",
                      ),
                      _buildTermSection(
                        title: "Information Sharing",
                        content:
                            "We value your privacy and do not sell, rent, or trade your information to third parties. "
                            "However, to provide our services, we may share limited information with logistics and delivery partners to ship your orders, "
                            "payment providers to process transactions, or legal authorities if required by law. "
                            "All third-party partners are bound by confidentiality agreements.",
                      ),
                      _buildTermSection(
                        title: "Cookies",
                        content:
                            "To improve your browsing and shopping experience, our platform may use cookies and similar technologies. "
                            "Cookies help us remember your preferences, analyze usage patterns, and offer personalized promotions. "
                            "You can disable cookies through your browser settings, but some features of our website may not function properly without them.",
                      ),
                      _buildTermSection(
                        title: "Contact for Privacy Concerns",
                        content:
                            "We are committed to protecting your personal data. If you have any questions, complaints, or requests regarding your information, "
                            "please reach us at support@meraldajewels.com. "
                            "Our support team will review and respond to your queries promptly, and you may request corrections, deletions, or updates at any time.",
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Close Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColo.primaryColor1,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Got It",
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 16,
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

// Contact Us Dialog
void showContactUsDialog(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final isSmallScreen = screenWidth < 400;
  final isMediumScreen = screenWidth >= 400 && screenWidth < 600;

  showDialog(
    context: context,
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
                    : 750,
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Text(
                "Contact Us",
                style: TextStyle(
                  fontSize: isSmallScreen ? 18 : 20,
                  fontWeight: FontWeight.bold,
                  color: TColo.primaryColor1,
                ),
              ),
              SizedBox(height: 15),

              // Contact Content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Icon(
                          Icons.support_agent,
                          size: 60,
                          color: TColo.primaryColor1,
                        ),
                      ),
                      SizedBox(height: 20),
                      _buildContactItem(
                        icon: Icons.email_outlined,
                        title: "Email Support",
                        content: "support@meraldajewels.com",
                        isClickable: true,
                        onTap: () async {
                          final Uri emailUri = Uri(
                            scheme: 'mailto',
                            path: 'support@meraldajewels.com',
                            query: 'subject=Customer Inquiry',
                          );
                          if (await canLaunchUrl(emailUri)) {
                            await launchUrl(emailUri);
                          }
                        },
                      ),
                      _buildContactItem(
                        icon: Icons.access_time_outlined,
                        title: "Response Time",
                        content: "24-48 hours",
                        isClickable: false,
                      ),
                      _buildContactItem(
                        icon: Icons.info_outline,
                        title: "Support Hours",
                        content: "Monday - Saturday: 9 AM - 6 PM IST",
                        isClickable: false,
                      ),
                      SizedBox(height: 15),
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: TColo.primaryColor1.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "We're here to help with any questions about our jewelry collection, orders, or services.",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 15),

              // Contact Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final Uri emailUri = Uri(
                      scheme: 'mailto',
                      path: 'support@meraldajewels.com',
                      query: 'subject=Customer Inquiry',
                    );
                    if (await canLaunchUrl(emailUri)) {
                      await launchUrl(emailUri);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColo.primaryColor1,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  icon: Icon(Icons.email, size: isSmallScreen ? 16 : 18),
                  label: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Send Email",
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 16,
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

// FAQ Dialog
void showFAQDialog(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final isSmallScreen = screenWidth < 400;
  final isMediumScreen = screenWidth >= 400 && screenWidth < 600;

  showDialog(
    context: context,
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
                    : 750,
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Text(
                "Frequently Asked Questions",
                style: TextStyle(
                  fontSize: isSmallScreen ? 18 : 20,
                  fontWeight: FontWeight.bold,
                  color: TColo.primaryColor1,
                ),
              ),
              SizedBox(height: 15),

              // FAQ Content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTermSection(
                        title: "How long does shipping take?",
                        content:
                            "Domestic (India): 5-7 business days post-shipment.\nInternational: 10-15 business days, subject to customs clearance.",
                      ),
                      _buildTermSection(
                        title: "What is your return policy?",
                        content:
                            "Returns accepted within 7 days for defective, damaged, or incorrect items only. Items must be in original condition.",
                      ),
                      _buildTermSection(
                        title: "How do I track my order?",
                        content:
                            "You'll receive tracking details via email/WhatsApp once your order ships. Orders are processed within 2-4 business days.",
                      ),
                      _buildTermSection(
                        title: "Is shipping free?",
                        content:
                            "Shipping is complimentary within India under certain minimum order values. International freight charges apply at checkout.",
                      ),
                      _buildTermSection(
                        title: "How do I request a refund?",
                        content:
                            "Email support@meraldajewels.com with your Order ID and issue details. Refunds are processed within 5-10 working days after inspection.",
                      ),
                      _buildTermSection(
                        title: "Are custom items returnable?",
                        content:
                            "Personalized, custom, or sale items are not eligible for return unless defective.",
                      ),
                      _buildTermSection(
                        title: "Is my payment secure?",
                        content:
                            "Yes, we use PCI-compliant payment gateways. Sensitive payment data is not stored on our servers.",
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 15),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: TColo.primaryColor1.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.help_outline,
                                color: TColo.primaryColor1, size: 20),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "Still have questions? Contact support@meraldajewels.com",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500,
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

              SizedBox(height: 15),

              // Close Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColo.primaryColor1,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Got It",
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 16,
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

// Feedback Dialog
void showFeedbackDialog(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final isSmallScreen = screenWidth < 400;
  final isMediumScreen = screenWidth >= 400 && screenWidth < 600;
  final TextEditingController feedbackController = TextEditingController();

  showDialog(
    context: context,
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
                    : 750,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Text(
                "Share Your Feedback",
                style: TextStyle(
                  fontSize: isSmallScreen ? 18 : 20,
                  fontWeight: FontWeight.bold,
                  color: TColo.primaryColor1,
                ),
              ),
              SizedBox(height: 15),

              // Feedback Content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Icon(
                          Icons.feedback_outlined,
                          size: 60,
                          color: TColo.primaryColor1,
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: TColo.primaryColor1.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "We value your opinion! Your feedback helps us improve our products and services to serve you better.",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Your Feedback",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: TColo.primaryColor1,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          controller: feedbackController,
                          maxLines: 6,
                          decoration: InputDecoration(
                            hintText:
                                "Tell us about your experience, suggestions, or any issues you faced...",
                            hintStyle: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(12),
                          ),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 15),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: TColo.primaryColor1),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            color: TColo.primaryColor1,
                            fontSize: isSmallScreen ? 14 : 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (feedbackController.text.trim().isNotEmpty) {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('Thank you for your valuable feedback!'),
                              backgroundColor: TColo.primaryColor1,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColo.primaryColor1,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      icon: Icon(Icons.send, size: isSmallScreen ? 16 : 18),
                      label: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Submit",
                          style: TextStyle(
                            fontSize: isSmallScreen ? 14 : 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

// Helper widget for each term section
Widget _buildTermSection({required String title, required String content}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 15),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: TColo.primaryColor1,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 5),
        Text(
          content,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
          ),
        ),
      ],
    ),
  );
}

// Helper widget for contact items
Widget _buildContactItem({
  required IconData icon,
  required String title,
  required String content,
  required bool isClickable,
  VoidCallback? onTap,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 15),
    child: GestureDetector(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: TColo.primaryColor1,
            size: 20,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: TColo.primaryColor1,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 12,
                    color: isClickable ? Colors.blue[700] : Colors.grey[700],
                    decoration: isClickable ? TextDecoration.underline : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
