import '../repositories/queue_repository.dart';

class CallNextPatientUseCase {
  final QueueRepository repository;

  CallNextPatientUseCase({required this.repository});

  Future<String?> call({required String department}) {
    return repository.callNextPatient(department: department);
  }
}
