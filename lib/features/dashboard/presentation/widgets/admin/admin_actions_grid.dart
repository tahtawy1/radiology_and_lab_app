import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:radiology_and_lab_app/core/constants/app_colors.dart';
import 'package:radiology_and_lab_app/core/constants/app_strings.dart';
import 'package:radiology_and_lab_app/features/queue/presentation/cubit/queue_admin_cubit.dart';

class AdminActionsGrid extends StatelessWidget {
  final String department;

  const AdminActionsGrid({super.key, required this.department});

  @override
  Widget build(BuildContext context) {
    final actions = [
      _ActionItem(
        icon: Icons.queue_outlined,
        label: 'Manage Queue',
        color: AppColors.primaryDark,
        bg: const Color(0xFFE6FAF8),
        onTap: () => context.push(AppStrings.queueAdminRoute, extra: {'showBackButton': true}),
      ),
      _ActionItem(
        icon: Icons.notifications_active_outlined,
        label: 'Call Next',
        color: Colors.orange,
        bg: Colors.orange.shade50,
        onTap: () {
          context.read<QueueAdminCubit>().callNextPatient(
            department: department,
          );
        },
      ),
      _ActionItem(
        icon: Icons.upload_file_outlined,
        label: 'Upload Results',
        color: Colors.purple,
        bg: Colors.purple.shade50,
        onTap: () => context.push(AppStrings.servedPatientsResultsRoute),
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
            const Expanded(child: SizedBox()),
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
