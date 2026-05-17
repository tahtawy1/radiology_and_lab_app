import '../entites/result_entity.dart';
import '../repositories/results_repositories.dart';

class GetPatientResultsUseCase {
  final ResultsRepository repository;

  GetPatientResultsUseCase(this.repository);

  Stream<List<ResultEntity>> call({required String patientId}) {
    return repository.getPatientResults(patientId: patientId);
  }
}
