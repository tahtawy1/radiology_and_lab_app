import '../repositories/results_repositories.dart';

class ReviewResultUseCase {
  final ResultsRepository repository;

  ReviewResultUseCase(this.repository);

  Future<void> call({
    required String resultId,
    required String doctorId,
    required String doctorNotes,
    required String classification,
  }) {
    return repository.reviewResult(
      resultId: resultId,
      doctorId: doctorId,
      doctorNotes: doctorNotes,
      classification: classification,
    );
  }
}
