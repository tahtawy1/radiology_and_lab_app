import 'package:radiology_and_lab_app/features/appointment/domain/entites/appointment_entity.dart';

abstract class QueueAdminState {
  final List<AppointmentEntity> queueEntries;
  final int totalToday;
  final int called;
  final int served;

  QueueAdminState({
    this.queueEntries = const [],
    this.totalToday = 0,
    this.called = 0,
    this.served = 0,
  });
}

class QueueAdminInitial extends QueueAdminState {}

class QueueAdminLoading extends QueueAdminState {
  QueueAdminLoading({
    super.queueEntries,
    super.totalToday,
    super.called,
    super.served,
  });
}

class QueueAdminLoaded extends QueueAdminState {
  QueueAdminLoaded({
    required super.queueEntries,
    required super.totalToday,
    required super.called,
    required super.served,
  });
}

class QueueAdminError extends QueueAdminState {
  final String message;
  QueueAdminError(
    this.message, {
    super.queueEntries,
    super.totalToday,
    super.called,
    super.served,
  });
}

class QueueAdminActionSuccess extends QueueAdminState {
  final String message;
  QueueAdminActionSuccess(
    this.message, {
    super.queueEntries,
    super.totalToday,
    super.called,
    super.served,
  });
}
