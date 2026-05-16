import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/cloudinary_service.dart';
import '../../domain/usecases/get_doctor_pending_reviews_usecase.dart';
import '../../domain/usecases/get_patient_results_usecase.dart';
import '../../domain/usecases/review_result_usecase.dart';
import '../../domain/usecases/upload_result_usecase.dart';
import '../../domain/usecases/get_served_patients_usecase.dart';
import 'results_state.dart';

class ResultsCubit extends Cubit<ResultsState> {
  final UploadResultUseCase uploadResultUseCase;
  final ReviewResultUseCase reviewResultUseCase;
  final GetPatientResultsUseCase getPatientResultsUseCase;
  final GetDoctorPendingReviewsUseCase getDoctorPendingReviewsUseCase;
  final GetServedPatientsUseCase getServedPatientsUseCase;
  final CloudinaryService cloudinaryService;

  ResultsCubit({
    required this.uploadResultUseCase,
    required this.reviewResultUseCase,
    required this.getPatientResultsUseCase,
    required this.getDoctorPendingReviewsUseCase,
    required this.getServedPatientsUseCase,
    required this.cloudinaryService,
  }) : super(ResultsInitial());

  String _mapExceptionToMessage(dynamic e) {
    if (e is ValidationException) return e.message;
    if (e is NetworkException) return e.message;
    if (e is ServerException) return e.message;
    return e.toString();
  }

  // ── Upload Result ──────────────────────────────────────────────────────────
  Future<void> uploadResult({
    required String appointmentId,
    required String filePath,
    required String notes,
  }) async {
    emit(ResultsLoading());
    try {
      final secureUrl = await cloudinaryService.uploadFile(filePath);

      await uploadResultUseCase(
        appointmentId: appointmentId,
        resultFileUrl: secureUrl,
        notes: notes,
      );
      emit(ResultsActionSuccess('Result uploaded successfully'));
    } catch (e) {
      emit(ResultsError(_mapExceptionToMessage(e)));
    }
  }

  // ── Review Result ──────────────────────────────────────────────────────────
  Future<void> reviewResult({
    required String resultId,
    required String doctorId,
    required String doctorNotes,
    required String classification,
  }) async {
    emit(ResultsLoading());
    try {
      await reviewResultUseCase(
        resultId: resultId,
        doctorId: doctorId,
        doctorNotes: doctorNotes,
        classification: classification,
      );
      emit(ResultsActionSuccess('Result reviewed successfully'));
    } catch (e) {
      emit(ResultsError(_mapExceptionToMessage(e)));
    }
  }

  // ── Get Patient Results ────────────────────────────────────────────────────
  Future<void> getPatientResults(String patientId) async {
    emit(ResultsLoading());
    try {
      final results = await getPatientResultsUseCase(patientId: patientId);
      emit(ResultsLoaded(results));
    } catch (e) {
      emit(ResultsError(_mapExceptionToMessage(e)));
    }
  }

  // ── Get Doctor Pending Reviews ─────────────────────────────────────────────
  Future<void> getDoctorPendingReviews(String doctorId) async {
    emit(ResultsLoading());
    try {
      final results = await getDoctorPendingReviewsUseCase(doctorId: doctorId);
      emit(ResultsLoaded(results));
    } catch (e) {
      emit(ResultsError(_mapExceptionToMessage(e)));
    }
  }

  // ── Get Served Patients ────────────────────────────────────────────────────
  Future<void> getServedPatients() async {
    emit(ResultsLoading());
    try {
      final appointments = await getServedPatientsUseCase();
      emit(ServedPatientsLoaded(appointments));
    } catch (e) {
      emit(ResultsError(_mapExceptionToMessage(e)));
    }
  }
}
