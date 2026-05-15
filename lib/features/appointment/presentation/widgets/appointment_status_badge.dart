import 'package:flutter/material.dart';

class AppointmentStatusBadge extends StatelessWidget {
  final String status;

  const AppointmentStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'confirmed':
        backgroundColor = const Color(0xFFD1FAE5); // Light emerald
        textColor = const Color(0xFF065F46); // Dark emerald
        break;
      case 'pending':
        backgroundColor = const Color(0xFFFEF3C7); // Light amber
        textColor = const Color(0xFF92400E); // Dark amber
        break;
      case 'cancelled':
        backgroundColor = const Color(0xFFFEE2E2); // Light red
        textColor = const Color(0xFF991B1B); // Dark red
        break;
      default:
        backgroundColor = Colors.grey.shade200;
        textColor = Colors.grey.shade800;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status[0].toUpperCase() + status.substring(1).toLowerCase(),
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
