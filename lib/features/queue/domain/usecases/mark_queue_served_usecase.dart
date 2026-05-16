import '../repositories/queue_repository.dart';

class MarkQueueServedUseCase {
  final QueueRepository repository;

  MarkQueueServedUseCase({required this.repository});

  Future<void> call({required String queueEntryId}) {
    return repository.markServed(queueEntryId: queueEntryId);
  }
}
