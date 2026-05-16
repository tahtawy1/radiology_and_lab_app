class ResultEntity {
  final String id;
  final String patientId;
  final String doctorId;
  final String appointmentId;

  final String patientName;
  final String testType;
  final String department;

  final String resultFileUrl;

  final String notes;

  final bool reviewedByDoctor;

  final String? classification;

  final String? doctorNotes;

  final String? reviewedBy;

  final DateTime createdAt;

  final DateTime? reviewedAt;

  ResultEntity({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.appointmentId,
    required this.patientName,
    required this.testType,
    required this.department,
    required this.resultFileUrl,
    required this.notes,
    required this.reviewedByDoctor,
    this.classification,
    this.doctorNotes,
    this.reviewedBy,
    required this.createdAt,
    this.reviewedAt,
  });
}
