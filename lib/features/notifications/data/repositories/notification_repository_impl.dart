import '../../domain/entites/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasource/notification_remote_datasource.dart';
import '../models/notification_model.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  const NotificationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> sendNotification(NotificationEntity notification) {
    return remoteDataSource.createNotification(
      NotificationModel.fromEntity(notification),
    );
  }

  @override
  Stream<List<NotificationEntity>> getUserNotifications(String userId, String role) {
    return remoteDataSource.streamUserNotifications(userId, role);
  }

  @override
  Future<void> markAsRead(String notificationId) {
    return remoteDataSource.markAsRead(notificationId);
  }
}
