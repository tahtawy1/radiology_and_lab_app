import '../repositories/queue_repository.dart';

class GetPatientsAheadUseCase {
  final QueueRepository repository;

  GetPatientsAheadUseCase({required this.repository});

  Future<int> call({
    required int queueNumber,
    required String department,
  }) {
    return repository.getPatientsAhead(
      queueNumber: queueNumber,
      department: department,
    );
  }
}
