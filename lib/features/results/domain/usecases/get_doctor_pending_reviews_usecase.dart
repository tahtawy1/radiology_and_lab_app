import '../entites/result_entity.dart';
import '../repositories/results_repositories.dart';

class GetDoctorPendingReviewsUseCase {
  final ResultsRepository repository;

  GetDoctorPendingReviewsUseCase(this.repository);

  Future<List<ResultEntity>> call({required String doctorId}) {
    return repository.getDoctorPendingReviews(doctorId: doctorId);
  }
}
