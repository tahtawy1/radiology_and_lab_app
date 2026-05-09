class UserEntity {
  final String id;
  final String email;
  final String fullName;
  final String nationalId;
  final String phone;
  final String role;
  final DateTime? createdAt;

  const UserEntity({
    required this.id,
    required this.email,
    required this.fullName,
    required this.nationalId,
    required this.phone,
    required this.role,
    this.createdAt,
  });
}
