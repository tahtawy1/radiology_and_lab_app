import '../repositories/queue_repository.dart';

class MarkQueueNoShowUseCase {
  final QueueRepository repository;

  MarkQueueNoShowUseCase({required this.repository});

  Future<void> call({required String queueEntryId}) {
    return repository.markNoShow(queueEntryId: queueEntryId);
  }
}
