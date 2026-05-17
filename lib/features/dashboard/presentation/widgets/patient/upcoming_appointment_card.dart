import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:radiology_and_lab_app/core/constants/app_colors.dart';
import 'package:radiology_and_lab_app/core/constants/app_strings.dart';
import 'package:radiology_and_lab_app/features/appointment/domain/entites/appointment_enums.dart';
import 'package:radiology_and_lab_app/features/appointment/presentation/cubit/appointment_cubit.dart';
import 'package:radiology_and_lab_app/features/appointment/presentation/cubit/appointment_state.dart';

import '../shared/dashboard_card.dart';
import '../shared/dashboard_section_title.dart';

/// Shows the most immediate upcoming appointment (pending or confirmed).
class UpcomingAppointmentCard extends StatelessWidget {
  const UpcomingAppointmentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentCubit, AppointmentState>(
      builder: (context, state) {
        if (state is! AppointmentsLoaded) return const SizedBox.shrink();

        final upcoming = state.appointments
            .where((a) =>
                (a.status == AppointmentStatus.pending ||
                 a.status == AppointmentStatus.confirmed) &&
                !a.appointmentDateTime.isBefore(
                    DateTime.now().subtract(const Duration(hours: 1))))
            .toList();

        // Sort by closest date
        upcoming.sort((a, b) => a.appointmentDateTime.compareTo(b.appointmentDateTime));

        if (upcoming.isEmpty) return const SizedBox.shrink();
        final next = upcoming.first;

        final isConfirmed = next.status == AppointmentStatus.confirmed;
        final statusColor = isConfirmed ? AppColors.successGreen : Colors.orange;
        final statusText = isConfirmed ? 'Confirmed' : 'Pending Approval';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DashboardSectionTitle(
              title: 'Upcoming Appointment',
              actionLabel: 'View All',
              onAction: () => context.go(AppStrings.myAppointmentsRoute),
            ),
            const SizedBox(height: 14),
            DashboardCard(
              borderColor: statusColor.withValues(alpha: 0.3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          next.testType,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          statusText,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _InfoRow(icon: Icons.local_hospital_outlined, text: next.department),
                  const SizedBox(height: 6),
                  _InfoRow(
                    icon: Icons.calendar_today_outlined,
                    text: '${next.appointmentDateTime.day}/${next.appointmentDateTime.month}/${next.appointmentDateTime.year}',
                  ),
                  if (next.doctorName.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    _InfoRow(icon: Icons.person_outline, text: 'Dr. ${next.doctorName}'),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
