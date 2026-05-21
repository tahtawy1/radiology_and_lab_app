import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:radiology_and_lab_app/core/constants/app_colors.dart';
import 'package:radiology_and_lab_app/features/appointment/presentation/cubit/appointment_cubit.dart';
import 'package:radiology_and_lab_app/features/appointment/presentation/cubit/appointment_state.dart';
import 'package:radiology_and_lab_app/features/results/presentation/cubit/results_cubit.dart';
import 'package:radiology_and_lab_app/features/results/presentation/cubit/results_state.dart';
import 'package:radiology_and_lab_app/features/appointment/domain/entites/appointment_enums.dart';

import '../shared/dashboard_card.dart';

class DoctorSummaryCards extends StatelessWidget {
  const DoctorSummaryCards({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentCubit, AppointmentState>(
      builder: (context, appState) {
        return BlocBuilder<ResultsCubit, ResultsState>(
          builder: (context, resultsState) {
            final pendingCount = appState.pendingDoctorAppointments.length;

            final now = DateTime.now();
            final approvedToday = appState.appointments.where((a) {
              final isApproved = a.status == AppointmentStatus.confirmed || a.status == AppointmentStatus.completed;
              final isToday = a.updatedAt.year == now.year && a.updatedAt.month == now.month && a.updatedAt.day == now.day;
              return isApproved && isToday;
            }).length;

            final reviewedCount = resultsState.results.where((r) => r.reviewedByDoctor).length;
            final criticalCount = resultsState.results.where((r) => r.classification?.toLowerCase() == 'critical').length;

            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        label: 'Pending Reviews',
                        value: pendingCount.toString(),
                        icon: Icons.pending_actions_outlined,
                        iconColor: Colors.orange,
                        iconBg: Colors.orange.shade50,
                      ),
                    ),
                    Expanded(
                      child: _StatCard(
                        label: 'Approved Today',
                        value: approvedToday.toString(),
                        icon: Icons.check_circle_outline,
                        iconColor: AppColors.successGreen,
                        iconBg: AppColors.successGreen.withValues(alpha: 0.1),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        label: 'Reviewed Results',
                        value: reviewedCount.toString(),
                        icon: Icons.fact_check_outlined,
                        iconColor: AppColors.primaryDark,
                        iconBg: const Color(0xFFE6FAF8),
                      ),
                    ),
                    Expanded(
                      child: _StatCard(
                        label: 'Critical Cases',
                        value: criticalCount.toString(),
                        icon: Icons.warning_amber_outlined,
                        iconColor: AppColors.errorRed,
                        iconBg: AppColors.errorBackground,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
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
