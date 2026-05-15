import '../repositories/appointment_repository.dart';

class GetDoctorsUseCase {
  final AppointmentRepository repository;

  GetDoctorsUseCase({required this.repository});

  Future<List<Map<String, String>>> call() {
    return repository.getDoctors();
  }
}
