import '../repositories/appointment_repository.dart';

class UpdateAppointmentStatusUseCase {
  final AppointmentRepository repository;

  UpdateAppointmentStatusUseCase({required this.repository});

  Future<void> call({
    required String appointmentId,
    required String status,
  }) async {
    await repository.updateAppointmentStatus(
      appointmentId: appointmentId,
      status: status,
    );
  }
}
