import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radiology_and_lab_app/core/constants/app_colors.dart';
import 'package:radiology_and_lab_app/features/appointment/domain/entites/appointment_entity.dart';
import 'package:radiology_and_lab_app/features/queue/presentation/cubit/queue_admin_cubit.dart';
import 'package:radiology_and_lab_app/features/queue/presentation/cubit/queue_admin_state.dart';

import '../shared/empty_state_widget.dart';

class ActiveQueuePreview extends StatelessWidget {
  const ActiveQueuePreview({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QueueAdminCubit, QueueAdminState>(
      builder: (context, state) {
        final active = state.queueEntries
            .where((e) =>
                e.queueStatus?.name == 'waiting' || e.queueStatus?.name == 'called')
            .toList();

        if (active.isEmpty) {
          return const EmptyStateWidget(
            message: 'No active queue entries',
            icon: Icons.queue_outlined,
          );
        }

        return Column(
          children: active.take(4).map((e) => _QueueTile(entry: e)).toList(),
        );
      },
    );
  }
}

class _QueueTile extends StatelessWidget {
  final AppointmentEntity entry;

  const _QueueTile({required this.entry});

  @override
  Widget build(BuildContext context) {
    final isCalled = entry.queueStatus?.name == 'called';
    final statusColor = isCalled ? Colors.blue : Colors.orange;
    final statusText = isCalled ? 'Called' : 'Waiting';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: statusColor.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.primaryDark,
            child: Text(
              '#${entry.queueNumber ?? '?'}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.patientName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  entry.testType,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
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
                color: statusColor,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
