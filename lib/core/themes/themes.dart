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
    scaffoldBackgroundColor: Colors.white70,
  ),
  AppTheme.Dark: ThemeData(
    brightness: Brightness.dark,
    accentColor: Colors.teal,
  ),
};
