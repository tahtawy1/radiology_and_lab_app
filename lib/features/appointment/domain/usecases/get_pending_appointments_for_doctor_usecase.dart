import 'package:radiology_and_lab_app/features/appointment/domain/entites/appointment_entity.dart';

import '../repositories/appointment_repository.dart';

class GetPendingAppointmentsForDoctorUseCase {
  final AppointmentRepository repository;

  GetPendingAppointmentsForDoctorUseCase({required this.repository});

  Future<List<AppointmentEntity>> call(String doctorId) async {
    return await repository.getPendingAppointmentsForDoctor(doctorId);
  }
}
