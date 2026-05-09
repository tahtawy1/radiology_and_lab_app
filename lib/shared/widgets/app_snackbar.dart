import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class AppSnackBar {
  static void showSuccess(BuildContext context, String message) {
    _showSnackBar(
      context,
      message,
      AppColors.successGreen,
      Icons.check_circle_outline,
    );
  }

  static void showError(BuildContext context, String message) {
    _showSnackBar(context, message, AppColors.errorRed, Icons.error_outline);
  }

  static void showInfo(BuildContext context, String message) {
    _showSnackBar(context, message, AppColors.primaryDark, Icons.info_outline);
  }

  static void _showSnackBar(
    BuildContext context,
    String message,
    Color backgroundColor,
    IconData icon,
  ) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
