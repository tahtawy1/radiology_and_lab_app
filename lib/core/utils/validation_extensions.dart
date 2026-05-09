import '../validation/validation_patterns.dart';

extension ValidationExtensions on String {
  bool get isValidEmail {
    return RegExp(ValidationPatterns.email).hasMatch(this);
  }

  bool get isValidPhone {
    return RegExp(ValidationPatterns.phone).hasMatch(this);
  }

  bool get isValidNationalId {
    return RegExp(ValidationPatterns.nationalId).hasMatch(this);
  }

  bool get isStrongPassword {
    return length >= 6;
  }
}
