import 'package:radiology_and_lab_app/features/appointment/domain/entites/appointment_entity.dart';
import '../repositories/queue_repository.dart';

class WatchPatientQueueEntryUseCase {
  final QueueRepository repository;

  WatchPatientQueueEntryUseCase({required this.repository});

  Stream<AppointmentEntity?> call({required String patientId}) {
    return repository.watchPatientQueueEntry(patientId: patientId);
  }
}
