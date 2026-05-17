import '../repositories/notification_repository.dart';

class MarkNotificationAsReadUseCase {
  final NotificationRepository _repository;

  const MarkNotificationAsReadUseCase(this._repository);

  Future<void> call(String notificationId) =>
      _repository.markAsRead(notificationId);
}
