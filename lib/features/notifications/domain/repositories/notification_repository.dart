import '../entites/notification_entity.dart';

abstract class NotificationRepository {
  /// Persist a new notification document to Firestore.
  Future<void> sendNotification(NotificationEntity notification);

  /// Stream of this user's notifications, ordered newest-first.
  Stream<List<NotificationEntity>> getUserNotifications(String userId);

  /// Flip isRead to true for a single document.
  Future<void> markAsRead(String notificationId);
}
