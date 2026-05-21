import 'package:radiology_and_lab_app/features/appointment/domain/entites/appointment_entity.dart';

abstract class QueuePatientState {
  final AppointmentEntity? queueEntry;
  final int patientsAhead;

  QueuePatientState({
    this.queueEntry,
    this.patientsAhead = 0,
  });
}

class QueuePatientInitial extends QueuePatientState {}

class QueuePatientLoading extends QueuePatientState {
  QueuePatientLoading({
    super.queueEntry,
    super.patientsAhead,
  });
}

class QueuePatientLoaded extends QueuePatientState {
  QueuePatientLoaded({
    required super.queueEntry,
    required super.patientsAhead,
  });
}

class QueuePatientError extends QueuePatientState {
  final String message;
  QueuePatientError(
    this.message, {
    super.queueEntry,
    super.patientsAhead,
  });
}
