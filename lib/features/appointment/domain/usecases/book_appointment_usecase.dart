import 'package:radiology_and_lab_app/features/appointment/domain/entites/appointment_entity.dart';

import '../repositories/appointment_repository.dart';

class BookAppointmentUseCase {
  final AppointmentRepository repository;

  BookAppointmentUseCase({required this.repository});

  Future<void> call(AppointmentEntity appointment) async {
    await repository.bookAppointment(appointment);
  }
}
