import '../entities/queue_entry_entity.dart';

abstract class QueueRepository {
  /// Fetch all queue entries for today, ordered by queue number.
  Future<List<QueueEntryEntity>> getTodayQueue({required String department});

  /// Stream of the patient's own queue entry so the patient screen auto-updates.
  Stream<QueueEntryEntity?> watchPatientQueueEntry({required String patientId});

  /// Admin: call the next waiting patient (sets status → in_progress).
  Future<void> callNextPatient({required String department});

  /// Admin: mark an entry as completed (sets status → completed).
  Future<void> markDone({required String queueEntryId});

  /// Admin: mark an entry as no-show (sets status → no_show).
  Future<void> markNoShow({required String queueEntryId});

  /// Patient: notify-me toggle — stored locally / in user profile (no-op for now).
  Future<void> setNotifyMe({
    required String patientId,
    required bool enabled,
  });
}
