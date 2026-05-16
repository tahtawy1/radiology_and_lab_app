import 'package:radiology_and_lab_app/features/appointment/domain/entites/appointment_entity.dart';

abstract class QueueAdminState {}

class QueueAdminInitial extends QueueAdminState {}

class QueueAdminLoading extends QueueAdminState {}

class QueueAdminLoaded extends QueueAdminState {
  final List<AppointmentEntity> queueEntries;
  final int totalToday;
  final int called;
  final int served;

  QueueAdminLoaded({
    required this.queueEntries,
    required this.totalToday,
    required this.called,
    required this.served,
  });
}

class QueueAdminError extends QueueAdminState {
  final String message;
  QueueAdminError(this.message);
}

class QueueAdminActionSuccess extends QueueAdminState {
  final String message;
  QueueAdminActionSuccess(this.message);
}
