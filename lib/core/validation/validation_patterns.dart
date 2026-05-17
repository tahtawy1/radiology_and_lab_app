class ValidationPatterns {
  static const String email =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phone = r'^[0-9]{11}$';
  static const String nationalId = r'^[0-9]{14}$';
}
