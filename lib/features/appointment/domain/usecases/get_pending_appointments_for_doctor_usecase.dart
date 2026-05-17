import 'package:radiology_and_lab_app/features/appointment/domain/entites/appointment_entity.dart';

import '../repositories/appointment_repository.dart';

class GetPendingAppointmentsForDoctorUseCase {
  final AppointmentRepository repository;

  GetPendingAppointmentsForDoctorUseCase({required this.repository});

  Stream<List<AppointmentEntity>> call(String doctorId) {
    return repository.getPendingAppointmentsForDoctor(doctorId);
  }
}
