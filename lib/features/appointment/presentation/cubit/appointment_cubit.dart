import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:radiology_and_lab_app/core/errors/exceptions.dart';
import 'package:radiology_and_lab_app/core/errors/failures.dart';
import 'package:radiology_and_lab_app/features/appointment/domain/entites/appointment_entity.dart';
import 'package:radiology_and_lab_app/features/appointment/domain/entites/appointment_enums.dart';
import 'package:radiology_and_lab_app/features/appointment/domain/usecases/book_appointment_usecase.dart';
import 'package:radiology_and_lab_app/features/appointment/domain/usecases/cancel_appointment_usecase.dart';
import 'package:radiology_and_lab_app/features/appointment/domain/usecases/get_all_appointments_usecase.dart';
import 'package:radiology_and_lab_app/features/appointment/domain/usecases/get_doctors_usecase.dart';
import 'package:radiology_and_lab_app/features/appointment/domain/usecases/get_patient_appointments_usecase.dart';
import 'package:radiology_and_lab_app/features/appointment/domain/usecases/get_pending_appointments_for_doctor_usecase.dart';
import 'package:radiology_and_lab_app/features/appointment/domain/usecases/update_appointment_status_usecase.dart';
import 'package:radiology_and_lab_app/features/appointment/domain/usecases/update_queue_status_usecase.dart';
import 'appointment_state.dart';

class AppointmentCubit extends Cubit<AppointmentState> {
  final BookAppointmentUseCase bookAppointmentUseCase;
  final GetPatientAppointmentsUseCase getPatientAppointmentsUseCase;
  final GetAllAppointmentsUseCase getAllAppointmentsUseCase;
  final CancelAppointmentUseCase cancelAppointmentUseCase;
  final UpdateAppointmentStatusUseCase updateAppointmentStatusUseCase;
  final UpdateQueueStatusUseCase updateQueueStatusUseCase;
  final GetDoctorsUseCase getDoctorsUseCase;
  final GetPendingAppointmentsForDoctorUseCase getPendingAppointmentsForDoctorUseCase;

  AppointmentCubit({
    required this.bookAppointmentUseCase,
    required this.getPatientAppointmentsUseCase,
    required this.getAllAppointmentsUseCase,
    required this.cancelAppointmentUseCase,
    required this.updateAppointmentStatusUseCase,
    required this.updateQueueStatusUseCase,
    required this.getDoctorsUseCase,
    required this.getPendingAppointmentsForDoctorUseCase,
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

  // ── Get Pending Appointments for Doctor ────────────────────────────────────
  Future<void> getPendingAppointmentsForDoctor(String doctorId) async {
    emit(AppointmentLoading());
    try {
      final appointments = await getPendingAppointmentsForDoctorUseCase(doctorId);
      emit(AppointmentsLoaded(appointments: appointments));
    } catch (e) {
      emit(AppointmentError(_mapExceptionToFailure(e).message));
    }
  }

  // ── Approve Appointment ────────────────────────────────────────────────────
  Future<void> approveAppointment(String appointmentId) async {
    emit(AppointmentLoading());
    try {
      await updateAppointmentStatusUseCase(
        appointmentId: appointmentId,
        status: AppointmentStatus.confirmed,
      );
      emit(AppointmentStatusUpdatedSuccess());
    } catch (e) {
      emit(AppointmentError(_mapExceptionToFailure(e).message));
    }
  }

  // ── Reject Appointment ─────────────────────────────────────────────────────
  Future<void> rejectAppointment(String appointmentId) async {
    emit(AppointmentLoading());
    try {
      await updateAppointmentStatusUseCase(
        appointmentId: appointmentId,
        status: AppointmentStatus.cancelled,
      );
      emit(AppointmentStatusUpdatedSuccess());
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
    required AppointmentStatus status,
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

  // ── Update Queue Status (Admin/Doctor use) ──────────────────────────────────
  Future<void> updateQueueStatus({
    required String appointmentId,
    required QueueStatus status,
  }) async {
    emit(AppointmentLoading());
    try {
      await updateQueueStatusUseCase(
        appointmentId: appointmentId,
        status: status,
      );
      emit(AppointmentStatusUpdatedSuccess()); // Reuse same success state for simplicity
    } catch (e) {
      emit(AppointmentError(_mapExceptionToFailure(e).message));
    }
  }
}
