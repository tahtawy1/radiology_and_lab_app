import 'package:radiology_and_lab_app/core/errors/failures.dart';
import 'package:radiology_and_lab_app/features/appointment/domain/entites/appointment_entity.dart';

import '../entites/appointment_enums.dart';

abstract class AppointmentRepository {
  Future<void> bookAppointment(AppointmentEntity appointment);

  Future<void> cancelAppointment(String appointmentId);

  Future<List<AppointmentEntity>> getAllAppointments();

  Future<List<AppointmentEntity>> getAppointmentsByPatientId(String patientId);

  Future<List<AppointmentEntity>> getPendingAppointmentsForDoctor(String doctorId);

  Future<void> updateAppointmentStatus({
    required String appointmentId,
    required AppointmentStatus status,
  });

  Future<void> updateQueueStatus({
    required String appointmentId,
    required QueueStatus status,
  });

  Future<List<Map<String, String>>> getDoctors();
}
