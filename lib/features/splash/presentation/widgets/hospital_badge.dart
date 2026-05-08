import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:radiology_and_lab_app/core/constants/app_colors.dart';
import 'package:radiology_and_lab_app/core/constants/app_text_styles.dart';

class HospitalBadge extends StatelessWidget {
  const HospitalBadge({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.667,
            vertical: 6.667,
          ),
          decoration: BoxDecoration(
            color: AppColors.glassWhite10,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.badgeBorder),
          ),
          child: Text(name, style: AppTypography.badge),
        ),
      ),
    );
  }
}
