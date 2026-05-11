import 'package:flutter/material.dart';
import 'package:radiology_and_lab_app/features/home/view/widgets/avatar_circle.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    super.key,
    required this.greeting,
    required this.patientName,
    required this.avatarInitials,
  });

  final String greeting;
  final String patientName;
  final String avatarInitials;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          // Medical cross icon
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.chipTeal,
              borderRadius: BorderRadius.circular(8),
              image: const DecorationImage(
                image: AssetImage('assets/images/logo.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Greeting text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(greeting, style: AppTypography.headerGreeting),
                Text(patientName, style: AppTypography.headerName),
              ],
            ),
          ),

          // Avatar circle
          AvatarCircle(initials: avatarInitials),
        ],
      ),
    );
  }
}
