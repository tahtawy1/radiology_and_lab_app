import 'package:flutter/material.dart';
import 'package:radiology_and_lab_app/features/appointment/domain/entites/appointment_entity.dart';
import 'package:radiology_and_lab_app/features/appointment/domain/entites/appointment_enums.dart';
import 'package:radiology_and_lab_app/features/appointment/presentation/widgets/patint/appointment_status_badge.dart';
import 'package:go_router/go_router.dart';
import 'package:radiology_and_lab_app/core/constants/app_strings.dart';

class AppointmentCard extends StatelessWidget {
  final AppointmentEntity appointment;
  final VoidCallback onCancel;

  const AppointmentCard({
    super.key,
    required this.appointment,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final isRadiology = appointment.department.toLowerCase() == 'radiology';
    final accentColor =
        isRadiology ? const Color(0xFF0D9488) : const Color(0xFFF59E0B);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 4, color: accentColor),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Row 1: date + status ──────────────────────────────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDate(appointment.appointmentDateTime),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          AppointmentStatusBadge(status: appointment.status),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // ── Row 2: department chip + queue chip ────────────────
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          _SmallChip(
                            label: appointment.department,
                            color: accentColor,
                            isColored: true,
                          ),
                          if (appointment.queueNumber != null)
                            _SmallChip(
                              icon: Icons.people_outline,
                              label: 'Queue #${appointment.queueNumber}',
                              color: Colors.grey,
                            ),
                          if (appointment.queueStatus != null)
                            _QueueStatusBadge(status: appointment.queueStatus!),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // ── Test type ─────────────────────────────────────────
                      Text(
                        appointment.testType,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0xFF1F2937),
                        ),
                      ),

                      // ── Referring doctor ────────────────────────────────────
                      if (appointment.doctorName.isNotEmpty) ...[
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Icon(
                              Icons.person_outline,
                              size: 13,
                              color: Colors.grey.shade500,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Ref: ${appointment.doctorName}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],

                      // ── Notes (optional) ────────────────────────────────────
                      if (appointment.notes != null &&
                          appointment.notes!.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.notes,
                                size: 13,
                                color: Colors.grey.shade500,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  appointment.notes!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      if (appointment.status !=
                          AppointmentStatus.cancelled) ...[
                        const SizedBox(height: 12),
                        const Divider(height: 1),
                        const SizedBox(height: 8),

                        // ── Action buttons ────────────────────────────────────
                        Builder(
                          builder: (context) {
                            if (appointment.status ==
                                AppointmentStatus.pending) {
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.info_outline,
                                        size: 14,
                                        color: Colors.orange.shade700,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Waiting doctor approval',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.orange.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    width: double.infinity,
                                    child: TextButton(
                                      onPressed: onCancel,
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.red.shade600,
                                      ),
                                      child: Text(
                                        'Cancel Appointment',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.red.shade600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            } else if (appointment.status ==
                                AppointmentStatus.confirmed) {
                              if (appointment.queueStatus == null) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.blue.shade100,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.hourglass_empty,
                                        size: 16,
                                        color: Colors.blue.shade700,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Medically Approved - Awaiting Queue',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.blue.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                // If served, show result status
                                if (appointment.queueStatus ==
                                    QueueStatus.served) {
                                  if (appointment.resultUploaded) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.green.shade100,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.upload_file,
                                            size: 16,
                                            color: Colors.green.shade700,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Result Uploaded - Awaiting Review',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.green.shade700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.orange.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.orange.shade100,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.science_outlined,
                                            size: 16,
                                            color: Colors.orange.shade700,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Patient Served - Processing Result',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.orange.shade700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                }

                                return SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      context.push(
                                        AppStrings.queuePatientRoute,
                                      );
                                    },
                                    icon: const Icon(Icons.queue, size: 18),
                                    label: const Text('View Queue'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFF0FDF4),
                                      foregroundColor: const Color(0xFF0D9488),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            } else if (appointment.status ==
                                AppointmentStatus.completed) {
                              return SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    context.push(
                                      AppStrings.patientResultsRoute,
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.assignment_turned_in_outlined,
                                    size: 18,
                                  ),
                                  label: const Text('Show Result'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFEFF6FF),
                                    foregroundColor: const Color(0xFF1E40AF),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}

// ── Queue status badge ────────────────────────────────────────────────────────
class _QueueStatusBadge extends StatelessWidget {
  final QueueStatus status;

  const _QueueStatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;
    String label;

    switch (status) {
      case QueueStatus.waiting:
        color = Colors.blue;
        icon = Icons.hourglass_empty;
        label = 'Waiting';
        break;
      case QueueStatus.called:
        color = Colors.orange;
        icon = Icons.notifications_active;
        label = 'Called';
        break;
      case QueueStatus.served:
        color = Colors.green;
        icon = Icons.check_circle_outline;
        label = 'Served';
        break;
      case QueueStatus.no_show:
        color = Colors.red;
        icon = Icons.person_off_outlined;
        label = 'No Show';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Small info chip ───────────────────────────────────────────────────────────
class _SmallChip extends StatelessWidget {
  final String label;
  final Color color;
  final bool isColored;
  final IconData? icon;

  const _SmallChip({
    required this.label,
    required this.color,
    this.isColored = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isColored ? color.withOpacity(0.1) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 12,
              color: isColored ? color : Colors.grey.shade600,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isColored ? color : Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
