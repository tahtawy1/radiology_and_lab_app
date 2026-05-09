import 'package:flutter/material.dart';
import 'package:radiology_and_lab_app/core/constants/app_colors.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 80, bottom: 60),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryDark, AppColors.primaryLight],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.glassWhite20,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 40, color: AppColors.white),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.white),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.glassWhite10,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.badgeBorder),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock_outline, size: 14, color: AppColors.white),
                const SizedBox(width: 6),
                Text(subtitle, style: const TextStyle(color: AppColors.white, fontSize: 12)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
