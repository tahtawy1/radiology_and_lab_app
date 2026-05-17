import '../entites/notification_entity.dart';
import '../repositories/notification_repository.dart';

class GetUserNotificationsUseCase {
  final NotificationRepository _repository;

  const GetUserNotificationsUseCase(this._repository);

  Stream<List<NotificationEntity>> call(String userId) =>
      _repository.getUserNotifications(userId);
}
