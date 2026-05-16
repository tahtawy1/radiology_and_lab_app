import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radiology_and_lab_app/features/queue/domain/entities/queue_entry_entity.dart';
import 'package:radiology_and_lab_app/features/queue/domain/usecases/queue_usecases.dart';

abstract class QueuePatientState {}

class QueuePatientInitial extends QueuePatientState {}

class QueuePatientLoading extends QueuePatientState {}

class QueuePatientLoaded extends QueuePatientState {
  final QueueEntryEntity? queueEntry;
  // This is a mock calculation since we don't have a way to count ahead dynamically without a dedicated query
  final int patientsAhead;

  QueuePatientLoaded({required this.queueEntry, required this.patientsAhead});
}

class QueuePatientError extends QueuePatientState {
  final String message;
  QueuePatientError(this.message);
}

class QueuePatientCubit extends Cubit<QueuePatientState> {
  final WatchPatientQueueEntryUseCase watchPatientQueueEntryUseCase;
  StreamSubscription? _queueSubscription;

  QueuePatientCubit({required this.watchPatientQueueEntryUseCase})
    : super(QueuePatientInitial());

  void watchPatientQueue(String patientId) {
    emit(QueuePatientLoading());
    _queueSubscription?.cancel();

    try {
      _queueSubscription = watchPatientQueueEntryUseCase(
        patientId: patientId,
      ).listen(
        (entry) {
          // Calculate mock patients ahead based on a simple logic or 0 if it's their turn
          int ahead = 0;
          if (entry != null && entry.queueStatus == 'waiting') {
            ahead = entry.queueNumber > 1 ? entry.queueNumber - 1 : 0;
          }
          emit(QueuePatientLoaded(queueEntry: entry, patientsAhead: ahead));
        },
        onError: (e) {
          emit(
            QueuePatientError('Failed to load queue updates: ${e.toString()}'),
          );
        },
      );
    } catch (e) {
      emit(QueuePatientError('Error observing queue: ${e.toString()}'));
    }
  }

  @override
  Future<void> close() {
    _queueSubscription?.cancel();
    return super.close();
  }
}
