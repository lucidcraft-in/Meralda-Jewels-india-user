import 'package:flutter/material.dart';

import '../webRegistration.dart';

Widget noSchemeSec(var user) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final isSmallScreen = constraints.maxWidth < 600;
      final isMediumScreen =
          constraints.maxWidth >= 600 && constraints.maxWidth < 900;

      if (isSmallScreen) {
        // Mobile layout
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.orange.shade200, width: 2),
                ),
                child: Icon(
                  Icons.person_off_outlined,
                  size: 48,
                  color: Colors.orange.shade600,
                ),
              ),

              SizedBox(height: 20),

              // Title
              Text(
                'No Scheme Available',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),

              SizedBox(height: 10),

              // Description
              Text(
                'This user doesn\'t have an active scheme. Please contact support to set up a scheme.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),

              SizedBox(height: 20),

              // Add New Scheme Button
              _buildAddAccountCard(context, user),

              SizedBox(height: 16),

              // Info Card
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 18,
                      color: Colors.blue.shade600,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Need Help?',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.blue.shade700,
                              fontSize: 13,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'Our support team will help you set up a scheme.',
                            style: TextStyle(
                              color: Colors.blue.shade600,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      } else if (isMediumScreen) {
        // Tablet layout
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon and text side by side
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Icon
                  Container(
                    padding: EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(22),
                      border:
                          Border.all(color: Colors.orange.shade200, width: 2),
                    ),
                    child: Icon(
                      Icons.person_off_outlined,
                      size: 56,
                      color: Colors.orange.shade600,
                    ),
                  ),

                  SizedBox(width: 20),

                  // Text content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          'No Scheme Available',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),

                        SizedBox(height: 10),

                        // Description
                        Text(
                          'This user doesn\'t have an active scheme. Please contact support to set up a scheme that suits your needs.',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[600],
                            height: 1.5,
                          ),
                        ),

                        SizedBox(height: 16),

                        // Add New Scheme Button
                        _buildAddAccountCard(context, user),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24),

              // Info Card
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 22,
                      color: Colors.blue.shade600,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Need Help?',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.blue.shade700,
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Our support team will help you set up a scheme that suits your needs.',
                            style: TextStyle(
                              color: Colors.blue.shade600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      } else {
        // Desktop layout
        return Container(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Container(
                padding: EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.orange.shade200, width: 2),
                ),
                child: Icon(
                  Icons.person_off_outlined,
                  size: 64,
                  color: Colors.orange.shade600,
                ),
              ),

              SizedBox(height: 24),

              // Title
              Text(
                'No Scheme Available',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),

              SizedBox(height: 12),

              // Description
              Text(
                'This user doesn\'t have an active scheme.\nPlease contact support to set up a scheme.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),

              SizedBox(height: 24),

              // Add New Scheme Button
              _buildAddAccountCard(context, user),

              SizedBox(height: 24),

              // Info Card
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 24,
                      color: Colors.blue.shade600,
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Need Help?',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.blue.shade700,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Our support team will help you set up a scheme that suits your needs.',
                            style: TextStyle(
                              color: Colors.blue.shade600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
    },
  );
}

Widget _buildAddAccountCard(BuildContext context, var user) {
  return GestureDetector(
    onTap: () {
      print(user);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => UserRegistrationDialog(
          type: "add",
          user: user,
        ),
      );
    },
    child: Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 27, 69, 38).withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Color.fromARGB(255, 27, 69, 38).withOpacity(0.05),
          width: 1.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left icon
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 27, 69, 38),
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 24,
            ),
          ),

          const SizedBox(width: 14),

          // Middle text section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add New Scheme',
                  style: TextStyle(
                    color: Color.fromARGB(255, 27, 69, 38),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Create multiple schemes for customers',
                  style: TextStyle(
                    color: Color.fromARGB(255, 27, 69, 38),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Right button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Color.fromARGB(255, 27, 69, 38)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Icons.person_add,
                  color: Color.fromARGB(255, 27, 69, 38),
                  size: 14,
                ),
                SizedBox(width: 6),
                Text(
                  'Create',
                  style: TextStyle(
                    color: Color.fromARGB(255, 27, 69, 38),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
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
