import 'package:radiology_and_lab_app/features/appointment/domain/entites/appointment_entity.dart';

abstract class QueueRepository {
  /// Fetch all queue entries for today, ordered by queue number.
  Future<List<AppointmentEntity>> getTodayQueue({required String department});

  /// Stream of the patient's own queue entry so the patient screen auto-updates.
  Stream<AppointmentEntity?> watchPatientQueueEntry({required String patientId});

  /// Admin: check-in a patient, generating their queue number.
  Future<void> checkInPatient({required String appointmentId, required String department});

  /// Admin: call the next waiting patient (sets queueStatus → called).
  Future<void> callNextPatient({required String department});

  /// Admin: mark an entry as served (sets queueStatus → served, status → completed).
  Future<void> markServed({required String queueEntryId});

  /// Admin: mark an entry as no-show (sets queueStatus → no_show).
  Future<void> markNoShow({required String queueEntryId});

  /// Patient: notify-me toggle — stored locally / in user profile (no-op for now).
  Future<void> setNotifyMe({
    required String patientId,
    required bool enabled,
  });
}
