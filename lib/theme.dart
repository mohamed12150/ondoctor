import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF7E57C2);
  static const Color backgroundColor = Color(0xFFF9F9F9);
  static const Color iconColor = Color(0xFF9575CD);

  static ThemeData get themeData {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
      ),
      useMaterial3: true,
      textTheme: const TextTheme(
        bodyMedium: TextStyle(fontSize: 14),
        titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
      iconTheme: const IconThemeData(color: iconColor),
    );
  }
}
