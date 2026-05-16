import '../repositories/queue_repository.dart';

class MarkQueueServedUseCase {
  final QueueRepository repository;

  MarkQueueServedUseCase({required this.repository});

  Future<void> call({required String appointmentId}) {
    return repository.markServed(appointmentId: appointmentId);
  }
}
