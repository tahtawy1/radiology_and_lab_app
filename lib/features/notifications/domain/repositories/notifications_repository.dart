import 'package:radiology_and_lab_app/features/notifications/domain/entites/notification_entity.dart';

abstract class NotificationsRepository {
  Stream<List<NotificationEntity>> getNotifications(String userId, String role);
  Future<void> markAsRead(String notificationId);
}
