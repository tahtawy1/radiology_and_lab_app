import '../entites/result_entity.dart';
import '../repositories/results_repositories.dart';

class GetDoctorPendingReviewsUseCase {
  final ResultsRepository repository;

  GetDoctorPendingReviewsUseCase(this.repository);

  Stream<List<ResultEntity>> call({required String doctorId}) {
    return repository.getDoctorPendingReviews(doctorId: doctorId);
  }
}
