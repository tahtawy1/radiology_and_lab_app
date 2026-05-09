import 'package:firebase_auth/firebase_auth.dart';

class FirebaseErrorMapper {
  static String getMessage(dynamic exception) {
    if (exception is FirebaseAuthException) {
      switch (exception.code) {
        case 'user-not-found':
          return 'No account found with this email';
        case 'wrong-password':
          return 'Incorrect password';
        case 'email-already-in-use':
          return 'This email is already registered';
        case 'weak-password':
          return 'Password is too weak';
        case 'invalid-email':
          return 'The email address is badly formatted';
        case 'user-disabled':
          return 'This user account has been disabled';
        case 'too-many-requests':
          return 'Too many attempts. Please try again later';
        case 'network-request-failed':
          return 'Please check your internet connection';
        case 'invalid-credential':
          return 'Invalid credentials provided';
        default:
          return exception.message ?? 'An unknown authentication error occurred';
      }
    }
    return exception.toString().replaceAll('Exception: ', '');
  }
}
