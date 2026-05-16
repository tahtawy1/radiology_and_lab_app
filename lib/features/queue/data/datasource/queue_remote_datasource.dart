import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/firebase_error_mapper.dart';
import 'package:radiology_and_lab_app/features/appointment/data/models/appointment_model.dart';

abstract class QueueRemoteDataSource {
  Future<List<AppointmentModel>> getTodayQueue({required String department});
  Stream<AppointmentModel?> watchPatientQueueEntry({required String patientId});
  Future<void> checkInPatient({required String appointmentId, required String department});
  Future<void> callNextPatient({required String department});
  Future<void> markServed({required String queueEntryId});
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
  Future<List<AppointmentModel>> getTodayQueue({
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
              // Only get appointments that are checked into the active queue OR confirmed but not yet in queue
              // But we can only query easily by one thing, so let's get all confirmed/completed/pending
              // and let the cubit filter them into the two sections (Confirmed vs Active Queue).
              .orderBy('appointmentDateTime')
              // Firestore complex index might not like orderBy queueNumber if it has nulls, so let's handle sorting locally for now or just order by appointmentDateTime
              .get();

      final list = snapshot.docs
          .map((doc) => AppointmentModel.fromMap(doc.data()))
          .toList();
      
      // Local sort: queueNumber ascending (nulls at the end)
      list.sort((a, b) {
        if (a.queueNumber == null && b.queueNumber == null) return 0;
        if (a.queueNumber == null) return 1;
        if (b.queueNumber == null) return -1;
        return a.queueNumber!.compareTo(b.queueNumber!);
      });

      return list;
    } on FirebaseException catch (e) {
      throw ServerException(FirebaseErrorMapper.getMessage(e));
    } catch (e) {
      throw const ServerException('Failed to fetch queue');
    }
  }

  @override
  Stream<AppointmentModel?> watchPatientQueueEntry({required String patientId}) {
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
        // Patient screen shows info if confirmed OR if already in queue
        .where('status', whereIn: ['confirmed', 'pending'])
        .orderBy('appointmentDateTime')
        .limit(1)
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isEmpty) return null;
          return AppointmentModel.fromMap(snapshot.docs.first.data());
        });
  }

  @override
  Future<void> checkInPatient({required String appointmentId, required String department}) async {
    try {
      // Use a transaction or count to generate sequential queueNumber
      // Not using snapshot directly since we just need the count, but keeping the await for the execution.
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
          .count()
          .get();
      
      // Wait, we only want to count the ones that ACTUALLY have a queue number for today.
      final queueCountSnapshot = await firestore
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
          .where('queueStatus', whereIn: ['waiting', 'called', 'served', 'no_show'])
          .count()
          .get();

      final int queueNumber = (queueCountSnapshot.count ?? 0) + 1;

      await firestore.collection('appointments').doc(appointmentId).update({
        'queueNumber': queueNumber,
        'queueStatus': 'waiting',
      });
    } on FirebaseException catch (e) {
      throw ServerException(FirebaseErrorMapper.getMessage(e));
    } catch (e) {
      throw const ServerException('Failed to add patient to queue');
    }
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
          'queueStatus': 'called', 
          'calledAt': Timestamp.fromDate(DateTime.now()),
        });
      }
    } on FirebaseException catch (e) {
      throw ServerException(FirebaseErrorMapper.getMessage(e));
    } catch (e) {
      throw const ServerException('Failed to call next patient');
    }
  }

  @override
  Future<void> markServed({required String queueEntryId}) async {
    try {
      await firestore.collection('appointments').doc(queueEntryId).update({
        'queueStatus': 'served',
        'status': 'completed',
        'servedAt': Timestamp.fromDate(DateTime.now()),
      });
    } on FirebaseException catch (e) {
      throw ServerException(FirebaseErrorMapper.getMessage(e));
    } catch (e) {
      throw const ServerException('Failed to mark patient as served');
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
