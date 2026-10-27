import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color.fromARGB(255, 0, 122, 255);

  //светлая тема
  static const Color lightBackgroundColor = Colors.white;
  static const Color lightTextColor = Colors.black;
  static const Color lightSecondaryTextColor = Color.fromARGB(255, 72, 72, 72);
  static const Color lightCardColor = Color.fromARGB(255, 245, 245, 253);
  static const Color lightHeaderColor = Colors.white;

  //тёмная тема
  static const Color darkBackgroundColor = Color(0xFF121418);
  static const Color darkTextColor = Color.fromARGB(255, 242, 245, 243);
  static const Color darkSecondaryTextColor = Color(0xFFADB3BD);
  static const Color darkCardColor = Color(0xFF1D2229);
  static const Color darkHeaderColor = Color(0xFF121418);


  static const Color backgroundColor = Colors.white;
  static const Color secondaryColor = Color.fromARGB(255, 153, 153, 153);
  static const Color textColor = Colors.black;
  static const Color textSecondaryColor = Color.fromARGB(255, 72, 72, 72);

  static final ThemeData lightTheme = _buildTheme(
    brightness: Brightness.light,
    backgroundColor: lightBackgroundColor,
    textColor: lightTextColor,
    secondaryTextColor: lightSecondaryTextColor,
    cardColor: lightCardColor,
    headerColor: lightHeaderColor,
  );

  static final ThemeData darkTheme = _buildTheme(
    brightness: Brightness.dark,
    backgroundColor: darkBackgroundColor,
    textColor: darkTextColor,
    secondaryTextColor: darkSecondaryTextColor,
    cardColor: darkCardColor,
    headerColor: darkHeaderColor,
  );


  static ThemeData _buildTheme({
    required Brightness brightness, 
    required Color backgroundColor, 
    required Color textColor, 
    required Color secondaryTextColor,
    required Color cardColor,
    required Color headerColor
  }) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: brightness
    ).copyWith(
      primary: primaryColor,
      surface: cardColor,
      onSurface: textColor,
      onSurfaceVariant: secondaryTextColor
    );

    return ThemeData(
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: backgroundColor,
      cardColor: cardColor,
      appBarTheme: AppBarTheme(
        backgroundColor: headerColor,
        foregroundColor: textColor,
        surfaceTintColor: Colors.transparent,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: cardColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: secondaryTextColor
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: textColor),
        bodyMedium: TextStyle(color: textColor),
        bodySmall: TextStyle(color: secondaryTextColor),
        titleLarge: TextStyle(color: textColor),
        titleMedium: TextStyle(color: textColor),
        titleSmall: TextStyle(color: textColor),
      ),
      iconTheme: IconThemeData(
        color: secondaryTextColor,
      ),
    );

  }
}

