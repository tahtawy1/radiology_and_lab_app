import '../repositories/appointment_repository.dart';

class CancelAppointmentUseCase {
  final AppointmentRepository repository;

  CancelAppointmentUseCase({required this.repository});

  Future<void> call(String appointmentId) async {
    await repository.cancelAppointment(appointmentId);
  }
}
