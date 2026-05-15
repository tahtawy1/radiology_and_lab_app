import 'package:flutter/material.dart';
import 'package:radiology_and_lab_app/features/appointment/domain/entites/appointment_entity.dart';
import 'package:radiology_and_lab_app/features/appointment/presentation/widgets/appointment_status_badge.dart';

class AppointmentCard extends StatelessWidget {
  final AppointmentEntity appointment;
  final VoidCallback onCancel;
  final VoidCallback onReschedule;

  const AppointmentCard({
    super.key,
    required this.appointment,
    required this.onCancel,
    required this.onReschedule,
  });

  @override
  Widget build(BuildContext context) {
    final isRadiology = appointment.department.toLowerCase() == 'radiology';
    final accentColor = isRadiology ? const Color(0xFF0D9488) : const Color(0xFFF59E0B);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Coloured left accent bar
              Container(width: 4, color: accentColor),
              // Card content
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
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
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
                          if (appointment.queueNumber > 0)
                            _SmallChip(
                              icon: Icons.people_outline,
                              label: 'Queue #${appointment.queueNumber}',
                              color: Colors.grey,
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // ── Test type ─────────────────────────────────────────
                      Text(
                        appointment.testType,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1F2937)),
                      ),

                      // ── Referring doctor ────────────────────────────────────
                      if (appointment.doctorName.isNotEmpty) ...[
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Icon(Icons.person_outline, size: 13, color: Colors.grey.shade500),
                            const SizedBox(width: 4),
                            Text(
                              'Ref: ${appointment.doctorName}',
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ],

                      // ── Notes (optional) ────────────────────────────────────
                      if (appointment.notes != null && appointment.notes!.isNotEmpty) ...[
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
                              Icon(Icons.notes, size: 13, color: Colors.grey.shade500),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  appointment.notes!,
                                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600, height: 1.3),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 12),
                      const Divider(height: 1),
                      const SizedBox(height: 8),

                      // ── Action buttons ────────────────────────────────────
                      Builder(
                        builder: (context) {
                          final canCancel = appointment.status == 'pending' || 
                                          (appointment.status == 'confirmed' && appointment.queueStatus == 'waiting');
                          
                          return Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                  onPressed: canCancel ? onCancel : () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Cannot cancel this appointment at its current stage.')),
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: canCancel ? Colors.red.shade600 : Colors.grey.shade400,
                                  ),
                                  child: Text('Cancel', style: TextStyle(fontWeight: FontWeight.w600, color: canCancel ? Colors.red.shade600 : Colors.grey.shade400)),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: onReschedule,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFF0FDF4),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: const Text(
                                    'Reschedule',
                                    style: TextStyle(color: Color(0xFF0D9488), fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
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
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
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
            Icon(icon, size: 12, color: isColored ? color : Colors.grey.shade600),
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
