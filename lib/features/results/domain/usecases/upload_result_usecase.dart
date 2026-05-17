import '../repositories/results_repositories.dart';

class UploadResultUseCase {
  final ResultsRepository repository;

  UploadResultUseCase(this.repository);

  Future<String> call({
    required String appointmentId,
    required String resultFileUrl,
    required String notes,
  }) {
    return repository.uploadResult(
      appointmentId: appointmentId,
      resultFileUrl: resultFileUrl,
      notes: notes,
    );
  }
}
