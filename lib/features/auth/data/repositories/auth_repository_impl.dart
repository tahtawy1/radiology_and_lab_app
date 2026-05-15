import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasource/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserEntity> signIn(
    String email,
    String password,
    String selectedRole,
  ) async {
    try {
      return await remoteDataSource.signIn(
        email: email,
        password: password,
        selectedRole: selectedRole,
      );
    } on AppException {
      rethrow;
    }
  }

  @override
  Future<UserEntity> signUp({
    required String email,
    required String password,
    required String fullName,
    required String nationalId,
    required String phone,
  }) async {
    try {
      return await remoteDataSource.signUp(
        email: email,
        password: password,
        fullName: fullName,
        nationalId: nationalId,
        phone: phone,
      );
    } on AppException {
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await remoteDataSource.signOut();
    } on AppException {
      rethrow;
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      return await remoteDataSource.getCurrentUser();
    } on AppException {
      rethrow;
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await remoteDataSource.resetPassword(email);
    } on AppException {
      rethrow;
    }
  }
}
