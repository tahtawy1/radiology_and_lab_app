import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:radiology_and_lab_app/core/constants/app_colors.dart';
import 'package:radiology_and_lab_app/core/constants/app_strings.dart';

class DoctorQuickActions extends StatelessWidget {
  const DoctorQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = [
      _ActionItem(
        icon: Icons.rate_review_outlined,
        label: 'Pending Requests',
        color: Colors.orange,
        bg: Colors.orange.shade50,
        onTap: () => context.push(AppStrings.doctorApprovalRoute),
      ),
      _ActionItem(
        icon: Icons.science_outlined,
        label: 'Pending Reviews',
        color: Colors.purple,
        bg: Colors.purple.shade50,
        onTap: () {}, // MVP placeholder
      ),
      _ActionItem(
        icon: Icons.fact_check_outlined,
        label: 'Reviewed Results',
        color: AppColors.primaryDark,
        bg: const Color(0xFFE6FAF8),
        onTap: () {}, // MVP placeholder
      ),
      _ActionItem(
        icon: Icons.queue_outlined,
        label: 'Queue Overview',
        color: Colors.blue,
        bg: Colors.blue.shade50,
        onTap: () {}, // MVP placeholder
      ),
    ];

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _QuickActionCard(item: actions[0])),
            const SizedBox(width: 12),
            Expanded(child: _QuickActionCard(item: actions[1])),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _QuickActionCard(item: actions[2])),
            const SizedBox(width: 12),
            Expanded(child: _QuickActionCard(item: actions[3])),
          ],
        ),
      ],
    );
  }
}

class _ActionItem {
  final IconData icon;
  final String label;
  final Color color;
  final Color bg;
  final VoidCallback onTap;

  const _ActionItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.bg,
    required this.onTap,
  });
}

class _QuickActionCard extends StatelessWidget {
  final _ActionItem item;

  const _QuickActionCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: AppColors.surfaceWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: item.bg, shape: BoxShape.circle),
              child: Icon(item.icon, color: item.color, size: 24),
            ),
            const SizedBox(height: 10),
            Text(
              item.label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
