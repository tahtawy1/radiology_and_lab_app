import 'package:flutter/material.dart';
import 'package:radiology_and_lab_app/features/appointment/domain/entites/appointment_entity.dart';
import 'package:radiology_and_lab_app/features/appointment/presentation/widgets/patint/appointment_status_badge.dart';

class DoctorApprovalCard extends StatelessWidget {
  final AppointmentEntity appointment;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const DoctorApprovalCard({
    super.key,
    required this.appointment,
    required this.onApprove,
    required this.onReject,
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
            color: Colors.black.withValues(alpha: 0.05),
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
                      Text(
                        appointment.patientName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 6),
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
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        appointment.testType,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Divider(height: 1),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: onReject,
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red.shade600,
                              ),
                              child: Text(
                                'Reject',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red.shade600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: onApprove,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0D9488),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Approve',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
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
}

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
        color: isColored ? color.withValues(alpha: 0.1) : Colors.grey.shade100,
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
