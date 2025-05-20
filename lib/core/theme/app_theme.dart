import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.indigo,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.indigo,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(Colors.indigo),
      trackColor: WidgetStateProperty.all(Colors.indigo.shade100),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.indigo,
    ),
    iconTheme: const IconThemeData(color: Colors.indigo),
    textTheme: const TextTheme(
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      bodyMedium: TextStyle(fontSize: 16),
    ),
    useMaterial3: true,
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.deepPurple,
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(Colors.deepPurple),
      trackColor: WidgetStateProperty.all(Colors.deepPurple.shade200),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.deepPurple,
    ),
    iconTheme: const IconThemeData(color: Colors.deepPurpleAccent),
    textTheme: const TextTheme(
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
      bodyMedium: TextStyle(fontSize: 16, color: Colors.white70),
    ),
    useMaterial3: true,
  );
}
