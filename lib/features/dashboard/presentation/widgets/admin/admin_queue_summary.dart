import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:radiology_and_lab_app/core/constants/app_colors.dart';
import 'package:radiology_and_lab_app/features/queue/presentation/cubit/queue_admin_cubit.dart';
import 'package:radiology_and_lab_app/features/queue/presentation/cubit/queue_admin_state.dart';

import '../shared/dashboard_card.dart';

class AdminQueueSummary extends StatelessWidget {
  const AdminQueueSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QueueAdminCubit, QueueAdminState>(
      builder: (context, state) {
        final totalToday = state.totalToday;
        final waiting = state.queueEntries
            .where((e) => e.queueStatus?.name == 'waiting')
            .length;
        final called = state.called;
        final served = state.served;

        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    label: 'Total Today',
                    value: totalToday.toString(),
                    icon: Icons.people_outline,
                    iconColor: AppColors.primaryDark,
                    iconBg: const Color(0xFFE6FAF8),
                  ),
                ),

                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    label: 'Waiting',
                    value: waiting.toString(),
                    icon: Icons.hourglass_empty_outlined,
                    iconColor: Colors.orange,
                    iconBg: Colors.orange.shade50,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    label: 'Called',
                    value: called.toString(),
                    icon: Icons.notifications_active_outlined,
                    iconColor: Colors.blue,
                    iconBg: Colors.blue.shade50,
                  ),
                ),

                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    label: 'Served',
                    value: served.toString(),
                    icon: Icons.check_circle_outline,
                    iconColor: AppColors.successGreen,
                    iconBg: AppColors.successGreen.withValues(alpha: 0.1),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
  });

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
