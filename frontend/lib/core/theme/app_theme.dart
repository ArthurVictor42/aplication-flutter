import 'package:flutter/material.dart';

abstract final class AppColors {
  static const primary = Color(0xFF3825D9);
  static const primaryLight = Color(0xFF5143F0);
  static const background = Color(0xFFFAF8FF);
  static const surface = Color(0xFFFFFFFF);
  static const text = Color(0xFF20243A);
  static const muted = Color(0xFF686A7D);
  static const palePurple = Color(0xFFE8E9FF);
  static const green = Color(0xFF5DE7B1);
  static const greenDark = Color(0xFF16A36A);
  static const border = Color(0xFFE8E6F5);
  static const hint = Color(0xFFB4B3C4);
  static const amber = Color(0xFFF5A524);
}

abstract final class AppTheme {
  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final dark = brightness == Brightness.dark;
    const primary = AppColors.primary;
    final scheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: brightness,
      surface: dark ? const Color(0xFF191A29) : Colors.white,
    );
    final text = dark ? const Color(0xFFF3F2FF) : AppColors.text;
    final muted = dark ? const Color(0xFFB8B7CC) : AppColors.muted;
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: dark ? const Color(0xFF0D101B) : AppColors.background,
      colorScheme: scheme.copyWith(primary: AppColors.primary, surface: dark ? const Color(0xFF191A29) : Colors.white),
      cardColor: dark ? const Color(0xFF191A29) : Colors.white,
      dividerColor: dark ? const Color(0xFF303247) : AppColors.border,
      appBarTheme: AppBarTheme(
        backgroundColor: dark ? const Color(0xFF0D101B) : AppColors.background,
        foregroundColor: text,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: muted),
        labelStyle: TextStyle(color: muted),
      ),
      textTheme: TextTheme(
        headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: text, letterSpacing: -.6),
        titleLarge: TextStyle(fontSize: 19, fontWeight: FontWeight.w700, color: text),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: text),
        bodyMedium: TextStyle(fontSize: 14, color: muted),
      ),
      fontFamily: 'Roboto',
    );
  }
}
