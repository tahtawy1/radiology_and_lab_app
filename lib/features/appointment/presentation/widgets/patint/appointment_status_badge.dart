import 'package:flutter/material.dart';
import 'package:radiology_and_lab_app/features/appointment/domain/entites/appointment_enums.dart';

class AppointmentStatusBadge extends StatelessWidget {
  final AppointmentStatus status;

  const AppointmentStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;

    switch (status) {
      case AppointmentStatus.confirmed:
        backgroundColor = const Color(0xFFD1FAE5); // Light emerald
        textColor = const Color(0xFF065F46); // Dark emerald
        break;
      case AppointmentStatus.pending:
        backgroundColor = const Color(0xFFFEF3C7); // Light amber
        textColor = const Color(0xFF92400E); // Dark amber
        break;
      case AppointmentStatus.completed:
        backgroundColor = const Color(0xFFDBEAFE); // Light blue
        textColor = const Color(0xFF1E40AF); // Dark blue
        break;
      case AppointmentStatus.cancelled:
        backgroundColor = const Color(0xFFFEE2E2); // Light red
        textColor = const Color(0xFF991B1B); // Dark red
        break;
    }

    final String label =
        status.name[0].toUpperCase() + status.name.substring(1).toLowerCase();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
