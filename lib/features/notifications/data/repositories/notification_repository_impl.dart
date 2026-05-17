import '../../domain/entites/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasource/notification_remote_datasource.dart';
import '../models/notification_model.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource _dataSource;

  const NotificationRepositoryImpl(this._dataSource);

  @override
  Future<void> sendNotification(NotificationEntity notification) {
    return _dataSource.createNotification(
      NotificationModel.fromEntity(notification),
    );
  }

  @override
  Stream<List<NotificationEntity>> getUserNotifications(String userId) {
    return _dataSource.streamUserNotifications(userId);
  }

  @override
  Future<void> markAsRead(String notificationId) {
    return _dataSource.markAsRead(notificationId);
  }
}
