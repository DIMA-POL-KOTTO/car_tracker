import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color.fromARGB(255, 0, 122, 255);
  static const Color secondaryColor = Color.fromARGB(255, 153, 153, 153);
  static const Color textColor = Colors.black;
  static const Color textSecondaryColor = Color.fromARGB(255, 72, 72, 72);
  static const Color backgroundColor = Colors.white;

  static const Color darkTextColor = Colors.white;
  static const Color darkTextSecondaryColor = Color(0xFFAEAEB2);
  static const Color darkBackgroundColor = Color(0xFF121212);
  static const Color darkSurfaceColor = Color(0xFF1E1E1E);


  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
    ),
    scaffoldBackgroundColor: backgroundColor
  );

  static ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
    ),
    scaffoldBackgroundColor: darkBackgroundColor,
  );
}

