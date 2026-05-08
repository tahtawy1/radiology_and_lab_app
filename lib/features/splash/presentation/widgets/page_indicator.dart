import 'package:flutter/material.dart';
import 'package:radiology_and_lab_app/core/constants/app_colors.dart';

class PageIndicator extends StatelessWidget {
  const PageIndicator({super.key});
  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      minHeight: 6,
      borderRadius: BorderRadius.circular(12),
      color: AppColors.progressActive,
      backgroundColor: AppColors.progressInactive,
    );
  }
}
