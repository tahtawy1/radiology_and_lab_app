import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:radiology_and_lab_app/features/appointment/data/models/appointment_model.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/firebase_error_mapper.dart';
import '../models/result_model.dart';

abstract class ResultRemoteDataSource {
  Future<void> uploadResult({
    required String appointmentId,
    required String resultFileUrl,
    required String notes,
  });

  Future<void> reviewResult({
    required String resultId,
    required String doctorId,
    required String doctorNotes,
    required String classification,
  });

  Future<List<ResultModel>> getPatientResults({required String patientId});

  Future<List<ResultModel>> getDoctorPendingReviews({required String doctorId});

  Future<List<AppointmentModel>> getServedPatients();
}

class ResultRemoteDataSourceImpl implements ResultRemoteDataSource {
  final FirebaseFirestore _firestore;

  ResultRemoteDataSourceImpl(this._firestore);

  @override
  Future<void> uploadResult({
    required String appointmentId,
    required String resultFileUrl,
    required String notes,
  }) async {
    try {
      final appointmentDocRef = _firestore
          .collection('appointments')
          .doc(appointmentId);
      final appointmentDoc = await appointmentDocRef.get();

      if (!appointmentDoc.exists) {
        throw const ServerException('Appointment not found');
      }

      final data = appointmentDoc.data()!;
      final patientId = data['patientId'] ?? '';
      final patientName = data['patientName'] ?? '';
      final testType = data['testType'] ?? '';
      final doctorId = data['doctorId'] ?? '';
      final department = data['department'] ?? '';

      final resultRef = _firestore.collection('results').doc();

      await _firestore.runTransaction((transaction) async {
        // 1. Create Result Document
        transaction.set(resultRef, {
          'id': resultRef.id,
          'appointmentId': appointmentId,
          'patientId': patientId,
          'patientName': patientName,
          'testType': testType,
          'doctorId': doctorId,
          'department': department,
          'resultFileUrl': resultFileUrl,
          'notes': notes,
          'reviewedByDoctor': false,
          'classification': null,
          'doctorNotes': null,
          'reviewedBy': null,
          'createdAt': FieldValue.serverTimestamp(),
          'reviewedAt': null,
        });

        // 2. Update Appointment to mark result as uploaded
        transaction.update(appointmentDocRef, {
          'resultUploaded': true,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      });
    } on FirebaseException catch (e) {
      throw ServerException(FirebaseErrorMapper.getMessage(e));
    } catch (e) {
      throw e is AppException
          ? e
          : const ServerException('Failed to upload result');
    }
  }

  @override
  Future<void> reviewResult({
    required String resultId,
    required String doctorId,
    required String doctorNotes,
    required String classification,
  }) async {
    try {
      final resultRef = _firestore.collection('results').doc(resultId);
      final doctorDocRef = _firestore.collection('users').doc(doctorId);

      await _firestore.runTransaction((transaction) async {
        final resultDoc = await transaction.get(resultRef);
        if (!resultDoc.exists) {
          throw const ServerException('Result not found');
        }

        final appointmentId = resultDoc.data()?['appointmentId'];
        final doctorDoc = await transaction.get(doctorDocRef);
        final doctorName = doctorDoc.data()?['fullName'] ?? 'Unknown Doctor';

        // 1. Update Result Document
        transaction.update(resultRef, {
          'reviewedByDoctor': true,
          'reviewedBy': doctorName,
          'classification': classification,
          'doctorNotes': doctorNotes,
          'reviewedAt': FieldValue.serverTimestamp(),
        });

        // 2. Update Appointment to completed
        transaction.update(
          _firestore.collection('appointments').doc(appointmentId),
          {'status': 'completed', 'updatedAt': FieldValue.serverTimestamp()},
        );
      });
    } on FirebaseException catch (e) {
      throw ServerException(FirebaseErrorMapper.getMessage(e));
    } catch (e) {
      throw e is AppException
          ? e
          : const ServerException('Failed to review result');
    }
  }

  @override
  Future<List<ResultModel>> getPatientResults({
    required String patientId,
  }) async {
    try {
      final resultsDoc =
          await _firestore
              .collection('results')
              .where('patientId', isEqualTo: patientId)
              .orderBy('createdAt', descending: true)
              .get();

      return resultsDoc.docs.map((e) => ResultModel.fromMap(e.data())).toList();
    } on FirebaseException catch (e) {
      print(e.message);
      throw ServerException(FirebaseErrorMapper.getMessage(e));
    } catch (e) {
      throw e is AppException
          ? e
          : const ServerException('Failed to fetch patient results');
    }
  }

  @override
  Future<List<ResultModel>> getDoctorPendingReviews({
    required String doctorId,
  }) async {
    try {
      final resultsDoc =
          await _firestore
              .collection('results')
              .where('doctorId', isEqualTo: doctorId)
              .where('reviewedByDoctor', isEqualTo: false)
              .orderBy('createdAt', descending: true)
              .get();
      print('Failed to fetch pending reviews ${resultsDoc.docs}');

      return resultsDoc.docs.map((e) => ResultModel.fromMap(e.data())).toList();
    } on FirebaseException catch (e) {
      print('Failed to fetch pending reviews $e');
      throw ServerException(FirebaseErrorMapper.getMessage(e));
    } catch (e) {
      print('Failed to fetch pending reviews $e');
      throw e is AppException
          ? e
          : const ServerException('Failed to fetch pending reviews');
    }
  }

  @override
  Future<List<AppointmentModel>> getServedPatients() async {
    try {
      final snapshot =
          await _firestore
              .collection('appointments')
              .where('queueStatus', isEqualTo: 'served')
              .where('resultUploaded', isEqualTo: false)
              .get();

      return snapshot.docs
          .map((doc) => AppointmentModel.fromMap(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw ServerException(FirebaseErrorMapper.getMessage(e));
    } catch (e) {
      throw const ServerException('Failed to fetch served patients');
    }
  }
}
