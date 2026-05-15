import 'package:radiology_and_lab_app/features/appointment/domain/entites/appointment_entity.dart';
import '../repositories/appointment_repository.dart';

class GetAllAppointmentsUseCase {
  final AppointmentRepository repository;

  GetAllAppointmentsUseCase({required this.repository});

  Future<List<AppointmentEntity>> call() async {
    return await repository.getAllAppointments();
  }
}
