import '../entities/queue_entry_entity.dart';
import '../repositories/queue_repository.dart';

class GetTodayQueueUseCase {
  final QueueRepository repository;

  GetTodayQueueUseCase({required this.repository});

  Future<List<QueueEntryEntity>> call({required String department}) {
    return repository.getTodayQueue(department: department);
  }
}

class WatchPatientQueueEntryUseCase {
  final QueueRepository repository;

  WatchPatientQueueEntryUseCase({required this.repository});

  Stream<QueueEntryEntity?> call({required String patientId}) {
    return repository.watchPatientQueueEntry(patientId: patientId);
  }
}

class CallNextPatientUseCase {
  final QueueRepository repository;

  CallNextPatientUseCase({required this.repository});

  Future<void> call({required String department}) {
    return repository.callNextPatient(department: department);
  }
}

class MarkQueueDoneUseCase {
  final QueueRepository repository;

  MarkQueueDoneUseCase({required this.repository});

  Future<void> call({required String queueEntryId}) {
    return repository.markDone(queueEntryId: queueEntryId);
  }
}

class MarkQueueNoShowUseCase {
  final QueueRepository repository;

  MarkQueueNoShowUseCase({required this.repository});

  Future<void> call({required String queueEntryId}) {
    return repository.markNoShow(queueEntryId: queueEntryId);
  }
}
