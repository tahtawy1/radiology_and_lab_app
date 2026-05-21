import '../../domain/entites/notification_entity.dart';

abstract class NotificationsState {
  final List<NotificationEntity> notifications;
  final int unreadCount;

  NotificationsState({
    this.notifications = const [],
  }) : unreadCount = notifications.where((n) => !n.isRead).length;
}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {
  NotificationsLoading({super.notifications});
}

class NotificationsLoaded extends NotificationsState {
  NotificationsLoaded({required super.notifications});
}

class NotificationsError extends NotificationsState {
  final String message;
  NotificationsError(this.message, {super.notifications});
}
