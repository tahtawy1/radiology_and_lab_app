import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/usecases/watch_patient_queue_entry_usecase.dart';
import '../../domain/usecases/get_patients_ahead_usecase.dart';
import 'queue_patient_state.dart';

class QueuePatientCubit extends Cubit<QueuePatientState> {
  final WatchPatientQueueEntryUseCase watchPatientQueueEntryUseCase;
  final GetPatientsAheadUseCase getPatientsAheadUseCase;
  StreamSubscription? _queueSubscription;

  QueuePatientCubit({
    required this.watchPatientQueueEntryUseCase,
    required this.getPatientsAheadUseCase,
  }) : super(QueuePatientInitial());

  // ── Failure mapper ─────────────────────────────────────────────────────────
  Failure _mapExceptionToFailure(dynamic e) {
    if (e is ValidationException) return ValidationFailure(e.message);
    if (e is NetworkException) return NetworkFailure(e.message);
    if (e is ServerException) return ServerFailure(e.message);
    return ServerFailure(e.toString());
  }

  // ── Watch Patient Queue ────────────────────────────────────────────────────
  void watchPatientQueue(String patientId) {
    emit(QueuePatientLoading());
    _queueSubscription?.cancel();

    _queueSubscription = watchPatientQueueEntryUseCase(patientId: patientId)
        .listen(
          (entry) async {
            int ahead = 0;
            try {
              if (entry != null &&
                  entry.queueStatus?.name == 'waiting' &&
                  entry.queueNumber != null) {
                ahead = await getPatientsAheadUseCase(
                  queueNumber: entry.queueNumber!,
                  department: entry.department,
                );
              }
              emit(QueuePatientLoaded(queueEntry: entry, patientsAhead: ahead));
            } catch (e) {
              emit(QueuePatientLoaded(queueEntry: entry, patientsAhead: 0));
            }
          },
          onError: (e) {
            emit(QueuePatientError(_mapExceptionToFailure(e).message));
          },
        );
  }

  @override
  Future<void> close() {
    _queueSubscription?.cancel();
    return super.close();
  }
}


