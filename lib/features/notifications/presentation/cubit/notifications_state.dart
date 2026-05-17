import '../../domain/entites/notification_entity.dart';

abstract class NotificationsState {}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsLoaded extends NotificationsState {
  final List<NotificationEntity> notifications;
  final int unreadCount;

  NotificationsLoaded({
    required this.notifications,
  }) : unreadCount = notifications.where((n) => !n.isRead).length;
}

class NotificationsError extends NotificationsState {
  final String message;
  NotificationsError(this.message);
}
