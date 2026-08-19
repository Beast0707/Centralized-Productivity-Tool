import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const Color lightBackground = Color(0xFFE5E5E5);
  static const Color textSubtle = Color(0xFF666666);

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.grey,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: lightBackground,
    );
  }

  // Foundation for your later dark-mode implementation.
  // Do not redesign the dark theme yet.
  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.grey,
        brightness: Brightness.dark,
      ),
    );
  }
}