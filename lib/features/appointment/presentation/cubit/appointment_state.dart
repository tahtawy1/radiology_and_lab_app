import 'package:radiology_and_lab_app/features/appointment/domain/entites/appointment_entity.dart';

abstract class AppointmentState {
  final List<AppointmentEntity> appointments;
  final List<AppointmentEntity> pendingDoctorAppointments;
  final List<AppointmentEntity> allAppointments;
  final List<Map<String, String>> doctors;

  AppointmentState({
    this.appointments = const [],
    this.pendingDoctorAppointments = const [],
    this.allAppointments = const [],
    this.doctors = const [],
  });
}

class AppointmentInitial extends AppointmentState {}

class AppointmentLoading extends AppointmentState {
  AppointmentLoading({
    super.appointments,
    super.pendingDoctorAppointments,
    super.allAppointments,
    super.doctors,
  });
}

class AppointmentBookedSuccess extends AppointmentState {
  AppointmentBookedSuccess({
    super.appointments,
    super.pendingDoctorAppointments,
    super.allAppointments,
    super.doctors,
  });
}

class AppointmentCancelledSuccess extends AppointmentState {
  AppointmentCancelledSuccess({
    super.appointments,
    super.pendingDoctorAppointments,
    super.allAppointments,
    super.doctors,
  });
}

class AppointmentStatusUpdatedSuccess extends AppointmentState {
  AppointmentStatusUpdatedSuccess({
    super.appointments,
    super.pendingDoctorAppointments,
    super.allAppointments,
    super.doctors,
  });
}

class AppointmentsLoaded extends AppointmentState {
  AppointmentsLoaded({
    required super.appointments,
    super.pendingDoctorAppointments,
    super.allAppointments,
    super.doctors,
  });
}

class AppointmentError extends AppointmentState {
  final String message;
  AppointmentError(
    this.message, {
    super.appointments,
    super.pendingDoctorAppointments,
    super.allAppointments,
    super.doctors,
  });
}

class DoctorsLoaded extends AppointmentState {
  DoctorsLoaded(
    List<Map<String, String>> doctors, {
    super.appointments,
    super.pendingDoctorAppointments,
    super.allAppointments,
  }) : super(doctors: doctors);
}
