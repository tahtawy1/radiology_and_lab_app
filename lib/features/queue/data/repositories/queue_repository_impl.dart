import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/queue_entry_entity.dart';
import '../../domain/repositories/queue_repository.dart';
import '../datasource/queue_remote_datasource.dart';

class QueueRepositoryImpl implements QueueRepository {
  final QueueRemoteDataSource remoteDataSource;

  QueueRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<QueueEntryEntity>> getTodayQueue({
    required String department,
  }) async {
    try {
      return await remoteDataSource.getTodayQueue(department: department);
    } on AppException {
      rethrow;
    }
  }

  @override
  Stream<QueueEntryEntity?> watchPatientQueueEntry({
    required String patientId,
  }) {
    return remoteDataSource.watchPatientQueueEntry(patientId: patientId);
  }

  @override
  Future<void> callNextPatient({required String department}) async {
    try {
      await remoteDataSource.callNextPatient(department: department);
    } on AppException {
      rethrow;
    }
  }

  @override
  Future<void> markDone({required String queueEntryId}) async {
    try {
      await remoteDataSource.markDone(queueEntryId: queueEntryId);
    } on AppException {
      rethrow;
    }
  }

  @override
  Future<void> markNoShow({required String queueEntryId}) async {
    try {
      await remoteDataSource.markNoShow(queueEntryId: queueEntryId);
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
