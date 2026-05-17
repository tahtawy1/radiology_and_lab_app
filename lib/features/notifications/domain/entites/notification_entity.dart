/// Enum for all notification types in the hospital workflow.
enum NotificationType {
  appointmentApproved,
  appointmentRejected,
  queueCalled,
  resultUploaded,
  resultReviewed,
  newAppointmentRequest,
  reviewCompleted,
  uploadFailed,
}

class NotificationEntity {
  final String id;
  final String userId;
  final String title;
  final String body;
  final NotificationType type;
  final bool isRead;
  final DateTime createdAt;

  const NotificationEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    required this.isRead,
    required this.createdAt,
  });
}
