import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/firebase_error_mapper.dart';
import '../models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<void> createNotification(NotificationModel notification);
  Stream<List<NotificationModel>> streamUserNotifications(String userId);
  Future<void> markAsRead(String notificationId);
}

class NotificationRemoteDataSourceImpl
    implements NotificationRemoteDataSource {
  final FirebaseFirestore _firestore;

  const NotificationRemoteDataSourceImpl(this._firestore);

  static const _collection = 'notifications';

  // ── Create ────────────────────────────────────────────────────────────────
  @override
  Future<void> createNotification(NotificationModel notification) async {
    try {
      if (notification.userId == 'ADMINS') {
        final adminDocs = await _firestore
            .collection('users')
            .where('role', isEqualTo: 'admin')
            .get();
        final batch = _firestore.batch();
        for (final doc in adminDocs.docs) {
          final docRef = _firestore.collection(_collection).doc();
          final map = notification.toMap();
          map['userId'] = doc.id; // Assign to specific admin
          map['id'] = docRef.id;
          map['createdAt'] = FieldValue.serverTimestamp();
          batch.set(docRef, map);
        }
        await batch.commit();
        return;
      }

      final docRef = notification.id.isNotEmpty
          ? _firestore.collection(_collection).doc(notification.id)
          : _firestore.collection(_collection).doc();

      final map = notification.toMap();

      // Always use the Firestore-generated id and server timestamp
      await docRef.set({
        ...map,
        'id': docRef.id,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      throw ServerException(FirebaseErrorMapper.getMessage(e));
    } catch (e) {
      throw e is AppException
          ? e
          : const ServerException('Failed to send notification');
    }
  }

  // ── Stream ────────────────────────────────────────────────────────────────
  @override
  Stream<List<NotificationModel>> streamUserNotifications(String userId) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => NotificationModel.fromMap(doc.data()))
              .toList(),
        );
  }

  // ── Mark as read ──────────────────────────────────────────────────────────
  @override
  Future<void> markAsRead(String notificationId) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(notificationId)
          .update({'isRead': true});
    } on FirebaseException catch (e) {
      throw ServerException(FirebaseErrorMapper.getMessage(e));
    } catch (e) {
      throw e is AppException
          ? e
          : const ServerException('Failed to mark notification as read');
    }
  }
}
