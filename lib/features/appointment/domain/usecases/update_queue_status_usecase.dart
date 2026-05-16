import '../entites/appointment_enums.dart';
import '../repositories/appointment_repository.dart';

class UpdateQueueStatusUseCase {
  final AppointmentRepository repository;

  UpdateQueueStatusUseCase({required this.repository});

  Future<void> call({
    required String appointmentId,
    required QueueStatus status,
  }) async {
    await repository.updateQueueStatus(
      appointmentId: appointmentId,
      status: status,
    );
  }
}
