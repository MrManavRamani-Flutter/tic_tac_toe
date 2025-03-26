import 'package:flutter/material.dart';

class NeonTheme {
  static const _fontFamily = 'ComicSansMS';

  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF06B1C8),
    // Neon Green
    scaffoldBackgroundColor: const Color(0xFFF5F7FA),
    // Light grey-blue
    cardColor: Colors.white,
    // Pure white for cards
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF06B1C8),
      // Neon Green
      secondary: Color(0xFFFF4081),
      // Neon Pink
      surface: Color(0xFFF5F7FA),
      onPrimary: Colors.black87,
      onSecondary: Colors.white,
      onSurface: Colors.black87,
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
        shadows: [
          Shadow(
            color: const Color(0xFF06B1C8).withOpacity(0.8),
            blurRadius: 8,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      bodyLarge: const TextStyle(
        fontFamily: _fontFamily,
        fontSize: 20,
        color: Colors.black87,
      ),
      labelLarge: const TextStyle(
        fontFamily: _fontFamily,
        fontSize: 18,
        color: Colors.black87,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF06B1C8),
        // Neon Green buttons
        foregroundColor: Colors.black87,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 35),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 12,
        shadowColor: const Color(0xFFFF4081).withOpacity(0.7),
        // Neon Pink shadow
        textStyle: const TextStyle(fontFamily: _fontFamily, fontSize: 20),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      labelStyle: const TextStyle(
        fontFamily: _fontFamily,
        fontSize: 18,
        color: Colors.black54,
      ),
      filled: true,
      fillColor: Colors.white.withOpacity(0.9),
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
    ),
    iconTheme: const IconThemeData(color: Colors.black87, size: 28),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF06B1C8),
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 24,
        color: Colors.black87,
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: const Color(0xFF06B1C8),
      // Neon Green background
      contentTextStyle: const TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16,
        color: Colors.black87,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 6,
      behavior: SnackBarBehavior.floating,
      actionTextColor: const Color(0xFFFF4081), // Neon Pink for action text
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.pinkAccent,
    scaffoldBackgroundColor: Colors.grey[900],
    cardColor: Colors.grey[850],
    colorScheme: ColorScheme.dark(
      primary: Colors.pinkAccent,
      secondary: Colors.cyanAccent,
      surface: Colors.grey[900]!,
      onPrimary: Colors.white,
      onSecondary: Colors.black87,
      onSurface: Colors.white,
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        shadows: [
          Shadow(
            color: Colors.pinkAccent.withOpacity(0.8),
            blurRadius: 8,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      bodyLarge: const TextStyle(
        fontFamily: _fontFamily,
        fontSize: 20,
        color: Colors.white70,
      ),
      labelLarge: const TextStyle(
        fontFamily: _fontFamily,
        fontSize: 18,
        color: Colors.white,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.pinkAccent,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 35),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 12,
        shadowColor: Colors.cyanAccent.withOpacity(0.7),
        textStyle: const TextStyle(fontFamily: _fontFamily, fontSize: 20),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Colors.pinkAccent, width: 2),
      ),
      labelStyle: const TextStyle(
        fontFamily: _fontFamily,
        fontSize: 18,
        color: Colors.white70,
      ),
      filled: true,
      fillColor: Colors.grey[850],
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
    ),
    iconTheme: const IconThemeData(color: Colors.white, size: 28),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.pinkAccent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 24,
        color: Colors.white,
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Colors.pinkAccent,
      // PinkAccent background
      contentTextStyle: const TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16,
        color: Colors.white,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 6,
      behavior: SnackBarBehavior.floating,
      actionTextColor: Colors.cyanAccent, // CyanAccent for action text
    ),
  );

  static bool isDarkMode(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;
}


