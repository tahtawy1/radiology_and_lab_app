import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/queue_entry_entity.dart';

class QueueEntryModel extends QueueEntryEntity {
  const QueueEntryModel({
    required super.id,
    required super.appointmentId,
    required super.patientId,
    required super.patientName,
    required super.department,
    required super.testType,
    required super.queueNumber,
    required super.queueStatus,
    required super.roomNumber,
    required super.date,
    super.calledAt,
    super.servedAt,
    required super.createdAt,
  });

  factory QueueEntryModel.fromEntity(QueueEntryEntity entity) {
    return QueueEntryModel(
      id: entity.id,
      appointmentId: entity.appointmentId,
      patientId: entity.patientId,
      patientName: entity.patientName,
      department: entity.department,
      testType: entity.testType,
      queueNumber: entity.queueNumber,
      queueStatus: entity.queueStatus,
      roomNumber: entity.roomNumber,
      date: entity.date,
      calledAt: entity.calledAt,
      servedAt: entity.servedAt,
      createdAt: entity.createdAt,
    );
  }

  factory QueueEntryModel.fromMap(Map<String, dynamic> map, String id) {
    return QueueEntryModel(
      id: id,
      appointmentId: map['appointmentId'] ?? '',
      patientId: map['patientId'] ?? '',
      patientName: map['patientName'] ?? '',
      department: map['department'] ?? '',
      testType: map['testType'] ?? '',
      queueNumber: map['queueNumber'] ?? 0,
      queueStatus: map['queueStatus'] ?? 'waiting',
      roomNumber: map['roomNumber'] ?? '',
      date: map['date'] != null
          ? (map['date'] as Timestamp).toDate()
          : DateTime.now(),
      calledAt: map['calledAt'] != null
          ? (map['calledAt'] as Timestamp).toDate()
          : null,
      servedAt: map['servedAt'] != null
          ? (map['servedAt'] as Timestamp).toDate()
          : null,
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'appointmentId': appointmentId,
      'patientId': patientId,
      'patientName': patientName,
      'department': department,
      'testType': testType,
      'queueNumber': queueNumber,
      'queueStatus': queueStatus,
      'roomNumber': roomNumber,
      'date': Timestamp.fromDate(date),
      'calledAt': calledAt != null ? Timestamp.fromDate(calledAt!) : null,
      'servedAt': servedAt != null ? Timestamp.fromDate(servedAt!) : null,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  QueueEntryModel copyWith({
    String? id,
    String? appointmentId,
    String? patientId,
    String? patientName,
    String? department,
    String? testType,
    int? queueNumber,
    String? queueStatus,
    String? roomNumber,
    DateTime? date,
    DateTime? calledAt,
    DateTime? servedAt,
    DateTime? createdAt,
  }) {
    return QueueEntryModel(
      id: id ?? this.id,
      appointmentId: appointmentId ?? this.appointmentId,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      department: department ?? this.department,
      testType: testType ?? this.testType,
      queueNumber: queueNumber ?? this.queueNumber,
      queueStatus: queueStatus ?? this.queueStatus,
      roomNumber: roomNumber ?? this.roomNumber,
      date: date ?? this.date,
      calledAt: calledAt ?? this.calledAt,
      servedAt: servedAt ?? this.servedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
