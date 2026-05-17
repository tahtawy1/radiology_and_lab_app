class ValidationPatterns {
  static const String email =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phone = r'^(010|011|012|015)[0-9]{8}$';
  static const String nationalId = r'^[0-9]{14}$';
}
