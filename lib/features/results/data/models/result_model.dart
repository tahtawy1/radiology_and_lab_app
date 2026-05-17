import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entites/result_entity.dart';

class ResultModel extends ResultEntity {
  ResultModel({
    required super.id,
    required super.patientId,
    required super.doctorId,
    required super.appointmentId,
    required super.patientName,
    required super.testType,
    required super.department,
    required super.resultFileUrl,
    required super.notes,
    required super.reviewedByDoctor,
    super.classification,
    super.doctorNotes,
    super.reviewedBy,
    required super.createdAt,
    super.reviewedAt,
  });

  factory ResultModel.fromMap(Map<String, dynamic> map) {
    return ResultModel(
      id: map['id'] ?? '',
      patientId: map['patientId'] ?? '',
      doctorId: map['doctorId'] ?? '',
      appointmentId: map['appointmentId'] ?? '',
      patientName: map['patientName'] ?? '',
      testType: map['testType'] ?? '',
      department: map['department'] ?? '',
      resultFileUrl: map['resultFileUrl'] ?? '',
      notes: map['notes'] ?? '',
      reviewedByDoctor: map['reviewedByDoctor'] ?? false,
      classification: map['classification'] as String?,
      doctorNotes: map['doctorNotes'] as String?,
      reviewedBy: map['reviewedBy'] as String?,
      createdAt:
          map['createdAt'] != null
              ? (map['createdAt'] as Timestamp).toDate()
              : DateTime.now(),
      reviewedAt:
          map['reviewedAt'] != null
              ? (map['reviewedAt'] as Timestamp).toDate()
              : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patientId': patientId,
      'doctorId': doctorId,
      'appointmentId': appointmentId,
      'patientName': patientName,
      'testType': testType,
      'department': department,
      'resultFileUrl': resultFileUrl,
      'notes': notes,
      'reviewedByDoctor': reviewedByDoctor,
      'classification': classification,
      'doctorNotes': doctorNotes,
      'reviewedBy': reviewedBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'reviewedAt': reviewedAt != null ? Timestamp.fromDate(reviewedAt!) : null,
    };
  }

  factory ResultModel.fromEntity(ResultEntity entity) {
    return ResultModel(
      id: entity.id,
      patientId: entity.patientId,
      doctorId: entity.doctorId,
      appointmentId: entity.appointmentId,
      patientName: entity.patientName,
      testType: entity.testType,
      department: entity.department,
      resultFileUrl: entity.resultFileUrl,
      notes: entity.notes,
      reviewedByDoctor: entity.reviewedByDoctor,
      classification: entity.classification,
      doctorNotes: entity.doctorNotes,
      reviewedBy: entity.reviewedBy,
      createdAt: entity.createdAt,
      reviewedAt: entity.reviewedAt,
    );
  }

  ResultModel copyWith({
    String? id,
    String? patientId,
    String? doctorId,
    String? appointmentId,
    String? patientName,
    String? testType,
    String? department,
    String? resultFileUrl,
    String? notes,
    bool? reviewedByDoctor,
    String? classification,
    String? doctorNotes,
    String? reviewedBy,
    DateTime? createdAt,
    DateTime? reviewedAt,
  }) {
    return ResultModel(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      doctorId: doctorId ?? this.doctorId,
      appointmentId: appointmentId ?? this.appointmentId,
      patientName: patientName ?? this.patientName,
      testType: testType ?? this.testType,
      department: department ?? this.department,
      resultFileUrl: resultFileUrl ?? this.resultFileUrl,
      notes: notes ?? this.notes,
      reviewedByDoctor: reviewedByDoctor ?? this.reviewedByDoctor,
      classification: classification ?? this.classification,
      doctorNotes: doctorNotes ?? this.doctorNotes,
      reviewedBy: reviewedBy ?? this.reviewedBy,
      createdAt: createdAt ?? this.createdAt,
      reviewedAt: reviewedAt ?? this.reviewedAt,
    );
  }
}
