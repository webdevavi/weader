import 'package:flutter/material.dart';

enum AppTheme {
  Light,
  Dark,
}

final appThemeData = {
  AppTheme.Light: ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.deepOrange,
    primaryColorDark: Colors.deepOrange[800],
    accentColor: Colors.teal,
    scaffoldBackgroundColor: Colors.white.withOpacity(0.8),
    appBarTheme: AppBarTheme(
      color: Colors.transparent,
      elevation: 0.0,
      iconTheme: IconThemeData(color: Colors.deepOrange),
      textTheme: TextTheme(
        headline6: TextStyle(
          color: Colors.deepOrange,
          fontSize: 22.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ),
  AppTheme.Dark: ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.grey.shade900,
    primaryColorDark: Colors.black,
    accentColor: Colors.teal,
    appBarTheme: AppBarTheme(
      color: Colors.transparent,
      elevation: 0.0,
      iconTheme: IconThemeData(color: Colors.white70),
      textTheme: TextTheme(
        headline6: TextStyle(
          color: Colors.white70,
          fontSize: 22.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ),
};
