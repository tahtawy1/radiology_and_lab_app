import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radiology_and_lab_app/core/errors/exceptions.dart';
import 'package:radiology_and_lab_app/core/errors/failures.dart';
import 'package:radiology_and_lab_app/features/queue/domain/entities/queue_entry_entity.dart';
import 'package:radiology_and_lab_app/features/queue/domain/usecases/queue_usecases.dart';

abstract class QueueAdminState {}

class QueueAdminInitial extends QueueAdminState {}

class QueueAdminLoading extends QueueAdminState {}

class QueueAdminLoaded extends QueueAdminState {
  final List<QueueEntryEntity> queueEntries;
  final int totalToday;
  final int inProgress;
  final int completed;

  QueueAdminLoaded({
    required this.queueEntries,
    required this.totalToday,
    required this.inProgress,
    required this.completed,
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

class QueueAdminCubit extends Cubit<QueueAdminState> {
  final GetTodayQueueUseCase getTodayQueueUseCase;
  final CallNextPatientUseCase callNextPatientUseCase;
  final MarkQueueDoneUseCase markQueueDoneUseCase;
  final MarkQueueNoShowUseCase markQueueNoShowUseCase;

  QueueAdminCubit({
    required this.getTodayQueueUseCase,
    required this.callNextPatientUseCase,
    required this.markQueueDoneUseCase,
    required this.markQueueNoShowUseCase,
  }) : super(QueueAdminInitial());

  Failure _mapExceptionToFailure(dynamic e) {
    if (e is ServerException) return ServerFailure(e.message);
    if (e is NetworkException) return NetworkFailure(e.message);
    return ServerFailure(e.toString());
  }

  Future<void> fetchQueue({required String department}) async {
    emit(QueueAdminLoading());
    try {
      final entries = await getTodayQueueUseCase(department: department);
      final totalToday = entries.length;
      final inProgress =
          entries.where((e) => e.queueStatus == 'in_progress').length;
      final completed =
          entries.where((e) => e.queueStatus == 'completed').length;

      emit(
        QueueAdminLoaded(
          queueEntries: entries,
          totalToday: totalToday,
          inProgress: inProgress,
          completed: completed,
        ),
      );
    } catch (e) {
      emit(QueueAdminError(_mapExceptionToFailure(e).message));
    }
  }

  Future<void> callNextPatient({required String department}) async {
    // try {
    await callNextPatientUseCase(department: department);
    emit(QueueAdminActionSuccess('Next patient called successfully'));
    await fetchQueue(department: department);
    // } catch (e) {
    //   emit(QueueAdminError(_mapExceptionToFailure(e).message));
    // }
  }

  Future<void> markDone({
    required String queueEntryId,
    required String department,
  }) async {
    try {
      await markQueueDoneUseCase(queueEntryId: queueEntryId);
      emit(QueueAdminActionSuccess('Patient marked as done'));
      await fetchQueue(department: department);
    } catch (e) {
      emit(QueueAdminError(_mapExceptionToFailure(e).message));
    }
  }

  Future<void> markNoShow({
    required String queueEntryId,
    required String department,
  }) async {
    try {
      await markQueueNoShowUseCase(queueEntryId: queueEntryId);
      emit(QueueAdminActionSuccess('Patient marked as no-show'));
      await fetchQueue(department: department);
    } catch (e) {
      emit(QueueAdminError(_mapExceptionToFailure(e).message));
    }
  }
}
