import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> signIn(String email, String password, String selectedRole);
  Future<UserEntity> signUp({
    required String email,
    required String password,
    required String fullName,
    required String nationalId,
    required String phone,
  });
  Future<void> signOut();
  Future<UserEntity?> getCurrentUser();
  Future<void> resetPassword(String email);
}
