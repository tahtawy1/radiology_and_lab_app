import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/cloudinary_service.dart';
import '../../domain/usecases/get_doctor_pending_reviews_usecase.dart';
import '../../domain/usecases/get_patient_results_usecase.dart';
import '../../domain/usecases/get_doctor_results_usecase.dart';
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
  final GetDoctorResultsUseCase getDoctorResultsUseCase;
  final GetServedPatientsUseCase getServedPatientsUseCase;
  final CloudinaryService cloudinaryService;
  final SendNotificationUseCase sendNotificationUseCase;

  StreamSubscription? _patientResultsSubscription;
  StreamSubscription? _doctorPendingReviewsSubscription;
  StreamSubscription? _doctorResultsSubscription;
  StreamSubscription? _servedPatientsSubscription;

  ResultsCubit({
    required this.uploadResultUseCase,
    required this.reviewResultUseCase,
    required this.getPatientResultsUseCase,
    required this.getDoctorPendingReviewsUseCase,
    required this.getDoctorResultsUseCase,
    required this.getServedPatientsUseCase,
    required this.cloudinaryService,
    required this.sendNotificationUseCase,
  }) : super(ResultsInitial());

  String _mapExceptionToMessage(dynamic e) {
    return FirebaseErrorMapper.getMessage(e);
  }

  // ── Upload Result ────────────────------------------------------------------
  Future<void> uploadResult({
    required String appointmentId,
    required String filePath,
    required String notes,
  }) async {
    emit(ResultsLoading(
      results: state.results,
      doctorPendingReviews: state.doctorPendingReviews,
      servedPatients: state.servedPatients,
    ));
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

      emit(ResultsActionSuccess(
        'Result uploaded successfully',
        results: state.results,
        doctorPendingReviews: state.doctorPendingReviews,
        servedPatients: state.servedPatients,
      ));
    } catch (e) {
      // ── Notify Admins of upload failure ─────────────────────────────
      await sendNotificationUseCase(
        NotificationEntity(
          id: '',
          userId: 'ADMINS',
          title: 'Upload Failed',
          body: 'An error occurred while uploading a result. Please try again.',
          type: NotificationType.uploadFailed,
          isRead: false,
          createdAt: DateTime.now(),
        ),
      );
      emit(ResultsError(
        _mapExceptionToMessage(e),
        results: state.results,
        doctorPendingReviews: state.doctorPendingReviews,
        servedPatients: state.servedPatients,
      ));
    }
  }

  // ── Review Result ────────────────------------------------------------------
  Future<void> reviewResult({
    required String resultId,
    required String doctorId,
    required String doctorNotes,
    required String classification,
  }) async {
    emit(ResultsLoading(
      results: state.results,
      doctorPendingReviews: state.doctorPendingReviews,
      servedPatients: state.servedPatients,
    ));
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

      emit(ResultsActionSuccess(
        'Result reviewed successfully',
        results: state.results,
        doctorPendingReviews: state.doctorPendingReviews,
        servedPatients: state.servedPatients,
      ));
    } catch (e) {
      emit(ResultsError(
        _mapExceptionToMessage(e),
        results: state.results,
        doctorPendingReviews: state.doctorPendingReviews,
        servedPatients: state.servedPatients,
      ));
    }
  }

  // ── Get Patient Results ────────────────────────────────────────────────────
  void getPatientResults(String patientId) {
    emit(ResultsLoading(
      results: state.results,
      doctorPendingReviews: state.doctorPendingReviews,
      servedPatients: state.servedPatients,
    ));
    _patientResultsSubscription?.cancel();
    try {
      _patientResultsSubscription = getPatientResultsUseCase(patientId: patientId).listen(
        (results) {
          emit(ResultsLoaded(
            results,
            doctorPendingReviews: state.doctorPendingReviews,
            servedPatients: state.servedPatients,
          ));
        },
        onError: (e) {
          emit(ResultsError(
            _mapExceptionToMessage(e),
            results: state.results,
            doctorPendingReviews: state.doctorPendingReviews,
            servedPatients: state.servedPatients,
          ));
        },
      );
    } catch (e) {
      emit(ResultsError(
        _mapExceptionToMessage(e),
        results: state.results,
        doctorPendingReviews: state.doctorPendingReviews,
        servedPatients: state.servedPatients,
      ));
    }
  }

  // ── Get Doctor Pending Reviews ─────────────────────────────────────────────
  void getDoctorPendingReviews(String doctorId) {
    emit(ResultsLoading(
      results: state.results,
      doctorPendingReviews: state.doctorPendingReviews,
      servedPatients: state.servedPatients,
    ));
    _doctorPendingReviewsSubscription?.cancel();
    try {
      _doctorPendingReviewsSubscription = getDoctorPendingReviewsUseCase(doctorId: doctorId).listen(
        (pendingReviews) {
          emit(ResultsLoaded(
            state.results,
            doctorPendingReviews: pendingReviews,
            servedPatients: state.servedPatients,
          ));
        },
        onError: (e) {
          emit(ResultsError(
            _mapExceptionToMessage(e),
            results: state.results,
            doctorPendingReviews: state.doctorPendingReviews,
            servedPatients: state.servedPatients,
          ));
        },
      );
    } catch (e) {
      emit(ResultsError(
        _mapExceptionToMessage(e),
        results: state.results,
        doctorPendingReviews: state.doctorPendingReviews,
        servedPatients: state.servedPatients,
      ));
    }
  }

  // ── Get Doctor All Results ─────────────────────────────────────────────────
  void getDoctorResults(String doctorId) {
    emit(ResultsLoading(
      results: state.results,
      doctorPendingReviews: state.doctorPendingReviews,
      servedPatients: state.servedPatients,
    ));
    _doctorResultsSubscription?.cancel();
    try {
      _doctorResultsSubscription = getDoctorResultsUseCase(doctorId).listen(
        (allResults) {
          emit(ResultsLoaded(
            allResults,
            doctorPendingReviews: state.doctorPendingReviews,
            servedPatients: state.servedPatients,
          ));
        },
        onError: (e) {
          emit(ResultsError(
            _mapExceptionToMessage(e),
            results: state.results,
            doctorPendingReviews: state.doctorPendingReviews,
            servedPatients: state.servedPatients,
          ));
        },
      );
    } catch (e) {
      emit(ResultsError(
        _mapExceptionToMessage(e),
        results: state.results,
        doctorPendingReviews: state.doctorPendingReviews,
        servedPatients: state.servedPatients,
      ));
    }
  }

  // ── Get Served Patients ────────────────--------------------------------────
  void getServedPatients() {
    emit(ResultsLoading(
      results: state.results,
      doctorPendingReviews: state.doctorPendingReviews,
      servedPatients: state.servedPatients,
    ));
    _servedPatientsSubscription?.cancel();
    try {
      _servedPatientsSubscription = getServedPatientsUseCase().listen(
        (appointments) {
          emit(ServedPatientsLoaded(
            appointments,
            results: state.results,
            doctorPendingReviews: state.doctorPendingReviews,
          ));
        },
        onError: (e) {
          emit(ResultsError(
            _mapExceptionToMessage(e),
            results: state.results,
            doctorPendingReviews: state.doctorPendingReviews,
            servedPatients: state.servedPatients,
          ));
        },
      );
    } catch (e) {
      emit(ResultsError(
        _mapExceptionToMessage(e),
        results: state.results,
        doctorPendingReviews: state.doctorPendingReviews,
        servedPatients: state.servedPatients,
      ));
    }
  }

  @override
  Future<void> close() {
    _patientResultsSubscription?.cancel();
    _doctorPendingReviewsSubscription?.cancel();
    _doctorResultsSubscription?.cancel();
    _servedPatientsSubscription?.cancel();
    return super.close();
  }
}
