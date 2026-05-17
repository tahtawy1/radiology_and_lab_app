import '../entites/notification_entity.dart';
import '../repositories/notification_repository.dart';

class SendNotificationUseCase {
  final NotificationRepository _repository;

  const SendNotificationUseCase(this._repository);

  Future<void> call(NotificationEntity notification) =>
      _repository.sendNotification(notification);
}
