abstract class AppException implements Exception {
  final String message;
  const AppException(this.message);

  @override
  String toString() => message;
}

class ServerException extends AppException {
  const ServerException([super.message = 'A server error occurred. Please try again.']);
}

class AuthException extends AppException {
  const AuthException(super.message);
}

class ValidationException extends AppException {
  const ValidationException([super.message = 'Invalid input provided.']);
}

class NetworkException extends AppException {
  const NetworkException([super.message = 'Please check your internet connection.']);
}

class CacheException extends AppException {
  const CacheException([super.message = 'Failed to load local data.']);
}
