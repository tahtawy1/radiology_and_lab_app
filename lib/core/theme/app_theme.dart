import 'package:flutter/material.dart';

abstract class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(useMaterial3: true, fontFamily: 'Poppins');
  }
}
