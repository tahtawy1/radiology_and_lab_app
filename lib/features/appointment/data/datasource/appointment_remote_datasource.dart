import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/firebase_error_mapper.dart';
import '../models/appointment_model.dart';

abstract class AppointmentRemoteDataSource {
  Future<void> bookAppointment(AppointmentModel appointment);

  Stream<List<AppointmentModel>> getAppointmentsByPatientId(String patientId);

  Stream<List<AppointmentModel>> getPendingAppointmentsForDoctor(
    String doctorId,
  );

  Stream<List<AppointmentModel>> getAppointmentsForDoctor(
    String doctorId,
  );

  Stream<List<AppointmentModel>> getAllAppointments();

  Future<void> cancelAppointment(String appointmentId);

  Future<void> updateAppointmentStatus({
    required String appointmentId,
    required String status,
  });

  Future<void> updateQueueStatus({
    required String appointmentId,
    required String status,
  });

  Future<List<Map<String, String>>> getDoctors();
}

class AppointmentRemoteDataSourceImpl implements AppointmentRemoteDataSource {
  final FirebaseFirestore firestore;

  AppointmentRemoteDataSourceImpl({required this.firestore});

  @override
  Future<void> bookAppointment(AppointmentModel appointment) async {
    try {
      final docRef = firestore.collection('appointments').doc();

      final updatedAppointment = appointment.copyWith(
        id: docRef.id,
      );

      await docRef.set(updatedAppointment.toMap());
    } on ServerException {
      rethrow;
    } on FirebaseException catch (e) {
      throw ServerException(FirebaseErrorMapper.getMessage(e));
    } catch (e) {
      throw const ServerException('Failed to book appointment');
    }
  }

  @override
  Future<void> cancelAppointment(String appointmentId) async {
    try {
      await firestore.collection('appointments').doc(appointmentId).update({
        'status': 'cancelled',
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    } on FirebaseException catch (e) {
      throw ServerException(FirebaseErrorMapper.getMessage(e));
    } catch (e) {
      throw const ServerException('Failed to cancel appointment');
    }
  }

  @override
  Stream<List<AppointmentModel>> getAllAppointments() {
    try {
      return firestore
          .collection('appointments')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => AppointmentModel.fromMap(doc.data()))
              .toList());
    } on FirebaseException catch (e) {
      throw ServerException(FirebaseErrorMapper.getMessage(e));
    } catch (e) {
      throw const ServerException('Failed to fetch appointments');
    }
  }

  @override
  Stream<List<AppointmentModel>> getAppointmentsByPatientId(
    String patientId,
  ) {
    try {
      // Requires Firestore Index: patientId (ASC) + appointmentDateTime (ASC)
      return firestore
          .collection('appointments')
          .where('patientId', isEqualTo: patientId)
          .orderBy('appointmentDateTime', descending: false)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => AppointmentModel.fromMap(doc.data()))
              .toList());
    } on FirebaseException catch (e) {
      throw ServerException(FirebaseErrorMapper.getMessage(e));
    } catch (e) {
      throw const ServerException('Failed to fetch appointments');
    }
  }

  @override
  Stream<List<AppointmentModel>> getPendingAppointmentsForDoctor(
    String doctorId,
  ) {
    try {
      return firestore
          .collection('appointments')
          .where('doctorId', isEqualTo: doctorId)
          .where('status', isEqualTo: 'pending')
          .orderBy('appointmentDateTime', descending: false)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => AppointmentModel.fromMap(doc.data()))
              .toList());
    } on FirebaseException catch (e) {
      print(e.message);
      throw ServerException(FirebaseErrorMapper.getMessage(e));
    } catch (e) {
      print(e);
      throw const ServerException(
        'Failed to fetch pending appointments for doctor',
      );
    }
  }

  @override
  Stream<List<AppointmentModel>> getAppointmentsForDoctor(String doctorId) {
    try {
      return firestore
          .collection('appointments')
          .where('doctorId', isEqualTo: doctorId)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => AppointmentModel.fromMap(doc.data()))
              .toList());
    } on FirebaseException catch (e) {
      throw ServerException(FirebaseErrorMapper.getMessage(e));
    } catch (e) {
      throw const ServerException('Failed to fetch doctor appointments');
    }
  }

  @override
  Future<void> updateAppointmentStatus({
    required String appointmentId,
    required String status,
  }) async {
    try {
      await firestore.collection('appointments').doc(appointmentId).update({
        'status': status,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    } on FirebaseException catch (e) {
      throw ServerException(FirebaseErrorMapper.getMessage(e));
    } catch (e) {
      throw const ServerException('Failed to update appointment status');
    }
  }

  @override
  Future<void> updateQueueStatus({
    required String appointmentId,
    required String status,
  }) async {
    try {
      final updates = <String, dynamic>{
        'queueStatus': status,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      };

      if (status == 'called') {
        updates['calledAt'] = Timestamp.fromDate(DateTime.now());
      } else if (status == 'served') {
        updates['servedAt'] = Timestamp.fromDate(DateTime.now());
        updates['resultUploaded'] = false;
      } else if (status == 'no_show') {
        updates['isNoShow'] = true;
      }

      await firestore
          .collection('appointments')
          .doc(appointmentId)
          .update(updates);
    } on FirebaseException catch (e) {
      throw ServerException(FirebaseErrorMapper.getMessage(e));
    } catch (e) {
      throw const ServerException('Failed to update queue status');
    }
  }

  @override
  Future<List<Map<String, String>>> getDoctors() async {
    try {
      final snapshot =
          await firestore
              .collection('users')
              .where('role', isEqualTo: 'Doctor')
              .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'name': (data['fullName'] ?? 'Unknown Doctor').toString(),
        };
      }).toList();
    } on FirebaseException catch (e) {
      throw ServerException(FirebaseErrorMapper.getMessage(e));
    } catch (e) {
      throw const ServerException('Failed to fetch doctors');
    }
  }
}
