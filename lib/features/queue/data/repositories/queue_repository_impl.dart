import '../../../../core/errors/exceptions.dart';
import 'package:radiology_and_lab_app/features/appointment/domain/entites/appointment_entity.dart';
import '../../domain/repositories/queue_repository.dart';
import '../datasource/queue_remote_datasource.dart';

class QueueRepositoryImpl implements QueueRepository {
  final QueueRemoteDataSource remoteDataSource;

  QueueRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<AppointmentEntity>> getTodayQueue({
    required String department,
  }) async {
    try {
      return await remoteDataSource.getTodayQueue(department: department);
    } on AppException {
      rethrow;
    }
  }

  @override
  Stream<AppointmentEntity?> watchPatientQueueEntry({
    required String patientId,
  }) {
    return remoteDataSource.watchPatientQueueEntry(patientId: patientId);
  }

  @override
  Future<void> checkInPatient({
    required String appointmentId,
    required String department,
  }) async {
    try {
      await remoteDataSource.checkInPatient(
        appointmentId: appointmentId,
        department: department,
      );
    } on AppException {
      rethrow;
    }
  }

  @override
  Future<String?> callNextPatient({required String department}) async {
    try {
      return await remoteDataSource.callNextPatient(department: department);
    } on AppException {
      rethrow;
    }
  }

  @override
  Future<void> markServed({required String appointmentId}) async {
    try {
      await remoteDataSource.markServed(appointmentId: appointmentId);
    } on AppException {
      rethrow;
    }
  }

  @override
  Future<void> markNoShow({required String appointmentId}) async {
    try {
      await remoteDataSource.markNoShow(appointmentId: appointmentId);
    } on AppException {
      rethrow;
    }
  }

  @override
  Future<int> getPatientsAhead({
    required int queueNumber,
    required String department,
  }) async {
    try {
      return await remoteDataSource.getPatientsAhead(
        queueNumber: queueNumber,
        department: department,
      );
    } on AppException {
      rethrow;
    }
  }

  @override
  Future<void> setNotifyMe({
    required String patientId,
    required bool enabled,
  }) async {
    try {
      await remoteDataSource.setNotifyMe(
        patientId: patientId,
        enabled: enabled,
      );
    } on AppException {
      rethrow;
    }
  }
}
