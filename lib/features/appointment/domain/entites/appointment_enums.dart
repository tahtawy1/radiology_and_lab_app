enum AppointmentStatus {
  pending,
  confirmed,
  completed,
  cancelled;

  String get name => toString().split('.').last;

  static AppointmentStatus fromString(String status) {
    return AppointmentStatus.values.firstWhere(
      (e) => e.name == status.toLowerCase(),
      orElse: () => AppointmentStatus.pending,
    );
  }
}

enum QueueStatus {
  waiting,
  called,
  served,
  no_show;

  String get name => toString().split('.').last;

  static QueueStatus fromString(String status) {
    return QueueStatus.values.firstWhere(
      (e) => e.name == status.toLowerCase(),
      orElse: () => QueueStatus.waiting,
    );
  }
}
