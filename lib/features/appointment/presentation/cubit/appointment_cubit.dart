import 'dart:async';
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
import '../../../../core/errors/firebase_error_mapper.dart';
import '../../../../features/notifications/domain/entites/notification_entity.dart';
import '../../../../features/notifications/domain/usecases/send_notification_usecase.dart';
import 'appointment_state.dart';

class AppointmentCubit extends Cubit<AppointmentState> {
  final BookAppointmentUseCase bookAppointmentUseCase;
  final GetPatientAppointmentsUseCase getPatientAppointmentsUseCase;
  final GetAllAppointmentsUseCase getAllAppointmentsUseCase;
  final CancelAppointmentUseCase cancelAppointmentUseCase;
  final UpdateAppointmentStatusUseCase updateAppointmentStatusUseCase;
  final UpdateQueueStatusUseCase updateQueueStatusUseCase;
  final GetDoctorsUseCase getDoctorsUseCase;
  final GetPendingAppointmentsForDoctorUseCase
  getPendingAppointmentsForDoctorUseCase;
  final SendNotificationUseCase sendNotificationUseCase;

  StreamSubscription? _patientAppointmentsSubscription;
  StreamSubscription? _pendingAppointmentsSubscription;
  StreamSubscription? _allAppointmentsSubscription;

  AppointmentCubit({
    required this.bookAppointmentUseCase,
    required this.getPatientAppointmentsUseCase,
    required this.getAllAppointmentsUseCase,
    required this.cancelAppointmentUseCase,
    required this.updateAppointmentStatusUseCase,
    required this.updateQueueStatusUseCase,
    required this.getDoctorsUseCase,
    required this.getPendingAppointmentsForDoctorUseCase,
    required this.sendNotificationUseCase,
  }) : super(AppointmentInitial());

  // ── Error Message mapper ───────────────────────────────────────────────────
  String _mapExceptionToMessage(dynamic e) {
    return FirebaseErrorMapper.getMessage(e);
  }

  // ── Book Appointment ───────────────────────────────────────────────────────
  Future<void> bookAppointment(AppointmentEntity appointment) async {
    emit(AppointmentLoading());
    try {
      await bookAppointmentUseCase(appointment);
      // ── Notify doctor ──────────────────────────────────────────────────
      if (appointment.doctorId.isNotEmpty) {
        await sendNotificationUseCase(
          NotificationEntity(
            id: '',
            userId: appointment.doctorId,
            title: 'New Appointment Request',
            body: 'A new patient appointment request requires review.',
            type: NotificationType.newAppointmentRequest,
            isRead: false,
            createdAt: DateTime.now(),
          ),
        );
      }
      emit(AppointmentBookedSuccess());
    } catch (e) {
      emit(AppointmentError(_mapExceptionToMessage(e)));
    }
  }

  // ── Get Patient Appointments ───────────────────────────────────────────────
  void getPatientAppointments(String patientId) {
    emit(AppointmentLoading());
    _patientAppointmentsSubscription?.cancel();
    
    try {
      _patientAppointmentsSubscription = getPatientAppointmentsUseCase(patientId).listen(
        (appointments) {
          emit(AppointmentsLoaded(appointments: appointments));
        },
        onError: (e) {
          emit(AppointmentError(_mapExceptionToMessage(e)));
        },
      );
    } catch (e) {
      emit(AppointmentError(_mapExceptionToMessage(e)));
    }
  }

  // ── Get Pending Appointments for Doctor ────────────────────────────────────
  void getPendingAppointmentsForDoctor(String doctorId) {
    emit(AppointmentLoading());
    _pendingAppointmentsSubscription?.cancel();

    try {
      _pendingAppointmentsSubscription = getPendingAppointmentsForDoctorUseCase(doctorId).listen(
        (appointments) {
          emit(AppointmentsLoaded(appointments: appointments));
        },
        onError: (e) {
          emit(AppointmentError(_mapExceptionToMessage(e)));
        },
      );
    } catch (e) {
      emit(AppointmentError(_mapExceptionToMessage(e)));
    }
  }

  // ── Approve Appointment ────────────────────────────────────────────────────
  Future<void> approveAppointment(
    String appointmentId, {
    required String patientId,
  }) async {
    List<AppointmentEntity>? currentList;
    if (state is AppointmentsLoaded) {
      currentList = (state as AppointmentsLoaded).appointments;
      final optimisticList = currentList.where((a) => a.id != appointmentId).toList();
      emit(AppointmentsLoaded(appointments: optimisticList));
    } else {
      emit(AppointmentLoading());
    }

    try {
      await updateAppointmentStatusUseCase(
        appointmentId: appointmentId,
        status: AppointmentStatus.confirmed,
      );
      // ── Notify patient ──────────────────────────────────────────────────
      await sendNotificationUseCase(
        NotificationEntity(
          id: '',
          userId: patientId,
          title: 'Appointment Approved',
          body: 'Your appointment has been approved successfully.',
          type: NotificationType.appointmentApproved,
          isRead: false,
          createdAt: DateTime.now(),
        ),
      );
      emit(AppointmentStatusUpdatedSuccess());
      
      if (currentList != null) {
        final optimisticList = currentList.where((a) => a.id != appointmentId).toList();
        emit(AppointmentsLoaded(appointments: optimisticList));
      }
    } catch (e) {
      if (currentList != null) {
        emit(AppointmentsLoaded(appointments: currentList));
      }
      emit(AppointmentError(_mapExceptionToMessage(e)));
    }
  }

  // ── Reject Appointment ─────────────────────────────────────────────────────
  Future<void> rejectAppointment(
    String appointmentId, {
    required String patientId,
  }) async {
    List<AppointmentEntity>? currentList;
    if (state is AppointmentsLoaded) {
      currentList = (state as AppointmentsLoaded).appointments;
      final optimisticList = currentList.where((a) => a.id != appointmentId).toList();
      emit(AppointmentsLoaded(appointments: optimisticList));
    } else {
      emit(AppointmentLoading());
    }

    try {
      await updateAppointmentStatusUseCase(
        appointmentId: appointmentId,
        status: AppointmentStatus.cancelled,
      );
      // ── Notify patient ──────────────────────────────────────────────────
      await sendNotificationUseCase(
        NotificationEntity(
          id: '',
          userId: patientId,
          title: 'Appointment Rejected',
          body: 'Unfortunately, your appointment request was not approved.',
          type: NotificationType.appointmentRejected,
          isRead: false,
          createdAt: DateTime.now(),
        ),
      );
      emit(AppointmentStatusUpdatedSuccess());
      
      if (currentList != null) {
        final optimisticList = currentList.where((a) => a.id != appointmentId).toList();
        emit(AppointmentsLoaded(appointments: optimisticList));
      }
    } catch (e) {
      if (currentList != null) {
        emit(AppointmentsLoaded(appointments: currentList));
      }
      emit(AppointmentError(_mapExceptionToMessage(e)));
    }
  }

  // ── Get All Appointments (Admin use) ───────────────────────────────────────
  void getAllAppointments() {
    emit(AppointmentLoading());
    _allAppointmentsSubscription?.cancel();
    
    try {
      _allAppointmentsSubscription = getAllAppointmentsUseCase().listen(
        (appointments) {
          emit(AppointmentsLoaded(appointments: appointments));
        },
        onError: (e) {
          emit(AppointmentError(_mapExceptionToMessage(e)));
        },
      );
    } catch (e) {
      emit(AppointmentError(_mapExceptionToMessage(e)));
    }
  }

  // ── Cancel Appointment ─────────────────────────────────────────────────────
  Future<void> cancelAppointment(String appointmentId) async {
    emit(AppointmentLoading());
    try {
      await cancelAppointmentUseCase(appointmentId);
      emit(AppointmentCancelledSuccess());
    } catch (e) {
      emit(AppointmentError(_mapExceptionToMessage(e)));
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
      emit(AppointmentError(_mapExceptionToMessage(e)));
    }
  }

  // ── Get Doctors ────────────────────────────────────────────────────────────
  Future<void> getDoctors() async {
    emit(AppointmentLoading());
    try {
      final doctors = await getDoctorsUseCase();
      emit(DoctorsLoaded(doctors));
    } catch (e) {
      emit(AppointmentError(_mapExceptionToMessage(e)));
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
      emit(
        AppointmentStatusUpdatedSuccess(),
      ); // Reuse same success state for simplicity
    } catch (e) {
      emit(AppointmentError(_mapExceptionToMessage(e)));
    }
  }

  @override
  Future<void> close() {
    _patientAppointmentsSubscription?.cancel();
    _pendingAppointmentsSubscription?.cancel();
    _allAppointmentsSubscription?.cancel();
    return super.close();
  }
}
