import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/firebase_error_mapper.dart';
import '../../domain/usecases/get_user_notifications_usecase.dart';
import '../../domain/usecases/mark_notification_as_read_usecase.dart';
import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final GetUserNotificationsUseCase _getUserNotificationsUseCase;
  final MarkNotificationAsReadUseCase _markNotificationAsReadUseCase;

  StreamSubscription? _subscription;

  NotificationsCubit({
    required GetUserNotificationsUseCase getUserNotificationsUseCase,
    required MarkNotificationAsReadUseCase markNotificationAsReadUseCase,
  }) : _getUserNotificationsUseCase = getUserNotificationsUseCase,
       _markNotificationAsReadUseCase = markNotificationAsReadUseCase,
       super(NotificationsInitial());

  // ── Error mapper ──────────────────────────────────────────────────────────
  String _mapError(dynamic e) => FirebaseErrorMapper.getMessage(e);

  // ── Start real-time stream ─────────────────────────────────────────────────
  void listenToNotifications(String userId, String role) {
    emit(NotificationsLoading());

    // Cancel any previous subscription before opening a new one
    _subscription?.cancel();

    _subscription = _getUserNotificationsUseCase(userId, role).listen(
      (notifications) {
        emit(NotificationsLoaded(notifications: notifications));
      },
      onError: (e) {
        emit(NotificationsError(_mapError(e)));
      },
    );
  }

  // ── Mark single notification read ─────────────────────────────────────────
  Future<void> markAsRead(String notificationId) async {
    try {
      await _markNotificationAsReadUseCase(notificationId);
      // No separate emit needed — the Firestore stream will push the updated list.
    } catch (e) {
      emit(NotificationsError(_mapError(e)));
    }
  }

  // ── Safe disposal ─────────────────────────────────────────────────────────
  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
