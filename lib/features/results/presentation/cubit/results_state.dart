import '../../domain/entites/result_entity.dart';
import '../../../appointment/domain/entites/appointment_entity.dart';

abstract class ResultsState {}

class ResultsInitial extends ResultsState {}

class ResultsLoading extends ResultsState {}

class ResultsLoaded extends ResultsState {
  final List<ResultEntity> results;
  ResultsLoaded(this.results);
}

class ServedPatientsLoaded extends ResultsState {
  final List<AppointmentEntity> appointments;
  ServedPatientsLoaded(this.appointments);
}

class ResultsActionSuccess extends ResultsState {
  final String message;
  ResultsActionSuccess(this.message);
}

class ResultsError extends ResultsState {
  final String message;
  ResultsError(this.message);
}
