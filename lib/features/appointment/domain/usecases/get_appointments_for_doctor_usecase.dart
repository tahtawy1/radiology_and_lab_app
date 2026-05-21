import 'package:radiology_and_lab_app/features/appointment/domain/entites/appointment_entity.dart';
import '../repositories/appointment_repository.dart';

class GetAppointmentsForDoctorUseCase {
  final AppointmentRepository repository;

  GetAppointmentsForDoctorUseCase({required this.repository});

  Stream<List<AppointmentEntity>> call(String doctorId) {
    return repository.getAppointmentsForDoctor(doctorId);
  }
}
