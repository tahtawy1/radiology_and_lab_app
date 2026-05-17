import '../../domain/entites/result_entity.dart';
import '../../../appointment/domain/entites/appointment_entity.dart';

abstract class ResultsRepository {
  Future<String> uploadResult({
    required String appointmentId,
    required String resultFileUrl,
    required String notes,
  });

  Future<String> reviewResult({
    required String resultId,
    required String doctorId,
    required String doctorNotes,
    required String classification,
  });

  Future<List<ResultEntity>> getPatientResults({required String patientId});

  Future<List<ResultEntity>> getDoctorPendingReviews({required String doctorId});

  Future<List<AppointmentEntity>> getServedPatients();
}
