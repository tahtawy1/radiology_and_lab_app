import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.fullName,
    required super.nationalId,
    required super.phone,
    required super.role,
    super.createdAt,
    super.fcmToken,
  });

  factory UserModel.fromFirebaseUser(User user, {required String role}) {
    return UserModel(
      id: user.uid,
      email: user.email ?? '',
      fullName: user.displayName ?? '',
      nationalId: '',
      phone: '',
      role: role,
      createdAt: DateTime.now(),
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['uid'] ?? '',
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
      nationalId: json['nationalId'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? 'patient',
      createdAt: json['createdAt']?.toDate(),
      fcmToken: json['fcmToken'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': id,
      'email': email,
      'fullName': fullName,
      'nationalId': nationalId,
      'phone': phone,
      'role': role,
      'createdAt': createdAt,
      'fcmToken': fcmToken,
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      fullName: fullName,
      nationalId: nationalId,
      phone: phone,
      role: role,
      createdAt: createdAt,
      fcmToken: fcmToken,
    );
  }
}
