import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/firebase_error_mapper.dart';
import '../models/queue_entry_model.dart';

abstract class QueueRemoteDataSource {
  Future<List<QueueEntryModel>> getTodayQueue({required String department});
  Stream<QueueEntryModel?> watchPatientQueueEntry({required String patientId});
  Future<void> callNextPatient({required String department});
  Future<void> markDone({required String queueEntryId});
  Future<void> markNoShow({required String queueEntryId});
  Future<void> setNotifyMe({required String patientId, required bool enabled});
}

class QueueRemoteDataSourceImpl implements QueueRemoteDataSource {
  final FirebaseFirestore firestore;

  QueueRemoteDataSourceImpl({required this.firestore});

  DateTime _startOfToday() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  DateTime _endOfToday() {
    return _startOfToday().add(const Duration(days: 1));
  }

  @override
  Future<List<QueueEntryModel>> getTodayQueue({
    required String department,
  }) async {
    try {
      final snapshot =
          await firestore
              .collection('appointments')
              .where('department', isEqualTo: department)
              .where(
                'appointmentDateTime',
                isGreaterThanOrEqualTo: Timestamp.fromDate(_startOfToday()),
              )
              .where(
                'appointmentDateTime',
                isLessThan: Timestamp.fromDate(_endOfToday()),
              )
              .orderBy('appointmentDateTime')
              .orderBy('queueNumber')
              .get();

      return snapshot.docs
          .map((doc) => QueueEntryModel.fromMap(doc.data(), doc.id))
          .toList();
    } on FirebaseException catch (e) {
      throw ServerException(FirebaseErrorMapper.getMessage(e));
    } catch (e) {
      throw const ServerException('Failed to fetch queue');
    }
  }

  @override
  Stream<QueueEntryModel?> watchPatientQueueEntry({required String patientId}) {
    // Only looking at today's active appointments
    return firestore
        .collection('appointments')
        .where('patientId', isEqualTo: patientId)
        .where(
          'appointmentDateTime',
          isGreaterThanOrEqualTo: Timestamp.fromDate(_startOfToday()),
        )
        .where(
          'appointmentDateTime',
          isLessThan: Timestamp.fromDate(_endOfToday()),
        )
        .where('status', isEqualTo: ['confirmed']) // Ensure it's active
        .orderBy('appointmentDateTime')
        .limit(1)
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isEmpty) return null;
          return QueueEntryModel.fromMap(
            snapshot.docs.first.data(),
            snapshot.docs.first.id,
          );
        });
  }

  @override
  Future<void> callNextPatient({required String department}) async {
    try {
      // Find the first patient with 'waiting' queueStatus for today
      final snapshot =
          await firestore
              .collection('appointments')
              .where('department', isEqualTo: department)
              .where(
                'appointmentDateTime',
                isGreaterThanOrEqualTo: Timestamp.fromDate(_startOfToday()),
              )
              .where(
                'appointmentDateTime',
                isLessThan: Timestamp.fromDate(_endOfToday()),
              )
              .where('queueStatus', isEqualTo: 'waiting')
              .orderBy('appointmentDateTime')
              .orderBy('queueNumber')
              .limit(1)
              .get();

      if (snapshot.docs.isNotEmpty) {
        final docId = snapshot.docs.first.id;
        await firestore.collection('appointments').doc(docId).update({
          'queueStatus':
              'in_progress', // 'in_progress' translates to 'called' logic in entity sometimes, using in_progress based on UI
          'calledAt': Timestamp.fromDate(DateTime.now()),
          'status':
              'confirmed', //? Ensure the appointment is marked confirmed if it was pending
        });
      }
    } on FirebaseException catch (e) {
      throw ServerException(FirebaseErrorMapper.getMessage(e));
    } catch (e) {
      throw const ServerException('Failed to call next patient');
    }
  }

  @override
  Future<void> markDone({required String queueEntryId}) async {
    try {
      await firestore.collection('appointments').doc(queueEntryId).update({
        'queueStatus': 'completed',
        'status': 'completed',
        'servedAt': Timestamp.fromDate(DateTime.now()),
      });
    } on FirebaseException catch (e) {
      throw ServerException(FirebaseErrorMapper.getMessage(e));
    } catch (e) {
      throw const ServerException('Failed to mark patient as done');
    }
  }

  @override
  Future<void> markNoShow({required String queueEntryId}) async {
    try {
      await firestore.collection('appointments').doc(queueEntryId).update({
        'queueStatus': 'no_show',
        'isNoShow': true,
      });
    } on FirebaseException catch (e) {
      throw ServerException(FirebaseErrorMapper.getMessage(e));
    } catch (e) {
      throw const ServerException('Failed to mark patient as no-show');
    }
  }

  @override
  Future<void> setNotifyMe({
    required String patientId,
    required bool enabled,
  }) async {
    try {
      await firestore.collection('users').doc(patientId).update({
        'notifyQueue': enabled,
      });
    } on FirebaseException catch (e) {
      throw ServerException(FirebaseErrorMapper.getMessage(e));
    } catch (e) {
      throw const ServerException('Failed to update notification settings');
    }
  }
}
