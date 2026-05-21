import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/usecases/get_today_queue_usecase.dart';
import '../../domain/usecases/check_in_patient_usecase.dart';
import '../../domain/usecases/call_next_patient_usecase.dart';
import '../../domain/usecases/mark_queue_served_usecase.dart';
import '../../domain/usecases/mark_queue_no_show_usecase.dart';
import '../../../../core/errors/firebase_error_mapper.dart';
import '../../../../features/notifications/domain/entites/notification_entity.dart';
import '../../../../features/notifications/domain/usecases/send_notification_usecase.dart';
import 'queue_admin_state.dart';

class QueueAdminCubit extends Cubit<QueueAdminState> {
  final GetTodayQueueUseCase getTodayQueueUseCase;
  final CheckInPatientUseCase checkInPatientUseCase;
  final CallNextPatientUseCase callNextPatientUseCase;
  final MarkQueueServedUseCase markQueueServedUseCase;
  final MarkQueueNoShowUseCase markQueueNoShowUseCase;
  final SendNotificationUseCase sendNotificationUseCase;

  StreamSubscription? _queueSubscription;

  QueueAdminCubit({
    required this.getTodayQueueUseCase,
    required this.checkInPatientUseCase,
    required this.callNextPatientUseCase,
    required this.markQueueServedUseCase,
    required this.markQueueNoShowUseCase,
    required this.sendNotificationUseCase,
  }) : super(QueueAdminInitial());

  // ── Error Message mapper ───────────────────────────────────────────────────
  String _mapExceptionToMessage(dynamic e) {
    return FirebaseErrorMapper.getMessage(e);
  }

  // ── Fetch Queue ────────────────────────────────----------------────────────
  void fetchQueue({required String department}) {
    emit(QueueAdminLoading(
      queueEntries: state.queueEntries,
      totalToday: state.totalToday,
      called: state.called,
      served: state.served,
    ));
    _queueSubscription?.cancel();

    try {
      _queueSubscription = getTodayQueueUseCase(department: department).listen(
        (entries) {
          final totalToday = entries.length;
          final called =
              entries.where((e) => e.queueStatus?.name == 'called').length;
          final served =
              entries.where((e) => e.queueStatus?.name == 'served').length;

          emit(QueueAdminLoaded(
            queueEntries: entries,
            totalToday: totalToday,
            called: called,
            served: served,
          ));
        },
        onError: (e) {
          emit(QueueAdminError(
            _mapExceptionToMessage(e),
            queueEntries: state.queueEntries,
            totalToday: state.totalToday,
            called: state.called,
            served: state.served,
          ));
        },
      );
    } catch (e) {
      emit(QueueAdminError(
        _mapExceptionToMessage(e),
        queueEntries: state.queueEntries,
        totalToday: state.totalToday,
        called: state.called,
        served: state.served,
      ));
    }
  }

  // ── Check In Patient ────────────────--------------------------------───────
  Future<void> checkInPatient({
    required String appointmentId,
    required String department,
  }) async {
    try {
      await checkInPatientUseCase(
        appointmentId: appointmentId,
        department: department,
      );
      // ── Notify Admins ────────────────--------------------------------──
      await sendNotificationUseCase(
        NotificationEntity(
          id: '',
          userId: 'ADMINS',
          title: 'Patient Checked In',
          body: 'A patient has checked in for the $department queue.',
          type: NotificationType.queueCalled,
          isRead: false,
          createdAt: DateTime.now(),
        ),
      );
      emit(QueueAdminActionSuccess(
        'Patient checked in successfully',
        queueEntries: state.queueEntries,
        totalToday: state.totalToday,
        called: state.called,
        served: state.served,
      ));
    } catch (e) {
      emit(QueueAdminError(
        _mapExceptionToMessage(e),
        queueEntries: state.queueEntries,
        totalToday: state.totalToday,
        called: state.called,
        served: state.served,
      ));
    }
  }

  // ── Call Next Patient ────────────────--------------------------------─────
  Future<void> callNextPatient({required String department}) async {
    try {
      final patientId = await callNextPatientUseCase(department: department);
      
      if (patientId == null) {
        emit(QueueAdminError(
          'Queue is empty or no waiting patients available.',
          queueEntries: state.queueEntries,
          totalToday: state.totalToday,
          called: state.called,
          served: state.served,
        ));
        return;
      }

      // ── Notify the called patient ─────────────────────────────────
      if (patientId.isNotEmpty) {
        await sendNotificationUseCase(
          NotificationEntity(
            id: '',
            userId: patientId,
            title: 'Queue Update',
            body: 'It is now your turn. Please proceed to the department.',
            type: NotificationType.queueCalled,
            isRead: false,
            createdAt: DateTime.now(),
          ),
        );
      }
      
      // ── Notify Admins ──────────────────────────────────────────────────
      await sendNotificationUseCase(
        NotificationEntity(
          id: '',
          userId: 'ADMINS',
          title: 'Patient Called',
          body: 'Next patient called for $department department.',
          type: NotificationType.queueCalled,
          isRead: false,
          createdAt: DateTime.now(),
        ),
      );
      
      emit(QueueAdminActionSuccess(
        'Next patient called',
        queueEntries: state.queueEntries,
        totalToday: state.totalToday,
        called: state.called,
        served: state.served,
      ));
    } catch (e) {
      emit(QueueAdminError(
        _mapExceptionToMessage(e),
        queueEntries: state.queueEntries,
        totalToday: state.totalToday,
        called: state.called,
        served: state.served,
      ));
    }
  }

  // ── Mark Served ───────────────────────────
  Future<void> markServed({
    required String appointmentId,
    required String department,
  }) async {
    try {
      await markQueueServedUseCase(appointmentId: appointmentId);
      // ── Notify Admins ──────────────────────────────────────────────────
      await sendNotificationUseCase(
        NotificationEntity(
          id: '',
          userId: 'ADMINS',
          title: 'Patient Served',
          body: 'A patient has been marked as served in $department.',
          type: NotificationType.queueCalled,
          isRead: false,
          createdAt: DateTime.now(),
        ),
      );
      emit(QueueAdminActionSuccess(
        'Patient marked as served',
        queueEntries: state.queueEntries,
        totalToday: state.totalToday,
        called: state.called,
        served: state.served,
      ));
    } catch (e) {
      emit(QueueAdminError(
        _mapExceptionToMessage(e),
        queueEntries: state.queueEntries,
        totalToday: state.totalToday,
        called: state.called,
        served: state.served,
      ));
    }
  }

  // ── Mark No Show ───────────────────────────────────────────────────────────
  Future<void> markNoShow({
    required String appointmentId,
    required String department,
  }) async {
    try {
      await markQueueNoShowUseCase(appointmentId: appointmentId);
      // ── Notify Admins ──────────────────────────────────────────────────
      await sendNotificationUseCase(
        NotificationEntity(
          id: '',
          userId: 'ADMINS',
          title: 'Patient No-Show',
          body: 'A patient was marked as no-show in $department.',
          type: NotificationType.queueCalled,
          isRead: false,
          createdAt: DateTime.now(),
        ),
      );
      emit(QueueAdminActionSuccess(
        'Patient marked as no-show',
        queueEntries: state.queueEntries,
        totalToday: state.totalToday,
        called: state.called,
        served: state.served,
      ));
    } catch (e) {
      emit(QueueAdminError(
        _mapExceptionToMessage(e),
        queueEntries: state.queueEntries,
        totalToday: state.totalToday,
        called: state.called,
        served: state.served,
      ));
    }
  }

  @override
  Future<void> close() {
    _queueSubscription?.cancel();
    return super.close();
  }
}
