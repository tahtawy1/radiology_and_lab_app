import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entites/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  NotificationModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.body,
    required super.type,
    required super.isRead,
    required super.createdAt,
  });

  // ── Factory: Firestore map → model ──────────────────────────────────────────
  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] as String? ?? '',
      userId: map['userId'] as String? ?? '',
      title: map['title'] as String? ?? '',
      body: map['body'] as String? ?? '',
      type: _typeFromString(map['type'] as String? ?? ''),
      isRead: map['isRead'] as bool? ?? false,
      createdAt:
          map['createdAt'] != null
              ? (map['createdAt'] as Timestamp).toDate()
              : DateTime.now(),
    );
  }

  // ── Factory: domain entity → model ──────────────────────────────────────────
  factory NotificationModel.fromEntity(NotificationEntity entity) {
    return NotificationModel(
      id: entity.id,
      userId: entity.userId,
      title: entity.title,
      body: entity.body,
      type: entity.type,
      isRead: entity.isRead,
      createdAt: entity.createdAt,
    );
  }

  // ── Serialise to Firestore map ───────────────────────────────────────────────
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'body': body,
      'type': _typeToString(type),
      'isRead': isRead,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // ── copyWith ────────────────────────────────────────────────────────────────
  NotificationModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? body,
    NotificationType? type,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // ── Enum helpers ─────────────────────────────────────────────────────────────
  static NotificationType _typeFromString(String value) {
    switch (value) {
      case 'appointmentApproved':
        return NotificationType.appointmentApproved;
      case 'appointmentRejected':
        return NotificationType.appointmentRejected;
      case 'queueCalled':
        return NotificationType.queueCalled;
      case 'resultUploaded':
        return NotificationType.resultUploaded;
      case 'resultReviewed':
        return NotificationType.resultReviewed;
      case 'newAppointmentRequest':
        return NotificationType.newAppointmentRequest;
      case 'reviewCompleted':
        return NotificationType.reviewCompleted;
      case 'uploadFailed':
        return NotificationType.uploadFailed;
      default:
        return NotificationType.appointmentApproved;
    }
  }

  static String _typeToString(NotificationType type) {
    switch (type) {
      case NotificationType.appointmentApproved:
        return 'appointmentApproved';
      case NotificationType.appointmentRejected:
        return 'appointmentRejected';
      case NotificationType.queueCalled:
        return 'queueCalled';
      case NotificationType.resultUploaded:
        return 'resultUploaded';
      case NotificationType.resultReviewed:
        return 'resultReviewed';
      case NotificationType.newAppointmentRequest:
        return 'newAppointmentRequest';
      case NotificationType.reviewCompleted:
        return 'reviewCompleted';
      case NotificationType.uploadFailed:
        return 'uploadFailed';
    }
  }
}
