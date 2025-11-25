import 'package:flutter/material.dart';

import '../utils/commonHead.dart';

class FAQSection extends StatelessWidget {
  const FAQSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 768;
        return _buildFAQSection(context, isMobile);
      },
    );
  }

  Widget _buildFAQSection(BuildContext context, bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 80,
        vertical: isMobile ? 60 : 100,
      ),
      color: const Color(0xFFF8F8F5),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            children: [
              CommonHead(
                headLine: "Frequently Asked Questions",
                subTitle:
                    'Find answers to common questions about our jewellery purchase plans',
              ),
              const SizedBox(height: 60),
              _FAQItem(
                question: 'What happens if I miss a monthly payment?',
                answer:
                    'If you miss a monthly payment, you will have a grace period of 7 days to make the payment without any penalty. After the grace period, a nominal late fee may be applied. We recommend setting up automatic payments to avoid missing any installments.',
              ),
              const SizedBox(height: 16),
              _FAQItem(
                question: 'Can I withdraw my savings before maturity?',
                answer:
                    'Yes, early withdrawal is possible. However, please note that bonus benefits and certain promotional offers may not be applicable for early withdrawals. The accumulated gold weight or value will be calculated based on the payments made until the withdrawal date.',
              ),
              const SizedBox(height: 16),
              _FAQItem(
                question:
                    'Can I buy any jewellery item with my accumulated value?',
                answer:
                    'Yes, you can choose from our entire collection of jewellery items. Your accumulated value can be used to purchase any jewellery piece from our store. Any remaining balance can be paid through other payment methods, and if your accumulated value exceeds the jewellery cost, the balance will be refunded to you.',
              ),
              const SizedBox(height: 16),
              _FAQItem(
                question: 'Is my money safe with Meralda?',
                answer:
                    'Absolutely. Your investment is completely secure with Meralda. We maintain the highest standards of financial security and transparency. All transactions are insured and your accumulated value is backed by physical gold reserves. We are also regulated by financial authorities to ensure complete safety of your funds.',
              ),
              const SizedBox(height: 16),
              _FAQItem(
                question:
                    'What is the difference between Aspire and Wishlist plans?',
                answer:
                    'The Aspire plan is based on gold weight accumulation, where you save towards a specific weight of gold. The Wishlist plan is value-based, where you save a fixed amount that grows over time. Both plans offer bonus months and loyalty benefits, but the redemption calculation differs based on the plan type.',
              ),
              const SizedBox(height: 16),
              _FAQItem(
                question: 'Can I upgrade or switch between plans?',
                answer:
                    'Yes, you can upgrade or switch between plans. However, certain terms and conditions apply. When switching plans, your accumulated value will be transferred to the new plan, and the benefits will be recalculated based on the new plan\'s structure. Please contact our customer service for detailed information on plan switching.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FAQItem extends StatefulWidget {
  final String question;
  final String answer;

  const _FAQItem({
    required this.question,
    required this.answer,
  });

  @override
  State<_FAQItem> createState() => _FAQItemState();
}

class _FAQItemState extends State<_FAQItem>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _iconRotation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _iconRotation = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _toggleExpanded,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFE5E5E5),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isHovered ? 0.06 : 0.02),
                blurRadius: _isHovered ? 12 : 4,
                offset: Offset(0, _isHovered ? 4 : 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.question,
                      style: TextStyle(
                        fontFamily: 'playfair',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _isExpanded || _isHovered
                            ? const Color(0xFFBFA05A)
                            : const Color(0xFF1A1A1A),
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  RotationTransition(
                    turns: _iconRotation,
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: _isExpanded || _isHovered
                          ? const Color(0xFFBFA05A)
                          : const Color(0xFF1A1A1A),
                      size: 24,
                    ),
                  ),
                ],
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: _isExpanded
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          Container(
                            height: 1,
                            color: const Color(0xFFE5E5E5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            widget.answer,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF6B6B6B),
                              height: 1.6,
                            ),
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
