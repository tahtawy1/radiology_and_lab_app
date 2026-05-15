import 'package:radiology_and_lab_app/features/appointment/domain/entites/appointment_entity.dart';

import '../repositories/appointment_repository.dart';

class GetPatientAppointmentsUseCase {
  final AppointmentRepository repository;

  GetPatientAppointmentsUseCase({required this.repository});

  Future<List<AppointmentEntity>> call(String patientId) async {
    return await repository.getAppointmentsByPatientId(patientId);
  }
}
