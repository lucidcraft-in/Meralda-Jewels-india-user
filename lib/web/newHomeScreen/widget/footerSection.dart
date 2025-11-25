import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF1A4D3E),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 900) {
            return _buildDesktopFooter();
          } else {
            return _buildMobileFooter();
          }
        },
      ),
    );
  }

  Widget _buildDesktopFooter() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: _buildBrandSection(),
            ),
            const SizedBox(width: 60),
            Expanded(
              child: _buildQuickLinks(),
            ),
            const SizedBox(width: 60),
            Expanded(
              child: _buildOurPlans(),
            ),
            const SizedBox(width: 60),
            Expanded(
              child: _buildSupport(),
            ),
          ],
        ),
        const SizedBox(height: 60),
        _buildDivider(),
        const SizedBox(height: 30),
        _buildBottomBar(),
      ],
    );
  }

  Widget _buildMobileFooter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBrandSection(),
        const SizedBox(height: 40),
        _buildQuickLinks(),
        const SizedBox(height: 40),
        _buildOurPlans(),
        const SizedBox(height: 40),
        _buildSupport(),
        const SizedBox(height: 50),
        _buildDivider(),
        const SizedBox(height: 30),
        _buildBottomBarMobile(),
      ],
    );
  }

  Widget _buildBrandSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo
        Container(
          width: 100,
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(image: AssetImage("assets/images/logo_bg_white.png"))
            ],
          ),
        ),
        const SizedBox(height: 25),
        const Text(
          'A medley of desires. Making luxury jewellery\naccessible through smart savings plans.',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 15,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 25),
        Row(
          children: [
            _buildSocialIcon(Icons.facebook),
            const SizedBox(width: 15),
            _buildSocialIcon(Icons.camera_alt),
            const SizedBox(width: 15),
            _buildSocialIcon(Icons.chat_bubble_outline),
            const SizedBox(width: 15),
            _buildSocialIcon(Icons.business),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white24, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        icon,
        color: Colors.white70,
        size: 20,
      ),
    );
  }

  Widget _buildQuickLinks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Links',
          style: TextStyle(
            color: Color(0xFFCB9E5F),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 25),
        _buildFooterLink('Our Plans'),
        _buildFooterLink('How It Works'),
        _buildFooterLink('Benefits'),
        _buildFooterLink('FAQ'),
        _buildFooterLink('Contact Us'),
      ],
    );
  }

  Widget _buildOurPlans() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Our Plans',
          style: TextStyle(
            color: Color(0xFFCB9E5F),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 25),
        _buildFooterLink('Aspire Plan'),
        _buildFooterLink('Wishlist Plan'),
        _buildFooterLink('Plan Calculator'),
        _buildFooterLink('Terms & Conditions'),
      ],
    );
  }

  Widget _buildSupport() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Support',
          style: TextStyle(
            color: Color(0xFFCB9E5F),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 25),
        _buildFooterLink('Customer Login'),
        _buildFooterLink('Track Payments'),
        _buildFooterLink('Privacy Policy'),
        _buildFooterLink('Refund Policy'),
      ],
    );
  }

  Widget _buildFooterLink(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: InkWell(
        onTap: () {},
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 15,
            height: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: Colors.white12,
    );
  }

  Widget _buildBottomBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          '© 2025 Meralda Jewels. All rights reserved.',
          style: TextStyle(
            color: Colors.white54,
            fontSize: 14,
          ),
        ),
        const Text(
          'Crafted with care in Dubai, UAE',
          style: TextStyle(
            color: Colors.white54,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBarMobile() {
    return Column(
      children: [
        const Text(
          '© 2025 Meralda Jewels. All rights reserved.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white54,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Crafted with care in Dubai, UAE',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white54,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

// Example usage in a page
class FooterExamplePage extends StatelessWidget {
  const FooterExamplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Your page content here
            Container(
              height: 500,
              color: Colors.white,
              child: const Center(
                child: Text(
                  'Page Content',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
            // Footer
            const FooterSection(),
          ],
        ),
      ),
    );
  }
}
