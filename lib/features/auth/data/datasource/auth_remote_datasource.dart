import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:radiology_and_lab_app/core/services/user_session_service.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/firebase_error_mapper.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signIn({
    required String email,
    required String password,
    required String selectedRole,
  });

  Future<UserModel> signUp({
    required String email,
    required String password,
    required String fullName,
    required String nationalId,
    required String phone,
  });

  Future<void> signOut();

  Future<UserModel?> getCurrentUser();

  Future<void> resetPassword(String email);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
  });

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
    required String selectedRole,
  }) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw const AuthException('User not found');
      }

      final doc =
          await firestore
              .collection('users')
              .doc(userCredential.user!.uid)
              .get();

      if (!doc.exists || doc.data() == null) {
        throw const ServerException('User data not found');
      }

      final user = UserModel.fromJson(doc.data()!);

      // Role validation
      if (user.role.toLowerCase() != selectedRole.toLowerCase()) {
        await firebaseAuth.signOut();

        throw const AuthException('Selected role does not match your account');
      }
      UserSessionService.currentUser = user;
      return user;
    } on FirebaseAuthException catch (e) {
      throw AuthException(FirebaseErrorMapper.getMessage(e));
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Database error occurred');
    } catch (e) {
      throw const ServerException('Something went wrong');
    }
  }

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String fullName,
    required String nationalId,
    required String phone,
  }) async {
    try {
      // Check duplicate national ID
      final nationalIdQuery =
          await firestore
              .collection('users')
              .where('nationalId', isEqualTo: nationalId)
              .get();

      if (nationalIdQuery.docs.isNotEmpty) {
        throw const ValidationException(
          'This National ID is already registered',
        );
      }

      // Check duplicate phone
      final phoneQuery =
          await firestore
              .collection('users')
              .where('phone', isEqualTo: phone)
              .get();

      if (phoneQuery.docs.isNotEmpty) {
        throw const ValidationException(
          'This phone number is already registered',
        );
      }

      // Create Firebase Auth account
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw const AuthException('Failed to create user account');
      }

      // Create user model
      final userModel = UserModel(
        id: userCredential.user!.uid,
        email: email,
        fullName: fullName,
        nationalId: nationalId,
        phone: phone,
        role: 'patient',
        createdAt: DateTime.now(),
      );

      // Save user in Firestore
      await firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(userModel.toJson());

      return userModel;
    } on FirebaseAuthException catch (e) {
      throw AuthException(FirebaseErrorMapper.getMessage(e));
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Database error occurred');
    } on ValidationException {
      rethrow;
    } catch (e) {
      throw const ServerException('Something went wrong');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      UserSessionService.currentUser = null;
      await firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw AuthException(FirebaseErrorMapper.getMessage(e));
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = firebaseAuth.currentUser;

      if (user == null) return null;

      final doc = await firestore.collection('users').doc(user.uid).get();

      if (!doc.exists || doc.data() == null) {
        return null;
      }

      return UserModel.fromJson(doc.data()!);
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Failed to fetch current user');
    } catch (e) {
      throw const ServerException('Something went wrong');
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthException(FirebaseErrorMapper.getMessage(e));
    } catch (e) {
      throw const ServerException('Failed to reset password');
    }
  }
}
