import 'package:radiology_and_lab_app/features/results/domain/entites/result_entity.dart';
import '../repositories/results_repositories.dart';

class GetDoctorResultsUseCase {
  final ResultsRepository repository;

  GetDoctorResultsUseCase({required this.repository});

  Stream<List<ResultEntity>> call(String doctorId) {
    return repository.getResultsForDoctor(doctorId: doctorId);
  }
}
