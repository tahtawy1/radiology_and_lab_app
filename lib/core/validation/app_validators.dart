import '../utils/validation_extensions.dart';

class AppValidators {
  static String? validateEmpty(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    if (!value.isValidEmail) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (!value.isStrongPassword) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    if (!value.isValidPhone) {
      return 'Please enter a valid Egyptian phone number (010, 011, 012, or 015 followed by 8 digits)';
    }
    return null;
  }

  static String? validateNationalId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'National ID is required';
    }
    if (!value.isValidNationalId) {
      return 'Please enter a valid 14-digit National ID';
    }
    return null;
  }

  static String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full Name is required';
    }
    if (value.trim().split(' ').length < 2) {
      return 'Please enter your first and last name';
    }
    return null;
  }
}
