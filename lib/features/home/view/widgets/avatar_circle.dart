import 'package:flutter/material.dart';
import 'package:radiology_and_lab_app/core/constants/app_colors.dart';
import 'package:radiology_and_lab_app/core/theme/app_typography.dart';

class AvatarCircle extends StatelessWidget {
  const AvatarCircle({super.key, required this.initials});

  final String initials;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.chipBg,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.cardBorder, width: 1.5),
      ),
      alignment: Alignment.center,
      child: Text(initials, style: AppTypography.avatarLabel),
    );
  }
}
