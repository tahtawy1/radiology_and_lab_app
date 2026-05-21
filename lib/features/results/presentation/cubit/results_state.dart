import '../../domain/entites/result_entity.dart';
import '../../../appointment/domain/entites/appointment_entity.dart';

abstract class ResultsState {
  final List<ResultEntity> results;
  final List<ResultEntity> doctorPendingReviews;
  final List<AppointmentEntity> servedPatients;

  ResultsState({
    this.results = const [],
    this.doctorPendingReviews = const [],
    this.servedPatients = const [],
  });
}

class ResultsInitial extends ResultsState {}

class ResultsLoading extends ResultsState {
  ResultsLoading({
    super.results,
    super.doctorPendingReviews,
    super.servedPatients,
  });
}

class ResultsLoaded extends ResultsState {
  ResultsLoaded(
    List<ResultEntity> results, {
    super.doctorPendingReviews,
    super.servedPatients,
  }) : super(results: results);
}

class ServedPatientsLoaded extends ResultsState {
  List<AppointmentEntity> get appointments => servedPatients;

  ServedPatientsLoaded(
    List<AppointmentEntity> appointments, {
    super.results,
    super.doctorPendingReviews,
  }) : super(servedPatients: appointments);
}

class ResultsActionSuccess extends ResultsState {
  final String message;
  ResultsActionSuccess(
    this.message, {
    super.results,
    super.doctorPendingReviews,
    super.servedPatients,
  });
}

class ResultsError extends ResultsState {
  final String message;
  ResultsError(
    this.message, {
    super.results,
    super.doctorPendingReviews,
    super.servedPatients,
  });
}
