import 'package:radiology_and_lab_app/features/appointment/domain/entites/appointment_entity.dart';
import '../repositories/queue_repository.dart';

class GetTodayQueueUseCase {
  final QueueRepository repository;

  GetTodayQueueUseCase({required this.repository});

  Future<List<AppointmentEntity>> call({required String department}) {
    return repository.getTodayQueue(department: department);
  }
}
