import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/usecases/get_today_queue_usecase.dart';
import '../../domain/usecases/check_in_patient_usecase.dart';
import '../../domain/usecases/call_next_patient_usecase.dart';
import '../../domain/usecases/mark_queue_served_usecase.dart';
import '../../domain/usecases/mark_queue_no_show_usecase.dart';
import '../../../../core/errors/firebase_error_mapper.dart';
import 'queue_admin_state.dart';

class QueueAdminCubit extends Cubit<QueueAdminState> {
  final GetTodayQueueUseCase getTodayQueueUseCase;
  final CheckInPatientUseCase checkInPatientUseCase;
  final CallNextPatientUseCase callNextPatientUseCase;
  final MarkQueueServedUseCase markQueueServedUseCase;
  final MarkQueueNoShowUseCase markQueueNoShowUseCase;

  QueueAdminCubit({
    required this.getTodayQueueUseCase,
    required this.checkInPatientUseCase,
    required this.callNextPatientUseCase,
    required this.markQueueServedUseCase,
    required this.markQueueNoShowUseCase,
  }) : super(QueueAdminInitial());

  // ── Error Message mapper ───────────────────────────────────────────────────
  String _mapExceptionToMessage(dynamic e) {
    return FirebaseErrorMapper.getMessage(e);
  }

  // ── Fetch Queue ────────────────────────────────────────────────────────────
  Future<void> fetchQueue({required String department}) async {
    emit(QueueAdminLoading());
    try {
      final entries = await getTodayQueueUseCase(department: department);
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
    } catch (e) {
      emit(QueueAdminError(_mapExceptionToMessage(e)));
    }
  }

  // ── Check In Patient ───────────────────────────────────────────────────────
  Future<void> checkInPatient({
    required String appointmentId,
    required String department,
  }) async {
    try {
      await checkInPatientUseCase(
        appointmentId: appointmentId,
        department: department,
      );
      emit(QueueAdminActionSuccess('Patient checked in successfully'));
      await fetchQueue(department: department);
    } catch (e) {
      emit(QueueAdminError(_mapExceptionToMessage(e)));
    }
  }

  // ── Call Next Patient ──────────────────────────────────────────────────────
  Future<void> callNextPatient({required String department}) async {
    try {
      await callNextPatientUseCase(department: department);
      emit(QueueAdminActionSuccess('Next patient called'));
      await fetchQueue(department: department);
    } catch (e) {
      emit(QueueAdminError(_mapExceptionToMessage(e)));
    }
  }

  // ── Mark Served ────────────────────────────────────────────────────────────
  Future<void> markServed({
    required String appointmentId,
    required String department,
  }) async {
    try {
      await markQueueServedUseCase(appointmentId: appointmentId);
      emit(QueueAdminActionSuccess('Patient marked as served'));
      await fetchQueue(department: department);
    } catch (e) {
      emit(QueueAdminError(_mapExceptionToMessage(e)));
    }
  }

  // ── Mark No Show ───────────────────────────────────────────────────────────
  Future<void> markNoShow({
    required String appointmentId,
    required String department,
  }) async {
    try {
      await markQueueNoShowUseCase(appointmentId: appointmentId);
      emit(QueueAdminActionSuccess('Patient marked as no-show'));
      await fetchQueue(department: department);
    } catch (e) {
      emit(QueueAdminError(_mapExceptionToMessage(e)));
    }
  }
}


