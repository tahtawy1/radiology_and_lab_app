import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/watch_patient_queue_entry_usecase.dart';
import 'queue_patient_state.dart';

class QueuePatientCubit extends Cubit<QueuePatientState> {
  final WatchPatientQueueEntryUseCase watchPatientQueueEntryUseCase;
  StreamSubscription? _queueSubscription;

  QueuePatientCubit({
    required this.watchPatientQueueEntryUseCase,
  }) : super(QueuePatientInitial());

  void watchPatientQueue(String patientId) {
    emit(QueuePatientLoading());
    _queueSubscription?.cancel();
    
    try {
      _queueSubscription = watchPatientQueueEntryUseCase(patientId: patientId).listen(
        (entry) {
          int ahead = 0;
          if (entry != null && entry.queueStatus?.name == 'waiting' && entry.queueNumber != null) {
            ahead = entry.queueNumber! > 1 ? entry.queueNumber! - 1 : 0; 
          }
          emit(QueuePatientLoaded(queueEntry: entry, patientsAhead: ahead));
        },
        onError: (e) {
          emit(QueuePatientError('Failed to load queue updates: ${e.toString()}'));
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
