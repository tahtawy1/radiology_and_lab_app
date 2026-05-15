import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:radiology_and_lab_app/core/errors/exceptions.dart';
import 'package:radiology_and_lab_app/core/errors/failures.dart';
import 'package:radiology_and_lab_app/features/appointment/domain/entites/appointment_entity.dart';
import 'package:radiology_and_lab_app/features/appointment/domain/usecases/book_appointment_usecase.dart';
import 'package:radiology_and_lab_app/features/appointment/domain/usecases/cancel_appointment_usecase.dart';
import 'package:radiology_and_lab_app/features/appointment/domain/usecases/get_all_appointments_usecase.dart';
import 'package:radiology_and_lab_app/features/appointment/domain/usecases/get_doctors_usecase.dart';
import 'package:radiology_and_lab_app/features/appointment/domain/usecases/get_patient_appointments_usecase.dart';
import 'package:radiology_and_lab_app/features/appointment/domain/usecases/update_appointment_status_usecase.dart';
import 'appointment_state.dart';

class AppointmentCubit extends Cubit<AppointmentState> {
  final BookAppointmentUseCase bookAppointmentUseCase;
  final GetPatientAppointmentsUseCase getPatientAppointmentsUseCase;
  final GetAllAppointmentsUseCase getAllAppointmentsUseCase;
  final CancelAppointmentUseCase cancelAppointmentUseCase;
  final UpdateAppointmentStatusUseCase updateAppointmentStatusUseCase;
  final GetDoctorsUseCase getDoctorsUseCase;

  AppointmentCubit({
    required this.bookAppointmentUseCase,
    required this.getPatientAppointmentsUseCase,
    required this.getAllAppointmentsUseCase,
    required this.cancelAppointmentUseCase,
    required this.updateAppointmentStatusUseCase,
    required this.getDoctorsUseCase,
  }) : super(AppointmentInitial());

  // ── Failure mapper ─────────────────────────────────────────────────────────
  Failure _mapExceptionToFailure(dynamic e) {
    if (e is ValidationException) return ValidationFailure(e.message);
    if (e is NetworkException) return NetworkFailure(e.message);
    if (e is ServerException) return ServerFailure(e.message);
    return ServerFailure(e.toString());
  }

  // ── Book Appointment ───────────────────────────────────────────────────────
  Future<void> bookAppointment(AppointmentEntity appointment) async {
    emit(AppointmentLoading());
    try {
      await bookAppointmentUseCase(appointment);
      emit(AppointmentBookedSuccess());
    } catch (e) {
      emit(AppointmentError(_mapExceptionToFailure(e).message));
    }
  }

  // ── Get Patient Appointments ───────────────────────────────────────────────
  Future<void> getPatientAppointments(String patientId) async {
    emit(AppointmentLoading());
    try {
      final appointments = await getPatientAppointmentsUseCase(patientId);
      emit(AppointmentsLoaded(appointments: appointments));
    } catch (e) {
      emit(AppointmentError(_mapExceptionToFailure(e).message));
    }
  }

  // ── Get All Appointments (Admin use) ───────────────────────────────────────
  Future<void> getAllAppointments() async {
    emit(AppointmentLoading());
    try {
      final appointments = await getAllAppointmentsUseCase();
      emit(AppointmentsLoaded(appointments: appointments));
    } catch (e) {
      emit(AppointmentError(_mapExceptionToFailure(e).message));
    }
  }

  // ── Cancel Appointment ─────────────────────────────────────────────────────
  Future<void> cancelAppointment(String appointmentId) async {
    emit(AppointmentLoading());
    try {
      await cancelAppointmentUseCase(appointmentId);
      emit(AppointmentCancelledSuccess());
    } catch (e) {
      emit(AppointmentError(_mapExceptionToFailure(e).message));
    }
  }

  // ── Update Status (Admin use) ──────────────────────────────────────────────
  Future<void> updateAppointmentStatus({
    required String appointmentId,
    required String status,
  }) async {
    emit(AppointmentLoading());
    try {
      await updateAppointmentStatusUseCase(
        appointmentId: appointmentId,
        status: status,
      );
      emit(AppointmentStatusUpdatedSuccess());
    } catch (e) {
      emit(AppointmentError(_mapExceptionToFailure(e).message));
    }
  }

  // ── Get Doctors ────────────────────────────────────────────────────────────
  Future<void> getDoctors() async {
    emit(AppointmentLoading());
    try {
      final doctors = await getDoctorsUseCase();
      emit(DoctorsLoaded(doctors));
    } catch (e) {
      emit(AppointmentError(_mapExceptionToFailure(e).message));
    }
  }
}
