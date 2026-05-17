import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

import 'package:radiology_and_lab_app/core/constants/app_colors.dart';
import 'package:radiology_and_lab_app/core/constants/app_strings.dart';
import 'package:radiology_and_lab_app/features/appointment/domain/entites/appointment_entity.dart';
import 'package:radiology_and_lab_app/features/appointment/presentation/cubit/appointment_cubit.dart';
import 'package:radiology_and_lab_app/features/appointment/presentation/cubit/appointment_state.dart';

import '../shared/dashboard_card.dart';
import '../shared/empty_state_widget.dart';

class PendingRequestsSection extends StatelessWidget {
  const PendingRequestsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentCubit, AppointmentState>(
      builder: (context, state) {
        if (state is AppointmentLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is! AppointmentsLoaded || state.appointments.isEmpty) {
          return const EmptyStateWidget(
            message: 'No pending requests',
            icon: Icons.check_circle_outline,
          );
        }

        final pending = state.appointments.take(5).toList();

        return Column(
          children: pending.map((appt) => _PendingCard(appt: appt)).toList(),
        );
      },
    );
  }
}

class _PendingCard extends StatelessWidget {
  final AppointmentEntity appt;

  const _PendingCard({required this.appt});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DashboardCard(
        padding: const EdgeInsets.all(16),
        borderColor: Colors.orange.withValues(alpha: 0.25),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.person_outlined, color: Colors.orange, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appt.patientName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${appt.testType} • ${appt.department}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () async {
                await context.push(
                  AppStrings.doctorApprovalRoute,
                  extra: {'showBackButton': true},
                );
                if (context.mounted) {
                  final user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    context.read<AppointmentCubit>().getPendingAppointmentsForDoctor(user.uid);
                  }
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryDark,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Review',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
