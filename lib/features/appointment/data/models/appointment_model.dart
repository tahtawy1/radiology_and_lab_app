import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entites/appointment_entity.dart';

class AppointmentModel extends AppointmentEntity {
  const AppointmentModel({
    required super.id,
    required super.patientId,
    required super.patientName,
    required super.department,
    required super.testType,
    required super.appointmentDateTime,
    super.notes,
    required super.status,
    required super.queueNumber,
    required super.queueStatus,
    required super.isNoShow,
    super.calledAt,
    super.servedAt,
    super.requestId,
    required super.doctorId,
    required super.doctorName,
    super.createdByType = 'patient_direct',
    required super.createdAt,
    required super.updatedAt,
  });

  // ── Factory: from Entity ──────────────────────────────────────────────────
  factory AppointmentModel.fromEntity(AppointmentEntity entity) {
    return AppointmentModel(
      id: entity.id,
      patientId: entity.patientId,
      patientName: entity.patientName,
      department: entity.department,
      testType: entity.testType,
      appointmentDateTime: entity.appointmentDateTime,
      notes: entity.notes,
      status: entity.status,
      queueNumber: entity.queueNumber,
      queueStatus: entity.queueStatus,
      isNoShow: entity.isNoShow,
      calledAt: entity.calledAt,
      servedAt: entity.servedAt,
      requestId: entity.requestId,
      doctorId: entity.doctorId,
      doctorName: entity.doctorName,
      createdByType: entity.createdByType,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  // ── Factory: from Firestore map ───────────────────────────────────────────
  factory AppointmentModel.fromMap(Map<String, dynamic> map) {
    return AppointmentModel(
      id: map['id'] ?? '',
      patientId: map['patientId'] ?? '',
      patientName: map['patientName'] ?? '',
      department: map['department'] ?? '',
      testType: map['testType'] ?? '',
      appointmentDateTime:
          map['appointmentDateTime'] != null
              ? (map['appointmentDateTime'] as Timestamp).toDate()
              : DateTime.now(),
      notes: map['notes'] as String?,
      status: map['status'] ?? 'pending',
      queueNumber: map['queueNumber'] ?? 0,
      queueStatus: map['queueStatus'] ?? 'waiting',
      isNoShow: map['isNoShow'] ?? false,
      calledAt:
          map['calledAt'] != null
              ? (map['calledAt'] as Timestamp).toDate()
              : null,
      servedAt:
          map['servedAt'] != null
              ? (map['servedAt'] as Timestamp).toDate()
              : null,
      requestId: map['requestId'] as String?,
      doctorId: map['doctorId'] ?? '',
      doctorName: map['doctorName'] ?? 'Unknown Doctor',
      createdByType: map['createdByType'] ?? 'patient_direct',
      createdAt:
          map['createdAt'] != null
              ? (map['createdAt'] as Timestamp).toDate()
              : DateTime.now(),
      updatedAt:
          map['updatedAt'] != null
              ? (map['updatedAt'] as Timestamp).toDate()
              : DateTime.now(),
    );
  }

  // ── Serialize to Firestore map ────────────────────────────────────────────
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patientId': patientId,
      'patientName': patientName,
      'department': department,
      'testType': testType,
      'appointmentDateTime': Timestamp.fromDate(appointmentDateTime),
      'notes': notes,
      'status': status,
      'queueNumber': queueNumber,
      'queueStatus': queueStatus,
      'isNoShow': isNoShow,
      'calledAt': calledAt != null ? Timestamp.fromDate(calledAt!) : null,
      'servedAt': servedAt != null ? Timestamp.fromDate(servedAt!) : null,
      // Future-linking fields (null for patient_direct bookings initially)
      'requestId': requestId,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'createdByType': createdByType,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // ── copyWith ──────────────────────────────────────────────────────────────
  AppointmentModel copyWith({
    String? id,
    String? patientId,
    String? patientName,
    String? department,
    String? testType,
    DateTime? appointmentDateTime,
    String? notes,
    String? status,
    int? queueNumber,
    String? queueStatus,
    bool? isNoShow,
    DateTime? calledAt,
    DateTime? servedAt,
    String? requestId,
    String? doctorId,
    String? doctorName,
    String? createdByType,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      department: department ?? this.department,
      testType: testType ?? this.testType,
      appointmentDateTime: appointmentDateTime ?? this.appointmentDateTime,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      queueNumber: queueNumber ?? this.queueNumber,
      queueStatus: queueStatus ?? this.queueStatus,
      isNoShow: isNoShow ?? this.isNoShow,
      calledAt: calledAt ?? this.calledAt,
      servedAt: servedAt ?? this.servedAt,
      requestId: requestId ?? this.requestId,
      doctorId: doctorId ?? this.doctorId,
      doctorName: doctorName ?? this.doctorName,
      createdByType: createdByType ?? this.createdByType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
