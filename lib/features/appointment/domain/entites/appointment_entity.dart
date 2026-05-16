import 'appointment_enums.dart';

class AppointmentEntity {
  final String id;
  final String patientId;
  final String patientName;
  final String department;
  final String testType;

  /// Date of appointment (time is always set to midnight – no slot reservation).
  final DateTime appointmentDateTime;

  /// Optional notes added by patient during booking
  final String? notes;

  /// Appointment lifecycle status: pending | confirmed | completed | cancelled
  final AppointmentStatus status;

  // ── Queue fields (managed by queue_feature later) ──────────────────────────
  final int? queueNumber;

  /// Queue status: waiting | called | served | no_show
  final QueueStatus? queueStatus;
  final bool isNoShow;
  final DateTime? calledAt;
  final DateTime? servedAt;

  // ── Future-linking fields (set by other features later) ────────────────────

  /// Links to a doctor test-request document when created via doctor_request flow.
  final String? requestId;

  /// Doctor who issued the test request (populated by selection or test_requests_feature later).
  final String doctorId;

  /// Referring doctor name (required, entered by patient during direct booking or set by doctor).
  final String doctorName;

  /// 'patient_direct' = patient booked themselves.
  /// 'doctor_request' = created from a doctor test-request (test_requests_feature).
  final String createdByType;

  // ── Timestamps ─────────────────────────────────────────────────────────────
  final DateTime createdAt;
  final DateTime updatedAt;

  const AppointmentEntity({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.department,
    required this.testType,
    required this.appointmentDateTime,
    this.notes,
    required this.status,
    this.queueNumber,
    this.queueStatus,
    required this.isNoShow,
    this.calledAt,
    this.servedAt,
    this.requestId,
    required this.doctorId,
    required this.doctorName,
    this.createdByType = 'patient_direct',
    required this.createdAt,
    required this.updatedAt,
  });
}
