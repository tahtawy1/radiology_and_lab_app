import '../../domain/entites/result_entity.dart';
import '../../domain/repositories/results_repositories.dart';
import '../datasource/result_remote_datasource.dart';
import '../../../appointment/domain/entites/appointment_entity.dart';

class ResultsRepositoryImpl implements ResultsRepository {
  final ResultRemoteDataSource remoteDataSource;

  ResultsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> uploadResult({
    required String appointmentId,
    required String resultFileUrl,
    required String notes,
  }) {
    return remoteDataSource.uploadResult(
      appointmentId: appointmentId,
      resultFileUrl: resultFileUrl,
      notes: notes,
    );
  }

  @override
  Future<void> reviewResult({
    required String resultId,
    required String doctorId,
    required String doctorNotes,
    required String classification,
  }) {
    return remoteDataSource.reviewResult(
      resultId: resultId,
      doctorId: doctorId,
      doctorNotes: doctorNotes,
      classification: classification,
    );
  }

  @override
  Future<List<ResultEntity>> getPatientResults({required String patientId}) {
    return remoteDataSource.getPatientResults(patientId: patientId);
  }

  @override
  Future<List<ResultEntity>> getDoctorPendingReviews({
    required String doctorId,
  }) {
    return remoteDataSource.getDoctorPendingReviews(doctorId: doctorId);
  }

  @override
  Future<List<AppointmentEntity>> getServedPatients() {
    return remoteDataSource.getServedPatients();
  }
}
