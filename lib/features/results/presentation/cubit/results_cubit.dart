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
import '../../../../core/errors/firebase_error_mapper.dart';
import '../../../../features/notifications/domain/entites/notification_entity.dart';
import '../../../../features/notifications/domain/usecases/send_notification_usecase.dart';
import 'results_state.dart';

class ResultsCubit extends Cubit<ResultsState> {
  final UploadResultUseCase uploadResultUseCase;
  final ReviewResultUseCase reviewResultUseCase;
  final GetPatientResultsUseCase getPatientResultsUseCase;
  final GetDoctorPendingReviewsUseCase getDoctorPendingReviewsUseCase;
  final GetServedPatientsUseCase getServedPatientsUseCase;
  final CloudinaryService cloudinaryService;
  final SendNotificationUseCase sendNotificationUseCase;

  ResultsCubit({
    required this.uploadResultUseCase,
    required this.reviewResultUseCase,
    required this.getPatientResultsUseCase,
    required this.getDoctorPendingReviewsUseCase,
    required this.getServedPatientsUseCase,
    required this.cloudinaryService,
    required this.sendNotificationUseCase,
  }) : super(ResultsInitial());

  String _mapExceptionToMessage(dynamic e) {
    return FirebaseErrorMapper.getMessage(e);
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

      final doctorId = await uploadResultUseCase(
        appointmentId: appointmentId,
        resultFileUrl: secureUrl,
        notes: notes,
      );
      
      // ── Notify the doctor ──────────────────────────────────────────
      if (doctorId.isNotEmpty) {
        await sendNotificationUseCase(
          NotificationEntity(
            id: '',
            userId: doctorId,
            title: 'New Result Uploaded',
            body: 'A new result has been uploaded and is pending your review.',
            type: NotificationType.resultUploaded,
            isRead: false,
            createdAt: DateTime.now(),
          ),
        );
      }

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
      final patientId = await reviewResultUseCase(
        resultId: resultId,
        doctorId: doctorId,
        doctorNotes: doctorNotes,
        classification: classification,
      );
      
      // ── Notify the patient ─────────────────────────────────────────
      if (patientId.isNotEmpty) {
        await sendNotificationUseCase(
          NotificationEntity(
            id: '',
            userId: patientId,
            title: 'Result Reviewed',
            body: 'Your test result has been reviewed by the doctor.',
            type: NotificationType.resultReviewed,
            isRead: false,
            createdAt: DateTime.now(),
          ),
        );
      }

      // ── Notify Admins/Lab ──────────────────────────────────────────
      await sendNotificationUseCase(
        NotificationEntity(
          id: '',
          userId: 'ADMINS',
          title: 'Result Review Completed',
          body: 'A medical result has been reviewed and finalized by the doctor.',
          type: NotificationType.reviewCompleted,
          isRead: false,
          createdAt: DateTime.now(),
        ),
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
