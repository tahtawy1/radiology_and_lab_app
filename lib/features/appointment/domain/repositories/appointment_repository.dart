import 'package:radiology_and_lab_app/core/errors/failures.dart';
import 'package:radiology_and_lab_app/features/appointment/domain/entites/appointment_entity.dart';

abstract class AppointmentRepository {
  Future<void> bookAppointment(AppointmentEntity appointment);

  Future<void> cancelAppointment(String appointmentId);

  Future<List<AppointmentEntity>> getAllAppointments();

  Future<List<AppointmentEntity>> getAppointmentsByPatientId(String patientId);

  Future<void> updateAppointmentStatus({
    required String appointmentId,
    required String status,
  });

  Future<List<Map<String, String>>> getDoctors();
}
