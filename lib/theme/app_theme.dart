import 'package:flutter/material.dart';

class AppTheme {
  static final Color primaryColor = Colors.blueGrey.shade800;
  static final Color accentColor = Colors.tealAccent.shade400;
  static final Color backgroundColor = Colors.grey.shade100;

  static ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: accentColor,
    ),
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: accentColor,
    ),
  );
}
