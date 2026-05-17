import '../../../appointment/domain/entites/appointment_entity.dart';
import '../repositories/results_repositories.dart';

class GetServedPatientsUseCase {
  final ResultsRepository repository;

  GetServedPatientsUseCase(this.repository);

  Stream<List<AppointmentEntity>> call() {
    return repository.getServedPatients();
  }
}
