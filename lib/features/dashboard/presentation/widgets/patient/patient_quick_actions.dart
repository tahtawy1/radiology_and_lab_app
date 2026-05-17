import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:radiology_and_lab_app/core/constants/app_colors.dart';
import 'package:radiology_and_lab_app/core/constants/app_strings.dart';

/// Patient-specific grid of quick action cards.
class PatientQuickActions extends StatelessWidget {
  const PatientQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = [
      _ActionItem(
        icon: Icons.add_circle_outline,
        label: 'Book Appointment',
        color: AppColors.primaryDark,
        bg: const Color(0xFFE6FAF8),
        onTap: () => context.push(AppStrings.bookAppointmentRoute),
      ),
      _ActionItem(
        icon: Icons.assignment_outlined,
        label: 'My Appointments',
        color: Colors.blue,
        bg: Colors.blue.shade50,
        onTap: () => context.push(AppStrings.myAppointmentsRoute),
      ),
      _ActionItem(
        icon: Icons.queue_outlined,
        label: 'My Queue',
        color: Colors.orange,
        bg: Colors.orange.shade50,
        onTap: () => context.push(AppStrings.queuePatientRoute),
      ),
      _ActionItem(
        icon: Icons.science_outlined,
        label: 'Results',
        color: Colors.purple,
        bg: Colors.purple.shade50,
        onTap: () {},
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: item.onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.surfaceWhite,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: item.bg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(item.icon, color: item.color, size: 24),
                ),
                const SizedBox(height: 12),
                Text(
                  item.label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
