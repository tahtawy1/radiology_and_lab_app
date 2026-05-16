import '../repositories/queue_repository.dart';

class CheckInPatientUseCase {
  final QueueRepository repository;

  CheckInPatientUseCase({required this.repository});

  Future<void> call({required String appointmentId, required String department}) {
    return repository.checkInPatient(appointmentId: appointmentId, department: department);
  }
}
