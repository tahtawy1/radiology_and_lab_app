import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:radiology_and_lab_app/core/constants/app_colors.dart';
import 'package:radiology_and_lab_app/core/constants/app_strings.dart';
import 'package:radiology_and_lab_app/features/queue/presentation/cubit/queue_patient_cubit.dart';
import 'package:radiology_and_lab_app/features/queue/presentation/cubit/queue_patient_state.dart';

/// Shows the patient's live queue position ONLY when queueStatus is not null.
/// Hidden when patient has not yet physically checked in.
class LiveQueueCard extends StatelessWidget {
  const LiveQueueCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QueuePatientCubit, QueuePatientState>(
      builder: (context, state) {
        final entry = state.queueEntry;

        // Enforce business rule: hide if no physical check-in yet
        if (entry == null || entry.queueStatus == null) {
          return const SizedBox.shrink();
        }

        final isCalled = entry.queueStatus?.name == 'called';
        final isServed = entry.queueStatus?.name == 'served';
        if (isServed) return const SizedBox.shrink();

        final gradientColors =
            isCalled
                ? [const Color(0xFFFF8C00), const Color(0xFFFFB347)]
                : [AppColors.gradientTop, AppColors.gradientMid];
        final statusText = isCalled ? "IT'S YOUR TURN!" : 'Waiting in Queue';
        final subText =
            isCalled
                ? 'Please proceed to the reception desk'
                : '${state.patientsAhead} patient(s) ahead • ${entry.department}';

        return Container(
          padding: const EdgeInsets.all(18),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: gradientColors.first.withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white.withValues(alpha: 0.25),
                child: Text(
                  '#${entry.queueNumber ?? '?'}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      statusText,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subText,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => context.push(AppStrings.queuePatientRoute),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Track',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
