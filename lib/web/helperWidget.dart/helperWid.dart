import 'package:flutter/material.dart';

import '../../model/customerModel.dart';

List<Color> getStatusColors(CustomerStatus status) {
  switch (status) {
    case CustomerStatus.pending:
      return [
        Color(0xFFFFF8E1), // Light amber
        Color(0xFFFFF3C4), // Lighter amber
      ];
    case CustomerStatus.approved:
      return [
        Color(0xFFE8F5E8), // Light green
        Color(0xFFF1F8E9), // Lighter green
      ];
    case CustomerStatus.rejected:
      return [
        Color(0xFFFFEBEE), // Light red
        Color(0xFFFFF5F5), // Lighter red
      ];
    default:
      return [Colors.grey.shade100, Colors.grey.shade50];
  }
}

Color getStatusBorderColor(CustomerStatus status) {
  switch (status) {
    case CustomerStatus.pending:
      return Color(0xFFFFCC02).withOpacity(0.3);
    case CustomerStatus.approved:
      return Color(0xFF4CAF50).withOpacity(0.3);
    case CustomerStatus.rejected:
      return Color(0xFFF44336).withOpacity(0.3);
    default:
      return Colors.grey.withOpacity(0.3);
  }
}

Color getStatusShadowColor(CustomerStatus status) {
  switch (status) {
    case CustomerStatus.pending:
      return Color(0xFFFFCC02).withOpacity(0.1);
    case CustomerStatus.approved:
      return Color(0xFF4CAF50).withOpacity(0.1);
    case CustomerStatus.rejected:
      return Color(0xFFF44336).withOpacity(0.1);
    default:
      return Colors.grey.withOpacity(0.1);
  }
}

Color getStatusIndicatorColor(CustomerStatus status) {
  switch (status) {
    case CustomerStatus.pending:
      return Color(0xFFFFB300); // Amber
    case CustomerStatus.approved:
      return Color(0xFF4CAF50); // Green
    case CustomerStatus.rejected:
      return Color(0xFFF44336); // Red
    default:
      return Colors.grey;
  }
}

Color getStatusTextColor(CustomerStatus status) {
  switch (status) {
    case CustomerStatus.pending:
      return Color(0xFF8A6914); // Dark amber
    case CustomerStatus.approved:
      return Color(0xFF2E7D32); // Dark green
    case CustomerStatus.rejected:
      return Color(0xFFC62828); // Dark red
    default:
      return Colors.grey.shade700;
  }
}

String getStatusText(CustomerStatus status) {
  switch (status) {
    case CustomerStatus.pending:
      return "Pending";
    case CustomerStatus.approved:
      return "Approved";
    case CustomerStatus.rejected:
      return "Rejected";
    default:
      return SchemeUserModel.statusToString(status).toString();
  }
}
