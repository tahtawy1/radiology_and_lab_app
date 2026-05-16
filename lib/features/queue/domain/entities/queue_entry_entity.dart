// Queue status values: waiting | in_progress | completed | no_show

class QueueEntryEntity {
  final String id;
  final String appointmentId;
  final String patientId;
  final String patientName;
  final String department;
  final String testType;
  final int queueNumber;

  /// Queue status: waiting | in_progress | completed | no_show
  final String queueStatus;

  final String roomNumber;
  final DateTime date;
  final DateTime? calledAt;
  final DateTime? servedAt;
  final DateTime createdAt;

  const QueueEntryEntity({
    required this.id,
    required this.appointmentId,
    required this.patientId,
    required this.patientName,
    required this.department,
    required this.testType,
    required this.queueNumber,
    required this.queueStatus,
    required this.roomNumber,
    required this.date,
    this.calledAt,
    this.servedAt,
    required this.createdAt,
  });
}
