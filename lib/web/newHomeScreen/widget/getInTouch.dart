import 'package:flutter/material.dart';

import '../utils/commonHead.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 40),
          CommonHead(
            headLine: "Get in Touch",
            subTitle:
                'Have questions? Our team is here to help you start your gold savings journey',
          ),
          const SizedBox(height: 50),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 900) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 100),
                  child: _buildDesktopLayout(),
                );
              } else {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  child: _buildMobileLayout(),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _buildContactForm(isDesktop: true)),
          const SizedBox(width: 30),
          Expanded(child: _buildContactInfo()),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildContactForm(),
        const SizedBox(height: 30),
        _buildContactInfo(),
      ],
    );
  }

  bool _hoverPrimary = false;
  Widget _buildContactForm({bool isDesktop = false}) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Send us a message',
              style: TextStyle(
                fontSize: 20,
                fontFamily: "playfair",
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 30),
            _buildTextField(
              label: 'Full Name',
              controller: _nameController,
              hint: 'Enter your name',
            ),
            const SizedBox(height: 25),
            _buildTextField(
              label: 'Email Address',
              controller: _emailController,
              hint: 'your.email@example.com',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 25),
            _buildTextField(
              label: 'Phone Number',
              controller: _phoneController,
              hint: '+971 XX XXX XXXX',
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 25),
            _buildTextField(
              label: 'Message',
              controller: _messageController,
              hint: 'Tell us how we can help you...',
              maxLines: 5,
            ),

            // 👇 Only add Spacer when on Desktop (bounded height)
            if (isDesktop) const Spacer(),

            const SizedBox(height: 30),

            MouseRegion(
              onEnter: (_) => setState(() => _hoverPrimary = true),
              onExit: (_) => setState(() => _hoverPrimary = false),
              cursor: SystemMouseCursors.click,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(vertical: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: _hoverPrimary
                      ? const Color(0xFF246956)
                      : const Color(0xFF1A4D3E),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    'Send Message',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Color(0xFF2C3E50),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Color(0xFF0F4C3A)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 12,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This field is required';
            }
            return null;
          },
        ),
      ],
    );
  }

  bool _hoverSecondary = false;
  Widget _buildContactInfo() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Contact Information',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: "playfair",
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 30),
              _buildContactItem(
                icon: Icons.phone,
                title: 'Phone',
                subtitle: '+971 4 444 4444',
                description: 'Mon-Sat: 9:00 AM - 9:00 PM',
              ),
              _buildContactItem(
                icon: Icons.email,
                title: 'Email',
                subtitle: 'plans@meraldajewels.com',
                description: 'We\'ll respond within 24 hours',
              ),
              _buildContactItem(
                icon: Icons.location_on,
                title: 'Visit Our Showroom',
                subtitle: 'Gold Souk, Deira',
                description: 'Dubai, UAE',
              ),
              _buildContactItem(
                icon: Icons.chat,
                title: 'WhatsApp',
                subtitle: '+871 50 XXX XXXX',
                description: 'Quick support via chat',
                isLast: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        Container(
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFCB9E5F),
                Color(0xFFB8884A),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ready to Start?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Visit our showroom or call us to begin your jewellery purchase plan today.',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 25),
              MouseRegion(
                onEnter: (_) => setState(() => _hoverSecondary = true),
                onExit: (_) => setState(() => _hoverSecondary = false),
                cursor: SystemMouseCursors.click,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    color: _hoverSecondary
                        ? const Color(0xFF246956) // lighter on hover
                        : const Color(0xFF1A4D3E),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Schedule a Visit',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String description,
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: const Color(0xFFD4A574),
              size: 20,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'playfair',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
