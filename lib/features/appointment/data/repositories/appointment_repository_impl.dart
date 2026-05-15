import 'package:radiology_and_lab_app/features/appointment/data/datasource/appointment_remote_datasource.dart';
import 'package:radiology_and_lab_app/features/appointment/domain/entites/appointment_entity.dart';
import 'package:radiology_and_lab_app/features/appointment/domain/repositories/appointment_repository.dart';

import '../../../../core/errors/exceptions.dart';

import '../models/appointment_model.dart';

class AppointmentRepositoryImpl implements AppointmentRepository {
  final AppointmentRemoteDataSource remoteDataSource;

  AppointmentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> bookAppointment(AppointmentEntity appointment) async {
    try {
      await remoteDataSource.bookAppointment(
        AppointmentModel.fromEntity(appointment),
      );
    } on AppException {
      rethrow;
    }
  }

  @override
  Future<void> cancelAppointment(String appointmentId) async {
    try {
      await remoteDataSource.cancelAppointment(appointmentId);
    } on AppException {
      rethrow;
    }
  }

  @override
  Future<List<AppointmentEntity>> getAllAppointments() async {
    try {
      return await remoteDataSource.getAllAppointments();
    } on AppException {
      rethrow;
    }
  }

  @override
  Future<List<AppointmentEntity>> getAppointmentsByPatientId(
    String patientId,
  ) async {
    try {
      return await remoteDataSource.getAppointmentsByPatientId(patientId);
    } on AppException {
      rethrow;
    }
  }

  @override
  Future<void> updateAppointmentStatus({
    required String appointmentId,
    required String status,
  }) async {
    try {
      await remoteDataSource.updateAppointmentStatus(
        appointmentId: appointmentId,
        status: status,
      );
    } on AppException {
      rethrow;
    }
  }

  @override
  Future<List<Map<String, String>>> getDoctors() {
    return remoteDataSource.getDoctors();
  }
}
