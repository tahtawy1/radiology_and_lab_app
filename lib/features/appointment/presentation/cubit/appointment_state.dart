import 'package:radiology_and_lab_app/features/appointment/domain/entites/appointment_entity.dart';

abstract class AppointmentState {}

class AppointmentInitial extends AppointmentState {}

class AppointmentLoading extends AppointmentState {}

class AppointmentBookedSuccess extends AppointmentState {}

class AppointmentCancelledSuccess extends AppointmentState {}

class AppointmentStatusUpdatedSuccess extends AppointmentState {}

class AppointmentsLoaded extends AppointmentState {
  final List<AppointmentEntity> appointments;
  AppointmentsLoaded({required this.appointments});
}

class AppointmentError extends AppointmentState {
  final String message;
  AppointmentError(this.message);
}

class DoctorsLoaded extends AppointmentState {
  final List<Map<String, String>> doctors;
  DoctorsLoaded(this.doctors);
}
