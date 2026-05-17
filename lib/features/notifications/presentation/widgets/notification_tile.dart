import 'package:flutter/material.dart';
import '../../domain/entites/notification_entity.dart';

/// A single notification tile shown in the notifications list.
class NotificationTile extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback onTap;

  const NotificationTile({
    super.key,
    required this.notification,
    required this.onTap,
  });

  // ── Icon + colour per type ───────────────────────────────────────────────
  _TypeStyle get _style {
    switch (notification.type) {
      case NotificationType.appointmentApproved:
        return _TypeStyle(
          icon: Icons.check_circle_outline,
          color: const Color(0xFF0D9488),
          label: 'Appointment',
        );
      case NotificationType.appointmentRejected:
        return _TypeStyle(
          icon: Icons.cancel_outlined,
          color: const Color(0xFFEF4444),
          label: 'Appointment',
        );
      case NotificationType.queueCalled:
        return _TypeStyle(
          icon: Icons.queue_outlined,
          color: const Color(0xFF6366F1),
          label: 'Queue',
        );
      case NotificationType.resultUploaded:
        return _TypeStyle(
          icon: Icons.upload_file_outlined,
          color: const Color(0xFFF59E0B),
          label: 'Result',
        );
      case NotificationType.resultReviewed:
        return _TypeStyle(
          icon: Icons.verified_outlined,
          color: const Color(0xFF10B981),
          label: 'Result',
        );
      case NotificationType.newAppointmentRequest:
        return _TypeStyle(
          icon: Icons.calendar_today_outlined,
          color: const Color(0xFF3B82F6),
          label: 'Request',
        );
      case NotificationType.reviewCompleted:
        return _TypeStyle(
          icon: Icons.fact_check_outlined,
          color: const Color(0xFF8B5CF6),
          label: 'Reviewed',
        );
      case NotificationType.uploadFailed:
        return _TypeStyle(
          icon: Icons.error_outline,
          color: const Color(0xFFEF4444),
          label: 'Error',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = _style;
    final isUnread = !notification.isRead;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.shade200,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left accent bar (always visible in this design)
              Container(
                width: 4,
                decoration: BoxDecoration(
                  color: style.color,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon bubble
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: style.color.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          style.icon,
                          color: style.color,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Title + body + time
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    notification.title,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: isUnread
                                          ? FontWeight.w800
                                          : FontWeight.w600,
                                      color: const Color(0xFF1E293B),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _relativeTime(notification.createdAt),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF94A3B8),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              notification.body,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF64748B),
                                height: 1.4,
                              ),
                            ),
                            
                            // Optional placeholder for action button space
                            // The user's image has action buttons but without deep links we leave it simple or add a generic one
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: _buildActionButton(style),
                            ),
                          ],
                        ),
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

  // Generic action button builder based on the style/type
  Widget _buildActionButton(_TypeStyle style) {
    if (notification.type == NotificationType.resultReviewed || 
        notification.type == NotificationType.resultUploaded) {
      return ElevatedButton(
        onPressed: onTap, // Just triggers the read action for now
        style: ElevatedButton.styleFrom(
          backgroundColor: style.color,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          minimumSize: const Size(0, 32),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text('View Report', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      );
    } else if (notification.type == NotificationType.queueCalled) {
      return OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: style.color,
          side: BorderSide(color: style.color.withOpacity(0.5)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          minimumSize: const Size(0, 32),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text('Track Queue', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      );
    } else if (notification.type == NotificationType.appointmentApproved) {
      return OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF475569),
          side: const BorderSide(color: Color(0xFFCBD5E1)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          minimumSize: const Size(0, 32),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text('Add to Calendar', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      );
    }
    
    // Default or fallback empty box
    return const SizedBox.shrink();
  }

  // ── Relative time helper ─────────────────────────────────────────────────
  String _relativeTime(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    final d = dateTime;
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[d.month - 1]} ${d.day}';
  }
}

class _TypeStyle {
  final IconData icon;
  final Color color;
  final String label;
  const _TypeStyle({
    required this.icon,
    required this.color,
    required this.label,
  });
}
