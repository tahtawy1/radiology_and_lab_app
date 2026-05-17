import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../errors/exceptions.dart';

class FirebaseErrorMapper {
  static String getMessage(dynamic exception) {
    if (exception is FirebaseAuthException) {
      switch (exception.code) {
        case 'user-not-found':
          return 'No account found with this email. Please check and try again.';
        case 'wrong-password':
          return 'Incorrect password. Please try again.';
        case 'email-already-in-use':
          return 'This email is already registered. Try logging in instead.';
        case 'weak-password':
          return 'Password is too weak. Use a stronger password.';
        case 'invalid-email':
          return 'The email address format is invalid.';
        case 'user-disabled':
          return 'This account has been disabled. Contact support.';
        case 'too-many-requests':
          return 'Too many attempts. Please wait a moment and try again.';
        case 'network-request-failed':
          return 'Network error. Please check your internet connection.';
        case 'invalid-credential':
          return 'Login failed. Please check your email and password.';
        default:
          return exception.message ?? 'Authentication failed. Please try again.';
      }
    }

    if (exception is FirebaseException) {
      switch (exception.code) {
        case 'permission-denied':
          return 'You do not have permission to perform this action.';
        case 'unavailable':
          return 'Service is currently unavailable. Please try again later.';
        case 'not-found':
          return 'The requested information was not found.';
        case 'already-exists':
          return 'This record already exists.';
        case 'deadline-exceeded':
          return 'The request timed out. Please try again.';
        default:
          return 'A database error occurred. Please try again.';
      }
    }

    if (exception is AppException) {
      return exception.message;
    }

    if (exception is Exception) {
      final msg = exception.toString().replaceAll('Exception: ', '');
      if (msg.contains('SocketException')) {
        return 'No internet connection. Please check your network.';
      }
      return msg;
    }

    return 'An unexpected error occurred. Please try again.';
  }
}
