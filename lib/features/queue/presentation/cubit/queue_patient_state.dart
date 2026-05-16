import 'package:radiology_and_lab_app/features/appointment/domain/entites/appointment_entity.dart';

abstract class QueuePatientState {}

class QueuePatientInitial extends QueuePatientState {}

class QueuePatientLoading extends QueuePatientState {}

class QueuePatientLoaded extends QueuePatientState {
  final AppointmentEntity? queueEntry;
  final int patientsAhead;

  QueuePatientLoaded({
    required this.queueEntry,
    required this.patientsAhead,
  });
}

class QueuePatientError extends QueuePatientState {
  final String message;
  QueuePatientError(this.message);
}
