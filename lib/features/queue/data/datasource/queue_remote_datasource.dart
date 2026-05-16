import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/firebase_error_mapper.dart';
import 'package:radiology_and_lab_app/features/appointment/data/models/appointment_model.dart';
import 'dart:developer';

abstract class QueueRemoteDataSource {
  Future<List<AppointmentModel>> getTodayQueue({required String department});
  Stream<AppointmentModel?> watchPatientQueueEntry({required String patientId});
  Future<void> checkInPatient({
    required String appointmentId,
    required String department,
  });
  Future<void> callNextPatient({required String department});
  Future<void> markServed({required String appointmentId});
  Future<void> markNoShow({required String appointmentId});
  Future<int> getPatientsAhead({
    required int queueNumber,
    required String department,
  });
  Future<void> setNotifyMe({required String patientId, required bool enabled});
}

class QueueRemoteDataSourceImpl implements QueueRemoteDataSource {
  final FirebaseFirestore firestore;

  QueueRemoteDataSourceImpl({required this.firestore});

  void queuePrint(String message) {
    log(message, name: 'QUEUE_DEBUG');
  }

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
      queuePrint('================ GET TODAY QUEUE ================');
      queuePrint('Department: $department');

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
              .get();

      final list =
          snapshot.docs
              .map((doc) => AppointmentModel.fromMap(doc.data()))
              .toList();

      // Local sort to ensure UI consistency: queueNumber ascending (nulls at the end)
      list.sort((a, b) {
        if (a.queueNumber == null && b.queueNumber == null) {
          return a.appointmentDateTime.compareTo(b.appointmentDateTime);
        }
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
  Stream<AppointmentModel?> watchPatientQueueEntry({
    required String patientId,
  }) {
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
        // Patient shows info if not cancelled
        .where('status', whereIn: ['pending', 'confirmed', 'completed'])
        .orderBy('appointmentDateTime')
        .limit(1)
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isEmpty) return null;
          return AppointmentModel.fromMap(snapshot.docs.first.data());
        })
        .handleError((e) {
          log(e.toString());
          return null;
        });
  }

  @override
  Future<void> checkInPatient({
    required String appointmentId,
    required String department,
  }) async {
    try {
      final counterRef = firestore
          .collection('counters')
          .doc('${department.toLowerCase()}_queue');
      final appointmentRef = firestore
          .collection('appointments')
          .doc(appointmentId);

      await firestore.runTransaction((transaction) async {
        final counterDoc = await transaction.get(counterRef);

        int nextNumber = 1;
        if (counterDoc.exists) {
          final lastReset =
              (counterDoc.data()?['lastReset'] as Timestamp?)?.toDate();
          if (lastReset != null && lastReset.isAfter(_startOfToday())) {
            nextNumber = (counterDoc.data()?['currentValue'] ?? 0) + 1;
          }
        }

        transaction.set(counterRef, {
          'currentValue': nextNumber,
          'lastReset': FieldValue.serverTimestamp(),
          'department': department,
        });

        transaction.update(appointmentRef, {
          'queueNumber': nextNumber,
          'queueStatus': 'waiting',
          'updatedAt': FieldValue.serverTimestamp(),
        });
      });
    } on FirebaseException catch (e) {
      throw ServerException(FirebaseErrorMapper.getMessage(e));
    } catch (e) {
      log(e.toString());
      throw const ServerException('Failed to check-in patient');
    }
  }

  @override
  Future<void> callNextPatient({required String department}) async {
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
              .where('queueStatus', isEqualTo: 'waiting')
              .orderBy('queueNumber')
              .limit(1)
              .get();

      if (snapshot.docs.isNotEmpty) {
        final docId = snapshot.docs.first.id;
        await firestore.collection('appointments').doc(docId).update({
          'queueStatus': 'called',
          'calledAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    } on FirebaseException catch (e) {
      throw ServerException(FirebaseErrorMapper.getMessage(e));
    } catch (e) {
      throw const ServerException('Failed to call next patient');
    }
  }

  @override
  Future<void> markServed({required String appointmentId}) async {
    try {
      await firestore.collection('appointments').doc(appointmentId).update({
        'queueStatus': 'served',
        'servedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      throw ServerException(FirebaseErrorMapper.getMessage(e));
    } catch (e) {
      throw const ServerException('Failed to mark patient as served');
    }
  }

  @override
  Future<void> markNoShow({required String appointmentId}) async {
    try {
      await firestore.collection('appointments').doc(appointmentId).update({
        'queueStatus': 'no_show',
        'isNoShow': true,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      throw ServerException(FirebaseErrorMapper.getMessage(e));
    } catch (e) {
      throw const ServerException('Failed to mark patient as no-show');
    }
  }

  @override
  Future<int> getPatientsAhead({
    required int queueNumber,
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
              .where('queueStatus', whereIn: ['waiting', 'called'])
              .where('queueNumber', isLessThan: queueNumber)
              .count()
              .get();

      return snapshot.count ?? 0;
    } catch (e) {
      return 0;
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
