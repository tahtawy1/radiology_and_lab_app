import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/firebase_error_mapper.dart';
import '../models/appointment_model.dart';

abstract class AppointmentRemoteDataSource {
  Future<void> bookAppointment(AppointmentModel appointment);

  Future<List<AppointmentModel>> getAppointmentsByPatientId(String patientId);

  Future<List<AppointmentModel>> getAllAppointments();

  Future<void> cancelAppointment(String appointmentId);

  Future<void> updateAppointmentStatus({
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
      // 1. Queue Number Generation
      // Count existing appointments for the same date + department.
      // Requires Composite Firestore Index: department (ASC) + appointmentDateTime (ASC)
      final startOfDay = DateTime(
        appointment.appointmentDateTime.year,
        appointment.appointmentDateTime.month,
        appointment.appointmentDateTime.day,
      );
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final countSnapshot =
          await firestore
              .collection('appointments')
              .where('department', isEqualTo: appointment.department)
              .where(
                'appointmentDateTime',
                isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),
              )
              .where(
                'appointmentDateTime',
                isLessThan: Timestamp.fromDate(endOfDay),
              )
              .count()
              .get();

      final queueNumber = (countSnapshot.count ?? 0) + 1;

      // 2. Save appointment with generated queue number
      final docRef = firestore.collection('appointments').doc();

      final updatedAppointment = appointment.copyWith(
        id: docRef.id,
        queueNumber: queueNumber,
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
  Future<List<AppointmentModel>> getAllAppointments() async {
    try {
      final snapshot =
          await firestore
              .collection('appointments')
              .orderBy('createdAt', descending: true)
              .get();

      return snapshot.docs
          .map((doc) => AppointmentModel.fromMap(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw ServerException(FirebaseErrorMapper.getMessage(e));
    } catch (e) {
      throw const ServerException('Failed to fetch appointments');
    }
  }

  @override
  Future<List<AppointmentModel>> getAppointmentsByPatientId(
    String patientId,
  ) async {
    try {
      // Requires Firestore Index: patientId (ASC) + appointmentDateTime (ASC)
      final snapshot =
          await firestore
              .collection('appointments')
              .where('patientId', isEqualTo: patientId)
              .orderBy('appointmentDateTime', descending: false)
              .get();

      return snapshot.docs
          .map((doc) => AppointmentModel.fromMap(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw ServerException(FirebaseErrorMapper.getMessage(e));
    } catch (e) {
      throw const ServerException('Failed to fetch appointments');
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
